package com.shop.shopping.controller;

import java.util.ArrayList;
import java.util.List;
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
import com.shop.shopping.model.CartItem;
import com.shop.shopping.repository.AppUserRepository;
import com.shop.shopping.service.CartService;
import com.shop.shopping.web.RegisterRequest;

@Controller
@RequestMapping
public class AuthController {

    private final AppUserRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @Autowired
    private CartService cartService;

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

        // ✅ Lấy cart guest (nếu có) trước khi set session
        List<CartItem> sessionCart = (List<CartItem>) session.getAttribute("cart");

        // Set thông tin đăng nhập vào session
        session.setAttribute("userEmail", email);
        session.setAttribute("role", userOpt.get().getRole());
        session.setAttribute("fullname", userOpt.get().getFullname());

        // ✅ Load cart từ DB
        List<CartItem> dbCart = cartService.loadCartFromDB(email);

        // ✅ Merge cart guest vào cart DB (nếu guest đã thêm hàng trước khi login)
        if (sessionCart != null && !sessionCart.isEmpty()) {
            for (CartItem sessionItem : sessionCart) {
                boolean found = false;
                for (CartItem dbItem : dbCart) {
                    if (dbItem.getProduct().getId() == sessionItem.getProduct().getId()) {
                        // Cộng dồn số lượng nếu sản phẩm đã có trong DB cart
                        dbItem.setQuantity(dbItem.getQuantity() + sessionItem.getQuantity());
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    dbCart.add(sessionItem);
                }
            }
            // ✅ Lưu cart đã merge lại DB
            cartService.saveCartToDB(email, dbCart);
        }

        // ✅ Ghi cart vào session (ưu tiên DB cart đã merge)
        session.setAttribute("cart", dbCart);

        if (redirect != null && !redirect.isEmpty()) {
            return "redirect:/" + redirect;
        }
        return "redirect:/";
    }

    @PostMapping("/logout")
    public String logout(HttpSession session, HttpServletRequest request) {
        if (session != null) {
            // ✅ Không cần giữ cart sau logout vì cart đã được lưu DB
            // Cart sẽ được load lại từ DB khi đăng nhập lần sau
            session.invalidate();
        }
        return "redirect:/home";
    }

    @PostMapping("/register")
    public String register(
            @Valid @ModelAttribute("register") RegisterRequest register,
            BindingResult bindingResult,
            Model model) {

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
        model.addAttribute("register", new RegisterRequest());
        return "auth";
    }
}