package com.shop.shopping.controller;

import com.shop.shopping.model.AppUser;
import com.shop.shopping.model.Order;
import com.shop.shopping.repository.AppUserRepository;
import com.shop.shopping.repository.CartItemEntityRepository;
import com.shop.shopping.repository.OrderRepository;
import com.shop.shopping.repository.ProductRepository;
import com.shop.shopping.repository.ReviewRepository;
import com.shop.shopping.service.ProductSyncService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import jakarta.servlet.http.HttpSession;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired private ProductRepository repo;
    @Autowired private OrderRepository orderRepo;
    @Autowired private AppUserRepository userRepo;
    @Autowired private ProductSyncService productSyncService;
    @Autowired private ReviewRepository reviewRepository;
    @Autowired private CartItemEntityRepository cartItemRepository;

    // ================= HELPER =================

    private boolean isAdmin(HttpSession session) {
        return "ADMIN".equals(session.getAttribute("role"));
    }

    // ================= TRANG CHINH =================

    @GetMapping("")
    public String adminPage(Model model, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/home";
        model.addAttribute("products", repo.findAll());
        model.addAttribute("orders", orderRepo.findAll());
        model.addAttribute("customers", userRepo.findCustomers());
        return "admin";
    }

    // ================= SAN PHAM =================

    @GetMapping("/delete-product")
    public String deleteProduct(@RequestParam int id,
                                HttpSession session,
                                RedirectAttributes redirectAttrs) {
        if (!isAdmin(session)) return "redirect:/home";
        deleteProductWithDependencies(id);
        redirectAttrs.addFlashAttribute("message", "Đã xóa sản phẩm!");
        return "redirect:/admin";
    }

    @PostMapping("/delete-products")
    public String deleteProducts(@RequestParam(value = "ids", required = false) List<Integer> ids,
                                 HttpSession session,
                                 RedirectAttributes redirectAttrs) {
        if (!isAdmin(session)) return "redirect:/home";

        if (ids == null || ids.isEmpty()) {
            redirectAttrs.addFlashAttribute("message", "Chưa chọn sản phẩm nào!");
            return "redirect:/admin";
        }

        reviewRepository.deleteByProductIdIn(ids);
        cartItemRepository.deleteByProductIdIn(ids);
        for (int id : ids) repo.deleteById(id);

        redirectAttrs.addFlashAttribute("message", "Đã xóa " + ids.size() + " sản phẩm!");
        return "redirect:/admin";
    }

    // ================= DON HANG =================

    @PostMapping("/update-order-status")
    public String updateOrderStatus(@RequestParam int orderId,
                                    @RequestParam String status,
                                    HttpSession session,
                                    RedirectAttributes redirectAttrs) {
        if (!isAdmin(session)) return "redirect:/home";
        Order order = orderRepo.findById(orderId).orElse(null);
        if (order != null) {
            order.setStatus(status);
            orderRepo.save(order);
        }
        redirectAttrs.addFlashAttribute("message", "Đã cập nhật trạng thái đơn #" + orderId);
        return "redirect:/admin#don-hang";
    }

    // ================= KHACH HANG =================

    @GetMapping("/customer/{id}")
    public String customerDetail(@PathVariable Long id,
                                 HttpSession session,
                                 Model model) {
        if (!isAdmin(session)) return "redirect:/home";

        AppUser customer = userRepo.findById(id).orElse(null);
        if (customer == null) return "redirect:/admin#khach-hang";

        List<Order> orders = orderRepo.findByUserEmailOrderByCreatedAtDesc(customer.getEmail());

        double totalSpent = orders.stream()
                .filter(o -> !"Đã hủy".equals(o.getStatus()))
                .mapToDouble(Order::getTotal)
                .sum();

        model.addAttribute("customer", customer);
        model.addAttribute("orders", orders);
        model.addAttribute("totalSpent", totalSpent);
        model.addAttribute("totalOrders", orders.size());
        return "admin-customer-detail";
    }

    // ================= PRIVATE =================

    private void deleteProductWithDependencies(int productId) {
        reviewRepository.deleteByProductId(productId);
        cartItemRepository.deleteByProductIdIn(List.of(productId));
        repo.deleteById(productId);
    }
}