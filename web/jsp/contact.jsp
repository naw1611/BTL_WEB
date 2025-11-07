<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ include file="header.jsp" %>
<h2>Liên Hệ</h2>
<div class="contact-form">
    <form action="contact" method="post">
        <label for="name">Họ và Tên:</label>
        <input type="text" id="name" name="name" value="${sessionScope.user != null ? sessionScope.user.fullName : ''}" required><br>
        
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" value="${sessionScope.user != null ? sessionScope.user.email : ''}" required><br>
        
        <label for="message">Nội Dung:</label>
        <textarea id="message" name="message" required></textarea><br>
        
        <button type="submit">Gửi</button>
    </form>
    <c:if test="${not empty message}">
        <p class="${messageType}">${message}</p>
    </c:if>
</div>
<%@ include file="footer.jsp" %>