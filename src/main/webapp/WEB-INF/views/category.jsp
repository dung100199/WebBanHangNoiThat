<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>${title}</title>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        .card img {
            height: 220px;
            object-fit: cover;
        }
        .card:hover {
            transform: scale(1.03);
            transition: 0.3s;
        }
    </style>
</head>

<body>
<jsp:include page="header.jsp" />    

<c:if test="${totalPages > 1}">
    <div class="d-flex justify-content-center mt-4 mb-2">
        <nav>
            <ul class="pagination">

                <!-- Nút Trước -->
                <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                    <a class="page-link"
                       href="/category/${title}?page=${currentPage - 1}">
                        ← Trước
                    </a>
                </li>

                <!-- Các số trang -->
                <c:forEach begin="0" end="${totalPages - 1}" var="i">
                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                        <a class="page-link"
                           href="/category/${title}?page=${i}">
                            ${i + 1}
                        </a>
                    </li>
                </c:forEach>

                <!-- Nút Sau -->
                <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                    <a class="page-link"
                       href="/category/${title}?page=${currentPage + 1}">
                        Sau →
                    </a>
                </li>

            </ul>
        </nav>
    </div>

    <!-- Hiển thị thông tin trang -->
    <p class="text-center text-muted mb-4" style="font-size:13px;">
        Trang ${currentPage + 1} / ${totalPages}
        &nbsp;|&nbsp; Tổng ${totalItems} sản phẩm
    </p>
</c:if>

<div class="container mt-4">
    <a href="/home" class="btn btn-dark mb-3">← Trang chủ</a>

    <h2 class="text-center text-uppercase mb-4">
    <c:choose>
        <c:when test="${title == 'phong-khach'}">Phòng Khách</c:when>
        <c:when test="${title == 'phong-ngu'}">Phòng Ngủ</c:when>
        <c:when test="${title == 'phong-bep'}">Phòng Bếp</c:when>
        <c:when test="${title == 'noi-that-van-phong'}">Nội Thất Văn Phòng</c:when>
        <c:when test="${title == 'noi-that-truong-hoc'}">Nội Thất Trường Học</c:when>
        <c:otherwise>${title}</c:otherwise>
    </c:choose>
    </h2>

    <div class="row">
        <c:forEach var="p" items="${products}">
            <div class="col-md-3">
                <div class="card mb-4 shadow-sm">

                    <a href="/product/${p.id}">
                        <img
                            src="${p.image}"
                            alt="${p.name}"
                            class="card-img-top"
                            loading="lazy"
                        >
                    </a>

                    <div class="card-body text-center">

                        <h5>
                            <a href="/product/${p.id}" style="text-decoration:none; color:black;">
                                ${p.name}
                            </a>
                        </h5>

                        <p style="color:red; font-weight:bold;">
                            <fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="0"/> VND
                        </p>

                        <a href="/add-to-cart?id=${p.id}" class="btn btn-success btn-sm">
                            🛒 Thêm
                        </a>

                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<jsp:include page="footer.jsp" />

</body>
</html>