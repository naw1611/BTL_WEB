<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="header.jsp" %>

<div class="container main-content" style="max-width: 1200px; margin: 30px auto;">
    <h2 style="margin-bottom: 20px;">🏷️ Đơn Hàng Của Tôi</h2>

    <c:if test="${empty orderList}">
        <div style="text-align: center; padding: 50px; background: #f8f9fa; border-radius: 8px;">
            <p style="font-size: 1.2em; color: #555;">Bạn chưa có đơn hàng nào.</p>
            <br>
            <a href="products" class="btn btn-primary" style="padding: 10px 20px; text-decoration: none; background: #007bff; color: white; border-radius: 5px;">
                Bắt đầu mua sắm
            </a>
        </div>
    </c:if>

    <c:if test="${not empty orderList}">
        <div class="orders-container">
            <table class="table order-table">
                <thead>
                    <tr>
                        <th>Mã Đơn</th>
                        <th>Ngày Đặt</th>
                        <th>Người Nhận</th>
                        <th>Tổng Tiền</th>
                        <th style="width: 150px;">Trạng Thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${orderList}">
                        <tr>
                            <td>
                                <strong>#${order.maDon}</strong>
                            </td>
                            <td>
                                <fmt:formatDate value="${order.ngayDat}" pattern="dd/MM/yyyy HH:mm"/>
                            </td>
                            <td>
                                ${order.tenNguoiNhan}<br>
                                <small style="color: #666;">${order.sdt}</small>
                            </td>
                            <td class="order-total">
                                <fmt:formatNumber value="${order.tongTien}" pattern="#,###"/> đ
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${order.trangThai == 'Đã giao hàng'}">
                                        <span class="status status-delivered">${order.trangThai}</span>
                                    </c:when>
                                    <c:when test="${order.trangThai == 'Đang vận chuyển'}">
                                        <span class="status status-shipped">${order.trangThai}</span>
                                    </c:when>
                                     <c:when test="${order.trangThai == 'Đã hủy'}">
                                        <span class="status status-cancelled">${order.trangThai}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status status-processing">${order.trangThai}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="order-detail?id=${order.maDon}" class="btn btn-sm btn-detail">
                                    Xem Chi Tiết
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>
</div>

<style>
.order-table {
    width: 100%;
    border-collapse: collapse;
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    overflow: hidden;
    font-size: 0.95em;
}

.order-table thead {
    background: #f8f9fa;
}

.order-table th {
    padding: 15px;
    font-weight: 600;
    text-align: left;
    border-bottom: 2px solid #dee2e6;
}

.order-table td {
    padding: 15px;
    vertical-align: middle;
    border-bottom: 1px solid #eee;
}

.order-table tbody tr:last-child td {
    border-bottom: none;
}

.order-total {
    font-weight: bold;
    color: #e60000;
    font-size: 1.1em;
}

.status {
    padding: 5px 12px;
    border-radius: 20px;
    font-weight: 600;
    color: #fff;
    font-size: 0.9em;
    text-align: center;
    display: inline-block;
}

.status-processing { /* Đã đặt / Đang xử lý */
    background: #007bff;
}
.status-shipped { /* Đang vận chuyển */
    background: #ffc107;
    color: #333;
}
.status-delivered { /* Đã giao hàng */
    background: #28a745;
}
.status-cancelled { /* Đã hủy */
    background: #6c757d;
}

.btn-detail {
    background: #6c757d;
    color: white;
    font-size: 0.9em;
    padding: 6px 12px;
    border-radius: 5px;
    text-decoration: none;
    transition: background 0.2s;
}
.btn-detail:hover {
    background: #5a6268;
    color: white;
}
</style>

<%@ include file="footer.jsp" %>