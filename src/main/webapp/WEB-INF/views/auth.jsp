<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<meta charset="UTF-8">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Đăng ký</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            margin: 0;
            min-height: 100vh;
            font-family: Arial, sans-serif;
            background: url('/images/home1.jpg') center/cover no-repeat fixed;
        }

        .auth-overlay {
            min-height: 100vh;
            background: rgba(0, 0, 0, 0.45);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .auth-box {
            width: 980px;
            max-width: 100%;
            background: #fff;
            border-radius: 10px;
            overflow: hidden;
            display: flex;
            position: relative; /* 🔥 QUAN TRỌNG */
        }

        /* ❌ NÚT ĐÓNG */
        .close-btn {
            position: absolute;
            top: 10px;
            right: 15px;
            font-size: 24px;
            text-decoration: none;
            color: #333;
            font-weight: bold;
        }

        .close-btn:hover {
            color: red;
        }

        .auth-col {
            flex: 1;
            padding: 40px 50px;
        }

        .auth-col.right {
            background: #ffffff;
            border-left: 1px solid #eee;
        }

        .auth-title {
            text-align: center;
            font-weight: 800;
            margin-bottom: 20px;
            letter-spacing: 0.5px;
        }

        .auth-label {
            font-weight: 700;
            margin-top: 10px;
            display: block;
        }

        .auth-actions {
            margin-top: 20px;
        }

        .forgot-link {
            display: inline-block;
            margin-top: 10px;
            color: #555;
            text-decoration: none;
        }

        .hint-text {
            font-size: 12px;
            color: #666;
            margin-top: 10px;
            line-height: 1.4;
        }
    </style>
</head>

<body>
<div class="auth-overlay">
    <div class="auth-box">

        <!-- ❌ NÚT X -->
        <a href="/home" class="close-btn">✖</a>

        <!-- LEFT: LOGIN -->
        <div class="auth-col left">
            <div class="auth-title">ĐĂNG NHẬP</div>

            <c:if test="${not empty loginError}">
                <div class="alert alert-danger">${loginError}</div>
            </c:if>

            <form method="post" action="/login">
            <label class="auth-label">Địa chỉ email *</label>
            <input class="form-control" type="text" name="emailOrUsername" required>

            <label class="auth-label">Mật khẩu *</label>
            <input class="form-control" type="password" name="password" required>

            <!-- THÊM DÒNG NÀY -->
            <input type="hidden" name="redirect" value="${param.redirect}">

            <div class="auth-actions">
                <button class="btn btn-primary w-100" type="submit">ĐĂNG NHẬP</button>
            </div>

            <a class="forgot-link" href="#">Quên mật khẩu?</a>
</form>
        </div>

        <!-- RIGHT: REGISTER -->
        <div class="auth-col right">
            <div class="auth-title">ĐĂNG KÝ</div>

            <c:if test="${not empty registerError}">
                <div class="alert alert-danger">${registerError}</div>
            </c:if>

            <c:if test="${registerSuccess}">
                <div class="alert alert-success">
                    Đăng ký thành công! Bạn có thể đăng nhập ngay bây giờ.
                </div>
            </c:if>

            <form method="post" action="/register">
                <label class="auth-label">Địa chỉ email</label>
                <input class="form-control" type="email" name="email" placeholder="abc@gmail.com" required>

                <label class="auth-label">Mật khẩu</label>
                <input class="form-control" type="password" name="password" required>

                <label class="auth-label">Xác nhận mật khẩu</label>
                <input class="form-control" type="password" name="confirmPassword" required>

                <div class="auth-actions">
                    <button class="btn btn-success w-100" type="submit">ĐĂNG KÝ</button>
                </div>
            </form>
        </div>

    </div>
</div>
</body>
</html>