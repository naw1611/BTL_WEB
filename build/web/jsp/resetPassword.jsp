<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt lại mật khẩu</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .password-requirements {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
            padding: 10px;
            background: #f5f5f5;
            border-radius: 5px;
        }
        .password-requirements ul {
            margin: 5px 0;
            padding-left: 20px;
        }
    </style>
</head>
<body>
<div class="auth-container">
    <div class="auth-section">
        <h2>🔐 Đặt lại mật khẩu</h2>
        <p>Vui lòng nhập mật khẩu mới cho tài khoản của bạn</p>
        
        <c:if test="${not empty message}">
            <p class="message ${messageType}">${message}</p>
        </c:if>
        
        <form action="resetPassword" method="post">
            <div class="form-group">
                <label for="newPassword">Mật khẩu mới *</label>
                <input type="password" id="newPassword" name="newPassword" 
                       required minlength="6" placeholder="Tối thiểu 6 ký tự">
            </div>
            
            <div class="form-group">
                <label for="confirmPassword">Xác nhận mật khẩu *</label>
                <input type="password" id="confirmPassword" name="confirmPassword" 
                       required minlength="6" placeholder="Nhập lại mật khẩu">
            </div>
            
            <div class="password-requirements">
                <strong>Yêu cầu mật khẩu:</strong>
                <ul>
                    <li>Ít nhất 6 ký tự</li>
                    <li>Nên kết hợp chữ hoa, chữ thường và số</li>
                    <li>Không dùng mật khẩu dễ đoán</li>
                </ul>
            </div>
            
            <button type="submit" class="btn-primary">💾 Đặt lại mật khẩu</button>
        </form>
        
        <p style="text-align: center; margin-top: 20px;">
            <a href="login">⬅️ Quay lại đăng nhập</a>
        </p>
    </div>
</div>

<script>
// ✅ Kiểm tra mật khẩu khớp trước khi submit
document.querySelector('form').addEventListener('submit', function(e) {
    const password = document.getElementById('newPassword').value;
    const confirm = document.getElementById('confirmPassword').value;
    
    if (password !== confirm) {
        e.preventDefault();
        alert('⚠️ Mật khẩu xác nhận không khớp!');
        document.getElementById('confirmPassword').focus();
    }
});
</script>
</body>
</html>