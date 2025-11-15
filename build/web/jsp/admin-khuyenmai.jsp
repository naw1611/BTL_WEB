<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ include file="header.jsp" %>

<h2>🎁 Quản lý khuyến mãi</h2>

<form action="AdminKhuyenMaiServlet" method="post" style="margin-bottom: 20px;">
    <input type="text" name="tenKM" placeholder="Tên khuyến mãi" required>
    <input type="text" name="noiDung" placeholder="Nội dung" required>
    <input type="date" name="ngayBatDau" required>
    <input type="date" name="ngayKetThuc" required>
    <input type="number" step="0.01" name="phanTramGiam" placeholder="%" required>
    <button type="submit">➕ Thêm khuyến mãi</button>
</form>

<table border="1" cellpadding="6" cellspacing="0" style="border-collapse: collapse;">
    <tr style="background:#eee;">
        <th>Mã KM</th>
        <th>Tên KM</th>
        <th>Nội dung</th>
        <th>Ngày bắt đầu</th>
        <th>Ngày kết thúc</th>
        <th>Giảm (%)</th>
        <th>Thao tác</th>
    </tr>
    <c:forEach var="km" items="${listKM}">
        <tr>
            <td>${km.maKM}</td>
            <td>${km.tenKM}</td>
            <td>${km.noiDung}</td>
            <td>${km.ngayBatDau}</td>
            <td>${km.ngayKetThuc}</td>
            <td>${km.phanTramGiam}</td>
            <td><a href="DeleteKhuyenMaiServlet?maKM=${km.maKM}" onclick="return confirm('Xóa khuyến mãi này?')">🗑 Xóa</a></td>
        </tr>
    </c:forEach>
</table>

<%@ include file="footer.jsp" %>
