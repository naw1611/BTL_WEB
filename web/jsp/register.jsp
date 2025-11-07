<%-- 
    Document   : register
    Created on : Oct 26, 2025, 8:01:23 PM
    Author     : Admin
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>
<h2>Đăng Ký Tài Khoản</h2>
<div class="register-form">
    <form action="register" method="post">
        <label for="fullName">Họ và Tên:</label>
        <input type="text" id="fullName" name="fullName" required><br>
        
        <label for="username">Tên Đăng Nhập:</label>
        <input type="text" id="username" name="username" required><br>
        
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required><br>
        
        <label for="phone">Số Điện Thoại:</label>
        <input type="text" id="phone" name="phone" required><br>
        
        <label for="address">Địa Chỉ:</label>
        <input type="text" id="address" name="address" required><br>
        
        <label for="password">Mật Khẩu:</label>
        <input type="password" id="password" name="password" required><br>
        
        <label for="confirmPassword">Nhập Lại Mật Khẩu:</label>
        <input type="password" id="confirmPassword" name="confirmPassword" required><br>
        
        <button type="submit">Đăng Ký</button>
    </form>
    <c:if test="${not empty message}">
        <p class="message">${message}</p>
    </c:if>
</div>
<%@ include file="footer.jsp" %>
