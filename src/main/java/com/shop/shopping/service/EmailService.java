package com.shop.shopping.service;

import com.shop.shopping.model.Order;
import com.shop.shopping.model.OrderItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import jakarta.mail.internet.MimeMessage;
import java.text.NumberFormat;
import java.io.UnsupportedEncodingException;
import java.util.Locale;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String fromEmail;

    public void sendOrderConfirmation(Order order) {
    try {
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

        helper.setFrom(fromEmail, "MVKE Furniture"); // ← tên hiển thị
        helper.setTo(order.getEmail().isEmpty() ? order.getUserEmail() : order.getEmail());
        helper.setSubject("✅ Xác nhận đơn hàng #" + order.getId() + " - MVKE Furniture");
        helper.setText(buildEmailContent(order), true);

        mailSender.send(message);

    } catch (UnsupportedEncodingException e) {
        System.err.println("Lỗi encoding tên: " + e.getMessage());
    } catch (Exception e) {
        System.err.println("Lỗi gửi email: " + e.getMessage());
    }
}

    private String buildEmailContent(Order order) {
        NumberFormat fmt = NumberFormat.getInstance(new Locale("vi", "VN"));

        StringBuilder items = new StringBuilder();
        for (OrderItem item : order.getItems()) {
            items.append("<tr>")
                 .append("<td style='padding:10px; border-bottom:1px solid #eee;'>")
                 .append("<img src='").append(item.getProductImage()).append("'")
                 .append(" style='width:60px; height:60px; object-fit:cover; border-radius:4px;'> ")
                 .append(item.getProductName()).append("</td>")
                 .append("<td style='padding:10px; border-bottom:1px solid #eee; text-align:center;'>")
                 .append(item.getQuantity()).append("</td>")
                 .append("<td style='padding:10px; border-bottom:1px solid #eee; text-align:right; color:#e00; font-weight:bold;'>")
                 .append(fmt.format((long)(item.getPrice() * item.getQuantity()))).append("đ</td>")
                 .append("</tr>");
        }

        String paymentLabel;
        switch (order.getPayment()) {
            case "bank": paymentLabel = "🏦 Chuyển khoản ngân hàng"; break;
            case "qr":   paymentLabel = "📱 Quét mã QR";             break;
            default:     paymentLabel = "💵 Tiền mặt khi nhận hàng"; break;
        }

        return "<!DOCTYPE html><html><body style='font-family:Arial,sans-serif; background:#f5f5f5; margin:0; padding:20px;'>"
             + "<div style='max-width:600px; margin:0 auto; background:white; border-radius:10px; overflow:hidden;'>"

             // Header
             + "<div style='background:#1a2a5e; padding:30px; text-align:center;'>"
             + "<h1 style='color:white; margin:0; font-size:24px;'>MVKE Furniture</h1>"
             + "<p style='color:#aac4ff; margin:8px 0 0;'>Cảm ơn bạn đã đặt hàng!</p>"
             + "</div>"

             // Success banner
             + "<div style='background:#e8f5e9; padding:20px; text-align:center; border-bottom:2px solid #28a745;'>"
             + "<div style='font-size:48px;'>✅</div>"
             + "<h2 style='color:#155724; margin:10px 0;'>Đặt hàng thành công!</h2>"
             + "<p style='color:#155724; margin:0;'>Mã đơn hàng: <strong>#" + order.getId() + "</strong></p>"
             + "</div>"

             // Thông tin giao hàng
             + "<div style='padding:24px;'>"
             + "<h3 style='color:#1a2a5e; border-bottom:2px solid #1a2a5e; padding-bottom:8px;'>📦 Thông tin giao hàng</h3>"
             + "<table style='width:100%; font-size:14px;'>"
             + "<tr><td style='padding:6px 0; color:#888; width:40%;'>Họ và tên</td><td style='padding:6px 0; font-weight:bold;'>" + order.getFullname() + "</td></tr>"
             + "<tr><td style='padding:6px 0; color:#888;'>Số điện thoại</td><td style='padding:6px 0; font-weight:bold;'>" + order.getPhone() + "</td></tr>"
             + "<tr><td style='padding:6px 0; color:#888;'>Địa chỉ</td><td style='padding:6px 0; font-weight:bold;'>" + order.getAddress() + ", " + order.getCity() + "</td></tr>"
             + "<tr><td style='padding:6px 0; color:#888;'>Thanh toán</td><td style='padding:6px 0; font-weight:bold;'>" + paymentLabel + "</td></tr>"
             + (order.getNote() != null && !order.getNote().isEmpty()
                ? "<tr><td style='padding:6px 0; color:#888;'>Ghi chú</td><td style='padding:6px 0;'>" + order.getNote() + "</td></tr>"
                : "")
             + "</table>"

             // Sản phẩm
             + "<h3 style='color:#1a2a5e; border-bottom:2px solid #1a2a5e; padding-bottom:8px; margin-top:24px;'>🛒 Sản phẩm đã đặt</h3>"
             + "<table style='width:100%; font-size:14px;'>"
             + "<tr style='background:#f5f5f5;'>"
             + "<th style='padding:10px; text-align:left;'>Sản phẩm</th>"
             + "<th style='padding:10px; text-align:center;'>SL</th>"
             + "<th style='padding:10px; text-align:right;'>Thành tiền</th>"
             + "</tr>"
             + items.toString()
             + "<tr>"
             + "<td colspan='2' style='padding:14px 10px; font-weight:bold; font-size:16px;'>Tổng cộng</td>"
             + "<td style='padding:14px 10px; font-weight:bold; font-size:18px; color:#e00; text-align:right;'>"
             + fmt.format((long) order.getTotal()) + "đ</td>"
             + "</tr>"
             + "</table>"

             // Chuyển khoản nếu cần
             + (order.getPayment().equals("bank") || order.getPayment().equals("qr")
                ? "<div style='background:#fff8e1; border:1px solid #ffc107; border-radius:8px; padding:16px; margin-top:20px; font-size:13px;'>"
                  + "<strong>⚠️ Vui lòng chuyển khoản:</strong><br>"
                  + "Ngân hàng: <strong>Vietcombank</strong> | STK: <strong>1039914852</strong><br>"
                  + "Chủ TK: <strong>MVKE FURNITURE</strong><br>"
                  + "Số tiền: <strong style='color:#e00;'>" + fmt.format((long) order.getTotal()) + "đ</strong><br>"
                  + "Nội dung: <strong>Thanh toan don hang #" + order.getId() + "</strong>"
                  + "</div>"
                : "")

             + "</div>"

             // Footer
             + "<div style='background:#f5f5f5; padding:20px; text-align:center; font-size:12px; color:#888;'>"
             + "<p>MVKE Furniture - Nội thất hiện đại</p>"
             + "<p>Hotline: 0901234567 | Email: mvke@gmail.com</p>"
             + "</div>"

             + "</div></body></html>";
    }
}