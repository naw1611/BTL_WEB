<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ include file="header.jsp" %>

<h2>📬 Lịch sử liên hệ của bạn</h2>

<table border="1" style="border-collapse:collapse; width:100%;">
    <tr>
        <th>Ngày gửi</th>
        <th>Nội dung</th>
        <th>Trạng thái</th>
        <th>Phản hồi từ Admin</th>
        <th>Ngày phản hồi</th>
    </tr>
    <c:forEach var="c" items="${contacts}">
        <tr>
            <td>${c.NgayGui}</td>
            <td>${c.NoiDung}</td>
            <td>${c.TrangThai}</td>
            <td>${empty c.PhanHoi ? '--- Chưa phản hồi ---' : c.PhanHoi}</td>
            <td>${c.NgayPhanHoi}</td>
        </tr>
    </c:forEach>
</table>

<%@ include file="footer.jsp" %>
