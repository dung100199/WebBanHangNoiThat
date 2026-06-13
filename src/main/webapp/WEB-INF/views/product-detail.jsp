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
        .product-img {
            width: 100%;
            border-radius: 8px;
            border: 1px solid #eee;
            object-fit: cover;
        }
        .product-name { font-size: 26px; font-weight: 700; color: #1a2a5e; }
        .product-price { font-size: 24px; font-weight: 700; color: #e00; margin: 12px 0; }
        .product-price-compare {
            font-size: 16px;
            color: #999;
            text-decoration: line-through;
            margin-left: 10px;
            font-weight: 500;
        }
        .product-meta { font-size: 14px; color: #666; margin-bottom: 8px; }
        .product-meta span { margin-right: 16px; }
        .option-label { font-size: 14px; font-weight: 600; color: #333; margin-bottom: 8px; }
        .option-btn {
            border: 1px solid #ccc;
            background: #fff;
            border-radius: 4px;
            padding: 6px 14px;
            margin: 0 8px 8px 0;
            font-size: 14px;
            cursor: pointer;
        }
        .option-btn.active {
            border-color: #1a2a5e;
            color: #1a2a5e;
            font-weight: 700;
            box-shadow: 0 0 0 1px #1a2a5e;
        }
        .product-description {
            border-top: 1px solid #eee;
            padding-top: 24px;
            font-size: 15px;
            line-height: 1.7;
            color: #444;
        }
        .product-description img { max-width: 100%; height: auto; }
        .policy-box {
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 20px;
            font-size: 14px;
        }
        .policy-box h6 { font-weight: 700; margin-bottom: 12px; color: #1a2a5e; }
        .policy-item { display: flex; align-items: flex-start; margin-bottom: 12px; gap: 10px; }
        .admin-reply-box {
            background: #f0f4ff;
            border-left: 4px solid #1a2a5e;
            border-radius: 0 6px 6px 0;
            padding: 10px 14px;
            margin-top: 10px;
            font-size: 13px;
        }
        .admin-reply-box .reply-label {
            font-weight: 700;
            color: #1a2a5e;
            margin-bottom: 4px;
            font-size: 12px;
        }
        .admin-reply-form {
            background: #fffbea;
            border: 1px dashed #f0a500;
            border-radius: 6px;
            padding: 10px 14px;
            margin-top: 10px;
        }
        .admin-reply-form textarea { font-size: 13px; resize: vertical; }
        .btn-admin-sm { font-size: 12px; padding: 3px 10px; }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container mt-4 mb-5">
    <div class="row">

        <div class="col-md-5">
            <img id="product-main-image"
                 src="${product.image}"
                 data-default="${product.image}"
                 alt="${product.name}"
                 class="product-img">
        </div>

        <div class="col-md-5">
            <div class="product-name">${product.name}</div>

            <div class="product-meta">
                <c:if test="${not empty product.productType}">
                    <span><strong>Phân loại:</strong> ${product.productType}</span>
                </c:if>
                <c:if test="${not empty product.vendor}">
                    <span><strong>Nhóm SP:</strong> ${product.vendor}</span>
                </c:if>
            </div>

            <div class="product-price">
                <span id="display-price">
                    <fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0"/>
                </span>đ
                <span id="display-compare-wrap"
                      class="product-price-compare"
                      style="${product.compareAtPrice != null && product.compareAtPrice > product.price ? '' : 'display:none;'}">
                    <span id="display-compare">
                        <fmt:formatNumber value="${product.compareAtPrice}" type="number" maxFractionDigits="0"/>
                    </span>đ
                </span>
            </div>

            <div id="product-options"></div>

            <hr>

            <c:choose>
                <c:when test="${sessionScope.role == 'ADMIN'}">
                </c:when>
                <c:otherwise>
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <div class="d-flex align-items-center border rounded" style="width:120px;">
                            <button type="button" onclick="changeQty(-1)"
                                    style="width:36px; height:42px; border:none; background:white; font-size:18px;">-</button>
                            <input type="number" id="qty" value="1" min="1"
                                   oninput="updateBuyNowQty()"
                                   style="width:48px; height:42px; border:none; text-align:center; font-size:16px; font-weight:600;">
                            <button type="button" onclick="changeQty(1)"
                                    style="width:36px; height:42px; border:none; background:white; font-size:18px;">+</button>
                        </div>
                        <a id="btn-buy" href="/buy-now?id=${product.id}&qty=1"
                           class="btn flex-grow-1"
                           style="background:#1a2a5e; color:white; font-weight:700; padding:12px;">
                             Mua ngay
                        </a>
                    </div>

                    <div class="d-flex align-items-center gap-3">
                        <div class="d-flex align-items-center border rounded" style="width:120px;">
                            <button type="button" onclick="changeQty2(-1)"
                                    style="width:36px; height:42px; border:none; background:white; font-size:18px;">-</button>
                            <input type="number" id="qty2" value="1" min="1"
                                   style="width:48px; height:42px; border:none; text-align:center; font-size:16px; font-weight:600;">
                            <button type="button" onclick="changeQty2(1)"
                                    style="width:36px; height:42px; border:none; background:white; font-size:18px;">+</button>
                        </div>
                        <a id="btn-cart" href="/add-to-cart?id=${product.id}&qty=1"
                           onclick="event.preventDefault(); addCurrentProductToCart();"
                           class="btn flex-grow-1"
                           style="background:#e0e0e0; color:#333; font-weight:700; padding:12px;">
                             Thêm vào giỏ hàng
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="col-md-2">
            <div class="policy-box">
                <div class="policy-item"><span>Sản phẩm được <strong>miễn phí giao hàng</strong></span></div>
                <h6>Chính sách bán hàng</h6>
                <div class="policy-item"><span>Cam kết <strong>chính hãng</strong> 100%</span></div>
                <div class="policy-item"><span>Miễn phí giao hàng từ <strong>800K</strong></span></div>
                <div class="policy-item"><span>Đổi trả miễn phí trong <strong>10 ngày</strong></span></div>
                <h6 class="mt-3">Dịch vụ khác</h6>
                <div class="policy-item"><span>Sửa chữa <strong>đồng giá 150.000đ</strong></span></div>
                <div class="policy-item"><span>Bảo hành <strong>12 tháng</strong></span></div>
            </div>
        </div>

    </div>

    <c:if test="${not empty product.description}">
        <div class="col-12 product-description mt-4">
            <h5 class="mb-3" style="color:#1a2a5e; font-weight:700;">Mô tả sản phẩm</h5>
            <div>${product.description}</div>
        </div>
    </c:if>
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
    <c:if test="${not empty message}">
        <div class="alert alert-success">${message}</div>
    </c:if>

    <div class="row">
        <div class="col-md-4">
            <div class="card p-4 mb-4">
                <h6 style="font-weight:700; color:#1a2a5e;">Viết đánh giá</h6>
                <c:choose>
                    <c:when test="${sessionScope.role == 'ADMIN'}">
                        <div class="text-center py-3">
                            <p style="color:#888; font-size:14px;">Admin không thể đánh giá sản phẩm.</p>
                        </div>
                    </c:when>
                    <c:when test="${not empty sessionScope.userEmail}">
                        <form action="/review/add" method="post">
                            <input type="hidden" name="productId" value="${product.id}">
                            <div class="mb-3">
                                <label style="font-weight:600;">Số sao</label>
                                <div class="d-flex gap-2 mt-1">
                                    <c:forEach begin="1" end="5" var="i">
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="rating"
                                                   value="${i}" id="star${i}" ${i == 5 ? 'checked' : ''} required>
                                            <label class="form-check-label" for="star${i}"
                                                   style="color:#f0a500; font-size:20px;">&#9733;</label>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label style="font-weight:600;">Nhận xét</label>
                                <textarea name="comment" class="form-control" rows="4"
                                          placeholder="Chia sẻ trải nghiệm của bạn..."></textarea>
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
                        <p>Chưa có đánh giá nào. Hãy là người đầu tiên!</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="r" items="${reviews}">
                        <div class="card p-3 mb-3">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <div>
                                    <strong style="font-size:14px;">
                                        ${r.userEmail.substring(0, 3)}***${r.userEmail.substring(r.userEmail.indexOf('@'))}
                                    </strong>
                                    <span style="color:#f0a500; margin-left:8px;">
                                        <c:forEach begin="1" end="${r.rating}" var="s">&#9733;</c:forEach>
                                        <c:forEach begin="${r.rating + 1}" end="5" var="s">&#9734;</c:forEach>
                                    </span>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <small style="color:#aaa;">
                                        <fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy"/>
                                    </small>
                                    <c:if test="${sessionScope.role == 'ADMIN'}">
                                        <form action="/admin/review/delete" method="post" style="margin:0;"
                                              onsubmit="return confirm('Xóa đánh giá này?')">
                                            <input type="hidden" name="reviewId" value="${r.id}">
                                            <input type="hidden" name="productId" value="${product.id}">
                                            <button type="submit" class="btn btn-danger btn-admin-sm">Xóa</button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>

                            <c:if test="${not empty r.comment}">
                                <p style="font-size:14px; color:#555; margin:0 0 6px 0;">${r.comment}</p>
                            </c:if>

                            <c:if test="${not empty r.adminReply}">
                                <div class="admin-reply-box">
                                    <div class="reply-label">Phản hồi từ cửa hàng:</div>
                                    <div>${r.adminReply}</div>
                                    <c:if test="${sessionScope.role == 'ADMIN'}">
                                        <div class="d-flex gap-2 mt-2">
                                            <button type="button"
                                                    onclick="toggleReplyForm('reply-form-${r.id}')"
                                                    class="btn btn-warning btn-admin-sm">Sửa reply</button>
                                            <form action="/admin/review/delete-reply" method="post" style="margin:0;">
                                                <input type="hidden" name="reviewId" value="${r.id}">
                                                <input type="hidden" name="productId" value="${product.id}">
                                                <button type="submit" class="btn btn-outline-danger btn-admin-sm">
                                                    Xóa reply
                                                </button>
                                            </form>
                                        </div>
                                    </c:if>
                                </div>
                            </c:if>

                            <c:if test="${sessionScope.role == 'ADMIN'}">
                                <div id="reply-form-${r.id}"
                                     class="admin-reply-form"
                                     style="${not empty r.adminReply ? 'display:none;' : ''}">
                                    <div style="font-size:12px; font-weight:700; color:#856404; margin-bottom:6px;">
                                        ${not empty r.adminReply ? 'Sửa' : 'Trả lời'} đánh giá này:
                                    </div>
                                    <form action="/admin/review/reply" method="post">
                                        <input type="hidden" name="reviewId" value="${r.id}">
                                        <input type="hidden" name="productId" value="${product.id}">
                                        <textarea name="reply" class="form-control mb-2" rows="2"
                                                  placeholder="Nhập phản hồi của cửa hàng..."
                                                  required>${r.adminReply}</textarea>
                                        <div class="d-flex gap-2">
                                            <button type="submit" class="btn btn-primary btn-admin-sm">
                                                Gửi phản hồi
                                            </button>
                                            <c:if test="${not empty r.adminReply}">
                                                <button type="button"
                                                        onclick="toggleReplyForm('reply-form-${r.id}')"
                                                        class="btn btn-outline-secondary btn-admin-sm">Hủy</button>
                                            </c:if>
                                        </div>
                                    </form>
                                </div>
                            </c:if>

                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />

<script type="application/json" id="product-options-data">${empty product.optionsJson ? '[]' : product.optionsJson}</script>
<script type="application/json" id="product-variants-data">${empty product.variantsJson ? '[]' : product.variantsJson}</script>

<script>
    const productVariants = JSON.parse(document.getElementById('product-variants-data').textContent || '[]');
    const productOptions  = JSON.parse(document.getElementById('product-options-data').textContent  || '[]');
    const selectedOptions = {};

    function formatVnd(value) {
        return new Intl.NumberFormat('vi-VN').format(Math.round(value));
    }

    function findVariant() {
    if (!productVariants.length) return null;
    return productVariants.find(function(v) {
        return (v.option1 || '') === (selectedOptions.option1 || '')
            && (v.option2 || '') === (selectedOptions.option2 || '')
            && (v.option3 || '') === (selectedOptions.option3 || '');
    });
}

    function getSelectedVariantLabel() {
        if (!productOptions.length) return '';
        return productOptions.map(function(opt, index) {
            var key = 'option' + (index + 1);
            return (opt.name || '') + ': ' + (selectedOptions[key] || '');
        }).join(', ');
    }

    function applyVariantSelection() {
        const variant    = findVariant();
        const priceEl    = document.getElementById('display-price');
        const compareWrap = document.getElementById('display-compare-wrap');
        const compareEl  = document.getElementById('display-compare');
        const imgEl      = document.getElementById('product-main-image');
        const defaultImage = imgEl ? imgEl.getAttribute('data-default') : '';

        let price   = ${product.price};
        let compare = ${product.compareAtPrice != null ? product.compareAtPrice : 0};

        if (variant) {
            if (variant.price)          price   = variant.price;
            if (variant.compareAtPrice) compare = variant.compareAtPrice;
            if (imgEl && variant.image) imgEl.src = variant.image;
        } else if (imgEl && defaultImage) {
            imgEl.src = defaultImage;
        }

        if (priceEl) priceEl.textContent = formatVnd(price);
        if (compareWrap && compareEl) {
            if (compare > price) {
                compareEl.textContent = formatVnd(compare);
                compareWrap.style.display = '';
            } else {
                compareWrap.style.display = 'none';
            }
        }

        var qty = Math.max(1, parseInt(document.getElementById('qty').value) || 1);
        var variantLabel = encodeURIComponent(getSelectedVariantLabel());
        var buyBtn = document.getElementById('btn-buy');
        if (buyBtn) buyBtn.href = '/buy-now?id=${product.id}&qty=' + qty + '&variant=' + variantLabel;
    }

    function selectOption(optionKey, value, btn) {
        selectedOptions[optionKey] = value;
        var group = btn.closest('.option-group');
        group.querySelectorAll('.option-btn').forEach(function(b) { b.classList.remove('active'); });
        btn.classList.add('active');
        applyVariantSelection();
    }

    function renderProductOptions() {
        var container = document.getElementById('product-options');
        if (!container || !productOptions.length) return;

        productOptions.forEach(function(opt, index) {
            if (!opt.values || !opt.values.length) return;
            var optionKey = 'option' + (index + 1);
            var wrap = document.createElement('div');
            wrap.className = 'option-group mb-3';
            wrap.innerHTML = '<div class="option-label">' + (opt.name || 'Tùy chọn') + '</div>';
            var btnWrap = document.createElement('div');
            opt.values.forEach(function(val, i) {
                var btn = document.createElement('button');
                btn.type = 'button';
                btn.className = 'option-btn' + (i === 0 ? ' active' : '');
                btn.textContent = val;
                btn.addEventListener('click', function() { selectOption(optionKey, val, btn); });
                btnWrap.appendChild(btn);
                if (i === 0) selectedOptions[optionKey] = val;
            });
            wrap.appendChild(btnWrap);
            container.appendChild(wrap);
        });
        applyVariantSelection();
    }

    function stripDescriptionLinks() {
        var desc = document.querySelector('.product-description');
        if (!desc) return;
        desc.querySelectorAll('a').forEach(function(link) {
            link.replaceWith(document.createTextNode(link.textContent));
        });
    }

    document.addEventListener('DOMContentLoaded', function() {
        renderProductOptions();
        stripDescriptionLinks();
    });

    function changeQty(delta) {
        var input = document.getElementById('qty');
        var val = Math.max(1, parseInt(input.value || 1) + delta);
        input.value = val;
        var variantLabel = encodeURIComponent(getSelectedVariantLabel());
        document.getElementById('btn-buy').href = '/buy-now?id=${product.id}&qty=' + val + '&variant=' + variantLabel;
    }

    function updateBuyNowQty() {
        var val = Math.max(1, parseInt(document.getElementById('qty').value) || 1);
        document.getElementById('qty').value = val;
        var variantLabel = encodeURIComponent(getSelectedVariantLabel());
        document.getElementById('btn-buy').href = '/buy-now?id=${product.id}&qty=' + val + '&variant=' + variantLabel;
    }

    function changeQty2(delta) {
        var input = document.getElementById('qty2');
        var val = Math.max(1, parseInt(input.value || 1) + delta);
        input.value = val;
    }

    function addCurrentProductToCart() {
        var qty = Math.max(1, parseInt(document.getElementById('qty2').value) || 1);
        var variant = getSelectedVariantLabel();
        addProductToCart(${product.id}, qty, null, variant);
    }

    function toggleReplyForm(id) {
        var form = document.getElementById(id);
        form.style.display = (form.style.display === 'none') ? 'block' : 'none';
    }
</script>

</body>
</html>