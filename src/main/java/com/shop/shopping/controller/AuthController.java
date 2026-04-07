package com.shop.shopping.controller;

import java.util.Optional;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import com.shop.shopping.model.AppUser;
import com.shop.shopping.repository.AppUserRepository;
import com.shop.shopping.web.RegisterRequest;

@Controller
@RequestMapping
public class AuthController {

    private final AppUserRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @Autowired
    public AuthController(AppUserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping({ "/login", "/auth", "/register" })
public String loginPage(Model model) {
    if (!model.containsAttribute("register")) {
        model.addAttribute("register", new RegisterRequest());
    }
    return "auth";
}

    @PostMapping("/login")
public String doLogin(
        @RequestParam("emailOrUsername") String emailOrUsername,
        @RequestParam("password") String password,
        @RequestParam(required = false) String redirect,
        Model model,
        HttpSession session) {

    String email = emailOrUsername.toLowerCase();
    Optional<AppUser> userOpt = userRepository.findByEmail(email);

    if (userOpt.isEmpty() || !passwordEncoder.matches(password, userOpt.get().getPasswordHash())) {
        model.addAttribute("loginError", "Email hoặc mật khẩu không đúng.");
        model.addAttribute("register", new RegisterRequest());
        return "auth";
    }

    // Giữ lại giỏ hàng trước khi đăng nhập
    Object cart = session.getAttribute("cart");

    session.setAttribute("userEmail", email);
    session.setAttribute("role", userOpt.get().getRole());

    // Khôi phục giỏ hàng nếu có
    if (cart != null) {
        session.setAttribute("cart", cart);
    }

    if (redirect != null && !redirect.isEmpty()) {
        return "redirect:/" + redirect;
    }
    return "redirect:/";
}

@PostMapping("/logout")
public String logout(HttpSession session, HttpServletRequest request) {
    if (session != null) {
        // Lấy giỏ hàng trước khi invalidate
        Object cart = session.getAttribute("cart");
        
        session.invalidate(); // Hủy session cũ
        
        // Tạo session MỚI và giữ lại giỏ hàng
        if (cart != null) {
            HttpSession newSession = request.getSession(true); // true = tạo mới
            newSession.setAttribute("cart", cart);
        }
    }
    return "redirect:/home";
}

    @PostMapping("/register")
    public String register(
            @Valid @ModelAttribute("register") RegisterRequest register,
            BindingResult bindingResult,
            Model model) {

        // Validation email + required fields được thực thi qua jakarta.validation
        if (bindingResult.hasErrors()) {
            if (bindingResult.getFieldError("email") != null) {
                model.addAttribute("registerError", bindingResult.getFieldError("email").getDefaultMessage());
            } else {
                model.addAttribute("registerError", "Vui lòng kiểm tra lại thông tin đăng ký.");
            }
            return "auth";
        }

        String email = register.getEmail().toLowerCase();

        Optional<AppUser> existing = userRepository.findByEmail(email);
        if (existing.isPresent()) {
            model.addAttribute("registerError", "Email này đã được đăng ký.");
            return "auth";
        }

        if (!register.getPassword().equals(register.getConfirmPassword())) {
            model.addAttribute("registerError", "Mật khẩu xác nhận không khớp.");
            return "auth";
        }

        AppUser user = new AppUser();
        user.setEmail(email);
        user.setPasswordHash(passwordEncoder.encode(register.getPassword()));
        userRepository.save(user);

        model.addAttribute("registerSuccess", true);
        model.addAttribute("register", new RegisterRequest()); // reset form
        return "auth";
    }
}

