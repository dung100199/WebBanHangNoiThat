// src/main/java/com/shop/shopping/repository/CartItemEntityRepository.java
package com.shop.shopping.repository;

import com.shop.shopping.model.CartItemEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface CartItemEntityRepository extends JpaRepository<CartItemEntity, Integer> {

    List<CartItemEntity> findByUserEmail(String userEmail);

    Optional<CartItemEntity> findByUserEmailAndProductId(String userEmail, int productId);

    void deleteByUserEmail(String userEmail);

    void deleteByUserEmailAndProductId(String userEmail, int productId);
}