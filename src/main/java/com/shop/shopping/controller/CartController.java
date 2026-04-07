package com.shop.shopping.controller;

import com.shop.shopping.model.CartItem;
import com.shop.shopping.model.OrderItem;
import com.shop.shopping.model.Product;
import com.shop.shopping.repository.OrderItemRepository;
import com.shop.shopping.repository.OrderRepository;
import com.shop.shopping.repository.ProductRepository;
import com.shop.shopping.service.EmailService;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.*;

import com.shop.shopping.model.Order;
import com.shop.shopping.model.OrderItem;
import com.shop.shopping.repository.OrderRepository;
import com.shop.shopping.repository.OrderItemRepository;

@Controller
public class CartController {

    @Autowired
    private ProductRepository productRepo;

    // ================= CART =================

    @GetMapping("/cart")
    public String viewCart(HttpSession session, Model model) {

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null) {
            cart = new ArrayList<>();
        }

        model.addAttribute("cart", cart);

        return "cart";
    }

    // ================= ADD TO CART =================
@GetMapping("/add-to-cart")
public String addToCart(@RequestParam int id,
                        @RequestParam(defaultValue = "1") int qty,
                        HttpSession session) {

    Product product = productRepo.findById(id).orElse(null);
    if (product == null) return "redirect:/home";

    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

    if (cart == null) {
        cart = new ArrayList<>();
    }

    boolean found = false;

    for (CartItem item : cart) {
        if (item.getProduct().getId() == id) {
            item.setQuantity(item.getQuantity() + qty);
            found = true;
            break;
        }
    }

    if (!found) {
        cart.add(new CartItem(product, qty));
    }

    session.setAttribute("cart", cart);

    return "redirect:/cart";
}
    // ================= BUY NOW =================

    @GetMapping("/buy-now")
    public String buyNow(@RequestParam int id, HttpSession session) {

        Product product = productRepo.findById(id).orElse(null);
        if (product == null) return "redirect:/home";

        List<CartItem> cart = new ArrayList<>();
        cart.add(new CartItem(product, 1));

        session.setAttribute("cart", cart);

        return "redirect:/checkout";
    }

    // ================= CHECKOUT =================

    @GetMapping("/checkout")
    public String checkout(HttpSession session, Model model) {

    // Chưa đăng nhập → chuyển sang trang login
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) {
        return "redirect:/login?redirect=checkout";
    }

    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    if (cart == null || cart.isEmpty()) {
        return "redirect:/home";
    }

    model.addAttribute("cart", cart);
    return "checkout";
}

    // ================= PLACE ORDER =================

    @Autowired
private OrderRepository orderRepo;

@Autowired
private OrderItemRepository orderItemRepo;

@Autowired
private EmailService emailService;

@PostMapping("/place-order")
public String placeOrder(
        @RequestParam String fullname,
        @RequestParam String phone,
        @RequestParam(required = false) String email,
        @RequestParam String city,
        @RequestParam String address,
        @RequestParam(required = false) String note,
        @RequestParam String payment,
        HttpSession session) {

    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    if (cart == null || cart.isEmpty()) return "redirect:/cart";

    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) userEmail = email; // dùng email từ form nếu chưa đăng nhập

    // Tính tổng tiền
    double total = 0;
    for (CartItem item : cart) {
        total += item.getProduct().getPrice() * item.getQuantity();
    }

    // Lưu đơn hàng
    Order order = new Order();
    order.setUserEmail(userEmail);
    order.setFullname(fullname);
    order.setPhone(phone);
    order.setEmail(email != null ? email : "");
    order.setCity(city);
    order.setAddress(address);
    order.setNote(note != null ? note : "");
    order.setPayment(payment);
    order.setTotal(total);
    orderRepo.save(order);

    // Lưu từng sản phẩm trong đơn
    for (CartItem item : cart) {
        OrderItem oi = new OrderItem();
        oi.setOrderId(order.getId());
        oi.setProductId(item.getProduct().getId());
        oi.setProductName(item.getProduct().getName());
        oi.setProductImage(item.getProduct().getImage());
        oi.setPrice(item.getProduct().getPrice());
        oi.setQuantity(item.getQuantity());
        orderItemRepo.save(oi);
    }

    // Lưu vào session để hiển thị trang xác nhận
    session.setAttribute("orderedItems", cart);
    session.setAttribute("orderInfo", order);
    session.removeAttribute("cart");

    // Load lại order từ DB để có đầy đủ items
Order savedOrder = orderRepo.findById(order.getId()).orElse(order);

// Gửi email xác nhận
try {
    emailService.sendOrderConfirmation(savedOrder);
} catch (Exception e) {
    System.err.println("Không gửi được email: " + e.getMessage());
}

    session.setAttribute("orderedItems", cart);
    session.setAttribute("orderInfo", order);
    session.removeAttribute("cart");

    return "redirect:/order-success";
}

@GetMapping("/order-success")
public String orderSuccess(HttpSession session, Model model) {
    model.addAttribute("orderInfo", session.getAttribute("orderInfo"));
    model.addAttribute("orderedItems", session.getAttribute("orderedItems"));
    return "order-success";
}

@GetMapping("/my-orders")
public String myOrders(HttpSession session, Model model) {
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) return "redirect:/login";

    List<Order> orders = orderRepo.findByUserEmailOrderByCreatedAtDesc(userEmail);
    model.addAttribute("orders", orders);
    model.addAttribute("orderItemRepo", orderItemRepo);
    return "my-orders";
}
    // Tăng số lượng
@GetMapping("/cart-plus")
public String cartPlus(@RequestParam int id, HttpSession session) {
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    if (cart != null) {
        for (CartItem item : cart) {
            if (item.getProduct().getId() == id) {
                item.setQuantity(item.getQuantity() + 1);
                break;
            }
        }
    }
    return "redirect:/cart";
}

// Giảm số lượng
@GetMapping("/cart-minus")
public String cartMinus(@RequestParam int id, HttpSession session) {
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    if (cart != null) {
        for (CartItem item : cart) {
            if (item.getProduct().getId() == id) {
                if (item.getQuantity() > 1) {
                    item.setQuantity(item.getQuantity() - 1);
                } else {
                    cart.remove(item); // xóa hẳn nếu số lượng = 1
                }
                break;
            }
        }
    }
    return "redirect:/cart";
}

// Xóa toàn bộ giỏ hàng
@GetMapping("/clear-cart")
public String clearCart(HttpSession session) {
    session.removeAttribute("cart");
    return "redirect:/cart";
}

// Xóa 1 sản phẩm khỏi giỏ
@GetMapping("/remove-cart")
public String removeCart(@RequestParam int id, HttpSession session) {
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    if (cart != null) {
        cart.removeIf(item -> item.getProduct().getId() == id);
        session.setAttribute("cart", cart);
    }
    return "redirect:/cart";
}

//Hủy đơn hàng
@PostMapping("/cancel-order")
public String cancelOrder(@RequestParam int orderId,
                          HttpSession session,
                          RedirectAttributes redirectAttrs) {

    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) return "redirect:/login";

    Order order = orderRepo.findById(orderId).orElse(null);

    // Kiểm tra đơn có tồn tại và thuộc về người dùng này không
    if (order == null || !order.getUserEmail().equals(userEmail)) {
        redirectAttrs.addFlashAttribute("error", "❌ Không tìm thấy đơn hàng!");
        return "redirect:/my-orders";
    }

    // Chỉ hủy được khi đang chờ xác nhận
    if (!order.getStatus().equals("Chờ xác nhận")) {
        redirectAttrs.addFlashAttribute("error", "❌ Không thể hủy đơn hàng đang " + order.getStatus());
        return "redirect:/my-orders";
    }

    order.setStatus("Đã hủy");
    orderRepo.save(order);

    redirectAttrs.addFlashAttribute("message", "✅ Đã hủy đơn hàng #" + orderId);
    return "redirect:/my-orders";
}
}