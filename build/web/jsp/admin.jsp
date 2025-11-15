<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="header.jsp" %>

<!-- 🧭 THANH MENU QUẢN TRỊ -->

<div style="margin-bottom:20px;">
    <a href="admin" 
       style="background:#007bff; color:white; padding:6px 10px; border-radius:5px; text-decoration:none; margin-right:10px;">
       🧾 Quản lý đơn hàng
    </a>

    <a href="adminProduct?action=list" 
       style="background:#28a745; color:white; padding:6px 10px; border-radius:5px; text-decoration:none; margin-right:10px;">
       📦 Quản lý sản phẩm
    </a>

    <a href="adminUser?action=list" 
       style="background:#6f42c1; color:white; padding:6px 10px; border-radius:5px; text-decoration:none; margin-right:10px;">
       👥 Quản lý người dùng
    </a>
    </div>
<div style="margin-bottom:20px;">
    <a href="adminCategory?action=list" 
       style="background:#ffc107; color:black; padding:6px 10px; border-radius:5px; text-decoration:none; margin-right:10px;">
       🗂️ Quản lý danh mục
    </a>

    <!-- 🎁 Thêm nút quản lý khuyến mãi -->
    <a href="adminKhuyenMai?action=list"
       style="background:#e83e8c; color:white; padding:6px 10px; border-radius:5px; text-decoration:none; margin-right:10px;">
       🎁 Quản lý khuyến mãi
    </a>
    
    <a href="adminContact?action=list" style="background:#17a2b8; color:white; padding:6px 10px; border-radius:5px; text-decoration:none;">
    💬 Quản lý liên hệ
</a>

</div>


<h2>📦 Quản Lý Đơn Hàng</h2>

<!-- 🔍 FORM TÌM KIẾM -->
<form action="admin" method="get" style="margin-bottom: 20px;">
    <input type="hidden" name="action" value="searchOrders">

    <label>Mã đơn:</label>
    <input type="text" name="orderId" value="${param.orderId}" style="width: 100px;">

    <label>Tên khách:</label>
    <input type="text" name="customerName" value="${param.customerName}" style="width: 150px;">

    <div style="margin-top: 8px;">
        <label>Từ ngày:</label>
        <input type="date" name="fromDate" value="${param.fromDate}">

        <label>Đến ngày:</label>
        <input type="date" name="toDate" value="${param.toDate}">
    </div>

    <button type="submit" style="margin-top:8px;">🔍 Tìm kiếm</button>
    <a href="admin" style="margin-left: 10px;">🧹 Xóa lọc</a>

    <!-- 📤 Xuất báo cáo -->
    <div style="margin-top:10px;">
        <a href="admin?action=exportExcel" class="btn" 
           style="background:green; color:white; padding:5px 10px; border-radius:5px; text-decoration:none;">📗 Xuất Excel</a>
        <a href="admin?action=exportPDF" class="btn" 
           style="background:red; color:white; padding:5px 10px; border-radius:5px; text-decoration:none;">📕 Xuất PDF</a>
    </div>
</form>

<hr>

<c:if test="${empty sessionScope.user || sessionScope.user.role != 'admin'}">
    <p>Bạn không có quyền truy cập! Vui lòng <a href="login">đăng nhập</a> với tài khoản admin.</p>
</c:if>

<c:if test="${not empty sessionScope.user && sessionScope.user.role == 'admin'}">

    <c:if test="${empty orders}">
        <p>Chưa có đơn hàng nào!</p>
    </c:if>

    <c:if test="${not empty orders}">
        <table border="1" cellspacing="0" cellpadding="6" style="width:100%; border-collapse:collapse; text-align:center;">
            <thead style="background-color:#f2f2f2;">
                <tr>
                    <th>Mã Đơn</th>
                    <th>Khách Hàng</th>
                    <th>Ngày Đặt</th>
                    <th>Tổng Tiền</th>
                    <th>Địa Chỉ Giao</th>
                    <th>Trạng Thái</th>
                    <th>Hành Động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="order" items="${orders}">
                    <tr>
                        <td>${order.maDon}</td>
                        <td>${order.user.fullName}</td>
                        <td><fmt:formatDate value="${order.ngayDat}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td><fmt:formatNumber value="${order.tongTien}" type="number"/> VNĐ</td>
                        <td>${order.diaChiGiao}</td>

                        <%-- ⭐ MÃ NÂNG CẤP (HIỂN THỊ MÀU THEO TRẠNG THÁI) --%>
<td>
    <c:choose>
        <c:when test="${order.trangThai == 'Đã giao hàng'}">
            <span style="color:green; font-weight:bold;">Đã giao hàng</span>
        </c:when>
        <c:when test="${order.trangThai == 'Đang giao hàng'}">
            <span style="color:blue;">Đang giao hàng</span>
        </c:when>
        <c:when test="${order.trangThai == 'Đã hủy'}">
            <span style="color:red; text-decoration: line-through;">Đã hủy</span>
        </c:when>
        <c:otherwise>
            <%-- Mặc định cho 'Đang xử lý' --%>
            <span style="color:#6c757d;">${order.trangThai}</span>
        </c:otherwise>
    </c:choose>
</td>

                        <td>
                            <a href="admin?action=detail&maDon=${order.maDon}">Chi tiết</a> |
                            <a href="admin?action=print&maDon=${order.maDon}" target="_blank">In</a>
                            
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>

    <c:if test="${not empty message}">
        <p class="${messageType}" style="margin-top:10px;">${message}</p>
    </c:if>

</c:if>

<%@ include file="footer.jsp" %>
