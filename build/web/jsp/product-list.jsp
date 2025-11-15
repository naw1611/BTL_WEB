<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="header.jsp" %>

<h2>📦 Quản Lý Sản Phẩm</h2>

<div style="margin-bottom:15px;">
    <a href="adminProduct?action=add"
       style="background:#28a745; color:white; padding:8px 12px; border-radius:5px; text-decoration:none;">
       ➕ Thêm sản phẩm mới
    </a>
</div>

<c:if test="${empty products}">
    <p>Chưa có sản phẩm nào!</p>
</c:if>

<c:if test="${not empty products}">
<table border="1" cellspacing="0" cellpadding="6" style="width:100%; border-collapse:collapse; text-align:center;">
    <thead style="background-color:#f2f2f2;">
        <tr>
            <th>Mã</th>
            <th>Tên sản phẩm</th>
            <th>Mã Code</th>
            <th>Giá</th>
            <th>Số lượng</th>
            <th>Ảnh</th>
            <th>Hành động</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="p" items="${products}">
            <tr>
                <td>${p.maSP}</td>
                <td>${p.tenSP}</td>
                <td>${p.codeSP}</td>
                <td><fmt:formatNumber value="${p.gia}" type="number"/> ₫</td>
                <td>${p.soLuong}</td>
                <td>
                    <img src="${pageContext.request.contextPath}/images/products/${p.hinhAnh}"
                         alt="${p.tenSP}" width="60" height="60"
                         style="object-fit:cover; border-radius:6px;">
                </td>
                <td>
                    <a href="adminProduct?action=edit&id=${p.maSP}" style="color:blue;">✏️ Sửa</a> |
                    <a href="adminProduct?action=delete&id=${p.maSP}"
                       onclick="return confirm('Xác nhận xóa sản phẩm này?');"
                       style="color:red;">🗑️ Xóa</a>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>
</c:if>

<%@ include file="footer.jsp" %>
