<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .top-bar {
        background-color: #1a2a5e;
        color: white;
        text-align: right;
        padding: 6px 20px;
        font-size: 14px;
    }
    .top-bar a, .top-bar .logout-btn {
        color: white;
        text-decoration: none;
        background: none;
        border: none;
        cursor: pointer;
        font-size: 14px;
        padding: 0;
    }
    .top-bar a:hover, .top-bar .logout-btn:hover {
        text-decoration: underline;
    }
    .header {
        background-color: #f5f5f5;
        padding: 15px 30px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .header .logo {
        height: 60px;
    }
    .header .search-box {
        width: 280px;
        border-radius: 20px;
        border: 1px solid #ccc;
        padding: 8px 16px;
        font-size: 14px;
        outline: none;
    }
    .menu {
        background-color: #1a2a5e;
        padding: 12px 0;
        text-align: center;
    }
    .menu a {
        color: white;
        text-decoration: none;
        margin: 0 18px;
        font-size: 15px;
        font-weight: 500;
        letter-spacing: 0.3px;
    }
    .menu a:hover {
        color: #f0a500;
    }
</style>

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
                    <a href="/my-orders"> Đơn hàng</a>
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
            <%-- Chưa đăng nhập --%>
            <a href="/login">Đăng nhập</a>
            <span> | </span>
            <span>Giỏ hàng 🛒</span>
        </c:otherwise>
    </c:choose>
</div>

<!-- HEADER -->
<div class="header">
    <img src="/images/logo.png" class="logo">
    <form action="/search" method="get" style="display:flex; gap:8px;">
    <input type="text"
           name="keyword"
           placeholder="Nhập sản phẩm cần tìm..."
           class="search-box"
           value="${param.keyword}">
    <button type="submit"
            style="background:#1a2a5e; color:white; border:none;
                   padding:8px 16px; border-radius:20px; cursor:pointer;
                   font-size:14px; white-space:nowrap;">
        Tìm
    </button>
</form>
</div>

<!-- MENU -->
<div class="menu">
    <a href="/home">Trang chủ</a>
    <a href="/category/phong-khach">Phòng Khách</a>
    <a href="/category/phong-ngu">Phòng Ngủ</a>
    <a href="/category/phong-bep">Phòng Bếp</a>
    <a href="/category/noi-that-van-phong">Nội Thất Văn Phòng</a>
    <a href="/category/noi-that-truong-hoc">Nội Thất Trường Học</a>
</div>