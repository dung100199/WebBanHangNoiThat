<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Admin - Quản lý</title>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .nav-tabs .nav-link { color: #1a2a5e; font-weight: 600; }
        .nav-tabs .nav-link.active { background: #1a2a5e; color: white; border-color: #1a2a5e; }
        .status-cho  { background:#fff3cd; color:#856404; padding:4px 10px; border-radius:20px; font-size:12px; }
        .status-xac  { background:#cce5ff; color:#004085; padding:4px 10px; border-radius:20px; font-size:12px; }
        .status-giao { background:#d4edda; color:#155724; padding:4px 10px; border-radius:20px; font-size:12px; }
        .status-hoan { background:#f8d7da; color:#721c24; padding:4px 10px; border-radius:20px; font-size:12px; }

        #bulk-toolbar {
            display: none;
            background: #fff3cd;
            border: 1px solid #ffc107;
            border-radius: 6px;
            padding: 10px 16px;
            margin-bottom: 12px;
            align-items: center;
            gap: 12px;
        }
        #bulk-toolbar.show { display: flex; }
        tr.selected-row { background: #fff8e1 !important; }
    </style>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="container mt-4 mb-5">
    <h2 class="mb-4">Trang quản lý</h2>

    <c:if test="${not empty message}">
        <div class="alert alert-success">${message}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <ul class="nav nav-tabs mb-4" id="adminTab">
        <li class="nav-item">
            <a class="nav-link active" href="#" onclick="showTab('san-pham', this)">Sản phẩm</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="#" onclick="showTab('don-hang', this)">Đơn hàng</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="#" onclick="showTab('khach-hang', this)">Khách hàng</a>
        </li>
    </ul>

    <div id="tab-san-pham">
        <div class="d-flex justify-content-between align-items-center mb-2">
            <h5 class="mb-0">Danh sách sản phẩm (${products.size()} sản phẩm)</h5>
            <button class="btn btn-outline-secondary btn-sm" onclick="toggleSelectAll()">Chọn tất cả</button>
        </div>

        <div id="bulk-toolbar">
            <span id="selected-count" style="font-weight:600; color:#856404;">0 sản phẩm được chọn</span>
            <form id="bulk-delete-form" action="/admin/delete-products" method="post"
                  onsubmit="return confirmBulkDelete()">
                <div id="bulk-ids-container"></div>
                <button type="submit" class="btn btn-danger btn-sm">Xóa các sản phẩm đã chọn</button>
            </form>
            <button class="btn btn-outline-secondary btn-sm" onclick="clearSelection()">Bỏ chọn tất cả</button>
        </div>

        <table class="table table-bordered table-hover">
            <thead class="table-dark">
                <tr>
                    <th style="width:40px;">
                        <input type="checkbox" id="check-all" onchange="toggleAll(this)" title="Chọn tất cả">
                    </th>
                    <th>ID</th>
                    <th>Tên</th>
                    <th>Giá</th>
                    <th>Danh mục</th>
                    <th>Ảnh</th>
                    <th>Xóa</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${products}">
                    <tr id="row-${p.id}">
                        <td>
                            <input type="checkbox" class="product-checkbox"
                                   value="${p.id}" onchange="onCheckboxChange()">
                        </td>
                        <td>${p.id}</td>
                        <td>${p.name}</td>
                        <td><fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="0"/> đ</td>
                        <td>${p.category}</td>
                        <td><img src="${p.image}" style="height:60px; object-fit:cover; border-radius:4px;"></td>
                        <td>
                            <a href="/admin/delete-product?id=${p.id}"
                               onclick="return confirm('Xóa sản phẩm này?')"
                               class="btn btn-danger btn-sm">Xóa</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <div id="tab-don-hang" style="display:none;">
        <h5>Danh sách đơn hàng (${orders.size()} đơn)</h5>
        <table class="table table-bordered table-hover">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Khách hàng</th>
                    <th>SĐT</th>
                    <th>Địa chỉ</th>
                    <th>Tổng tiền</th>
                    <th>Thanh toán</th>
                    <th>Ngày đặt</th>
                    <th>Trạng thái</th>
                    <th>Cập nhật</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="order" items="${orders}">
                    <tr>
                        <td>#${order.id}</td>
                        <td>
                            <strong>${order.fullname}</strong><br>
                            <small class="text-muted">${order.userEmail}</small>
                        </td>
                        <td>${order.phone}</td>
                        <td style="max-width:150px; font-size:13px;">${order.address}, ${order.city}</td>
                        <td style="color:red; font-weight:bold; white-space:nowrap;">
                            <fmt:formatNumber value="${order.total}" type="number" maxFractionDigits="0"/>đ
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${order.payment == 'bank'}">CK</c:when>
                                <c:when test="${order.payment == 'qr'}">QR</c:when>
                                <c:when test="${order.payment == 'cod'}">COD</c:when>
                            </c:choose>
                        </td>
                        <td style="font-size:13px; white-space:nowrap;">
                            ${order.createdAt.dayOfMonth}/${order.createdAt.monthValue}/${order.createdAt.year}
                            ${order.createdAt.hour}:
                            <c:choose>
                                <c:when test="${order.createdAt.minute < 10}">0${order.createdAt.minute}</c:when>
                                <c:otherwise>${order.createdAt.minute}</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${order.status == 'Chờ xác nhận'}"><span class="status-cho">Chờ xác nhận</span></c:when>
                                <c:when test="${order.status == 'Đã xác nhận'}"><span class="status-xac">Đã xác nhận</span></c:when>
                                <c:when test="${order.status == 'Đang giao'}"><span class="status-giao">Đang giao</span></c:when>
                                <c:when test="${order.status == 'Hoàn thành'}"><span class="status-giao">Hoàn thành</span></c:when>
                                <c:otherwise><span class="status-hoan">${order.status}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <form action="/admin/update-order-status" method="post">
                                <input type="hidden" name="orderId" value="${order.id}">
                                <select name="status" class="form-select form-select-sm mb-1">
                                    <option value="Chờ xác nhận"  ${order.status == 'Chờ xác nhận'  ? 'selected' : ''}>Chờ xác nhận</option>
                                    <option value="Đã xác nhận"   ${order.status == 'Đã xác nhận'   ? 'selected' : ''}>Đã xác nhận</option>
                                    <option value="Đang giao"     ${order.status == 'Đang giao'     ? 'selected' : ''}>Đang giao</option>
                                    <option value="Hoàn thành"    ${order.status == 'Hoàn thành'    ? 'selected' : ''}>Hoàn thành</option>
                                    <option value="Đã hủy"        ${order.status == 'Đã hủy'        ? 'selected' : ''}>Đã hủy</option>
                                </select>
                                <button type="submit" class="btn btn-primary btn-sm w-100">Lưu</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <div id="tab-khach-hang" style="display:none;">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="mb-0">Danh sách khách hàng (${customers.size()} khách)</h5>
        </div>

        <div class="mb-3">
            <input type="text" id="customer-search"
                   class="form-control" style="max-width:400px;"
                   placeholder="Tìm theo tên hoặc email..."
                   oninput="filterCustomers()">
        </div>

        <table class="table table-bordered table-hover" id="customer-table">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Họ tên</th>
                    <th>Email</th>
                    <th>Số điện thoại</th>
                    <th>Chi tiết</th>
                </tr>
            </thead>
            <tbody id="customer-tbody">
                <c:forEach var="u" items="${customers}">
                    <tr class="customer-row"
                        data-name="${u.fullname}"
                        data-email="${u.email}">
                        <td>${u.id}</td>
                        <td>${u.fullname}</td>
                        <td>${u.email}</td>
                        <td>${u.phone}</td>
                        <td>
                            <a href="/admin/customer/${u.id}"
                               class="btn btn-primary btn-sm">Xem chi tiết</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div id="customer-empty" style="display:none; color:#888; text-align:center; padding:24px;">
            Không tìm thấy khách hàng nào.
        </div>
    </div>

</div>

<jsp:include page="footer.jsp" />

<script>
    function showTab(tab, el) {
        document.getElementById('tab-san-pham').style.display = 'none';
        document.getElementById('tab-don-hang').style.display = 'none';
        document.getElementById('tab-khach-hang').style.display = 'none';
        document.getElementById('tab-' + tab).style.display = 'block';
        document.querySelectorAll('.nav-link').forEach(e => e.classList.remove('active'));
        el.classList.add('active');
    }

    window.onload = function() {
        if (window.location.hash === '#don-hang') {
            showTab('don-hang', document.querySelectorAll('.nav-link')[1]);
        }
        if (window.location.hash === '#khach-hang') {
            showTab('khach-hang', document.querySelectorAll('.nav-link')[2]);
        }
    }

    function getCheckboxes() {
        return document.querySelectorAll('.product-checkbox');
    }

    function getChecked() {
        return document.querySelectorAll('.product-checkbox:checked');
    }

    function onCheckboxChange() {
        const checked = getChecked();
        const total = getCheckboxes().length;
        const toolbar = document.getElementById('bulk-toolbar');
        const countEl = document.getElementById('selected-count');
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
        onCheckboxChange();
    }

    function toggleSelectAll() {
        const checkAll = document.getElementById('check-all');
        checkAll.checked = !checkAll.checked;
        toggleAll(checkAll);
    }

    function clearSelection() {
        document.getElementById('check-all').checked = false;
        toggleAll(document.getElementById('check-all'));
    }

    function confirmBulkDelete() {
        const checked = getChecked();
        if (checked.length === 0) {
            alert('Chưa chọn sản phẩm nào!');
            return false;
        }
        if (!confirm('Xóa ' + checked.length + ' sản phẩm đã chọn? Hành động này không thể hoàn tác!')) {
            return false;
        }
        const container = document.getElementById('bulk-ids-container');
        container.innerHTML = '';
        checked.forEach(cb => {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'ids';
            input.value = cb.value;
            container.appendChild(input);
        });
        return true;
    }

    function filterCustomers() {
        const keyword = document.getElementById('customer-search').value.toLowerCase().trim();
        const rows = document.querySelectorAll('.customer-row');
        let visibleCount = 0;

        rows.forEach(row => {
            const name  = (row.getAttribute('data-name')  || '').toLowerCase();
            const email = (row.getAttribute('data-email') || '').toLowerCase();
            const match = name.includes(keyword) || email.includes(keyword);
            row.style.display = match ? '' : 'none';
            if (match) visibleCount++;
        });

        document.getElementById('customer-empty').style.display =
            visibleCount === 0 ? 'block' : 'none';
    }
</script>

</body>
</html>