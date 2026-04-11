<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<meta charset="UTF-8">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>MVKE Shop</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        .featured-section {
            margin-top: 40px;
        }

        .featured-grid {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 28px;
            padding: 0 10px;
        }

        .featured-card {
            width: 250px;
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
            background: #fff;
        }

        .featured-card img {
            width: 100%;
            height: 180px;
            object-fit: cover;
        }

        .featured-card h3 {
            margin-top: 10px;
            font-size: 18px;
            font-weight: 600;
        }

        .banner img {
            width: 100%;
            height: 500px;
            object-fit: cover;
        }
    </style>
</head>

<body>

<!-- ✅ HEADER -->
<jsp:include page="header.jsp" />

<!-- BANNER -->
<div class="banner">
    <img src="/images/home1.jpg">
</div>

<c:if test="${not empty dbError}">
    <div class="container mt-3">
        <div class="alert alert-warning text-center">
            Lỗi dữ liệu từ MySQL: ${dbError}
        </div>
    </div>
</c:if>

<!-- FEATURED -->
<div class="featured-section">
    <div class="featured-grid">

        <a class="featured-card" href="/category/phong-khach">
            <img src="/images/homepk.jpg">
            <h3>Phòng Khách</h3>
        </a>

        <a class="featured-card" href="/category/phong-ngu">
            <img src="/images/homepn.jpg">
            <h3>Phòng Ngủ</h3>
        </a>

        <a class="featured-card" href="/category/phong-bep">
            <img src="/images/homepb.jpeg">
            <h3>Phòng Bếp</h3>
        </a>

        <a class="featured-card" href="/category/noi-that-van-phong">
            <img src="/images/homevp.jpg">
            <h3>Nội Thất Văn Phòng</h3>
        </a>

        <a class="featured-card" href="/category/noi-that-truong-hoc">
            <img src="/images/homesc.jpg">
            <h3>Nội Thất Trường Học</h3>
        </a>

    </div>
</div>

<!-- ABOUT -->
<div class="container mt-5 mb-5">
    <div class="row align-items-center">

        <div class="col-md-6">
            <img src="/images/home1.jpg" style="width:100%;">
        </div>

        <div class="col-md-6">
            <h2>Về MVKE</h2>
            <p>
                MVKE là thương hiệu nội thất hiện đại, mang đến giải pháp không gian sống
                tinh tế, tiện nghi và đậm chất cá nhân.
            </p>

            <p>
                Chúng tôi không ngừng đổi mới để mang đến những sản phẩm tốt nhất.
            </p>
        </div>

    </div>
</div>

<!-- ✅ FOOTER -->
<jsp:include page="footer.jsp" />

</body>
</html>