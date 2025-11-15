<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ include file="header.jsp" %>

<h2>📂 Quản lý danh mục sản phẩm</h2>

<!-- Nút thêm danh mục -->
<div style="margin-bottom: 15px;">
    <a href="adminCategory?action=add" 
       style="background: #28a745; color: white; padding: 6px 10px; border-radius: 5px; text-decoration: none;">
       ➕ Thêm danh mục mới
    </a>
</div>

<!-- Danh sách danh mục -->
<table border="1" cellpadding="6" cellspacing="0" style="width:100%; border-collapse: collapse; text-align:center;">
    <thead style="background-color: #f2f2f2;">
        <tr>
            <th>Mã danh mục</th>
            <th>Tên danh mục</th>
            <th>Mô tả</th>
            <th>Hành động</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="cat" items="${categories}">
            <tr>
                <td>${cat.maDanhMuc}</td>
                <td>${cat.tenDanhMuc}</td>
                <td>${cat.moTa}</td>
                <td>
                    <a href="adminCategory?action=edit&id=${cat.maDanhMuc}" 
                       style="color: blue;">✏️ Sửa</a> |
                    <form action="adminCategory" method="post" style="display:inline;" 
                          onsubmit="return confirm('Bạn có chắc muốn xóa danh mục này?');">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="${cat.maDanhMuc}">
                        <button type="submit" style="border:none; background:none; color:red; cursor:pointer;">🗑️ Xóa</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>

<%@ include file="footer.jsp" %>
