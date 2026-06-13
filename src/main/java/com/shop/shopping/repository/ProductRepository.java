package com.shop.shopping.repository;

import com.shop.shopping.model.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.Optional;

public interface ProductRepository extends JpaRepository<Product, Integer> {

    Optional<Product> findByExternalProductId(Long externalProductId);

    List<Product> findByExternalProductIdIsNull();

    List<Product> findByCategory(String category);

    // Phân trang theo danh mục
    Page<Product> findByCategory(String category, Pageable pageable);

    // Tìm kiếm
    @Query("SELECT p FROM Product p WHERE LOWER(p.name) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<Product> searchByName(@Param("keyword") String keyword);
}