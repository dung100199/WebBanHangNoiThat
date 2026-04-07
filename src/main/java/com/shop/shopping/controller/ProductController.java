package com.shop.shopping.controller;

import com.shop.shopping.model.Product;
import com.shop.shopping.model.Review;
import com.shop.shopping.repository.ProductRepository;
import com.shop.shopping.repository.ReviewRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.List;


@Controller
public class ProductController {

    @Autowired
    private ProductRepository productRepository;

    

    // Trang danh mục có phân trang
    @GetMapping("/category/{name}")
    public String category(@PathVariable String name,
                           @RequestParam(defaultValue = "0") int page,
                           @RequestParam(defaultValue = "8") int size,
                           Model model) {

        Pageable pageable = PageRequest.of(page, size);
        Page<Product> productPage = productRepository.findByCategory(name, pageable);

        model.addAttribute("products",    productPage.getContent());
        model.addAttribute("currentPage", productPage.getNumber());
        model.addAttribute("totalPages",  productPage.getTotalPages());
        model.addAttribute("totalItems",  productPage.getTotalElements());
        model.addAttribute("title",       name);
        return "category";
    }

    // Tìm kiếm
    @GetMapping("/search")
    public String search(@RequestParam(required = false) String keyword, Model model) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return "redirect:/home";
        }
        List<Product> results = productRepository.searchByName(keyword.trim());
        model.addAttribute("products", results);
        model.addAttribute("keyword",  keyword);
        model.addAttribute("total",    results.size());
        return "search";
    }

    // Chi tiết sản phẩm
    @Autowired
private ReviewRepository reviewRepo;

@GetMapping("/product/{id}")
public String productDetail(@PathVariable int id, Model model) {
    Product product = productRepository.findById(id).orElse(null);
    if (product == null) return "redirect:/home";

    // Lấy danh sách đánh giá
    List<Review> reviews = reviewRepo.findByProductIdOrderByCreatedAtDesc(id);
    Double avgRating = reviewRepo.avgRatingByProductId(id);
    Long totalReviews = reviewRepo.countByProductId(id);

    model.addAttribute("product", product);
    model.addAttribute("reviews", reviews);
    model.addAttribute("avgRating", avgRating != null ? Math.round(avgRating * 10.0) / 10.0 : 0);
    model.addAttribute("totalReviews", totalReviews);
    return "product-detail";
}
}