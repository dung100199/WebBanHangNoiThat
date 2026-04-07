<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Đơn hàng của tôi</title>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f5f5f5; }
        .order-card {
            background: white;
            border-radius: 8px;
            border: 1px solid #eee;
            margin-bottom: 16px;
            overflow: hidden;
        }
        .order-header {
            background: #f9f9f9;
            padding: 12px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #eee;
            font-size: 13px;
            color: #888;
        }
        .order-header .order-id { font-weight: 700; color: #1a2a5e; }
        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-cho    { background:#fff3cd; color:#856404; }
        .status-xac    { background:#cce5ff; color:#004085; }
        .status-giao   { background:#d4edda; color:#155724; }
        .status-hoan   { background:#f8d7da; color:#721c24; }
        .product-row {
            display: flex;
            align-items: center;
            padding: 16px 20px;
            border-bottom: 1px solid #f5f5f5;
            gap: 14px;
        }
        .product-row img {
            width: 70px;
            height: 70px;
            object-fit: cover;
            border-radius: 6px;
            border: 1px solid #eee;
        }
        .product-name { font-weight: 600; font-size: 14px; }
        .product-qty  { font-size: 13px; color: #888; }
        .product-price { margin-left: auto; font-weight: 700; color: #e00; white-space: nowrap; }
        .order-footer {
            padding: 12px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .total-label { font-size: 14px; color: #555; }
        .total-value { font-size: 18px; font-weight: 700; color: #e00; }
        .payment-badge {
            font-size: 12px;
            color: #555;
            background: #f0f0f0;
            padding: 4px 10px;
            border-radius: 4px;
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container mt-4 mb-5">
    <c:if test="${not empty message}">
    <div class="alert alert-success">${message}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>
    <h4 style="color:#1a2a5e; font-weight:700;" class="mb-4"> Đơn hàng của tôi</h4>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="text-center py-5">
                <div style="font-size:60px;"></div>
                <h5 class="mt-3" style="color:#888;">Bạn chưa có đơn hàng nào</h5>
                <a href="/home" class="btn btn-dark mt-3">← Tiếp tục mua sắm</a>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="order" items="${orders}">
                <div class="order-card">

                    <!-- HEADER -->
                    <div class="order-header">
                        <span>
                            <span class="order-id">Đơn hàng #${order.id}</span>
                            &nbsp;|&nbsp;
                            ${order.createdAt.dayOfMonth}/${order.createdAt.monthValue}/${order.createdAt.year}
                            ${order.createdAt.hour}:${order.createdAt.minute}
                        </span>
                        <span>
                            <c:choose>
                                <c:when test="${order.status == 'Chờ xác nhận'}">
                                    <span class="status-badge status-cho">⏳ Chờ xác nhận</span>
                                </c:when>
                                <c:when test="${order.status == 'Đã xác nhận'}">
                                    <span class="status-badge status-xac">✅ Đã xác nhận</span>
                                </c:when>
                                <c:when test="${order.status == 'Đang giao'}">
                                    <span class="status-badge status-giao">🚚 Đang giao</span>
                                </c:when>
                                <c:when test="${order.status == 'Hoàn thành'}">
                                    <span class="status-badge status-giao">✓ Hoàn thành</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge status-hoan">${order.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <!-- SẢN PHẨM -->
                    <c:forEach var="item" items="${order.items}">
                        <div class="product-row">
                            <img src="${item.productImage}" alt="${item.productName}">
                            <div>
                                <div class="product-name">${item.productName}</div>
                                <div class="product-qty">Số lượng: ${item.quantity}</div>
                            </div>
                            <div class="product-price">
                                <fmt:formatNumber value="${item.price * item.quantity}"
                                                  type="number" maxFractionDigits="0"/>đ
                            </div>
                        </div>
                    </c:forEach>

                    <!-- FOOTER -->
                    <div class="order-footer">
                        <div>
                            <span class="payment-badge">
                                <c:choose>
                                    <c:when test="${order.payment == 'bank'}">🏦 Chuyển khoản</c:when>
                                    <c:when test="${order.payment == 'qr'}">📱 QR</c:when>
                                    <c:when test="${order.payment == 'cod'}">💵 COD</c:when>
                                </c:choose>
                            </span>
                            &nbsp;
                            <span style="font-size:13px; color:#888;">
                                Giao đến: ${order.address}, ${order.city}
                            </span>
                        </div>
                        <div class="d-flex align-items-center gap-3">
                            <div class="text-end">
                                <div class="total-label">Tổng tiền</div>
                                <div class="total-value">
                                    <fmt:formatNumber value="${order.total}" type="number" maxFractionDigits="0"/>đ
                                </div>
                            </div>
                            <!-- NÚT HỦY — chỉ hiện khi đang chờ xác nhận -->
                            <c:if test="${order.status == 'Chờ xác nhận'}">
                                <form action="/cancel-order" method="post"
                                    onsubmit="return confirm('Bạn có chắc muốn hủy đơn hàng #${order.id}?')">
                                    <input type="hidden" name="orderId" value="${order.id}">
                                    <button type="submit" class="btn btn-outline-danger btn-sm">
                                         Hủy đơn
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </div>

                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="footer.jsp" />

</body>
</html>