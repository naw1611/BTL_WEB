<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="header.jsp" %>

<h2>Quản Lý Đơn Hàng</h2>
<!-- 🧭 FORM TÌM KIẾM -->
<form action="admin" method="get" style="margin-bottom: 20px;">
    <input type="hidden" name="action" value="searchOrders">

    <label>Mã đơn: </label>
    <input type="text" name="orderId" value="${param.orderId}" style="width: 100px;">

    <label>Tên khách: </label>
    <input type="text" name="customerName" value="${param.customerName}" style="width: 150px;">
    <div>
    <label>Từ ngày: </label>
    <input type="date" name="fromDate" value="${param.fromDate}">

    <label>Đến ngày: </label>
    <input type="date" name="toDate" value="${param.toDate}">
    </div>

    <button type="submit">Tìm kiếm</button>
    <a href="admin" style="margin-left: 10px;">🧹 Xóa lọc</a>
</form>

<c:if test="${empty sessionScope.user || sessionScope.user.role != 'admin'}">
    <p>Bạn không có quyền truy cập! Vui lòng <a href="login">đăng nhập</a> với tài khoản admin.</p>
</c:if>

<c:if test="${not empty sessionScope.user && sessionScope.user.role == 'admin'}">
    <c:if test="${empty orders}">
        <p>Chưa có đơn hàng nào!</p>
    </c:if>

    <c:if test="${not empty orders}">
        <table class="order-table" border="1" cellspacing="0" cellpadding="6" style="width:100%; border-collapse:collapse;">
            <tr>
                <th>Mã Đơn</th>
                <th>Khách Hàng</th>
                <th>Ngày Đặt</th>
                <th>Tổng Tiền</th>
                <th>Địa Chỉ Giao</th>
                <th>Trạng Thái</th>
                <th>Hành Động</th>
            </tr>

            <c:forEach var="order" items="${orders}">
                <tr>
                    <td>${order.maDon}</td>
                    <td>${order.user.fullName}</td>
                    <td>${order.ngayDat}</td>
                    <td><fmt:formatNumber value="${order.tongTien}" type="number"/> VNĐ</td>
                    <td>${order.diaChiGiao}</td>

                    <td>
                        <!-- Form cập nhật trạng thái đơn -->
                        <form action="admin" method="post" style="display:flex; align-items:center; gap:4px;">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="maDon" value="${order.maDon}">
                            <select name="status">
                                <option value="Đang xử lý" ${order.trangThai == 'Đang xử lý' ? 'selected' : ''}>Đang xử lý</option>
                                <option value="Đang giao" ${order.trangThai == 'Đang giao' ? 'selected' : ''}>Đang giao</option>
                                <option value="Đã giao" ${order.trangThai == 'Đã giao' ? 'selected' : ''}>Đã giao</option>
                                <option value="Đã hủy" ${order.trangThai == 'Đã hủy' ? 'selected' : ''}>Đã hủy</option>
                            </select>
                            <button type="submit">Cập nhật</button>
                        </form>
                    </td>

                    <td>
                        <a href="admin?action=detail&maDon=${order.maDon}">Chi Tiết</a> |
                        <a href="admin?action=print&maDon=${order.maDon}" target="_blank">In</a>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </c:if>

    <c:if test="${not empty message}">
        <p class="${messageType}">${message}</p>
    </c:if>
</c:if>

<%@ include file="footer.jsp" %>
