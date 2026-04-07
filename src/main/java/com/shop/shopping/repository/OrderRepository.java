package com.shop.shopping.repository;

import com.shop.shopping.model.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface OrderRepository extends JpaRepository<Order, Integer> {
    List<Order> findByUserEmailOrderByCreatedAtDesc(String userEmail);
}