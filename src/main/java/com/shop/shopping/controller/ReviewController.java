package com.shop.shopping.controller;

import com.shop.shopping.model.Review;
import com.shop.shopping.repository.ReviewRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Date;

@Controller
public class ReviewController {

    @Autowired
    private ReviewRepository reviewRepo;

    // ================= USER: THÊM ĐÁNH GIÁ =================

    @PostMapping("/review/add")
    public String addReview(@RequestParam int productId,
                            @RequestParam int rating,
                            @RequestParam(required = false) String comment,
                            HttpSession session,
                            RedirectAttributes redirectAttrs) {

        String userEmail = (String) session.getAttribute("userEmail");

        if (userEmail == null) {
            redirectAttrs.addFlashAttribute("reviewError", "Bạn cần đăng nhập để đánh giá!");
            return "redirect:/product/" + productId;
        }

        if (reviewRepo.existsByProductIdAndUserEmail(productId, userEmail)) {
            redirectAttrs.addFlashAttribute("reviewError", "Bạn đã đánh giá sản phẩm này rồi!");
            return "redirect:/product/" + productId;
        }

        Review review = new Review();
        review.setProductId(productId);
        review.setUserEmail(userEmail);
        review.setRating(rating);
        review.setComment(comment != null ? comment.trim() : "");
        reviewRepo.save(review);

        redirectAttrs.addFlashAttribute("reviewSuccess", "✅ Cảm ơn bạn đã đánh giá!");
        return "redirect:/product/" + productId;
    }

    // ================= ADMIN: XÓA ĐÁNH GIÁ =================

    @PostMapping("/admin/review/delete")
    public String deleteReview(@RequestParam int reviewId,
                               @RequestParam(required = false) Integer productId,
                               HttpSession session,
                               RedirectAttributes redirectAttrs) {

        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) return "redirect:/home";

        reviewRepo.deleteById(reviewId);
        redirectAttrs.addFlashAttribute("message", "✅ Đã xóa đánh giá #" + reviewId);

        // Nếu xóa từ trang product-detail thì quay lại trang đó
        if (productId != null) {
            return "redirect:/product/" + productId;
        }
        // Nếu xóa từ trang admin thì quay lại admin tab review
        return "redirect:/admin#don-hang";
    }

    // ================= ADMIN: TRẢ LỜI ĐÁNH GIÁ =================

    @PostMapping("/admin/review/reply")
    public String replyReview(@RequestParam int reviewId,
                              @RequestParam String reply,
                              @RequestParam(required = false) Integer productId,
                              HttpSession session,
                              RedirectAttributes redirectAttrs) {

        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) return "redirect:/home";

        Review review = reviewRepo.findById(reviewId).orElse(null);
        if (review != null) {
            review.setAdminReply(reply.trim());
            review.setRepliedAt(new Date());
            reviewRepo.save(review);
            redirectAttrs.addFlashAttribute("message", "✅ Đã trả lời đánh giá!");
        }

        if (productId != null) {
            return "redirect:/product/" + productId;
        }
        return "redirect:/admin#reviews";
    }

    // ================= ADMIN: XÓA TRẢ LỜI =================

    @PostMapping("/admin/review/delete-reply")
    public String deleteReply(@RequestParam int reviewId,
                              @RequestParam(required = false) Integer productId,
                              HttpSession session,
                              RedirectAttributes redirectAttrs) {

        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) return "redirect:/home";

        Review review = reviewRepo.findById(reviewId).orElse(null);
        if (review != null) {
            review.setAdminReply(null);
            review.setRepliedAt(null);
            reviewRepo.save(review);
            redirectAttrs.addFlashAttribute("message", "✅ Đã xóa trả lời!");
        }

        if (productId != null) {
            return "redirect:/product/" + productId;
        }
        return "redirect:/admin#reviews";
    }
}