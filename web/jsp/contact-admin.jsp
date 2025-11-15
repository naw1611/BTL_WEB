<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ include file="header.jsp" %>
<html>
<head>
    <title>Quản lý liên hệ</title>
    <style>
        table { width:100%; border-collapse:collapse; margin-top:20px; }
        th, td { border:1px solid #ccc; padding:8px; text-align:left; }
        th { background:#007bff; color:white; }
        tr:nth-child(even){ background:#f9f9f9; }
        .btn { padding:5px 10px; border-radius:4px; text-decoration:none; color:white; }
        .btn-view { background:#17a2b8; }
    </style>
</head>
<body>
    <h2>📩 Quản lý Liên hệ</h2>

    <table>
        <tr>
            <th>Mã</th>
            <th>Tên khách</th>
            <th>Email</th>
            <th>Nội dung</th>
            <th>Ngày gửi</th>
            <th>Trạng thái</th>
            <th>Hành động</th>
        </tr>

        <%
            List<Map<String,Object>> contacts = (List<Map<String,Object>>) request.getAttribute("contacts");
            if (contacts != null && !contacts.isEmpty()) {
                for (Map<String,Object> c : contacts) {
        %>
            <tr>
                <td><%= c.get("MaLienHe") %></td>
                <td><%= c.get("TenKhach") %></td>
                <td><%= c.get("Email") %></td>
                <td><%= c.get("NoiDung") %></td>
                <td><%= c.get("NgayGui") %></td>
                <td><%= c.get("TrangThai") %></td>
                <td>
                    <a class="btn btn-view" href="adminContact?action=view&id=<%= c.get("MaLienHe") %>">👁 Xem</a>
                </td>
            </tr>
        <%
                }
            } else {
        %>
            <tr><td colspan="7" style="text-align:center;">Không có liên hệ nào.</td></tr>
        <% } %>
    </table>
</body>
</html>
<%@ include file="footer.jsp" %>