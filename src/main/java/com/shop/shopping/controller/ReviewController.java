package com.shop.shopping.controller;

import com.shop.shopping.model.Review;
import com.shop.shopping.repository.ReviewRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class ReviewController {

    @Autowired
    private ReviewRepository reviewRepo;

    @PostMapping("/review/add")
    public String addReview(@RequestParam int productId,
                            @RequestParam int rating,
                            @RequestParam(required = false) String comment,
                            HttpSession session,
                            RedirectAttributes redirectAttrs) {

        String userEmail = (String) session.getAttribute("userEmail");

        // Chưa đăng nhập
        if (userEmail == null) {
            redirectAttrs.addFlashAttribute("reviewError", "Bạn cần đăng nhập để đánh giá!");
            return "redirect:/product/" + productId;
        }

        // Đã đánh giá rồi
        if (reviewRepo.existsByProductIdAndUserEmail(productId, userEmail)) {
            redirectAttrs.addFlashAttribute("reviewError", "Bạn đã đánh giá sản phẩm này rồi!");
            return "redirect:/product/" + productId;
        }

        // Lưu đánh giá
        Review review = new Review();
        review.setProductId(productId);
        review.setUserEmail(userEmail);
        review.setRating(rating);
        review.setComment(comment != null ? comment.trim() : "");
        reviewRepo.save(review);

        redirectAttrs.addFlashAttribute("reviewSuccess", "✅ Cảm ơn bạn đã đánh giá!");
        return "redirect:/product/" + productId;
    }
}