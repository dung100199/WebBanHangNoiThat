<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Tìm kiếm: ${keyword}</title>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .card img { height: 220px; object-fit: cover; }
        .card:hover { transform: scale(1.03); transition: 0.3s; }
        .keyword-highlight { color: #1a2a5e; font-weight: 700; }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container mt-4">
    <div class="mb-4">
        <h4>
            Kết quả tìm kiếm cho
            <span class="keyword-highlight">"${keyword}"</span>
        </h4>
        <p class="text-muted">Tìm thấy ${total} sản phẩm</p>
    </div>

    <c:choose>
        <c:when test="${empty products}">
            <div class="text-center py-5">
                <div style="font-size:60px;">🔍</div>
                <h5 class="mt-3" style="color:#888;">
                    Không tìm thấy sản phẩm nào với từ khóa "${keyword}"
                </h5>
                <p class="text-muted">Thử tìm với từ khóa khác hoặc duyệt theo danh mục</p>
                <a href="/home" class="btn btn-dark mt-2">← Về trang chủ</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row">
                <c:forEach var="p" items="${products}">
                    <div class="col-md-3">
                        <div class="card mb-4 shadow-sm">
                            <a href="/product/${p.id}">
                                <img src="${p.image}" alt="${p.name}" class="card-img-top">
                            </a>
                            <div class="card-body text-center">
                                <h5>
                                    <a href="/product/${p.id}"
                                       style="text-decoration:none; color:black;">
                                        ${p.name}
                                    </a>
                                </h5>
                                <p style="color:red; font-weight:bold;">
                                    <fmt:formatNumber value="${p.price}"
                                                      type="number"
                                                      maxFractionDigits="0"/> VND
                                </p>
                                <a href="/add-to-cart?id=${p.id}"
                                   class="btn btn-success btn-sm">
                                    🛒 Thêm
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="footer.jsp" />

</body>
</html>
