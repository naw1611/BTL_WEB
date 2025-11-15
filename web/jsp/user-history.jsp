<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="header.jsp" %>

<h2>🧾 Lịch Sử Mua Hàng Của Người Dùng</h2>

<a href="adminUser?action=list" style="margin-bottom:10px; display:inline-block;">⬅️ Quay lại danh sách người dùng</a>

<c:if test="${empty orders}">
    <p>Người dùng này chưa có đơn hàng nào.</p>
</c:if>

<c:if test="${not empty orders}">
<table border="1" cellspacing="0" cellpadding="6" style="width:100%; border-collapse:collapse; text-align:center;">
    <thead style="background-color:#f2f2f2;">
        <tr>
            <th>Mã Đơn</th>
            <th>Ngày Đặt</th>
            <th>Tổng Tiền</th>
            <th>Trạng Thái</th>
            <th>Hành Động</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="o" items="${orders}">
            <tr>
                <td>${o.maDon}</td>
                <td><fmt:formatDate value="${o.ngayDat}" pattern="dd/MM/yyyy HH:mm"/></td>
                <td><fmt:formatNumber value="${o.tongTien}" type="number"/> ₫</td>
                <td>${o.trangThai}</td>
                <td><a href="admin?action=detail&maDon=${o.maDon}">🔍 Xem chi tiết</a></td>
            </tr>
        </c:forEach>
    </tbody>
</table>
</c:if>

<%@ include file="footer.jsp" %>
