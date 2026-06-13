package com.shop.shopping.repository;

import com.shop.shopping.model.AppUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;
import java.util.Optional;

public interface AppUserRepository extends JpaRepository<AppUser, Long> {
    Optional<AppUser> findByEmail(String email);
    List<AppUser> findByRoleNot(String role);

    @Query("SELECT u FROM AppUser u WHERE u.role IS NULL OR u.role != 'ADMIN'")
    List<AppUser> findCustomers();
}