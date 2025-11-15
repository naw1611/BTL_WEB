<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ include file="header.jsp" %>

<h2>✏️ Chỉnh sửa người dùng</h2>

<form action="adminUser" method="post" style="width:400px;">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="id" value="${user.maUser}">

    <label>Tên đăng nhập:</label><br>
    <input type="text" value="${user.username}" readonly style="width:100%;"><br><br>

    <label>Họ tên:</label><br>
    <input type="text" value="${user.fullName}" readonly style="width:100%;"><br><br>

    <label>Email:</label><br>
    <input type="text" value="${user.email}" readonly style="width:100%;"><br><br>

    <label>Quyền:</label><br>
    <select name="role" style="width:100%;">
        <option value="user" ${user.role == 'user' ? 'selected' : ''}>Người dùng</option>
        <option value="admin" ${user.role == 'admin' ? 'selected' : ''}>Quản trị viên</option>
    </select><br><br>

    <label>Trạng thái:</label><br>
    <select name="trangThai" style="width:100%;">
        <option value="true" ${user.trangThai ? 'selected' : ''}>Hoạt động</option>
        <option value="false" ${!user.trangThai ? 'selected' : ''}>Bị khóa</option>
    </select><br><br>

    <button type="submit" style="background:#28a745; color:white; padding:8px 15px; border:none; border-radius:5px;">
        💾 Lưu thay đổi
    </button>
    <a href="adminUser?action=list" style="margin-left:10px;">⬅️ Quay lại</a>
</form>

<%@ include file="footer.jsp" %>
