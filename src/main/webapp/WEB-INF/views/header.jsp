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
    .header .logo { height: 60px; }
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
    .menu a:hover { color: #f0a500; }
    .cart-wrapper { position: relative; display: inline-block; }
    .cart-icon { color: white; text-decoration: none; position: relative; }
    .cart-count {
        position: absolute; top: -8px; right: -10px;
        background: #ff4444; color: white; border-radius: 50%;
        padding: 2px 6px; font-size: 11px; font-weight: bold;
    }
    .cart-overlay {
        position: fixed; inset: 0; background: rgba(0,0,0,0.45);
        opacity: 0; visibility: hidden; transition: all 0.25s ease; z-index: 9998;
    }
    .cart-overlay.active { opacity: 1; visibility: visible; }
    .mini-cart {
        display: block; position: fixed; top: 0; right: -420px;
        width: 380px; max-width: calc(100vw - 24px); height: 100vh;
        background: #fff; color: #222;
        box-shadow: -8px 0 24px rgba(0,0,0,0.16);
        z-index: 9999; transition: right 0.25s ease;
    }
    .mini-cart.active { right: 0; }
    .mini-cart-header {
        display: flex; align-items: center; justify-content: space-between;
        padding: 22px 20px 16px; border-bottom: 1px solid #ececec;
    }
    .mini-cart-title { font-size: 24px; font-weight: 600; margin: 0; }
    .mini-cart-close {
        border: none; background: none; font-size: 28px;
        line-height: 1; color: #666; cursor: pointer;
    }
    #mini-cart-items { max-height: calc(100vh - 220px); overflow-y: auto; }
    .mini-cart-item {
        display: flex; align-items: center; gap: 14px;
        padding: 16px 20px; border-bottom: 1px solid #eee;
    }
    .mini-cart-item img { width: 64px; height: 64px; object-fit: cover; flex-shrink: 0; }
    .mini-cart-item-info { flex: 1; }
    .mini-cart-item-name { font-size: 15px; font-weight: 500; margin-bottom: 4px; }
    .mini-cart-item-meta { color: #666; font-size: 14px; }
    .mini-cart-remove {
        border: 1px solid #ddd; background: #fff; border-radius: 50%;
        width: 28px; height: 28px; line-height: 24px;
        text-align: center; cursor: pointer; color: #888;
    }
    .mini-cart-footer { padding: 10px; }
    .mini-cart-total {
        display: flex; justify-content: space-between;
        align-items: center; margin-bottom: 14px; font-size: 16px;
    }
    .mini-cart-total strong { color: #111; }
    .mini-cart-actions { display: flex; flex-direction: column; gap: 10px; }
    .mini-cart-btn {
        display: block; width: 100%; padding: 12px;
        border: 1px solid #111; text-transform: uppercase;
        font-weight: 700; text-decoration: none; text-align: center; color: #111;
    }
    .mini-cart-btn.primary { background: #111; color: #fff; }
    .mini-cart-empty { padding: 32px 20px; color: #777; text-align: center; }
</style>

<!-- TOP BAR -->
<div class="top-bar">
    <c:choose>
        <c:when test="${not empty sessionScope.userEmail}">
    <span>Xin chào,
        <c:choose>
            <c:when test="${not empty sessionScope.fullname}">${sessionScope.fullname}</c:when>
            <c:otherwise>${sessionScope.userEmail}</c:otherwise>
        </c:choose>
    </span>
    <span> | </span>
    ...

            <c:choose>
                <c:when test="${sessionScope.role == 'ADMIN'}">
                    <a href="/admin">🔧 Quản lý</a>
                    <span> | </span>
                    <a href="/profile">👤 Tài khoản</a>
                    <span> | </span>
                    <form method="post" action="/logout" style="display:inline;">
                        <button class="logout-btn" type="submit">Đăng xuất</button>
                    </form>
                </c:when>

                <c:otherwise>
                    <a href="/my-orders">📦 Đơn hàng</a>
                    <span> | </span>
                    <a href="/profile">👤 Tài khoản</a>
                    <span> | </span>
                    <form method="post" action="/logout" style="display:inline;">
                        <button class="logout-btn" type="submit">Đăng xuất</button>
                    </form>
                    <span> | </span>
                    <div class="cart-wrapper">
                        <a href="/cart" class="cart-icon" onclick="event.preventDefault(); openMiniCart();">
                            Giỏ hàng 🛒
                            <span id="cart-count" class="cart-count">0</span>
                        </a>
                        <div id="mini-cart" class="mini-cart">
                            <div class="mini-cart-header">
                                <h3 class="mini-cart-title">GIỎ HÀNG</h3>
                                <button type="button" class="mini-cart-close" onclick="closeMiniCart()">&times;</button>
                            </div>
                            <div id="mini-cart-items">
                                <p style="padding:10px;">Chưa có sản phẩm</p>
                            </div>
                            <div class="mini-cart-footer">
                                <div class="mini-cart-total">
                                    <span>Thành tiền:</span>
                                    <strong id="mini-cart-total">0 VND</strong>
                                </div>
                                <div class="mini-cart-actions">
                                    <a href="/cart" class="mini-cart-btn primary">Xem giỏ hàng</a>
                                    <a href="/checkout" class="mini-cart-btn">Thanh toán</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>

        </c:when>
        <c:otherwise>
            <a href="/login">Đăng nhập / Đăng ký</a>
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

<div id="cart-overlay" class="cart-overlay" onclick="closeMiniCart()"></div>

<script>
function formatCartPrice(price) {
    return new Intl.NumberFormat('vi-VN').format(price) + ' VND';
}

function openMiniCart() {
    const miniCart = document.getElementById("mini-cart");
    const overlay = document.getElementById("cart-overlay");
    if (!miniCart || !overlay) return;
    miniCart.classList.add("active");
    overlay.classList.add("active");
    document.body.style.overflow = "hidden";
}

function closeMiniCart() {
    const miniCart = document.getElementById("mini-cart");
    const overlay = document.getElementById("cart-overlay");
    if (!miniCart || !overlay) return;
    miniCart.classList.remove("active");
    overlay.classList.remove("active");
    document.body.style.overflow = "";
}

function updateMiniCart(cart, totalItems, totalAmount) {
    const container = document.getElementById("mini-cart-items");
    const count = document.getElementById("cart-count");
    const total = document.getElementById("mini-cart-total");
    if (!container || !count || !total) return;

    count.innerText = totalItems;
    total.innerText = formatCartPrice(totalAmount || 0);

    if (!cart || cart.length === 0) {
        container.innerHTML = "<div class='mini-cart-empty'>Chưa có sản phẩm</div>";
        return;
    }

    let html = "";
    cart.forEach(item => {
        html += '<div class="mini-cart-item">'
            + '<img src="' + item.image + '">'
            + '<div class="mini-cart-item-info">'
            + '<div class="mini-cart-item-name">' + item.name + '</div>'
            + '<div class="mini-cart-item-meta">' + item.quantity + ' x ' + formatCartPrice(item.price) + '</div>'
            + '</div>'
            + '<button type="button" class="mini-cart-remove" onclick="removeFromMiniCart(' + item.id + ')">&times;</button>'
            + '</div>';
    });
    container.innerHTML = html;
}

window.addEventListener("DOMContentLoaded", () => {
    fetch('/cart-data')
        .then(res => res.json())
        .then(data => updateMiniCart(data.cart, data.totalItems, data.total));
});

function syncMiniCart(data) {
    if (!data) return;
    updateMiniCart(data.cart || [], data.totalItems || 0, data.total || 0);
}

function addProductToCart(productId, qty, onFinally) {
    fetch('/add-to-cart-ajax', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'id=' + encodeURIComponent(productId) + '&qty=' + encodeURIComponent(qty || 1)
    })
    .then(res => res.json())
    .then(data => {
        if (!data.success) throw new Error(data.message || 'Không thể thêm sản phẩm vào giỏ hàng');
        syncMiniCart(data);
        openMiniCart();
    })
    .catch(error => {
        console.error('Error:', error);
        alert(error.message || 'Có lỗi xảy ra. Vui lòng thử lại.');
    })
    .finally(() => {
        if (typeof onFinally === 'function') onFinally();
    });
}

function removeFromMiniCart(productId) {
    fetch('/remove-cart-ajax', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'id=' + encodeURIComponent(productId)
    })
    .then(res => res.json())
    .then(data => syncMiniCart(data))
    .catch(error => {
        console.error('Error:', error);
        alert('Có lỗi xảy ra. Vui lòng thử lại.');
    });
}
</script>