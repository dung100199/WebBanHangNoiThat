package com.shop.shopping.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping({"/", "/home"})
    public String homePage(Model model) {
        // nếu cần, load danh sách sản phẩm/some data:
        // model.addAttribute("products", productService.findFeatured());
        return "home";
    }
}