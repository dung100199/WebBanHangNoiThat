<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Giỏ hàng</title>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        tr.selected-row { background: #fff8e1 !important; }
        .cart-toolbar {
            display: none;
            background: #fff3cd;
            border: 1px solid #ffc107;
            border-radius: 6px;
            padding: 10px 16px;
            margin-bottom: 12px;
            align-items: center;
            gap: 12px;
        }
        .cart-toolbar.show { display: flex; }
        .variant-label { font-size: 12px; color: #888; display: block; margin-top: 2px; }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container mt-4 mb-5">

    <h2>Giỏ hàng</h2>

    <div class="cart-toolbar" id="cart-toolbar">
        <span id="selected-count" style="font-weight:600; color:#856404;">0 sản phẩm được chọn</span>
        <button class="btn btn-danger btn-sm" onclick="deleteSelected()">Xóa đã chọn</button>
        <button class="btn btn-success btn-sm" onclick="checkoutSelected()">Thanh toán đã chọn</button>
        <button class="btn btn-outline-secondary btn-sm" onclick="clearSelection()">Bỏ chọn</button>
    </div>

    <table class="table align-middle">
        <tr>
            <th style="width:40px;">
                <input type="checkbox" id="check-all" onchange="toggleAll(this)">
            </th>
            <th>Tên</th>
            <th>Giá</th>
            <th>Số lượng</th>
            <th>Thành tiền</th>
            <th></th>
        </tr>

        <c:set var="total" value="0" />
        <c:forEach var="item" items="${cart}">
            <tr id="row-${item.product.id}">
                <td>
                    <input type="checkbox" class="item-checkbox"
                           value="${item.product.id}"
                           onchange="onCheckChange()">
                </td>
                <td>
                    <img src="${item.product.image}"
                         style="height:50px; width:50px; object-fit:cover; border-radius:4px; margin-right:8px;">
                    ${item.product.name}
                    <c:if test="${not empty item.variant}">
                        <span class="variant-label">${item.variant}</span>
                    </c:if>
                </td>
                <td>
                    <fmt:formatNumber value="${item.product.price}" type="number" maxFractionDigits="0"/> VND
                </td>
                <td>
                    <div class="d-flex align-items-center border rounded" style="width:110px;">
                        <a href="/cart-minus?id=${item.product.id}"
                           class="btn btn-sm" style="font-size:18px; padding:2px 8px;">-</a>
                        <span style="width:36px; text-align:center; font-weight:600;">${item.quantity}</span>
                        <a href="/cart-plus?id=${item.product.id}"
                           class="btn btn-sm" style="font-size:18px; padding:2px 8px;">+</a>
                    </div>
                </td>
                <td style="color:red; font-weight:bold;">
                    <fmt:formatNumber value="${item.product.price * item.quantity}"
                                      type="number" maxFractionDigits="0"/> VND
                </td>
                <td>
                    <a href="/remove-cart?id=${item.product.id}" class="btn btn-danger btn-sm">Xóa</a>
                </td>
            </tr>
            <c:set var="total" value="${total + item.product.price * item.quantity}" />
        </c:forEach>

        <tr>
            <td colspan="4" class="text-end fw-bold">Tổng cộng:</td>
            <td style="color:red; font-weight:bold; font-size:16px;">
                <fmt:formatNumber value="${total}" type="number" maxFractionDigits="0"/> VND
            </td>
            <td></td>
        </tr>
    </table>

    <div class="d-flex gap-2">
        <a href="/home" class="btn btn-dark">Tiếp tục mua</a>
        <a href="/clear-cart" class="btn btn-outline-danger">Xóa toàn bộ giỏ hàng</a>
        <a href="/checkout" class="btn btn-success ms-auto">Thanh toán tất cả</a>
    </div>

</div>

<form id="delete-form" action="/remove-cart-multiple" method="post" style="display:none;">
    <div id="delete-ids"></div>
</form>

<form id="checkout-form" action="/checkout-selected" method="post" style="display:none;">
    <div id="checkout-ids"></div>
</form>

<jsp:include page="footer.jsp" />

<script>
    function getCheckboxes() {
        return document.querySelectorAll('.item-checkbox');
    }

    function getChecked() {
        return document.querySelectorAll('.item-checkbox:checked');
    }

    function onCheckChange() {
        const checked  = getChecked();
        const total    = getCheckboxes().length;
        const toolbar  = document.getElementById('cart-toolbar');
        const countEl  = document.getElementById('selected-count');
        const checkAll = document.getElementById('check-all');

        getCheckboxes().forEach(cb => {
            cb.closest('tr').classList.toggle('selected-row', cb.checked);
        });

        countEl.textContent = checked.length + ' sản phẩm được chọn';
        toolbar.classList.toggle('show', checked.length > 0);
        checkAll.indeterminate = checked.length > 0 && checked.length < total;
        checkAll.checked = checked.length === total;
    }

    function toggleAll(masterCb) {
        getCheckboxes().forEach(cb => { cb.checked = masterCb.checked; });
        onCheckChange();
    }

    function clearSelection() {
        document.getElementById('check-all').checked = false;
        toggleAll(document.getElementById('check-all'));
    }

    function deleteSelected() {
        const checked = getChecked();
        if (checked.length === 0) return;
        if (!confirm('Xóa ' + checked.length + ' sản phẩm đã chọn?')) return;

        const container = document.getElementById('delete-ids');
        container.innerHTML = '';
        checked.forEach(cb => {
            const input = document.createElement('input');
            input.type  = 'hidden';
            input.name  = 'ids';
            input.value = cb.value;
            container.appendChild(input);
        });
        document.getElementById('delete-form').submit();
    }

    function checkoutSelected() {
        const checked = getChecked();
        if (checked.length === 0) return;

        const container = document.getElementById('checkout-ids');
        container.innerHTML = '';
        checked.forEach(cb => {
            const input = document.createElement('input');
            input.type  = 'hidden';
            input.name  = 'ids';
            input.value = cb.value;
            container.appendChild(input);
        });
        document.getElementById('checkout-form').submit();
    }
</script>

</body>
</html>