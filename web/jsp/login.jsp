<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ include file="header.jsp" %>

<div class="auth-container">
    <!-- FORM ĐĂNG NHẬP -->
    <div id="login-section" class="auth-section">
        <h2>Đăng Nhập</h2>
        <form action="login" method="post" class="login-form">
            <div class="form-group">
                <label for="usernameOrEmail">Tên đăng nhập hoặc Email</label>
                <input type="text" id="usernameOrEmail" name="usernameOrEmail" required>
            </div>

            <div class="form-group">
                <label for="password">Mật khẩu</label>
                <input type="password" id="password" name="password" required>
            </div>

            <c:if test="${not empty message}">
                <p class="message ${messageType}">${message}</p>
            </c:if>

            <button type="submit" class="btn-login">Đăng Nhập</button>

            <div class="auth-links">
                <p>Chưa có tài khoản? <a href="register">Đăng ký ngay</a></p>
                <p><a href="#" onclick="showForgotForm(); return false;">Quên mật khẩu?</a></p>
            </div>
        </form>
    </div>

    <!-- FORM QUÊN MẬT KHẨU -->
    <div id="forgot-section" class="auth-section" style="display: none;">
        <h2>Khôi Phục Mật Khẩu</h2>
        <form action="forgotPassword" method="post" class="forgot-form">
            <div class="form-group">
                <label for="identifier">Email hoặc Số điện thoại</label>
                <input type="text" id="identifier" name="identifier" 
                       placeholder="Nhập email hoặc SĐT đã đăng ký" required>
            </div>

            <c:if test="${not empty forgotMessage}">
                <p class="message ${forgotMessageType}">${forgotMessage}</p>
            </c:if>

            <button type="submit" class="btn-primary">Gửi mã xác nhận</button>
            <p style="text-align: center; margin-top: 15px;">
                <a href="#" onclick="showLoginForm(); return false;">Quay lại đăng nhập</a>
            </p>
        </form>
    </div>
</div>

<script>
function showForgotForm() {
    document.getElementById('login-section').style.display = 'none';
    document.getElementById('forgot-section').style.display = 'block';
}
function showLoginForm() {
    document.getElementById('forgot-section').style.display = 'none';
    document.getElementById('login-section').style.display = 'block';
}
</script>

<%@ include file="footer.jsp" %>