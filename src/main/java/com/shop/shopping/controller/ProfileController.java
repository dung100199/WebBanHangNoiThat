package com.shop.shopping.controller;

import com.shop.shopping.model.AppUser;
import com.shop.shopping.model.Order;
import com.shop.shopping.repository.AppUserRepository;
import com.shop.shopping.repository.OrderRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.List;

@Controller
@RequestMapping("/profile")
public class ProfileController {

    @Autowired
    private AppUserRepository userRepo;

    @Autowired
    private OrderRepository orderRepo;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    // Trang thông tin cá nhân
    @GetMapping("")
    public String profilePage(HttpSession session, Model model) {
        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null) return "redirect:/login";

        AppUser user = userRepo.findByEmail(userEmail).orElse(null);
        List<Order> orders = orderRepo.findByUserEmailOrderByCreatedAtDesc(userEmail);

        model.addAttribute("user", user);
        model.addAttribute("orders", orders);
        return "profile";
    }

    // Cập nhật thông tin
    @PostMapping("/update")
    public String updateProfile(@RequestParam String fullname,
                                @RequestParam String phone,
                                @RequestParam String address,
                                HttpSession session,
                                RedirectAttributes redirectAttrs) {

        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null) return "redirect:/login";

        AppUser user = userRepo.findByEmail(userEmail).orElse(null);
        if (user == null) return "redirect:/login";

        user.setFullname(fullname);
        user.setPhone(phone);
        user.setAddress(address);
        userRepo.save(user);

        session.setAttribute("fullname", fullname);

        redirectAttrs.addFlashAttribute("message", "✅ Cập nhật thông tin thành công!");
        return "redirect:/profile";
    }

    // Đổi mật khẩu
    @PostMapping("/change-password")
    public String changePassword(@RequestParam String currentPassword,
                                 @RequestParam String newPassword,
                                 @RequestParam String confirmPassword,
                                 HttpSession session,
                                 RedirectAttributes redirectAttrs) {

        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null) return "redirect:/login";

        AppUser user = userRepo.findByEmail(userEmail).orElse(null);
        if (user == null) return "redirect:/login";

        // Kiểm tra mật khẩu hiện tại
        if (!passwordEncoder.matches(currentPassword, user.getPasswordHash())) {
            redirectAttrs.addFlashAttribute("passError", "❌ Mật khẩu hiện tại không đúng!");
            return "redirect:/profile";
        }

        // Kiểm tra xác nhận mật khẩu
        if (!newPassword.equals(confirmPassword)) {
            redirectAttrs.addFlashAttribute("passError", "❌ Mật khẩu xác nhận không khớp!");
            return "redirect:/profile";
        }

        // Kiểm tra độ dài
        if (newPassword.length() < 6) {
            redirectAttrs.addFlashAttribute("passError", "❌ Mật khẩu phải có ít nhất 6 ký tự!");
            return "redirect:/profile";
        }

        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepo.save(user);

        redirectAttrs.addFlashAttribute("passSuccess", "✅ Đổi mật khẩu thành công!");
        return "redirect:/profile";
    }
}