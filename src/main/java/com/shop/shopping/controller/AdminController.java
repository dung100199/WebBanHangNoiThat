package com.shop.shopping.controller;

import com.shop.shopping.model.Product;
import com.shop.shopping.model.Order;
import com.shop.shopping.repository.ProductRepository;
import com.shop.shopping.repository.OrderRepository;
import com.shop.shopping.service.UnsplashService;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import jakarta.servlet.http.HttpSession;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private ProductRepository repo;

    @Autowired
    private UnsplashService unsplashService;

    @Autowired
    private OrderRepository orderRepo;

    // Trang admin
    @GetMapping("")
    public String adminPage(Model model, HttpSession session) {
        if (!"ADMIN".equals(session.getAttribute("role"))) return "redirect:/home";
        model.addAttribute("products", repo.findAll());
        model.addAttribute("orders", orderRepo.findAll());
        return "admin";
    }

    // Thêm 1 sản phẩm
    @PostMapping("/add-product")
    public String addProduct(@RequestParam String name,
                             @RequestParam double price,
                             @RequestParam String category,
                             @RequestParam(required = false) String keyword,
                             HttpSession session,
                             RedirectAttributes redirectAttrs) {

        if (!"ADMIN".equals(session.getAttribute("role"))) return "redirect:/home";

        String searchKeyword = (keyword == null || keyword.isEmpty()) ? name : keyword;
        String imageUrl = unsplashService.getImageUrl(searchKeyword);

        Product product = new Product();
        product.setName(name);
        product.setPrice(price);
        product.setCategory(category);
        product.setImage(imageUrl);
        repo.save(product);

        redirectAttrs.addFlashAttribute("message", "✅ Đã thêm sản phẩm: " + name);
        return "redirect:/admin";
    }

    // Import từ Excel
    @PostMapping("/import-excel")
    public String importExcel(@RequestParam("file") MultipartFile file,
                              HttpSession session,
                              RedirectAttributes redirectAttrs) {

        if (!"ADMIN".equals(session.getAttribute("role"))) return "redirect:/home";

        int count = 0;
        try {
            Workbook workbook = new XSSFWorkbook(file.getInputStream());
            Sheet sheet = workbook.getSheetAt(0);

            for (Row row : sheet) {
                if (row.getRowNum() == 0) continue;

                String name     = row.getCell(0).getStringCellValue();
                double price    = row.getCell(1).getNumericCellValue();
                String category = row.getCell(2).getStringCellValue();
                String keyword  = row.getCell(3).getStringCellValue();

                String imageUrl = unsplashService.getImageUrl(keyword);

                Product product = new Product();
                product.setName(name);
                product.setPrice(price);
                product.setCategory(category);
                product.setImage(imageUrl);
                repo.save(product);
                count++;
            }
            workbook.close();

        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("message", "❌ Lỗi khi import: " + e.getMessage());
            return "redirect:/admin";
        }

        redirectAttrs.addFlashAttribute("message", "✅ Import thành công " + count + " sản phẩm!");
        return "redirect:/admin";
    }

    // Xóa 1 sản phẩm
    @GetMapping("/delete-product")
    public String deleteProduct(@RequestParam int id,
                                HttpSession session,
                                RedirectAttributes redirectAttrs) {
        if (!"ADMIN".equals(session.getAttribute("role"))) return "redirect:/home";
        repo.deleteById(id);
        redirectAttrs.addFlashAttribute("message", "✅ Đã xóa sản phẩm!");
        return "redirect:/admin";
    }

    // ✅ Xóa nhiều sản phẩm cùng lúc
    @PostMapping("/delete-products")
    public String deleteProducts(@RequestParam(value = "ids", required = false) List<Integer> ids,
                                 HttpSession session,
                                 RedirectAttributes redirectAttrs) {
        if (!"ADMIN".equals(session.getAttribute("role"))) return "redirect:/home";

        if (ids == null || ids.isEmpty()) {
            redirectAttrs.addFlashAttribute("message", "⚠️ Chưa chọn sản phẩm nào!");
            return "redirect:/admin";
        }

        for (int id : ids) {
            repo.deleteById(id);
        }

        redirectAttrs.addFlashAttribute("message", "✅ Đã xóa " + ids.size() + " sản phẩm!");
        return "redirect:/admin";
    }

    // Cập nhật trạng thái đơn hàng
    @PostMapping("/update-order-status")
    public String updateOrderStatus(@RequestParam int orderId,
                                    @RequestParam String status,
                                    HttpSession session,
                                    RedirectAttributes redirectAttrs) {
        if (!"ADMIN".equals(session.getAttribute("role"))) return "redirect:/home";
        Order order = orderRepo.findById(orderId).orElse(null);
        if (order != null) {
            order.setStatus(status);
            orderRepo.save(order);
        }
        redirectAttrs.addFlashAttribute("message", "✅ Đã cập nhật trạng thái đơn #" + orderId);
        return "redirect:/admin";
    }

    // Mở form sửa sản phẩm
    @GetMapping("/edit-product/{id}")
    public String editProductForm(@PathVariable int id,
                                  HttpSession session,
                                  Model model) {
        if (!"ADMIN".equals(session.getAttribute("role"))) return "redirect:/home";

        Product product = repo.findById(id).orElse(null);
        if (product == null) return "redirect:/admin";

        model.addAttribute("product", product);
        model.addAttribute("products", repo.findAll());
        model.addAttribute("orders", orderRepo.findAll());
        return "admin";
    }

    // Lưu sản phẩm sau khi sửa
    @PostMapping("/edit-product")
    public String editProduct(@RequestParam int id,
                              @RequestParam String name,
                              @RequestParam double price,
                              @RequestParam String category,
                              @RequestParam(required = false) String keyword,
                              @RequestParam(required = false) String image,
                              HttpSession session,
                              RedirectAttributes redirectAttrs) {

        if (!"ADMIN".equals(session.getAttribute("role"))) return "redirect:/home";

        Product product = repo.findById(id).orElse(null);
        if (product == null) return "redirect:/admin";

        product.setName(name);
        product.setPrice(price);
        product.setCategory(category);

        if (keyword != null && !keyword.isEmpty()) {
            product.setImage(unsplashService.getImageUrl(keyword));
        } else if (image != null && !image.isEmpty()) {
            product.setImage(image);
        }

        repo.save(product);
        redirectAttrs.addFlashAttribute("message", "✅ Đã cập nhật sản phẩm: " + name);
        return "redirect:/admin";
    }
}