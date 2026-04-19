package com.shop.shopping.controller;

import com.shop.shopping.model.CartItem;
import com.shop.shopping.model.OrderItem;
import com.shop.shopping.model.Product;
import com.shop.shopping.repository.OrderItemRepository;
import com.shop.shopping.repository.OrderRepository;
import com.shop.shopping.repository.ProductRepository;
import com.shop.shopping.service.CartService;
import com.shop.shopping.service.EmailService;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.*;

import com.shop.shopping.model.Order;

@Controller
public class CartController {

    @Autowired
    private ProductRepository productRepo;

    @Autowired
    private OrderRepository orderRepo;

    @Autowired
    private OrderItemRepository orderItemRepo;

    @Autowired
    private EmailService emailService;

    @Autowired
    private CartService cartService;

    // ================= HELPER =================

    private String getEmail(HttpSession session) {
        return (String) session.getAttribute("userEmail");
    }

    private Map<String, Object> buildCartResponse(List<CartItem> cart) {
        Map<String, Object> response = new HashMap<>();
        double total = 0;
        int totalItems = 0;
        List<Map<String, Object>> cartItems = new ArrayList<>();

        if (cart == null) {
            cart = new ArrayList<>();
        }

        for (CartItem item : cart) {
            total += item.getProduct().getPrice() * item.getQuantity();
            totalItems += item.getQuantity();

            Map<String, Object> itemData = new HashMap<>();
            itemData.put("id", item.getProduct().getId());
            itemData.put("name", item.getProduct().getName());
            itemData.put("image", item.getProduct().getImage());
            itemData.put("price", item.getProduct().getPrice());
            itemData.put("quantity", item.getQuantity());
            cartItems.add(itemData);
        }

        response.put("success", true);
        response.put("cart", cartItems);
        response.put("total", total);
        response.put("totalItems", totalItems);
        return response;
    }

    // ================= CART =================

    @GetMapping("/cart")
    public String viewCart(HttpSession session, Model model) {
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null) {
            cart = new ArrayList<>();
        }

        model.addAttribute("cart", cart);
        return "cart";
    }

    // ================= ADD TO CART =================

    @GetMapping("/add-to-cart")
    public String addToCart(@RequestParam int id,
                            @RequestParam(defaultValue = "1") int qty,
                            HttpSession session) {

        Product product = productRepo.findById(id).orElse(null);
        if (product == null) return "redirect:/home";

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) cart = new ArrayList<>();

        boolean found = false;
        for (CartItem item : cart) {
            if (item.getProduct().getId() == id) {
                item.setQuantity(item.getQuantity() + qty);
                found = true;
                break;
            }
        }
        if (!found) cart.add(new CartItem(product, qty));

        session.setAttribute("cart", cart);

        // ✅ Sync DB nếu đã đăng nhập
        String email = getEmail(session);
        if (email != null) cartService.addItemToDB(email, id, qty);

        return "redirect:/cart";
    }

    // ================= BUY NOW =================

    @GetMapping("/buy-now")
public String buyNow(@RequestParam int id,
                     @RequestParam(defaultValue = "1") int qty,  // ✅ thêm tham số qty
                     HttpSession session) {

    Product product = productRepo.findById(id).orElse(null);
    if (product == null) return "redirect:/home";

    List<CartItem> cart = new ArrayList<>();
    cart.add(new CartItem(product, qty));  // ✅ dùng qty thay vì 1
    session.setAttribute("cart", cart);

    return "redirect:/checkout";
}

    // ================= CHECKOUT =================

    @GetMapping("/checkout")
    public String checkout(HttpSession session, Model model) {
        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null) {
            return "redirect:/login?redirect=checkout";
        }

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            return "redirect:/home";
        }

        model.addAttribute("cart", cart);
        return "checkout";
    }

    // ================= PLACE ORDER =================

    @PostMapping("/place-order")
    public String placeOrder(
            @RequestParam String fullname,
            @RequestParam String phone,
            @RequestParam(required = false) String email,
            @RequestParam String city,
            @RequestParam String address,
            @RequestParam(required = false) String note,
            @RequestParam String payment,
            HttpSession session) {

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) return "redirect:/cart";

        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null) userEmail = email;

        // Tính tổng tiền
        double total = 0;
        for (CartItem item : cart) {
            total += item.getProduct().getPrice() * item.getQuantity();
        }

        // Lưu đơn hàng
        Order order = new Order();
        order.setUserEmail(userEmail);
        order.setFullname(fullname);
        order.setPhone(phone);
        order.setEmail(email != null ? email : "");
        order.setCity(city);
        order.setAddress(address);
        order.setNote(note != null ? note : "");
        order.setPayment(payment);
        order.setTotal(total);
        orderRepo.save(order);

        // Lưu từng sản phẩm trong đơn
        for (CartItem item : cart) {
            OrderItem oi = new OrderItem();
            oi.setOrderId(order.getId());
            oi.setProductId(item.getProduct().getId());
            oi.setProductName(item.getProduct().getName());
            oi.setProductImage(item.getProduct().getImage());
            oi.setPrice(item.getProduct().getPrice());
            oi.setQuantity(item.getQuantity());
            orderItemRepo.save(oi);
        }

        // ✅ Xóa cart trong DB sau khi đặt hàng thành công
        String sessionEmail = getEmail(session);
        if (sessionEmail != null) cartService.clearCartInDB(sessionEmail);

        // Lưu vào session để hiển thị trang xác nhận
        session.setAttribute("orderedItems", cart);
        session.setAttribute("orderInfo", order);
        session.removeAttribute("cart");

        // Gửi email xác nhận
        Order savedOrder = orderRepo.findById(order.getId()).orElse(order);
        try {
            emailService.sendOrderConfirmation(savedOrder);
        } catch (Exception e) {
            System.err.println("Không gửi được email: " + e.getMessage());
        }

        return "redirect:/order-success";
    }

    // ================= ORDER SUCCESS =================

    @GetMapping("/order-success")
    public String orderSuccess(HttpSession session, Model model) {
        model.addAttribute("orderInfo", session.getAttribute("orderInfo"));
        model.addAttribute("orderedItems", session.getAttribute("orderedItems"));
        return "order-success";
    }

    // ================= MY ORDERS =================

    @GetMapping("/my-orders")
    public String myOrders(HttpSession session, Model model) {
        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null) return "redirect:/login";

        List<Order> orders = orderRepo.findByUserEmailOrderByCreatedAtDesc(userEmail);
        model.addAttribute("orders", orders);
        model.addAttribute("orderItemRepo", orderItemRepo);
        return "my-orders";
    }

    // ================= CART PLUS / MINUS =================

    @GetMapping("/cart-plus")
    public String cartPlus(@RequestParam int id, HttpSession session) {
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart != null) {
            for (CartItem item : cart) {
                if (item.getProduct().getId() == id) {
                    item.setQuantity(item.getQuantity() + 1);
                    // ✅ Sync DB
                    String email = getEmail(session);
                    if (email != null) cartService.updateQuantityInDB(email, id, item.getQuantity());
                    break;
                }
            }
        }
        return "redirect:/cart";
    }

    @GetMapping("/cart-minus")
    public String cartMinus(@RequestParam int id, HttpSession session) {
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart != null) {
            for (CartItem item : cart) {
                if (item.getProduct().getId() == id) {
                    if (item.getQuantity() > 1) {
                        item.setQuantity(item.getQuantity() - 1);
                        // ✅ Sync DB cập nhật số lượng
                        String email = getEmail(session);
                        if (email != null) cartService.updateQuantityInDB(email, id, item.getQuantity());
                    } else {
                        cart.remove(item);
                        // ✅ Sync DB xóa sản phẩm
                        String email = getEmail(session);
                        if (email != null) cartService.removeItemFromDB(email, id);
                    }
                    break;
                }
            }
        }
        return "redirect:/cart";
    }

    // ================= CLEAR / REMOVE CART =================

    @GetMapping("/clear-cart")
    public String clearCart(HttpSession session) {
        // ✅ Sync DB
        String email = getEmail(session);
        if (email != null) cartService.clearCartInDB(email);

        session.removeAttribute("cart");
        return "redirect:/cart";
    }

    @GetMapping("/remove-cart")
    public String removeCart(@RequestParam int id, HttpSession session) {
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart != null) {
            cart.removeIf(item -> item.getProduct().getId() == id);
            session.setAttribute("cart", cart);

            // ✅ Sync DB
            String email = getEmail(session);
            if (email != null) cartService.removeItemFromDB(email, id);
        }
        return "redirect:/cart";
    }

    // ================= CANCEL ORDER =================

    @PostMapping("/cancel-order")
    public String cancelOrder(@RequestParam int orderId,
                              HttpSession session,
                              RedirectAttributes redirectAttrs) {

        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null) return "redirect:/login";

        Order order = orderRepo.findById(orderId).orElse(null);

        if (order == null || !order.getUserEmail().equals(userEmail)) {
            redirectAttrs.addFlashAttribute("error", "❌ Không tìm thấy đơn hàng!");
            return "redirect:/my-orders";
        }

        if (!order.getStatus().equals("Chờ xác nhận")) {
            redirectAttrs.addFlashAttribute("error", "❌ Không thể hủy đơn hàng đang " + order.getStatus());
            return "redirect:/my-orders";
        }

        order.setStatus("Đã hủy");
        orderRepo.save(order);

        redirectAttrs.addFlashAttribute("message", "✅ Đã hủy đơn hàng #" + orderId);
        return "redirect:/my-orders";
    }

    // ================= ADD TO CART AJAX =================

    @PostMapping("/add-to-cart-ajax")
    @ResponseBody
    public Map<String, Object> addToCartAjax(@RequestParam int id,
                                             @RequestParam(defaultValue = "1") int qty,
                                             HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        Product product = productRepo.findById(id).orElse(null);
        if (product == null) {
            response.put("success", false);
            response.put("message", "Sản phẩm không tồn tại");
            return response;
        }

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) cart = new ArrayList<>();

        boolean found = false;
        for (CartItem item : cart) {
            if (item.getProduct().getId() == id) {
                item.setQuantity(item.getQuantity() + qty);
                found = true;
                break;
            }
        }
        if (!found) cart.add(new CartItem(product, qty));

        session.setAttribute("cart", cart);

        // ✅ Sync DB nếu đã đăng nhập
        String email = getEmail(session);
        if (email != null) cartService.addItemToDB(email, id, qty);

        return buildCartResponse(cart);
    }

    // ================= REMOVE FROM CART AJAX =================

    @PostMapping("/remove-cart-ajax")
    @ResponseBody
    public Map<String, Object> removeCartAjax(@RequestParam int id, HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart != null) {
            cart.removeIf(item -> item.getProduct().getId() == id);
            session.setAttribute("cart", cart);

            // ✅ Sync DB nếu đã đăng nhập
            String email = getEmail(session);
            if (email != null) cartService.removeItemFromDB(email, id);

            return buildCartResponse(cart);
        }

        response.put("success", false);
        return response;
    }

    // ================= GET CART DATA =================

    @GetMapping("/cart-data")
    @ResponseBody
    public Map<String, Object> getCartData(HttpSession session) {
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        return buildCartResponse(cart);
    }
}