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
                
                <!-- ⭐ THÊM THÔNG TIN THANH TOÁN -->
                <p><strong>Thanh toán:</strong> 
                    <c:choose>
                        <c:when test="${order.phuongThucThanhToan == 'Chuyển khoản'}">
                            <span style="color:#28a745; font-weight:bold;">🏦 Chuyển khoản</span>
                        </c:when>
                        <c:when test="${order.phuongThucThanhToan == 'VNPAY'}">
                            <span style="color:#0066cc; font-weight:bold;">💳 VNPAY</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color:#6c757d; font-weight:bold;">💵 COD</span>
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>
        </div>

        <!-- ⭐ PHẦN HIỂN THỊ ẢNH CHUYỂN KHOẢN -->
        <c:if test="${order.phuongThucThanhToan == 'Chuyển khoản' && not empty order.anhChuyenKhoan}">
            <div style="margin-bottom: 25px; padding: 20px; background: #fff3cd; border: 2px solid #ffc107; border-radius: 10px;">
                <h4 style="color: #856404; margin-top: 0;">📸 Ảnh xác nhận chuyển khoản</h4>
                <div style="text-align: center;">
                    <img src="${pageContext.request.contextPath}/${order.anhChuyenKhoan}" 
                         alt="Ảnh chuyển khoản đơn #${order.maDon}" 
                         style="max-width: 600px; width: 100%; border: 3px solid #28a745; border-radius: 10px; cursor: pointer; box-shadow: 0 4px 15px rgba(0,0,0,0.2);"
                         onclick="window.open(this.src, '_blank')"
                         onerror="this.src='${pageContext.request.contextPath}/images/no-image.jpg'">
                    <p style="margin-top: 10px; color: #856404; font-style: italic;">
                        💡 Click vào ảnh để xem kích thước đầy đủ
                    </p>
                </div>
            </div>
        </c:if>

        <!-- FORM CẬP NHẬT TRẠNG THÁI (CHỈ ADMIN) -->
        <c:if test="${sessionScope.user.role == 'admin'}">
            <div style="background: #f4f4f4; padding: 15px; border-radius: 8px; margin-bottom: 25px;">
                <form action="admin" method="post">
                    <input type="hidden" name="action" value="updateStatus">
                    <input type="hidden" name="maDon" value="${order.maDon}">
                    <label><strong>Cập nhật trạng thái:</strong></label>
                    <select name="status" required style="padding: 8px; border-radius: 5px; margin: 0 10px;">
                        <option value="Đang xử lý" <c:if test="${order.trangThai == 'Đang xử lý'}">selected</c:if>>Đang xử lý</option>
                        <option value="Đang giao hàng" <c:if test="${order.trangThai == 'Đang giao hàng'}">selected</c:if>>Đang giao hàng</option>
                        <option value="Đã giao hàng" <c:if test="${order.trangThai == 'Đã giao hàng'}">selected</c:if>>Đã giao hàng</option>
                        <option value="Đã hủy" <c:if test="${order.trangThai == 'Đã hủy'}">selected</c:if>>Đã hủy</option>
                    </select>
                    <button type="submit" style="padding: 8px 20px; background: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer;">
                        Cập nhật
                    </button>
                </form>

                <c:if test="${param.success == '1'}">
                    <p style="color: green; margin-top: 10px;">✅ Cập nhật trạng thái thành công!</p>
                </c:if>
                <c:if test="${param.error == '1'}">
                    <p style="color: red; margin-top: 10px;">❌ Có lỗi xảy ra khi cập nhật!</p>
                </c:if>
            </div>
        </c:if>

        <!-- DANH SÁCH SẢN PHẨM -->
        <h3>Sản Phẩm Trong Đơn Hàng</h3>
        <table border="1" cellspacing="0" cellpadding="8" style="width:100%; border-collapse:collapse;">
            <thead style="background-color:#f2f2f2;">
                <tr>
                    <th>Hình Ảnh</th>
                    <th>Sản Phẩm</th>
                    <th>Giá</th>
                    <th>Số Lượng</th>
                    <th>Tổng</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${orderDetails}">
                    <tr>
                        <td style="text-align: center;">
                            <img src="${pageContext.request.contextPath}/images/${item.product.hinhAnh}" 
                                 alt="${item.product.tenSP}"
                                 style="width: 80px; height: 80px; object-fit: cover; border-radius: 5px;"
                                 onerror="this.src='${pageContext.request.contextPath}/images/no-image.jpg'">
                        </td>
                        <td>
                            <strong>${item.product.tenSP}</strong><br>
                            <small style="color: #888;">Mã: ${item.product.codeSP}</small>
                        </td>
                        <td style="text-align: right;">
                            <fmt:formatNumber value="${item.donGia}" type="number"/> VNĐ
                        </td>
                        <td style="text-align: center;">
                            <strong>${item.soLuong}</strong>
                        </td>
                        <td style="text-align: right;">
                            <strong style="color: #e74c3c;">
                                <fmt:formatNumber value="${item.donGia * item.soLuong}" type="number"/> VNĐ
                            </strong>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
            <tfoot style="background-color: #f8f9fa; font-weight: bold;">
                <tr>
                    <td colspan="4" style="text-align: right;">TỔNG CỘNG:</td>
                    <td style="text-align: right; color: #e74c3c; font-size: 1.2em;">
                        <fmt:formatNumber value="${order.tongTien}" type="number"/> VNĐ
                    </td>
                </tr>
            </tfoot>
        </table>

        <!-- FOOTER ACTIONS -->
        <div style="margin-top: 20px; padding: 15px; background: #f8f9fa; border-radius: 5px;">
            <a href="admin?action=print&maDon=${order.maDon}" 
               target="_blank"
               style="background: #17a2b8; color: white; padding: 10px 20px; border-radius: 5px; text-decoration: none; margin-right: 10px;">
                🖨 In đơn hàng
            </a>
            <a href="admin" 
               style="background: #6c757d; color: white; padding: 10px 20px; border-radius: 5px; text-decoration: none;">
                ⬅ Quay lại
            </a>
        </div>
    </div>
</div>

<style>
/* Responsive cho mobile */
@media (max-width: 768px) {
    .row {
        display: block;
    }
    .col-md-6 {
        width: 100%;
        margin-bottom: 20px;
    }
    table {
        font-size: 0.9em;
    }
    img {
        max-width: 100%;
    }
}
</style>

<%@ include file="footer.jsp" %>