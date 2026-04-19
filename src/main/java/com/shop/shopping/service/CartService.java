// src/main/java/com/shop/shopping/service/CartService.java
package com.shop.shopping.service;

import com.shop.shopping.model.CartItem;
import com.shop.shopping.model.CartItemEntity;
import com.shop.shopping.model.Product;
import com.shop.shopping.repository.CartItemEntityRepository;
import com.shop.shopping.repository.ProductRepository;
import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class CartService {

    @Autowired
    private CartItemEntityRepository cartItemEntityRepo;

    @Autowired
    private ProductRepository productRepo;

    // Load cart từ DB → session (gọi khi login)
    public List<CartItem> loadCartFromDB(String userEmail) {
        List<CartItemEntity> entities = cartItemEntityRepo.findByUserEmail(userEmail);
        List<CartItem> cart = new ArrayList<>();

        for (CartItemEntity entity : entities) {
            Product product = productRepo.findById(entity.getProductId()).orElse(null);
            if (product != null) {
                cart.add(new CartItem(product, entity.getQuantity()));
            }
        }
        return cart;
    }

    // Lưu toàn bộ session cart → DB (ghi đè)
    @Transactional
    public void saveCartToDB(String userEmail, List<CartItem> cart) {
        cartItemEntityRepo.deleteByUserEmail(userEmail);
        if (cart == null) return;

        for (CartItem item : cart) {
            CartItemEntity entity = new CartItemEntity();
            entity.setUserEmail(userEmail);
            entity.setProductId(item.getProduct().getId());
            entity.setQuantity(item.getQuantity());
            cartItemEntityRepo.save(entity);
        }
    }

    // Thêm 1 sản phẩm vào DB cart
    @Transactional
    public void addItemToDB(String userEmail, int productId, int qty) {
        Optional<CartItemEntity> existing =
            cartItemEntityRepo.findByUserEmailAndProductId(userEmail, productId);

        if (existing.isPresent()) {
            CartItemEntity entity = existing.get();
            entity.setQuantity(entity.getQuantity() + qty);
            cartItemEntityRepo.save(entity);
        } else {
            CartItemEntity entity = new CartItemEntity();
            entity.setUserEmail(userEmail);
            entity.setProductId(productId);
            entity.setQuantity(qty);
            cartItemEntityRepo.save(entity);
        }
    }

    // Cập nhật số lượng
    @Transactional
    public void updateQuantityInDB(String userEmail, int productId, int newQty) {
        Optional<CartItemEntity> existing =
            cartItemEntityRepo.findByUserEmailAndProductId(userEmail, productId);

        if (existing.isPresent()) {
            if (newQty <= 0) {
                cartItemEntityRepo.deleteByUserEmailAndProductId(userEmail, productId);
            } else {
                CartItemEntity entity = existing.get();
                entity.setQuantity(newQty);
                cartItemEntityRepo.save(entity);
            }
        }
    }

    // Xóa 1 sản phẩm
    @Transactional
    public void removeItemFromDB(String userEmail, int productId) {
        cartItemEntityRepo.deleteByUserEmailAndProductId(userEmail, productId);
    }

    // Xóa toàn bộ cart
    @Transactional
    public void clearCartInDB(String userEmail) {
        cartItemEntityRepo.deleteByUserEmail(userEmail);
    }
}