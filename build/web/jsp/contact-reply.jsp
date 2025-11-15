<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ include file="header.jsp" %>
<html>
<head>
    <title>Phản hồi liên hệ</title>
    <style>
        body { font-family: Arial; margin:20px; }
        textarea { width:100%; height:150px; padding:8px; }
        .btn { padding:6px 12px; background:#28a745; color:white; border:none; border-radius:4px; cursor:pointer; }
        .info { background:#f9f9f9; padding:10px; margin-bottom:15px; border-left:4px solid #007bff; }
    </style>
</head>
<body>
    <h2>📨 Phản hồi liên hệ</h2>

    <%
        Map<String,Object> c = (Map<String,Object>) request.getAttribute("contact");
        if (c != null) {
    %>
        <div class="info">
            <p><strong>Tên khách:</strong> <%= c.get("TenKhach") %></p>
            <p><strong>Email:</strong> <%= c.get("Email") %></p>
            <p><strong>Nội dung:</strong> <%= c.get("NoiDung") %></p>
            <p><strong>Ngày gửi:</strong> <%= c.get("NgayGui") %></p>
        </div>

        <form method="post" action="adminContact">
            <input type="hidden" name="action" value="reply">
            <input type="hidden" name="id" value="<%= c.get("MaLienHe") %>">

            <label>Phản hồi:</label><br>
            <textarea name="reply" required><%= c.get("PhanHoi") != null ? c.get("PhanHoi") : "" %></textarea><br><br>

            <button type="submit" class="btn">📨 Gửi phản hồi</button>
        </form>

    <% } else { %>
        <p>Không tìm thấy thông tin liên hệ.</p>
    <% } %>
</body>
</html>
<%@ include file="footer.jsp" %>