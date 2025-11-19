<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="header.jsp" %>

<style>
    .pagination {
        display: flex;
        justify-content: center;
        padding: 20px 0;
    }
    .pagination a, .pagination span {
        color: #007bff;
        padding: 8px 16px;
        text-decoration: none;
        border: 1px solid #ddd;
        margin: 0 4px;
        border-radius: 4px;
        transition: background-color .3s;
    }
    .pagination span.current {
        background-color: #007bff;
        color: white;
        border: 1px solid #007bff;
    }
    .pagination a:hover {
        background-color: #f2f2f2;
    }
</style>

<h2>📦 Quản Lý Sản Phẩm</h2>

<div style="margin-bottom:15px; display: flex; justify-content: space-between; align-items: center;">
    <a href="adminProduct?action=add"
       style="background:#28a745; color:white; padding:8px 12px; border-radius:5px; text-decoration:none;">
       ➕ Thêm sản phẩm mới
    </a>

    <a href="adminProduct?action=trash"
       style="background:#ffc107; color:#333; padding:8px 12px; border-radius:5px; text-decoration:none; border: 1px solid #e0a800; font-weight: bold;">
       🗑️ Thùng rác (Khôi phục SP)
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
                    <img src="${pageContext.request.contextPath}/images/${p.hinhAnh}"
                         alt="${p.tenSP}"
                         onerror="this.src='${pageContext.request.contextPath}/images/no-image.jpg'"
                         style="width: 100px; height: 100px; object-fit: contain; background: #f9f9f9; border-radius: 8px;">
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

<c:if test="${totalPages > 1}">
    <div class="pagination">
        
        <c:if test="${currentPage > 1}">
            <a href="adminProduct?page=${currentPage - 1}">&laquo; Trước</a>
        </c:if>

        <c:forEach begin="1" end="${totalPages}" var="i">
            <c:choose>
                <c:when test="${i == currentPage}">
                    <span class="current">${i}</span>
                </c:when>
                <c:otherwise>
                    <a href="adminProduct?page=${i}">${i}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <c:if test="${currentPage < totalPages}">
            <a href="adminProduct?page=${currentPage + 1}">Sau &raquo;</a>
        </c:if>
    </div>
</c:if>


<%@ include file="footer.jsp" %>