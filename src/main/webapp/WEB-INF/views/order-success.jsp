<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Đặt hàng thành công</title>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f9f9f9; }
        .success-box {
            background: white;
            border-radius: 12px;
            padding: 40px;
            text-align: center;
            border: 1px solid #ddd;
            margin-top: 40px;
        }
        .success-icon {
            width: 80px;
            height: 80px;
            background: #28a745;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 40px;
            color: white;
        }
        .success-title {
            font-size: 26px;
            font-weight: 700;
            color: #1a2a5e;
            margin-bottom: 8px;
        }
        .success-subtitle {
            font-size: 15px;
            color: #666;
            margin-bottom: 30px;
        }
        .order-info-box {
            background: #f5f5f5;
            border-radius: 8px;
            padding: 20px;
            text-align: left;
            margin-bottom: 24px;
        }
        .order-info-box .row-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #eee;
            font-size: 14px;
        }
        .order-info-box .row-item:last-child {
            border-bottom: none;
        }
        .order-info-box .label { color: #888; }
        .order-info-box .value { font-weight: 600; color: #222; }
        .section-title {
            font-size: 16px;
            font-weight: 700;
            color: #1a2a5e;
            margin-bottom: 14px;
        }
        .product-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
            font-size: 14px;
        }
        .total-row {
            display: flex;
            justify-content: space-between;
            padding: 14px 0 0;
            font-weight: 700;
            font-size: 16px;
            color: #e00;
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container mb-5">
    <div class="row justify-content-center">
        <div class="col-md-7">

            <!-- HỘP THÀNH CÔNG -->
            <div class="success-box">
                <div class="success-icon">✓</div>
                <div class="success-title">Đặt hàng thành công!</div>
                <div class="success-subtitle">
                    Cảm ơn bạn đã mua hàng tại <strong>MVKE Furniture</strong>.<br>
                    Chúng tôi sẽ liên hệ xác nhận đơn hàng trong thời gian sớm nhất.
                </div>

                <!-- THÔNG TIN ĐƠN HÀNG -->
                <div class="text-start">
                    <div class="section-title">📋 Thông tin đơn hàng</div>
                    <div class="order-info-box">
                        <div class="row-item">
                            <span class="label">Họ và tên</span>
                            <span class="value">${orderInfo.fullname}</span>
                        </div>
                        <div class="row-item">
                            <span class="label">Số điện thoại</span>
                            <span class="value">${orderInfo.phone}</span>
                        </div>
                        <div class="row-item">
                            <span class="label">Email</span>
                            <span class="value">${orderInfo.email}</span>
                        </div>
                        <div class="row-item">
                            <span class="label">Địa chỉ giao hàng</span>
                            <span class="value">${orderInfo.address}, ${orderInfo.city}</span>
                        </div>
                        <div class="row-item">
                            <span class="label">Phương thức thanh toán</span>
                            <span class="value">
                                <c:choose>
                                    <c:when test="${orderInfo.payment == 'bank'}">🏦 Chuyển khoản ngân hàng</c:when>
                                    <c:when test="${orderInfo.payment == 'qr'}">📱 Quét mã QR</c:when>
                                    <c:when test="${orderInfo.payment == 'cod'}">💵 Tiền mặt khi nhận hàng</c:when>
                                </c:choose>
                            </span>
                        </div>
                        <c:if test="${not empty orderInfo.note}">
                        <div class="row-item">
                            <span class="label">Ghi chú</span>
                            <span class="value">${orderInfo.note}</span>
                        </div>
                        </c:if>
                    </div>

                    <!-- SẢN PHẨM ĐÃ ĐẶT -->
                    <div class="section-title"> Sản phẩm đã đặt</div>
                    <div class="order-info-box">
                        <c:set var="total" value="0" />
                        <c:forEach var="item" items="${orderedItems}">
                            <div class="product-row">
                                <span>
                                    <img src="${item.product.image}"
                                         style="height:40px; width:40px; object-fit:cover;
                                                border-radius:4px; margin-right:8px;">
                                    ${item.product.name}
                                    <span class="text-muted">× ${item.quantity}</span>
                                </span>
                                <span style="white-space:nowrap;">
                                    <fmt:formatNumber
                                        value="${item.product.price * item.quantity}"
                                        type="number" maxFractionDigits="0"/>đ
                                </span>
                            </div>
                            <c:set var="total" value="${total + item.product.price * item.quantity}" />
                        </c:forEach>

                        <div class="product-row">
                            <span style="color:#888;">Phí vận chuyển</span>
                            <span style="color:#28a745; font-weight:600;">Miễn phí</span>
                        </div>

                        <div class="total-row">
                            <span>Tổng cộng</span>
                            <span>
                                <fmt:formatNumber value="${total}" type="number" maxFractionDigits="0"/>đ
                            </span>
                        </div>
                    </div>

                    <!-- HƯỚNG DẪN NẾU CHỌN QR/BANK -->
                    <c:if test="${orderInfo.payment == 'qr' or orderInfo.payment == 'bank'}">
                    <div style="background:#fff8e1; border:1px solid #ffc107; border-radius:8px;
                                padding:16px; font-size:13px; margin-bottom:20px;">
                        <strong> Lưu ý thanh toán:</strong><br>
                        Vui lòng chuyển khoản đúng số tiền
                        <strong style="color:#e00;">
                            <fmt:formatNumber value="${total}" type="number" maxFractionDigits="0"/>đ
                        </strong>
                        đến tài khoản:<br>
                        Ngân hàng: <strong>Vietcombank</strong> |
                        STK: <strong>1039914852</strong> |
                        Chủ TK: <strong>MVKE FURNITURE</strong><br>
                        Nội dung: <strong>Thanh toan don hang MVKE</strong>
                    </div>
                    </c:if>
                </div>

                <!-- NÚT -->
                <div class="d-flex gap-3 justify-content-center">
                    <a href="/home" class="btn btn-dark px-4">← Tiếp tục mua sắm</a>
                </div>
            </div>

        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />

</body>
</html>