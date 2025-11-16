<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Xác nhận mã</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .resend-link {
            margin-top: 15px;
            text-align: center;
            font-size: 14px;
        }
        .resend-link button {
            background: none;
            border: none;
            color: #2196F3;
            text-decoration: underline;
            cursor: pointer;
            font-size: 14px;
        }
        .resend-link button:hover {
            color: #1976D2;
        }
    </style>
</head>
<body>
<div class="auth-container">
    <div class="auth-section">
        <h2>📧 Xác nhận mã</h2>
        <p>Mã xác nhận đã được gửi đến email của bạn</p>
        <p style="font-size: 12px; color: #666;">Vui lòng kiểm tra cả hộp thư spam nếu không thấy email</p>
        
        <c:if test="${not empty message}">
            <p class="message ${messageType}">${message}</p>
        </c:if>
        
        <form action="verifyCode" method="post">
            <div class="form-group">
                <input type="text" name="code" placeholder="Nhập mã 6 số" 
                       maxlength="6" required pattern="[0-9]{6}"
                       style="text-align: center; font-size: 24px; letter-spacing: 8px; font-weight: bold;">
            </div>
            <button type="submit" class="btn-primary">✅ Xác nhận</button>
        </form>
        
        <!-- ✅ NÚT GỬI LẠI MÃ -->
        <div class="resend-link">
            <p>Không nhận được mã?</p>
            <form action="verifyCode" method="post" style="display: inline;">
                <input type="hidden" name="action" value="resend">
                <button type="submit">🔄 Gửi lại mã</button>
            </form>
        </div>
        
        <p style="text-align: center; margin-top: 20px;">
            <a href="login">⬅️ Quay lại đăng nhập</a>
        </p>
    </div>
</div>
</body>
</html>