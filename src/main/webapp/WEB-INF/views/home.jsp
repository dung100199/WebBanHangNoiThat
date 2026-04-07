<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<meta charset="UTF-8">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>MVKE Shop</title>
    <meta charset="UTF-8">

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            margin: 0;
            font-family: Arial;
        }

        /* TOP BAR */
        .top-bar {
            background: #0b1c5a;
            color: white;
            padding: 5px 20px;
            text-align: right;
        }

        .top-bar a {
            color: white;
            text-decoration: none;
            font-weight: 600;
        }

        .top-bar a:hover {
            color: yellow;
        }

        .top-bar .logout-btn {
            color: white;
            font-weight: 600;
            text-decoration: none;
            border: none;
            background: transparent;
            padding: 0;
        }

        .top-bar .logout-btn:hover {
            color: yellow;
        }

        /* HEADER */
        .header {
            background: #f2f2f2;
            padding: 15px 0;
        }

        .logo {
            height: 60px;
        }

        /* FEATURED (cards giống ảnh) */
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
            display: block;
        }

        .featured-card h3 {
            margin-top: 10px;
            font-size: 18px;
            font-weight: 600;
            color: #222;
        }

        /* MENU */
        .menu {
            background: #0b1c5a;
        }

        .menu a {
            color: white;
            margin: 0 15px;
            text-decoration: none;
            font-weight: bold;
        }

        .menu a:hover {
            color: yellow;
        }

        /* BANNER */
        .banner img {
            width: 100%;
            height: 500px;
            object-fit: cover;
        }

        /* ABOUT */
        .about img {
            border-radius: 10px;
        }

        /* FOOTER */
        .footer {
            background: #2c2c2c;
            color: white;
            padding: 40px 0;
        }

        .footer p {
            margin: 5px 0;
        }

        .footer h5 {
            margin-bottom: 15px;
        }
    </style>
</head>

<body>

<!-- TOP BAR -->
<div class="top-bar">
    <c:choose>
        <c:when test="${not empty sessionScope.userEmail}">
            <span>Xin chào, ${sessionScope.userEmail}</span>
            <span> | </span>
            
            <c:choose>
                <%-- Nếu là ADMIN: chỉ hiển thị Quản lý, Tài khoản, Đăng xuất --%>
                <c:when test="${sessionScope.role == 'ADMIN'}">
                    <a href="/admin">⚙️ Quản lý</a>
                    <span> | </span>
                    <a href="/profile">👤 Tài khoản</a>
                    <span> | </span>
                    <form method="post" action="/logout" style="display:inline;">
                        <button class="logout-btn" type="submit">Đăng xuất</button>
                    </form>
                </c:when>
                
                <%-- Nếu là USER: hiển thị Đơn hàng, Tài khoản, Đăng xuất, Giỏ hàng --%>
                <c:otherwise>
                    <a href="/orders">🛒 Đơn hàng</a>
                    <span> | </span>
                    <a href="/profile">👤 Tài khoản</a>
                    <span> | </span>
                    <form method="post" action="/logout" style="display:inline;">
                        <button class="logout-btn" type="submit">Đăng xuất</button>
                    </form>
                    <span> | </span>
                    <a href="/cart" style="color:white;">Giỏ hàng 🛒</a>
                </c:otherwise>
            </c:choose>
            
        </c:when>
        <c:otherwise>
            <a href="/login">Đăng nhập</a>
            <span> | </span>
            <span>Giỏ hàng 🛒</span>
        </c:otherwise>
    </c:choose>
</div>

<!-- HEADER -->
<div class="container header d-flex justify-content-between align-items-center">
    <a href="/home">
        <img src="/images/logo.png" class="logo">
    </a>
    <input type="text" placeholder="Nhập sản phẩm cần tìm..." class="form-control" style="width:250px;">
</div>

<!-- MENU -->
<div class="menu text-center p-3">
    <a href="/home">Trang chủ</a>
    <a href="/category/phong-khach">Phòng Khách</a>
    <a href="/category/phong-ngu">Phòng Ngủ</a>
    <a href="/category/phong-bep">Phòng Bếp</a>
    <a href="/category/noi-that-van-phong">Nội Thất Văn Phòng</a>
    <a href="/category/noi-that-truong-hoc">Nội Thất Trường Học</a>
</div>

<!-- BANNER -->
<div class="banner">
    <img src="/images/home1.jpg">
</div>

<c:if test="${not empty dbError}">
    <div class="container" style="margin-top:15px;">
        <div class="alert alert-warning text-center" style="margin-bottom:0;">
            Lỗi dữ liệu từ MySQL: ${dbError}
        </div>
    </div>
</c:if>

<div class="featured-section">
    <div class="featured-grid">
        <!-- Giữ giao diện: bọc ảnh + tiêu đề trong 1 link để cả 2 clickable, dùng class featured-card để giữ style -->
        <a class="featured-card" href="/category/phong-khach" style="text-decoration:none; color:inherit;">
            <img src="/images/homepk.jpg" alt="Phòng khách">
            <h3>Phòng Khách</h3>
        </a>

        <a class="featured-card" href="/category/phong-ngu" style="text-decoration:none; color:inherit;">
            <img src="/images/homepn.jpg" alt="Phòng ngủ">
            <h3>Phòng Ngủ</h3>
        </a>

        <a class="featured-card" href="/category/phong-bep" style="text-decoration:none; color:inherit;">
            <img src="/images/homepb.jpeg" alt="Phòng bếp">
            <h3>Phòng Bếp</h3>
        </a>

        <a class="featured-card" href="/category/noi-that-van-phong" style="text-decoration:none; color:inherit;">
            <img src="/images/homevp.jpg" alt="Nội thất văn phòng">
            <h3>Nội Thất Văn Phòng</h3>
        </a>

        <a class="featured-card" href="/category/noi-that-truong-hoc" style="text-decoration:none; color:inherit;">
            <img src="/images/homesc.jpg" alt="Nội thất trường học">
            <h3>Nội Thất Trường Học</h3>
        </a>
    </div>
</div>

<!-- ABOUT -->
<div class="container mt-5 mb-5 about">
    <div class="row align-items-center">

        <!-- IMAGE -->
        <div class="col-md-6">
            <img src="/images/home1.jpg" style="width:100%;">
        </div>

        <!-- TEXT -->
        <div class="col-md-6">
            <h2>Về MVKE</h2>
            <p style="color:#555; line-height:1.6;">
                MVKE là thương hiệu nội thất hiện đại, mang đến giải pháp không gian sống
                tinh tế, tiện nghi và đậm chất cá nhân. Chúng tôi tập trung vào thiết kế
                tối giản, chất lượng cao và trải nghiệm người dùng.
            </p>

            <p style="color:#555; line-height:1.6;">
                Với mục tiêu trở thành thương hiệu nội thất hàng đầu, MVKE không ngừng đổi
                mới và sáng tạo để mang đến những sản phẩm tốt nhất cho khách hàng.
            </p>
        </div>

    </div>
</div>