package com.shop.shopping.repository;

import com.shop.shopping.model.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface ReviewRepository extends JpaRepository<Review, Integer> {

    List<Review> findByProductIdOrderByCreatedAtDesc(int productId);

    boolean existsByProductIdAndUserEmail(int productId, String userEmail);

    @Query("SELECT AVG(r.rating) FROM Review r WHERE r.productId = :productId")
    Double avgRatingByProductId(@Param("productId") int productId);

    @Query("SELECT COUNT(r) FROM Review r WHERE r.productId = :productId")
    Long countByProductId(@Param("productId") int productId);
}