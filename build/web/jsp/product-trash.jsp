<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ include file="header.jsp" %>

<div class="container" style="margin-top: 20px;">
    <h2 class="text-danger">🗑 Thùng rác sản phẩm</h2>
    
    <div style="margin-bottom: 15px;">
        <a href="${pageContext.request.contextPath}/adminProduct?action=list" class="btn btn-secondary">
            ⬅ Quay lại danh sách sản phẩm
        </a>
    </div>

    <table class="table table-bordered table-hover">
        <thead class="table-danger"> <tr>
                <th>ID</th>
                <th>Hình ảnh</th>
                <th>Tên sản phẩm</th>
                <th>Giá</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="p" items="${trashList}">
                <tr>
                    <td>${p.maSP}</td>
                    <td>
                        <img src="images/${p.hinhAnh}" width="60" height="60" style="object-fit: cover;">
                    </td>
                    <td>${p.tenSP}</td>
                    <td>${p.gia}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/adminProduct?action=restore&id=${p.maSP}" 
                           class="btn btn-success btn-sm"
                           onclick="return confirm('Bạn muốn khôi phục sản phẩm này bán lại?')">
                           ♻️ Khôi phục
                        </a>
                    </td>
                </tr>
            </c:forEach>
            
            <c:if test="${empty trashList}">
                <tr>
                    <td colspan="5" class="text-center">Thùng rác trống!</td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>

<%@ include file="footer.jsp" %>