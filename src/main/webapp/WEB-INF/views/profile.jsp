<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Thông tin cá nhân</title>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f5f5f5; }
        .section-title {
            font-size: 16px;
            font-weight: 700;
            color: #1a2a5e;
            border-bottom: 2px solid #1a2a5e;
            padding-bottom: 8px;
            margin-bottom: 20px;
        }
        .avatar {
            width: 80px; height: 80px;
            background: #1a2a5e;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 32px; color: white; font-weight: 700;
        }
        .status-cho  { background:#fff3cd; color:#856404; padding:3px 10px; border-radius:20px; font-size:12px; }
        .status-xac  { background:#cce5ff; color:#004085; padding:3px 10px; border-radius:20px; font-size:12px; }
        .status-giao { background:#d4edda; color:#155724; padding:3px 10px; border-radius:20px; font-size:12px; }
        .status-huy  { background:#f8d7da; color:#721c24; padding:3px 10px; border-radius:20px; font-size:12px; }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container mt-4 mb-5">

    <!-- HEADER PROFILE -->
    <div class="bg-white rounded border p-4 mb-4 d-flex align-items-center gap-4">
        <div class="avatar">
            ${user.fullname != null ? user.fullname.substring(0,1).toUpperCase() : user.email.substring(0,1).toUpperCase()}
        </div>
        <div>
            <h4 style="margin:0; color:#1a2a5e;">
                ${not empty user.fullname ? user.fullname : 'Chưa cập nhật tên'}
            </h4>
            <p style="margin:4px 0 0; color:#888; font-size:14px;">${user.email}</p>
            <c:if test="${sessionScope.role == 'ADMIN'}">
                <span style="background:#dc3545; color:white; padding:2px 8px; border-radius:4px; font-size:12px; font-weight:600;">
                    ⚙️ ADMIN
                </span>
            </c:if>
        </div>
    </div>

    <c:choose>
        <%-- Nếu là ADMIN: chỉ hiển thị form đổi mật khẩu --%>
        <c:when test="${sessionScope.role == 'ADMIN'}">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <!-- THÔNG BÁO -->
                    <c:if test="${not empty passError}">
                        <div class="alert alert-danger">${passError}</div>
                    </c:if>
                    <c:if test="${not empty passSuccess}">
                        <div class="alert alert-success">${passSuccess}</div>
                    </c:if>

                    <!-- FORM ĐỔI MẬT KHẨU -->
                    <div class="bg-white rounded border p-4 mb-4">
                        <div class="section-title"> Đổi mật khẩu</div>
                        <form action="/profile/change-password" method="post">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Mật khẩu hiện tại</label>
                                <input type="password" name="currentPassword"
                                       class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Mật khẩu mới</label>
                                <input type="password" name="newPassword"
                                       class="form-control" minlength="6" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Xác nhận mật khẩu mới</label>
                                <input type="password" name="confirmPassword"
                                       class="form-control" minlength="6" required>
                            </div>
                            <button type="submit" class="btn btn-warning w-100">
                                🔑 Đổi mật khẩu
                            </button>
                        </form>
                    </div>
                    
                    
                </div>
            </div>
        </c:when>

        <%-- Nếu là USER: hiển thị đầy đủ thông tin + lịch sử đơn hàng --%>
        <c:otherwise>
            <div class="row">

                <!-- CỘT TRÁI -->
                <div class="col-md-6">

                    <!-- THÔNG BÁO -->
                    <c:if test="${not empty message}">
                        <div class="alert alert-success">${message}</div>
                    </c:if>
                    <c:if test="${not empty passError}">
                        <div class="alert alert-danger">${passError}</div>
                    </c:if>
                    <c:if test="${not empty passSuccess}">
                        <div class="alert alert-success">${passSuccess}</div>
                    </c:if>

                    <!-- FORM THÔNG TIN -->
                    <div class="bg-white rounded border p-4 mb-4">
                        <div class="section-title">👤 Thông tin cá nhân</div>
                        <form action="/profile/update" method="post">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Email</label>
                                <input type="text" class="form-control" value="${user.email}" disabled>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Họ và tên</label>
                                <input type="text" name="fullname" class="form-control"
                                       value="${user.fullname}" placeholder="Nguyễn Văn A">
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Số điện thoại</label>
                                <input type="text" name="phone" class="form-control"
                                       value="${user.phone}" placeholder="0901234567">
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Địa chỉ mặc định</label>
                                <input type="text" name="address" class="form-control"
                                       value="${user.address}"
                                       placeholder="Số nhà, đường, phường, quận, tỉnh">
                            </div>
                            <button type="submit" class="btn btn-primary w-100">
                                💾 Lưu thông tin
                            </button>
                        </form>
                    </div>

                    <!-- FORM ĐỔI MẬT KHẨU -->
                    <div class="bg-white rounded border p-4 mb-4">
                        <div class="section-title"> Đổi mật khẩu</div>
                        <form action="/profile/change-password" method="post">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Mật khẩu hiện tại</label>
                                <input type="password" name="currentPassword"
                                       class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Mật khẩu mới</label>
                                <input type="password" name="newPassword"
                                       class="form-control" minlength="6" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Xác nhận mật khẩu mới</label>
                                <input type="password" name="confirmPassword"
                                       class="form-control" minlength="6" required>
                            </div>
                            <button type="submit" class="btn btn-warning w-100">
                                 Đổi mật khẩu
                            </button>
                        </form>
                    </div>
                </div>

                <!-- CỘT PHẢI: LỊCH SỬ ĐƠN HÀNG -->
                <div class="col-md-6">
                    <div class="bg-white rounded border p-4">
                        <div class="section-title"> Đơn hàng gần đây</div>

                        <c:choose>
                            <c:when test="${empty orders}">
                                <div class="text-center py-4" style="color:#888;">
                                    <div style="font-size:40px;"></div>
                                    <p>Chưa có đơn hàng nào</p>
                                    <a href="/home" class="btn btn-dark btn-sm">Mua sắm ngay</a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="order" items="${orders}">
                                    <div class="border rounded p-3 mb-3">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <strong style="color:#1a2a5e;">Đơn #${order.id}</strong>
                                            <c:choose>
                                                <c:when test="${order.status == 'Chờ xác nhận'}"><span class="status-cho">⏳ Chờ xác nhận</span></c:when>
                                                <c:when test="${order.status == 'Đã xác nhận'}"><span class="status-xac">✅ Đã xác nhận</span></c:when>
                                                <c:when test="${order.status == 'Đang giao'}"><span class="status-giao">🚚 Đang giao</span></c:when>
                                                <c:when test="${order.status == 'Hoàn thành'}"><span class="status-giao">✓ Hoàn thành</span></c:when>
                                                <c:otherwise><span class="status-huy">${order.status}</span></c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div style="font-size:13px; color:#888;">
                                        ${order.createdAt.dayOfMonth}/${order.createdAt.monthValue}/${order.createdAt.year}
                                        </div>
                                        <div class="d-flex justify-content-between align-items-center mt-2">
                                            <span style="font-size:13px; color:#555;">
                                                ${order.address}, ${order.city}
                                            </span>
                                            <strong style="color:#e00;">
                                                <fmt:formatNumber value="${order.total}"
                                                                  type="number"
                                                                  maxFractionDigits="0"/>đ
                                            </strong>
                                        </div>
                                    </div>
                                </c:forEach>
                                <a href="/my-orders" class="btn btn-outline-primary w-100 mt-2">
                                    Xem tất cả đơn hàng →
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

            </div>
        </c:otherwise>
    </c:choose>

</div>

<jsp:include page="footer.jsp" />

</body>
</html>