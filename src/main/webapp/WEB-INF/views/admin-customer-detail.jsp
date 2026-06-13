<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết khách hàng</title>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .info-card {
            background: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 24px;
            margin-bottom: 24px;
        }
        .info-label { font-size: 13px; color: #888; margin-bottom: 2px; }
        .info-value { font-size: 15px; font-weight: 600; color: #222; }
        .stat-box {
            background: #f4f6fb;
            border-radius: 8px;
            padding: 16px 20px;
            text-align: center;
        }
        .stat-number { font-size: 28px; font-weight: 700; color: #1a2a5e; }
        .stat-label  { font-size: 13px; color: #888; margin-top: 4px; }
        .status-cho  { background:#fff3cd; color:#856404; padding:3px 10px; border-radius:20px; font-size:12px; }
        .status-xac  { background:#cce5ff; color:#004085; padding:3px 10px; border-radius:20px; font-size:12px; }
        .status-giao { background:#d4edda; color:#155724; padding:3px 10px; border-radius:20px; font-size:12px; }
        .status-hoan { background:#f8d7da; color:#721c24; padding:3px 10px; border-radius:20px; font-size:12px; }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container mt-4 mb-5">

    <div class="mb-3">
        <a href="/admin#khach-hang" class="btn btn-outline-secondary btn-sm">Quay lại danh sách</a>
    </div>

    <h4 class="mb-4" style="color:#1a2a5e; font-weight:700;">Chi tiết khách hàng</h4>

    <!-- THÔNG TIN KHÁCH HÀNG -->
    <div class="info-card">
        <div class="row g-4">
            <div class="col-md-3">
                <div class="info-label">Họ tên</div>
                <div class="info-value">
                    <c:choose>
                        <c:when test="${not empty customer.fullname}">${customer.fullname}</c:when>
                        <c:otherwise><span style="color:#bbb;">Chưa cập nhật</span></c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="col-md-3">
                <div class="info-label">Email</div>
                <div class="info-value">${customer.email}</div>
            </div>
            <div class="col-md-3">
                <div class="info-label">Số điện thoại</div>
                <div class="info-value">
                    <c:choose>
                        <c:when test="${not empty customer.phone}">${customer.phone}</c:when>
                        <c:otherwise><span style="color:#bbb;">Chưa cập nhật</span></c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="col-md-3">
                <div class="info-label">Địa chỉ</div>
                <div class="info-value">
                    <c:choose>
                        <c:when test="${not empty customer.address}">${customer.address}</c:when>
                        <c:otherwise><span style="color:#bbb;">Chưa cập nhật</span></c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- THỐNG KÊ -->
    <c:set var="completedCount" value="0" />
    <c:forEach var="o" items="${orders}">
        <c:if test="${o.status == 'Hoàn thành'}">
            <c:set var="completedCount" value="${completedCount + 1}" />
        </c:if>
    </c:forEach>

    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="stat-box">
                <div class="stat-number">${totalOrders}</div>
                <div class="stat-label">Tổng đơn hàng</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-box">
                <div class="stat-number">
                    <fmt:formatNumber value="${totalSpent}" type="number" maxFractionDigits="0"/>đ
                </div>
                <div class="stat-label">Tổng chi tiêu</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-box">
                <div class="stat-number">${completedCount}</div>
                <div class="stat-label">Đơn hoàn thành</div>
            </div>
        </div>
    </div>

    <!-- LỊCH SỬ ĐƠN HÀNG -->
    <div class="info-card">
        <h5 class="mb-3" style="color:#1a2a5e; font-weight:700;">Lịch sử đơn hàng</h5>

        <c:choose>
            <c:when test="${empty orders}">
                <div style="color:#888; text-align:center; padding:32px;">
                    Khách hàng chưa có đơn hàng nào.
                </div>
            </c:when>
            <c:otherwise>
                <table class="table table-bordered table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>Mã đơn</th>
                            <th>Ngày đặt</th>
                            <th>Địa chỉ</th>
                            <th>Thanh toán</th>
                            <th>Tổng tiền</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="o" items="${orders}">
                            <tr>
                                <td>#${o.id}</td>
                                <td style="font-size:13px; white-space:nowrap;">
                                    ${o.createdAt.dayOfMonth}/${o.createdAt.monthValue}/${o.createdAt.year}
                                    ${o.createdAt.hour}:<c:choose>
                                        <c:when test="${o.createdAt.minute < 10}">0${o.createdAt.minute}</c:when>
                                        <c:otherwise>${o.createdAt.minute}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="font-size:13px;">${o.address}, ${o.city}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${o.payment == 'bank'}">Chuyển khoản</c:when>
                                        <c:when test="${o.payment == 'qr'}">QR</c:when>
                                        <c:when test="${o.payment == 'cod'}">COD</c:when>
                                    </c:choose>
                                </td>
                                <td style="color:red; font-weight:bold; white-space:nowrap;">
                                    <fmt:formatNumber value="${o.total}" type="number" maxFractionDigits="0"/>đ
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${o.status == 'Chờ xác nhận'}"><span class="status-cho">Chờ xác nhận</span></c:when>
                                        <c:when test="${o.status == 'Đã xác nhận'}"><span class="status-xac">Đã xác nhận</span></c:when>
                                        <c:when test="${o.status == 'Đang giao'}"><span class="status-giao">Đang giao</span></c:when>
                                        <c:when test="${o.status == 'Hoàn thành'}"><span class="status-giao">Hoàn thành</span></c:when>
                                        <c:otherwise><span class="status-hoan">${o.status}</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

</div>

<jsp:include page="footer.jsp" />

</body>
</html>