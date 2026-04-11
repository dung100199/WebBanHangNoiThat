
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>${product.name}</title>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .breadcrumb-bar {
            background: #f5f5f5;
            padding: 10px 30px;
            font-size: 13px;
            color: #888;
        }
        .breadcrumb-bar a {
            color: #888;
            text-decoration: none;
        }
        .breadcrumb-bar a:hover { color: #1a2a5e; }

        .product-img {
            width: 100%;
            border-radius: 8px;
            border: 1px solid #eee;
            object-fit: cover;
        }
        .product-name {
            font-size: 26px;
            font-weight: 700;
            color: #1a2a5e;
        }
        .product-price {
            font-size: 24px;
            font-weight: 700;
            color: #e00;
            margin: 12px 0;
        }
        .btn-cart {
            background-color: #1a2a5e;
            color: white;
            border: none;
            padding: 14px 0;
            font-size: 16px;
            border-radius: 6px;
            width: 100%;
            margin-bottom: 10px;
        }
        .btn-cart:hover { background-color: #0f1a3e; color: white; }
        .btn-buy {
            background-color: #e00;
            color: white;
            border: none;
            padding: 14px 0;
            font-size: 16px;
            border-radius: 6px;
            width: 100%;
        }
        .btn-buy:hover { background-color: #b00; color: white; }
        .policy-box {
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 20px;
            font-size: 14px;
        }
        .policy-box h6 {
            font-weight: 700;
            margin-bottom: 12px;
            color: #1a2a5e;
        }
        .policy-item {
            display: flex;
            align-items: flex-start;
            margin-bottom: 12px;
            gap: 10px;
        }
        .policy-item .icon { font-size: 18px; margin-top: 2px; }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="breadcrumb-bar">
    <a href="/home">Trang chủ</a> /
    <a href="/category/${product.category}">${product.category}</a> /
    <strong>${product.name}</strong>
</div>

<div class="container mt-4 mb-5">
    <div class="row">
        <div class="col-md-5">
            <img src="${product.image}" alt="${product.name}" class="product-img">
        </div>

        <div class="col-md-5">
            <div class="product-name">${product.name}</div>

            <div class="product-price">
                <fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0"/>đ
            </div>

            <hr>

            <div class="d-flex align-items-center gap-3 mb-3">
                <div class="d-flex align-items-center border rounded" style="width:120px;">
                    <button type="button" onclick="changeQty(-1)" style="width:36px; height:42px; border:none; background:white; font-size:18px;">-</button>
                    <input type="number" id="qty" value="1" min="1" style="width:48px; height:42px; border:none; text-align:center; font-size:16px; font-weight:600;">
                    <button type="button" onclick="changeQty(1)" style="width:36px; height:42px; border:none; background:white; font-size:18px;">+</button>
                </div>
                <a id="btn-buy" href="/buy-now?id=${product.id}&qty=1" class="btn flex-grow-1" style="background:#1a2a5e; color:white; font-weight:700; padding:12px;">
                    Mua ngay
                </a>
            </div>

            <div class="d-flex align-items-center gap-3">
                <div class="d-flex align-items-center border rounded" style="width:120px;">
                    <button type="button" onclick="changeQty2(-1)" style="width:36px; height:42px; border:none; background:white; font-size:18px;">-</button>
                    <input type="number" id="qty2" value="1" min="1" style="width:48px; height:42px; border:none; text-align:center; font-size:16px; font-weight:600;">
                    <button type="button" onclick="changeQty2(1)" style="width:36px; height:42px; border:none; background:white; font-size:18px;">+</button>
                </div>
                <a id="btn-cart" href="/add-to-cart?id=${product.id}&qty=1" class="btn flex-grow-1" onclick="event.preventDefault(); addCurrentProductToCart();" style="background:#e0e0e0; color:#333; font-weight:700; padding:12px;">
                    Thêm vào giỏ hàng
                </a>
            </div>

            <script>
                function addCurrentProductToCart() {
                    var qty = Math.max(1, parseInt(document.getElementById('qty2').value) || 1);
                    addProductToCart(${product.id}, qty);
                }

                function changeQty(delta) {
                    var input = document.getElementById('qty');
                    var val = Math.max(1, parseInt(input.value) + delta);
                    input.value = val;
                    document.getElementById('btn-buy').href = '/buy-now?id=${product.id}&qty=' + val;
                }

                function changeQty2(delta) {
                    var input = document.getElementById('qty2');
                    var val = Math.max(1, parseInt(input.value) + delta);
                    input.value = val;
                }
            </script>
        </div>

        <div class="col-md-2">
            <div class="policy-box">
                <div class="policy-item">
                    <span class="icon">*</span>
                    <span>Sản phẩm được <strong>miễn phí giao hàng</strong></span>
                </div>
                <h6>Chính sách bán hàng</h6>
                <div class="policy-item">
                    <span class="icon">OK</span>
                    <span>Cam kết <strong>chính hãng</strong> 100%</span>
                </div>
                <div class="policy-item">
                    <span class="icon">Ship</span>
                    <span>Miễn phí giao hàng từ <strong>800K</strong></span>
                </div>
                <div class="policy-item">
                    <span class="icon">Doi</span>
                    <span>Đổi trả miễn phí trong <strong>10 ngày</strong></span>
                </div>
                <h6 class="mt-3">Dịch vụ khác</h6>
                <div class="policy-item">
                    <span class="icon">Fix</span>
                    <span>Sửa chữa <strong>đồng giá 150.000đ</strong></span>
                </div>
                <div class="policy-item">
                    <span class="icon">BH</span>
                    <span>Bảo hành <strong>12 tháng</strong></span>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="container mb-5">
    <hr>
    <div class="d-flex align-items-center gap-4 mb-4">
        <div class="text-center">
            <div style="font-size:48px; font-weight:700; color:#1a2a5e;">${avgRating}</div>
            <div style="color:#f0a500; font-size:24px;">
                <c:forEach begin="1" end="5" var="i">
                    <c:choose>
                        <c:when test="${i <= avgRating}">&#9733;</c:when>
                        <c:otherwise>&#9734;</c:otherwise>
                    </c:choose>
                </c:forEach>
            </div>
            <div style="font-size:13px; color:#888;">${totalReviews} đánh giá</div>
        </div>
        <div style="font-size:20px; font-weight:600; color:#333;">Đánh giá sản phẩm</div>
    </div>

    <c:if test="${not empty reviewSuccess}">
        <div class="alert alert-success">${reviewSuccess}</div>
    </c:if>
    <c:if test="${not empty reviewError}">
        <div class="alert alert-danger">${reviewError}</div>
    </c:if>

    <div class="row">
        <div class="col-md-4">
            <div class="card p-4 mb-4">
                <h6 style="font-weight:700; color:#1a2a5e;">Viết đánh giá</h6>
                <c:choose>
                    <c:when test="${not empty sessionScope.userEmail}">
                        <form action="/review/add" method="post">
                            <input type="hidden" name="productId" value="${product.id}">
                            <div class="mb-3">
                                <label style="font-weight:600;">Số sao</label>
                                <div class="d-flex gap-2 mt-1">
                                    <c:forEach begin="1" end="5" var="i">
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="rating" value="${i}" id="star${i}" ${i == 5 ? 'checked' : ''} required>
                                            <label class="form-check-label" for="star${i}" style="color:#f0a500; font-size:20px;">&#9733;</label>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label style="font-weight:600;">Nhận xét</label>
                                <textarea name="comment" class="form-control" rows="4" placeholder="Chia sẻ trải nghiệm của bạn..."></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Gửi đánh giá</button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-3">
                            <p style="color:#888; font-size:14px;">Đăng nhập để đánh giá sản phẩm</p>
                            <a href="/login" class="btn btn-outline-primary btn-sm">Đăng nhập</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="col-md-8">
            <c:choose>
                <c:when test="${empty reviews}">
                    <div class="text-center py-5" style="color:#888;">
                        <div style="font-size:40px;">...</div>
                        <p>Chưa có đánh giá nào. Hãy là người đầu tiên!</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="r" items="${reviews}">
                        <div class="card p-3 mb-3">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <div>
                                    <strong style="font-size:14px;">${r.userEmail.substring(0, 3)}***${r.userEmail.substring(r.userEmail.indexOf('@'))}</strong>
                                    <span style="color:#f0a500; margin-left:8px;">
                                        <c:forEach begin="1" end="${r.rating}" var="s">&#9733;</c:forEach>
                                        <c:forEach begin="${r.rating + 1}" end="5" var="s">&#9734;</c:forEach>
                                    </span>
                                </div>
                                <small style="color:#aaa;">
                                    <fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy"/>
                                </small>
                            </div>
                            <c:if test="${not empty r.comment}">
                                <p style="font-size:14px; color:#555; margin:0;">${r.comment}</p>
                            </c:if>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />

</body>
</html>
