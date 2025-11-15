<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="header.jsp" %>

<div class="container" style="max-width: 1000px; margin: 30px auto;">
    <h2>Chi Tiết Đơn Hàng #${order.maDon}</h2>
    <hr>

    <div class="order-detail">
        <div class="row" style="margin-bottom: 20px;">
            <div class="col-md-6">
                <h4>Thông tin người nhận</h4>
                <p><strong>Khách Hàng:</strong> ${order.user.fullName}</p>
                <p><strong>Email:</strong> ${order.user.email}</p>
                <p><strong>SĐT:</strong> ${order.user.soDienThoai}</p>
                <p><strong>Địa Chỉ Giao:</strong> ${order.diaChiGiao}</p>
            </div>

            <div class="col-md-6">
                <h4>Thông tin đơn hàng</h4>
                <p><strong>Ngày Đặt:</strong> 
                   <fmt:formatDate value="${order.ngayDat}" pattern="HH:mm 'ngày' dd/MM/yyyy"/></p>
                <p><strong>Tổng Tiền:</strong> 
                    <strong style="color: #c00; font-size: 1.2em;">
                        <fmt:formatNumber value="${order.tongTien}" type="number"/> VNĐ
                    </strong>
                </p>
                <p><strong>Trạng Thái:</strong> ${order.trangThai}</p>
            </div>
        </div>

        <c:if test="${sessionScope.user.role == 'admin'}">
            <div style="background: #f4f4f4; padding: 15px; border-radius: 8px; margin-bottom: 25px;">
                <form action="admin" method="post">
                    <input type="hidden" name="action" value="updateStatus">
                    <input type="hidden" name="maDon" value="${order.maDon}">
                    <label><strong>Cập nhật trạng thái:</strong></label>
                    <select name="status" required>
                        <option value="Đang xử lý" <c:if test="${order.trangThai == 'Đang xử lý'}">selected</c:if>>Đang xử lý</option>
                        <option value="Đang giao hàng" <c:if test="${order.trangThai == 'Đang giao hàng'}">selected</c:if>>Đang giao hàng</option>
                        <option value="Đã giao hàng" <c:if test="${order.trangThai == 'Đã giao hàng'}">selected</c:if>>Đã giao hàng</option>
                        <option value="Đã hủy" <c:if test="${order.trangThai == 'Đã hủy'}">selected</c:if>>Đã hủy</option>
                    </select>
                    <button type="submit">Cập nhật</button>
                </form>

                <c:if test="${param.success == '1'}">
                    <p style="color: green;">✅ Cập nhật trạng thái thành công!</p>
                </c:if>
                <c:if test="${param.error == '1'}">
                    <p style="color: red;">❌ Có lỗi xảy ra khi cập nhật!</p>
                </c:if>
            </div>
        </c:if>

        <h3>Sản Phẩm Trong Đơn Hàng</h3>
        <table border="1" cellspacing="0" cellpadding="8" style="width:100%; border-collapse:collapse;">
            <tr>
                <th>Hình Ảnh</th>
                <th>Sản Phẩm</th>
                <th>Giá</th>
                <th>Số Lượng</th>
                <th>Tổng</th>
            </tr>
            <c:forEach var="item" items="${orderDetails}">
                <tr>
                    <td><img src="${pageContext.request.contextPath}/images/${item.product.hinhAnh}" width="80"></td>
                    <td>${item.product.tenSP} (${item.product.codeSP})</td>
                    <td><fmt:formatNumber value="${item.donGia}" type="number"/> VNĐ</td>
                    <td>${item.soLuong}</td>
                    <td><fmt:formatNumber value="${item.donGia * item.soLuong}" type="number"/> VNĐ</td>
                </tr>
            </c:forEach>
        </table>

        <div style="margin-top: 20px;">
            <a href="admin?action=print&maDon=${order.maDon}" target="_blank">🖨 In đơn hàng</a> |
            <a href="admin">⬅ Quay lại</a>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
