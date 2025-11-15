<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ include file="header.jsp" %>
<h2>📩 Liên Hệ</h2>

<div class="contact-form">
    <form action="contact" method="post">
        <label>Họ và Tên:</label>
        <input type="text" name="name" value="${sessionScope.user != null ? sessionScope.user.fullName : ''}" required><br>
        
        <label>Email:</label>
        <input type="email" name="email" value="${sessionScope.user != null ? sessionScope.user.email : ''}" required><br>
        
        <label>Nội Dung:</label>
        <textarea name="message" required></textarea><br>
        
        <button type="submit">📨 Gửi liên hệ</button>
    </form>

        <!-- 🌟 Nút xem lịch sử liên hệ -->
<a href="contact?action=history" 
   style="display:inline-block; margin-top:10px; color:#007bff; text-decoration:none;">
   📜 Xem lịch sử liên hệ của bạn
</a>
        
    <c:if test="${not empty message}">
        <p class="${messageType}">${message}</p>
    </c:if>
</div>

<%@ include file="footer.jsp" %>
