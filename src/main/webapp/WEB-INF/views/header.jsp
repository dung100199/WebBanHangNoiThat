<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    * { box-sizing: border-box; }

    /* ── TOP BAR ── */
    /* ── TOP BAR ── */
    .top-bar {
        background-color: #1a2a5e;
        color: rgba(255,255,255,0.85);
        text-align: right;
        padding: 8px 32px;
        font-size: 14px;
        letter-spacing: 0.2px;
        display: flex;
        justify-content: flex-end;
        align-items: center;
        gap: 4px;
    }
    /* Thêm thuộc tính này để ép form chứa nút Đăng xuất chạy thẳng hàng */
    .top-bar form {
        display: inline-flex;
        align-items: center;
        margin: 0; /* Xóa margin mặc định của form nếu có */
    }
    .top-bar a, .top-bar .logout-btn {
    color: rgba(255,255,255,0.85);
    text-decoration: none;
    background: none;
    border: none;
    cursor: pointer;
    font-size: 14px;
    padding: 2px 8px;
    border-radius: 4px;
    transition: background 0.18s, color 0.18s;
    white-space: nowrap;
}
    .top-bar a:hover, .top-bar .logout-btn:hover {
        color: #fff;
        background: rgba(255,255,255,0.12);
        text-decoration: none;
    }
    .top-bar .sep { color: rgba(255,255,255,0.35); }
    .top-bar span:not(.sep):not(.cart-count) { color: rgba(255,255,255,0.85); }

    /* ── HEADER ── */
    .header {
        background-color: #ffffff;
        padding: 16px 32px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid #ebebeb;
    }
    .header .logo { height: 56px; min-width: 120px; display: block; }
    .header > a { flex-shrink: 0; }
    .header .search-form {
        display: flex;
        align-items: center;
        background: #f4f4f6;
        border-radius: 24px;
        border: 1.5px solid transparent;
        padding: 0 6px 0 18px;
        transition: border-color 0.2s, box-shadow 0.2s;
        gap: 6px;
    }
    .header .search-form:focus-within {
        border-color: #1a2a5e;
        background: #fff;
        box-shadow: 0 0 0 3px rgba(26,42,94,0.08);
    }
    .header .search-box {
        width: 260px;
        border: none;
        background: transparent;
        padding: 9px 0;
        font-size: 14px;
        outline: none;
        color: #222;
    }
    .header .search-box::placeholder { color: #aaa; }
    .header .search-btn {
        background: #1a2a5e;
        color: white;
        border: none;
        padding: 7px 18px;
        border-radius: 20px;
        cursor: pointer;
        font-size: 13px;
        font-weight: 500;
        white-space: nowrap;
        transition: background 0.18s, transform 0.12s;
    }
    .header .search-btn:hover { background: #253a7e; }
    .header .search-btn:active { transform: scale(0.97); }

    /* ── MENU ── */
    .menu {
        background-color: #1a2a5e;
        padding: 0;
        text-align: center;
        display: flex;
        justify-content: center;
        align-items: stretch;
    }
    .menu a {
        color: rgba(255,255,255,0.88);
        text-decoration: none;
        font-size: 16px;
        font-weight: 500;
        letter-spacing: 0.4px;
        padding: 16px 32px;
        display: inline-block;
        position: relative;
        transition: color 0.18s;
    }
    .menu a::after {
        content: '';
        position: absolute;
        bottom: 0; left: 50%; right: 50%;
        height: 3px;
        background: #f0a500;
        border-radius: 2px 2px 0 0;
        transition: left 0.22s ease, right 0.22s ease;
    }
    .menu a:hover { color: #fff; }
    .menu a:hover::after { left: 20px; right: 20px; }

    /* ── CART ── */
    .cart-wrapper { position: relative; display: inline-flex; align-items: center; }
    .cart-icon {
        color: rgba(255,255,255,0.88);
        text-decoration: none;
        position: relative;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 16px 32px;
        font-size: 16px;
        font-weight: 500;
        transition: color 0.18s;
    }
    .cart-icon:hover { color: #fff; }
    .cart-count {
        background: #e8380d;
        color: white;
        border-radius: 10px;
        padding: 1px 6px;
        font-size: 11px;
        font-weight: 700;
        min-width: 18px;
        text-align: center;
        line-height: 16px;
    }

    .cart-overlay {
        position: fixed; inset: 0; background: rgba(10,15,40,0.5);
        opacity: 0; visibility: hidden;
        transition: opacity 0.28s ease, visibility 0.28s ease;
        z-index: 9998;
        backdrop-filter: blur(2px);
    }
    .cart-overlay.active { opacity: 1; visibility: visible; }

    .mini-cart {
        display: block; position: fixed; top: 0; right: -440px;
        width: 400px; max-width: calc(100vw - 20px); height: 100vh;
        background: #fff; color: #222;
        box-shadow: -4px 0 32px rgba(0,0,0,0.12);
        z-index: 9999;
        transition: right 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        display: flex; flex-direction: column;
    }
    .mini-cart.active { right: 0; }

    .mini-cart-header {
        display: flex; align-items: center; justify-content: space-between;
        padding: 24px 24px 18px;
        border-bottom: 1px solid #f0f0f0;
        flex-shrink: 0;
    }
    .mini-cart-title {
        font-size: 18px; font-weight: 600; margin: 0;
        letter-spacing: 1px; color: #1a2a5e;
    }
    .mini-cart-close {
        border: 1px solid #e8e8e8;
        background: #fafafa;
        width: 34px; height: 34px;
        border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        font-size: 20px; line-height: 1; color: #666; cursor: pointer;
        transition: background 0.15s, border-color 0.15s;
    }
    .mini-cart-close:hover { background: #f0f0f0; border-color: #ccc; }

    #mini-cart-items {
        flex: 1; overflow-y: auto;
        scrollbar-width: thin;
        scrollbar-color: #e0e0e0 transparent;
    }
    .mini-cart-item {
        display: flex; align-items: center; gap: 14px;
        padding: 16px 24px;
        border-bottom: 1px solid #f5f5f5;
        transition: background 0.15s;
    }
    .mini-cart-item:hover { background: #fafafa; }
    .mini-cart-item img {
        width: 68px; height: 68px; object-fit: cover; flex-shrink: 0;
        border-radius: 6px; border: 1px solid #f0f0f0;
    }
    .mini-cart-item-info { flex: 1; }
    .mini-cart-item-name { font-size: 14px; font-weight: 500; margin-bottom: 5px; color: #1a1a1a; }
    .mini-cart-item-meta { color: #888; font-size: 13px; }
    .mini-cart-remove {
        border: 1px solid #e8e8e8; background: #fff; border-radius: 50%;
        width: 30px; height: 30px;
        display: flex; align-items: center; justify-content: center;
        cursor: pointer; color: #aaa; font-size: 16px;
        transition: border-color 0.15s, color 0.15s, background 0.15s;
        flex-shrink: 0;
    }
    .mini-cart-remove:hover { border-color: #e8380d; color: #e8380d; background: #fff5f3; }

    .mini-cart-footer {
        padding: 18px 24px 24px;
        border-top: 1px solid #f0f0f0;
        flex-shrink: 0;
        background: #fafafa;
    }
    .mini-cart-total {
        display: flex; justify-content: space-between;
        align-items: center; margin-bottom: 16px;
        font-size: 15px; color: #444;
    }
    .mini-cart-total strong { color: #1a2a5e; font-size: 17px; font-weight: 600; }
    .mini-cart-actions { display: flex; flex-direction: column; gap: 10px; }
    .mini-cart-btn {
        display: block; width: 100%; padding: 13px;
        border: 1.5px solid #1a2a5e;
        border-radius: 6px;
        font-weight: 600; font-size: 13px; letter-spacing: 0.5px;
        text-transform: uppercase;
        text-decoration: none; text-align: center;
        color: #1a2a5e;
        background: transparent;
        transition: background 0.18s, color 0.18s;
    }
    .mini-cart-btn:hover { background: rgba(26,42,94,0.06); }
    .mini-cart-btn.primary { background: #1a2a5e; color: #fff; }
    .mini-cart-btn.primary:hover { background: #253a7e; }
    .mini-cart-empty {
        padding: 48px 24px; color: #aaa; text-align: center;
        font-size: 14px;
    }
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
            <span class="sep"> | </span>
            <c:choose>
                <c:when test="${sessionScope.role == 'ADMIN'}">
                    <a href="/admin">Quản lý</a>
                    <span class="sep"> | </span>
                    <a href="/profile">Tài khoản</a>
                    <span class="sep"> | </span>
                    <form method="post" action="/logout" style="display:inline;">
                        <button class="logout-btn" type="submit">Đăng xuất</button>
                    </form>
                </c:when>
                <c:otherwise>
                    <a href="/my-orders">Đơn hàng</a>
                    <span class="sep"> | </span>
                    <a href="/profile">Tài khoản</a>
                    <span class="sep"> | </span>
                    <form method="post" action="/logout" style="display:inline;">
                        <button class="logout-btn" type="submit">Đăng xuất</button>
                    </form>
                    <span class="sep"> | </span>
                    <div class="cart-wrapper">
                        <a href="/cart" class="cart-icon" onclick="event.preventDefault(); openMiniCart();">
                            Giỏ hàng
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
            <span class="sep"> | </span>
            <span>Giỏ hàng</span>
        </c:otherwise>
    </c:choose>
</div>

<!-- HEADER -->
<div class="header">
    <a href="/home"><img src="/images/logo.png" class="logo" alt="MOHO"></a>
    <form action="/search" method="get" class="search-form">
        <input type="text"
               name="keyword"
               placeholder="Nhập sản phẩm cần tìm..."
               class="search-box"
               value="${param.keyword}">
        <button type="submit" class="search-btn">Tìm</button>
    </form>
</div>

<!-- MENU -->
<div class="menu">
    <a href="/home">Trang chủ</a>
    <a href="/category/phong-khach">Phòng Khách</a>
    <a href="/category/phong-ngu">Phòng Ngủ</a>
    <a href="/category/phong-bep">Phòng Bếp</a>
    <a href="/category/noi-that-van-phong">Nội Thất Văn Phòng</a>
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

function addProductToCart(productId, qty, onFinally, variant) {
    var variantStr = variant || '';
    fetch('/add-to-cart-ajax', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'id=' + encodeURIComponent(productId)
            + '&qty=' + encodeURIComponent(qty || 1)
            + '&variant=' + encodeURIComponent(variantStr)
    })
    .then(res => res.json())
    .then(data => {
        if (!data.success) throw new Error(data.message || 'Khong the them san pham vao gio hang');
        syncMiniCart(data);
        openMiniCart();
    })
    .catch(error => {
        console.error('Error:', error);
        alert(error.message || 'Co loi xay ra. Vui long thu lai.');
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