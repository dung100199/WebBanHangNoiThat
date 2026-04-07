<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Thanh toán</title>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f9f9f9; }
        .section-title {
            font-size: 18px;
            font-weight: 700;
            color: #1a2a5e;
            border-bottom: 2px solid #1a2a5e;
            padding-bottom: 8px;
            margin-bottom: 20px;
        }
        .form-label { font-weight: 600; font-size: 14px; }
        .form-control { border-radius: 4px; font-size: 14px; }
        .order-box {
            background: white;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 24px;
            position: sticky;
            top: 20px;
        }
        .order-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
            font-size: 14px;
        }
        .order-total {
            display: flex;
            justify-content: space-between;
            padding: 14px 0 0;
            font-weight: 700;
            font-size: 16px;
            color: #e00;
        }
        .payment-method {
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 12px 16px;
            margin-bottom: 10px;
            cursor: pointer;
            font-size: 14px;
            display: block;
            width: 100%;
        }
        .payment-method:hover { border-color: #1a2a5e; }
        .payment-method input { margin-right: 8px; }
        .bank-info {
            background: #f5f5f5;
            border-radius: 6px;
            padding: 14px;
            font-size: 13px;
            margin-bottom: 10px;
        }
        .btn-order {
            background: #e00;
            color: white;
            width: 100%;
            padding: 14px;
            font-size: 16px;
            font-weight: 700;
            border: none;
            border-radius: 6px;
            margin-top: 16px;
        }
        .btn-order:hover { background: #b00; color: white; }
        .policy-check { font-size: 13px; margin: 16px 0; }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<!-- Tính tổng tiền -->
<c:set var="total" value="0" />
<c:forEach var="item" items="${cart}">
    <c:set var="total" value="${total + item.product.price * item.quantity}" />
</c:forEach>

<div class="container mt-4 mb-5">
    <h4 class="mb-4" style="color:#1a2a5e; font-weight:700;">🛒 Thanh toán</h4>

    <form action="/place-order" method="post">
    <div class="row">

        <!-- CỘT TRÁI -->
        <div class="col-md-7">

            <!-- THÔNG TIN GIAO HÀNG -->
            <div class="bg-white p-4 rounded border mb-3">
                <div class="section-title">Địa chỉ giao hàng</div>

                <div class="mb-3">
                    <label class="form-label">Họ và tên *</label>
                    <input type="text" name="fullname" class="form-control"
                           placeholder="Nguyễn Văn A" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Số điện thoại *</label>
                    <input type="text" name="phone" class="form-control"
                           placeholder="0901234567" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Email *</label>
                    <input type="email" name="email" class="form-control"
                    value="${sessionScope.userEmail}"
                    placeholder="email@example.com" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Tỉnh / Thành phố *</label>
                    <select name="city" class="form-control" required>
                        <option value="">-- Chọn tỉnh thành --</option>
                        <option>Hà Nội</option>
                        <option>Tp. Hồ Chí Minh</option>
                        <option>Đà Nẵng</option>
                        <option>Hải Phòng</option>
                        <option>Cần Thơ</option>
                        <option>An Giang</option>
                        <option>Bình Dương</option>
                        <option>Đồng Nai</option>
                        <option>Khánh Hòa</option>
                        <option>Nghệ An</option>
                        <option>Thanh Hóa</option>
                        <option>Thừa Thiên Huế</option>
                        <option>Quảng Nam</option>
                        <option>Bắc Ninh</option>
                        <option>Lâm Đồng</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Địa chỉ cụ thể *</label>
                    <input type="text" name="address" class="form-control"
                           placeholder="Số nhà, tên đường, phường/xã, quận/huyện" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Ghi chú (tuỳ chọn)</label>
                    <textarea name="note" class="form-control" rows="3"
                              placeholder="Ghi chú thêm cho đơn hàng..."></textarea>
                </div>
            </div>

            <!-- PHƯƠNG THỨC THANH TOÁN -->
            <div class="bg-white p-4 rounded border">
                <div class="section-title">Phương thức thanh toán</div>

                <!-- CHUYỂN KHOẢN -->
                <label class="payment-method">
                    <input type="radio" name="payment" value="bank" checked
                           onclick="showPayment('bank')">
                    🏦 Chuyển khoản ngân hàng
                </label>
                <div id="bank-info" class="bank-info">
                    <strong>Ngân hàng Vietcombank</strong><br>
                    Số tài khoản: <strong>1039914852</strong><br>
                    Chủ tài khoản: <strong>MVKE FURNITURE</strong><br>
                    <span style="color:#e00;">Vui lòng chuyển khoản trước khi nhận hàng.</span>
                </div>

                <!-- QUÉT MÃ QR -->
                <label class="payment-method">
                    <input type="radio" name="payment" value="qr"
                           onclick="showPayment('qr')">
                    📱 Quét mã QR
                </label>
                <div id="qr-info" style="display:none; text-align:center; padding:20px;
                                         background:#f5f5f5; border-radius:6px; margin-bottom:10px;">
                    <p style="font-size:14px; color:#555; margin-bottom:12px;">
                        Quét mã QR để thanh toán
                        <strong style="color:#e00; font-size:16px;">
                            <fmt:formatNumber value="${total}" type="number" maxFractionDigits="0"/>đ
                        </strong>
                    </p>
                    <img src="https://img.vietqr.io/image/VCB-1039914852-compact2.png?amount=${total}&addInfo=Thanh%20toan%20don%20hang%20MVKE&accountName=MVKE%20FURNITURE"
                         alt="QR thanh toán"
                         style="width:230px; border:6px solid white; border-radius:10px;
                                box-shadow:0 4px 12px rgba(0,0,0,0.15);">
                    <p style="font-size:12px; color:#888; margin-top:12px; line-height:1.8;">
                        Ngân hàng: <strong>Vietcombank (VCB)</strong><br>
                        Số TK: <strong>1039914852</strong><br>
                        Chủ TK: <strong>MVKE FURNITURE</strong><br>
                        Nội dung: <strong>Thanh toan don hang MVKE</strong>
                    </p>
                </div>

                <!-- TIỀN MẶT COD -->
                <label class="payment-method">
                    <input type="radio" name="payment" value="cod"
                           onclick="showPayment('cod')">
                    💵 Thanh toán tiền mặt khi nhận hàng (COD)
                </label>
                <div id="cod-info" style="display:none; background:#f5f5f5; border-radius:6px;
                                          padding:14px; font-size:13px; margin-bottom:10px;">
                    Bạn sẽ thanh toán bằng tiền mặt khi nhận hàng.<br>
                    Nhân viên giao hàng sẽ thu tiền tại địa chỉ của bạn.
                </div>

                <div class="policy-check">
                    <input type="checkbox" required>
                    Tôi đã đọc và đồng ý
                    <a href="#" style="color:#1a2a5e;">
                        điều kiện đổi trả hàng, giao hàng và chính sách bảo mật
                    </a>
                </div>

                <button type="submit" class="btn btn-order">Đặt mua</button>
            </div>
        </div>

        <!-- CỘT PHẢI: TÓM TẮT ĐƠN HÀNG -->
        <div class="col-md-5">
            <div class="order-box">
                <div class="section-title">Tóm tắt đơn hàng</div>

                <c:forEach var="item" items="${cart}">
                    <div class="order-item">
                        <span>
                            <img src="${item.product.image}"
                                 style="height:45px; width:45px; object-fit:cover;
                                        border-radius:4px; margin-right:8px;">
                            ${item.product.name}
                            <span class="text-muted ms-1">× ${item.quantity}</span>
                        </span>
                        <span style="white-space:nowrap; margin-left:8px;">
                            <fmt:formatNumber
                                value="${item.product.price * item.quantity}"
                                type="number" maxFractionDigits="0"/>đ
                        </span>
                    </div>
                </c:forEach>

                <div class="order-item">
                    <span>Phí vận chuyển</span>
                    <span style="color:#28a745; font-weight:600;">Miễn phí</span>
                </div>

                <div class="order-total">
                    <span>Tổng cộng</span>
                    <span>
                        <fmt:formatNumber value="${total}" type="number" maxFractionDigits="0"/>đ
                    </span>
                </div>

                <a href="/cart" class="btn btn-outline-secondary w-100 mt-3">
                    ← Quay lại giỏ hàng
                </a>
            </div>
        </div>

    </div>
    </form>
</div>

<script>
    function showPayment(type) {
        document.getElementById('bank-info').style.display = 'none';
        document.getElementById('qr-info').style.display   = 'none';
        document.getElementById('cod-info').style.display  = 'none';
        if (type === 'bank') document.getElementById('bank-info').style.display = 'block';
        if (type === 'qr')   document.getElementById('qr-info').style.display   = 'block';
        if (type === 'cod')  document.getElementById('cod-info').style.display  = 'block';
    }
</script>

<jsp:include page="footer.jsp" />

</body>
</html>