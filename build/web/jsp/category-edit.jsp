<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ include file="header.jsp" %>

<h2>✏️ Chỉnh sửa danh mục</h2>

<form action="adminCategory" method="post" style="max-width:400px;">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="id" value="${category.maDanhMuc}">

    <label for="tenDanhMuc">Tên danh mục:</label><br>
    <input type="text" id="tenDanhMuc" name="tenDanhMuc" value="${category.tenDanhMuc}" 
           required style="width:100%; margin-bottom:10px;"><br>

    <label for="moTa">Mô tả:</label><br>
    <textarea id="moTa" name="moTa" rows="3" style="width:100%; margin-bottom:10px;">${category.moTa}</textarea><br>

    <button type="submit" style="background:#007bff; color:white; padding:6px 12px; border:none; border-radius:4px;">
        💾 Cập nhật
    </button>
    <a href="adminCategory?action=list" 
       style="margin-left:10px; text-decoration:none; color:#555;">🔙 Quay lại</a>
</form>

<%@ include file="footer.jsp" %>
