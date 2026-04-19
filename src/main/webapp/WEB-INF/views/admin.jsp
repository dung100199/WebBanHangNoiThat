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
    <h2 class="mb-4"> Trang quản lý</h2>

    <c:if test="${not empty message}">
        <div class="alert alert-success">${message}</div>
    </c:if>

    <!-- TABS -->
    <ul class="nav nav-tabs mb-4" id="adminTab">
        <li class="nav-item">
            <a class="nav-link active" href="#" onclick="showTab('san-pham', this)"> Sản phẩm</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="#" onclick="showTab('don-hang', this)"> Đơn hàng</a>
        </li>
    </ul>

    <!-- ===================== TAB SẢN PHẨM ===================== -->
    <div id="tab-san-pham">

        <div class="row">
            <!-- FORM THÊM SP -->
            <div class="col-md-6">
                <div class="card p-4 mb-4">
                    <h5> Thêm sản phẩm</h5>
                    <form action="/admin/add-product" method="post">
                        <div class="mb-3">
                            <label>Tên sản phẩm</label>
                            <input type="text" name="name" class="form-control" placeholder="VD: Sofa ABC" required>
                        </div>
                        <div class="mb-3">
                            <label>Giá (VND)</label>
                            <input type="number" name="price" class="form-control" placeholder="VD: 5000000" required>
                        </div>
                        <div class="mb-3">
                            <label>Danh mục</label>
                            <select name="category" class="form-control">
                                <option value="phong-khach">Phòng Khách</option>
                                <option value="phong-ngu">Phòng Ngủ</option>
                                <option value="phong-bep">Phòng Bếp</option>
                                <option value="noi-that-van-phong">Nội Thất Văn Phòng</option>
                                <option value="noi-that-truong-hoc">Nội Thất Trường Học</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label>Từ khóa ảnh (tiếng Anh)</label>
                            <input type="text" name="keyword" class="form-control"
                                   placeholder="VD: sofa, dining table, wardrobe">
                            <small class="text-muted">Để trống sẽ dùng tên sản phẩm làm từ khóa</small>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Thêm sản phẩm</button>
                    </form>
                </div>
            </div>

            <!-- FORM IMPORT EXCEL -->
            <div class="col-md-6">
                <div class="card p-4 mb-4">
                    <h5> Import từ Excel</h5>
                    <p class="text-muted small">File Excel cần có: <b>name, price, category, keyword</b></p>
                    <form action="/admin/import-excel" method="post" enctype="multipart/form-data">
                        <div class="mb-3">
                            <label>Chọn file Excel (.xlsx)</label>
                            <input type="file" name="file" class="form-control" accept=".xlsx" required>
                        </div>
                        <button type="submit" class="btn btn-success w-100">Import từ Excel</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- FORM SỬA SẢN PHẨM -->
        <c:if test="${not empty product}">
            <div class="card p-4 mb-4 border-warning">
                <h5> Sửa sản phẩm: <span style="color:#e6a817;">${product.name}</span></h5>
                <form action="/admin/edit-product" method="post">
                    <input type="hidden" name="id" value="${product.id}">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label>Tên sản phẩm</label>
                                <input type="text" name="name" class="form-control" value="${product.name}" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label>Giá (VND)</label>
                                <input type="number" name="price" class="form-control" value="${product.price}" required>
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label>Danh mục</label>
                        <select name="category" class="form-control">
                            <option value="phong-khach"         ${product.category == 'phong-khach'         ? 'selected' : ''}>Phòng Khách</option>
                            <option value="phong-ngu"           ${product.category == 'phong-ngu'           ? 'selected' : ''}>Phòng Ngủ</option>
                            <option value="phong-bep"           ${product.category == 'phong-bep'           ? 'selected' : ''}>Phòng Bếp</option>
                            <option value="noi-that-van-phong"  ${product.category == 'noi-that-van-phong'  ? 'selected' : ''}>Nội Thất Văn Phòng</option>
                            <option value="noi-that-truong-hoc" ${product.category == 'noi-that-truong-hoc' ? 'selected' : ''}>Nội Thất Trường Học</option>
                        </select>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label>Từ khóa ảnh mới (tiếng Anh)</label>
                                <input type="text" name="keyword" class="form-control" placeholder="Để trống nếu không đổi ảnh">
                                <small class="text-muted">Nhập để lấy ảnh mới từ Unsplash</small>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label>Hoặc nhập link ảnh trực tiếp</label>
                                <input type="text" name="image" class="form-control" placeholder="https://...">
                                <small class="text-muted">Để trống nếu giữ ảnh cũ</small>
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label>Ảnh hiện tại</label><br>
                        <img src="${product.image}" style="height:100px; object-fit:cover; border-radius:6px; border:1px solid #ddd;">
                    </div>
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-warning flex-grow-1"> Lưu thay đổi</button>
                        <a href="/admin" class="btn btn-outline-secondary">Hủy</a>
                    </div>
                </form>
            </div>
        </c:if>

        <!-- DANH SÁCH SẢN PHẨM -->
        <div class="d-flex justify-content-between align-items-center mb-2">
            <h5 class="mb-0"> Danh sách sản phẩm (${products.size()} sản phẩm)</h5>
            <button class="btn btn-outline-secondary btn-sm" onclick="toggleSelectAll()">
                 Chọn tất cả
            </button>
        </div>

        <!-- Toolbar xóa nhiều -->
        <div id="bulk-toolbar">
            <span id="selected-count" style="font-weight:600; color:#856404;">0 sản phẩm được chọn</span>
            <form id="bulk-delete-form" action="/admin/delete-products" method="post"
                  onsubmit="return confirmBulkDelete()">
                <div id="bulk-ids-container"></div>
                <button type="submit" class="btn btn-danger btn-sm">
                    🗑 Xóa các sản phẩm đã chọn
                </button>
            </form>
            <button class="btn btn-outline-secondary btn-sm" onclick="clearSelection()">
                Bỏ chọn tất cả
            </button>
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
                    <th>Sửa</th>
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
                        <td><fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="0"/> VND</td>
                        <td>${p.category}</td>
                        <td><img src="${p.image}" style="height:60px; object-fit:cover; border-radius:4px;"></td>
                        <td>
                            <a href="/admin/edit-product/${p.id}" class="btn btn-warning btn-sm"> Sửa</a>
                        </td>
                        <td>
                            <a href="/admin/delete-product?id=${p.id}"
                               onclick="return confirm('Xóa sản phẩm này?')"
                               class="btn btn-danger btn-sm"> Xóa</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- ===================== TAB ĐƠN HÀNG ===================== -->
    <div id="tab-don-hang" style="display:none;">
        <h5> Danh sách đơn hàng (${orders.size()} đơn)</h5>
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
                                <c:when test="${order.payment == 'bank'}"> CK</c:when>
                                <c:when test="${order.payment == 'qr'}"> QR</c:when>
                                <c:when test="${order.payment == 'cod'}"> COD</c:when>
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
                                <c:when test="${order.status == 'Chờ xác nhận'}"><span class="status-cho"> Chờ xác nhận</span></c:when>
                                <c:when test="${order.status == 'Đã xác nhận'}"><span class="status-xac"> Đã xác nhận</span></c:when>
                                <c:when test="${order.status == 'Đang giao'}"><span class="status-giao"> Đang giao</span></c:when>
                                <c:when test="${order.status == 'Hoàn thành'}"><span class="status-giao"> Hoàn thành</span></c:when>
                                <c:otherwise><span class="status-hoan">${order.status}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <form action="/admin/update-order-status" method="post">
                                <input type="hidden" name="orderId" value="${order.id}">
                                <select name="status" class="form-select form-select-sm mb-1">
                                    <option value="Chờ xác nhận"  ${order.status == 'Chờ xác nhận'  ? 'selected' : ''}> Chờ xác nhận</option>
                                    <option value="Đã xác nhận"   ${order.status == 'Đã xác nhận'   ? 'selected' : ''}> Đã xác nhận</option>
                                    <option value="Đang giao"     ${order.status == 'Đang giao'     ? 'selected' : ''}> Đang giao</option>
                                    <option value="Hoàn thành"    ${order.status == 'Hoàn thành'    ? 'selected' : ''}> Hoàn thành</option>
                                    <option value="Đã hủy"        ${order.status == 'Đã hủy'        ? 'selected' : ''}> Đã hủy</option>
                                </select>
                                <button type="submit" class="btn btn-primary btn-sm w-100">Lưu</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

</div>

<script>
    function showTab(tab, el) {
        document.getElementById('tab-san-pham').style.display = 'none';
        document.getElementById('tab-don-hang').style.display = 'none';
        document.getElementById('tab-' + tab).style.display = 'block';
        document.querySelectorAll('.nav-link').forEach(e => e.classList.remove('active'));
        el.classList.add('active');
    }

    window.onload = function() {
        if (window.location.hash === '#don-hang') {
            showTab('don-hang', document.querySelectorAll('.nav-link')[1]);
        }
        const editForm = document.querySelector('.border-warning');
        if (editForm) editForm.scrollIntoView({ behavior: 'smooth' });
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
</script>

</body>
</html>