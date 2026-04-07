<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Giỏ hàng</title>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container mt-4 mb-5">

    <h2>🛒 Giỏ hàng</h2>

    <table class="table align-middle">
        <tr>
            <th>Tên</th>
            <th>Giá</th>
            <th>Số lượng</th>
            <th>Thành tiền</th>
            <th></th>
        </tr>

        <c:set var="total" value="0" />
        <c:forEach var="item" items="${cart}">
            <tr>
                <td>
                    <img src="${item.product.image}"
                         style="height:50px; width:50px; object-fit:cover; border-radius:4px; margin-right:8px;">
                    ${item.product.name}
                </td>
                <td>
                    <fmt:formatNumber value="${item.product.price}" type="number" maxFractionDigits="0"/> VND
                </td>
                <td>
                    <!-- NÚT TĂNG GIẢM SỐ LƯỢNG -->
                    <div class="d-flex align-items-center border rounded" style="width:110px;">
                        <a href="/cart-minus?id=${item.product.id}"
                           class="btn btn-sm" style="font-size:18px; padding:2px 8px;">−</a>
                        <span style="width:36px; text-align:center; font-weight:600;">${item.quantity}</span>
                        <a href="/cart-plus?id=${item.product.id}"
                           class="btn btn-sm" style="font-size:18px; padding:2px 8px;">+</a>
                    </div>
                </td>
                <td style="color:red; font-weight:bold;">
                    <fmt:formatNumber value="${item.product.price * item.quantity}"
                                      type="number" maxFractionDigits="0"/> VND
                </td>
                <td>
                    <a href="/remove-cart?id=${item.product.id}" class="btn btn-danger btn-sm">Xóa</a>
                </td>
            </tr>
            <c:set var="total" value="${total + item.product.price * item.quantity}" />
        </c:forEach>

        <!-- TỔNG TIỀN -->
        <tr>
            <td colspan="3" class="text-end fw-bold">Tổng cộng:</td>
            <td style="color:red; font-weight:bold; font-size:16px;">
                <fmt:formatNumber value="${total}" type="number" maxFractionDigits="0"/> VND
            </td>
            <td></td>
        </tr>
    </table>

    <div class="d-flex gap-2">
        <a href="/home" class="btn btn-dark">← Tiếp tục mua</a>
        <a href="/clear-cart" class="btn btn-outline-danger">🗑️ Xóa toàn bộ giỏ hàng</a>
        <a href="/checkout" class="btn btn-success ms-auto">Thanh toán →</a>
    </div>

</div>

<jsp:include page="footer.jsp" />

</body>
</html>