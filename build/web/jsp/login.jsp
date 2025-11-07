<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ include file="header.jsp" %>
<h2>Đăng Nhập</h2>
<div class="login-form">
    <form action="login" method="post">
        <label for="usernameOrEmail">Tên Đăng Nhập hoặc Email:</label>
        <input type="text" id="usernameOrEmail" name="usernameOrEmail" required><br>
        
        <label for="password">Mật Khẩu:</label>
        <input type="password" id="password" name="password" required><br>
        
        <button type="submit">Đăng Nhập</button>
    </form>
    <c:if test="${not empty message}">
        <p class="${messageType}">${message}</p>
    </c:if>
    <p>Chưa có tài khoản? <a href="register">Đăng ký ngay</a></p>
</div>
<%@ include file="footer.jsp" %>