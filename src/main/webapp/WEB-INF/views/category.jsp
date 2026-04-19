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
        
        /* Cart Sidebar Styles */
        .cart-sidebar-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            z-index: 9998;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
        }
        
        .cart-sidebar-overlay.active {
            opacity: 1;
            visibility: visible;
        }
        
        .cart-sidebar {
            position: fixed;
            top: 0;
            right: -450px;
            width: 420px;
            height: 100vh;
            background: white;
            z-index: 9999;
            box-shadow: -2px 0 10px rgba(0,0,0,0.1);
            transition: right 0.3s ease;
            display: flex;
            flex-direction: column;
        }
        
        .cart-sidebar.active {
            right: 0;
        }
        
        .cart-header {
            padding: 20px;
            border-bottom: 1px solid #e0e0e0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .cart-header h3 {
            margin: 0;
            font-size: 18px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .cart-close {
            background: none;
            border: none;
            font-size: 28px;
            cursor: pointer;
            color: #666;
            line-height: 1;
            padding: 0;
            width: 30px;
            height: 30px;
        }
        
        .cart-close:hover {
            color: #000;
        }
        
        .cart-items {
            flex: 1;
            overflow-y: auto;
            padding: 20px;
        }
        
        .cart-item {
            display: flex;
            gap: 15px;
            padding-bottom: 20px;
            margin-bottom: 20px;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .cart-item:last-child {
            border-bottom: none;
        }
        
        .cart-item-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 4px;
        }
        
        .cart-item-info {
            flex: 1;
        }
        
        .cart-item-name {
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 5px;
            color: #333;
        }
        
        .cart-item-price {
            font-size: 14px;
            color: #666;
            margin-bottom: 5px;
        }
        
        .cart-item-quantity {
            font-size: 13px;
            color: #999;
        }
        
        .cart-item-remove {
            background: none;
            border: none;
            color: #999;
            font-size: 20px;
            cursor: pointer;
            padding: 0;
            width: 24px;
            height: 24px;
        }
        
        .cart-item-remove:hover {
            color: #dc3545;
        }
        
        .cart-empty {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        
        .cart-empty-icon {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.3;
        }
        
        .cart-footer {
            border-top: 1px solid #e0e0e0;
            padding: 20px;
            background: #fafafa;
        }
        
        .cart-total {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            font-size: 16px;
        }
        
        .cart-total-label {
            font-weight: 500;
        }
        
        .cart-total-amount {
            font-weight: 600;
            color: #dc3545;
        }
        
        .cart-buttons {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        
        .cart-btn {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-transform: uppercase;
            text-align: center;
            text-decoration: none;
            display: block;
        }
        
        .cart-btn-view {
            background: white;
            border: 1px solid #333;
            color: #333;
        }
        
        .cart-btn-view:hover {
            background: #f5f5f5;
        }
        
        .cart-btn-checkout {
            background: #333;
            color: white;
        }
        
        .cart-btn-checkout:hover {
            background: #000;
        }
        
        .btn-add-cart:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }
        
        .spinner-border-sm {
            width: 1rem;
            height: 1rem;
            border-width: 0.15em;
        }
        
        /* Scrollbar styling */
        .cart-items::-webkit-scrollbar {
            width: 6px;
        }
        
        .cart-items::-webkit-scrollbar-track {
            background: #f1f1f1;
        }
        
        .cart-items::-webkit-scrollbar-thumb {
            background: #888;
            border-radius: 3px;
        }
        
        .cart-items::-webkit-scrollbar-thumb:hover {
            background: #555;
        }
    </style>
</head>

<body>
<jsp:include page="header.jsp" />    

<!-- Cart Sidebar Overlay -->
<div class="cart-sidebar-overlay" id="cartOverlay" onclick="closeCartSidebar()"></div>

<!-- Cart Sidebar -->
<div class="cart-sidebar" id="cartSidebar">
    <div class="cart-header">
        <h3>Gi? h?ng</h3>
        <button class="cart-close" onclick="closeCartSidebar()">?</button>
    </div>
    
    <div class="cart-items" id="cartItemsContainer">
        <!-- Cart items will be loaded here -->
    </div>
    
    <div class="cart-footer" id="cartFooter">
        <div class="cart-total">
            <span class="cart-total-label">Thành tiền:</span>
            <span class="cart-total-amount" id="cartTotalAmount">0 VND</span>
        </div>
        <div class="cart-buttons">
            <a href="/cart" class="cart-btn cart-btn-view">Xem giỏ hàng</a>
            <a href="/checkout" class="cart-btn cart-btn-checkout">Checkout</a>
        </div>
    </div>
</div>

<div class="container mt-4">
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

                        <c:if test="${sessionScope.role != 'ADMIN'}">
                        <button 
                            onclick="addToCart(${p.id})" 
                            class="btn btn-success btn-sm btn-add-cart"
                            id="btn-${p.id}">
                            <span class="btn-text">Thêm</span>
                        </button>
                    </c:if>

                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<c:if test="${totalPages > 1}">
    <div class="d-flex justify-content-center mt-4 mb-2">
        <nav>
            <ul class="pagination">

                <!-- NÃºt TrÆ°á»›c -->
                <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                    <a class="page-link"
                       href="/category/${title}?page=${currentPage - 1}">
                        < Trước
                    </a>
                </li>

                <!-- CÃ¡c sá»‘ trang -->
                <c:forEach begin="0" end="${totalPages - 1}" var="i">
                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                        <a class="page-link"
                           href="/category/${title}?page=${i}">
                            ${i + 1}
                        </a>
                    </li>
                </c:forEach>

                <!-- NÃºt Sau -->
                <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                    <a class="page-link"
                       href="/category/${title}?page=${currentPage + 1}">
                        Sau >
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

<jsp:include page="footer.jsp" />

<script>
function formatPrice(price) {
    return new Intl.NumberFormat('vi-VN').format(price) + ' VND';
}

function addToCart(productId) {
    const btn = document.getElementById('btn-' + productId);
    const btnText = btn.querySelector('.btn-text');
    
    // Disable button vÃ  hiá»ƒn thá»‹ loading
    btn.disabled = true;
    btnText.innerHTML = '<span class="spinner-border spinner-border-sm"></span>';

    addProductToCart(productId, 1, function() {
        btn.disabled = false;
        btnText.textContent = 'Thêm';
    });
    return;

    // Gá»­i request AJAX
    fetch('/add-to-cart-ajax', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'id=' + productId + '&qty=1'
    })
    .then(response => response.json())
    .then(data => {
        // Reset button
        btn.disabled = false;
        btnText.textContent = 'Th?m';
        
        if (data.success) {
            // Cáº­p nháº­t giá» hÃ ng vÃ  hiá»ƒn thá»‹ sidebar
            updateCartSidebar(data.cart, data.total);
            openCartSidebar();
        } else {
            alert(data.message);
        }
    })
    .catch(error => {
        // Reset button
        btn.disabled = false;
        btnText.textContent = 'Thêm';
        
        console.error('Error:', error);
        alert('Có lỗi xảy ra. Vui lòng thử lại!');
    });
}

function updateCartSidebar(cartItems, total) {
    const container = document.getElementById('cartItemsContainer');

    if (!cartItems || cartItems.length === 0) {
        container.innerHTML = `
            <div class="cart-empty">
                <div class="cart-empty-icon">ðŸ›’</div>
                <p>Giỏ hàng trống</p>
            </div>
        `;
        document.getElementById('cartFooter').style.display = 'none';
    } else {
        let html = '';
        cartItems.forEach(item => {
            html += '<div class="cart-item">'
                + '<img src="' + item.image + '" alt="' + item.name + '" class="cart-item-image">'
                + '<div class="cart-item-info">'
                + '<div class="cart-item-name">' + item.name + '</div>'
                + '<div class="cart-item-price">' + item.quantity + ' × ' + formatPrice(item.price) + '</div>'
                + '</div>'
                + '<button class="cart-item-remove" onclick="removeFromCart(' + item.id + ')">×</button>'
                + '</div>';
        });
        container.innerHTML = html;
        document.getElementById('cartTotalAmount').textContent = formatPrice(total);
        document.getElementById('cartFooter').style.display = 'block';
    }
}

function removeFromCart(productId) {
    fetch('/remove-cart-ajax', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'id=' + productId
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            updateCartSidebar(data.cart, data.total);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Có lỗi xảy ra, vui lòng thử lại!');
    });
}

function openCartSidebar() {
    document.getElementById('cartSidebar').classList.add('active');
    document.getElementById('cartOverlay').classList.add('active');
    document.body.style.overflow = 'hidden';
}

function closeCartSidebar() {
    document.getElementById('cartSidebar').classList.remove('active');
    document.getElementById('cartOverlay').classList.remove('active');
    document.body.style.overflow = '';
}
</script>

</body>
</html>

