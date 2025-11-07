<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="header.jsp" %>

<div class="container" style="max-width: 1000px; margin: 30px auto;">
    <h2>Chi Tiết Đơn Hàng #${order.maDon}</h2>
    <hr>

    <div class="order-detail">
        <!-- PHẦN 1: THÔNG TIN NGƯỜI NHẬN -->
        <div class="row" style="margin-bottom: 20px;">
            <div class="col-md-6">
                <h4>Thông tin người nhận</h4>
                <p><strong>Khách Hàng:</strong> ${order.user.fullName}</p>
                <p><strong>Email:</strong> ${order.user.email}</p>
                <p><strong>Địa Chỉ Giao:</strong> ${order.diaChiGiao}</p>
                <c:if test="${not empty order.sdt}">
                    <p><strong>Điện thoại:</strong> ${order.sdt}</p>
                </c:if>
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

        <hr>

        <!-- PHẦN 2: CẬP NHẬT (ADMIN) -->
        <c:if test="${sessionScope.user.role == 'admin'}">
            <div style="background: #f4f4f4; padding: 15px; border-radius: 8px; margin-bottom: 25px;">
                <form action="admin" method="post" class="form-inline">
                    <input type="hidden" name="action" value="updateStatus">
                    <input type="hidden" name="maDon" value="${order.maDon}">
                    <label for="status" class="mr-2"><strong>Cập Nhật Trạng Thái:</strong></label>
                    <select id="status" name="status" class="form-control mr-2" required>
                        <option value="Đang xử lý" <c:if test="${order.trangThai == 'Đang xử lý'}">selected</c:if>>Đang xử lý</option>
                        <option value="Đang giao" <c:if test="${order.trangThai == 'Đang giao'}">selected</c:if>>Đang giao</option>
                        <option value="Đã giao" <c:if test="${order.trangThai == 'Đã giao'}">selected</c:if>>Đã giao</option>
                        <option value="Đã hủy" <c:if test="${order.trangThai == 'Đã hủy'}">selected</c:if>>Đã hủy</option>
                    </select>
                    <button type="submit" class="btn btn-success">Cập Nhật</button>
                </form>

                <!-- Hiển thị thông báo -->
                <c:if test="${param.success == '1'}">
                    <p class="alert alert-success mt-2">✅ Cập nhật trạng thái thành công!</p>
                </c:if>
                <c:if test="${param.error == '1'}">
                    <p class="alert alert-danger mt-2">❌ Có lỗi xảy ra khi cập nhật trạng thái!</p>
                </c:if>
            </div>
        </c:if>

        <!-- PHẦN 3: BẢNG SẢN PHẨM -->
        <h3>Sản Phẩm Trong Đơn Hàng</h3>
        <table class="table table-bordered table-hover">
            <thead class="thead-light">
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
                        <td><img src="${pageContext.request.contextPath}/images/${item.product.hinhAnh}"
                                 alt="${item.product.tenSP}"
                                 style="width: 80px; height: 80px; object-fit: cover; border-radius: 4px;"></td>
                        <td>${item.product.tenSP} (${item.product.codeSP})</td>
                        <td><fmt:formatNumber value="${item.donGia}" type="number"/> VNĐ</td>
                        <td>${item.soLuong}</td>
                        <td><fmt:formatNumber value="${item.donGia * item.soLuong}" type="number"/> VNĐ</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- Nút quay lại -->
        <c:if test="${sessionScope.user.role == 'admin'}">
            <button onclick="window.print()" class="btn btn-secondary">In Đơn Hàng</button>
            <a href="admin" class="btn btn-primary">Quay lại (Admin)</a>
        </c:if>
        <c:if test="${sessionScope.user.role != 'admin'}">
            <a href="order?action=view" class="btn btn-primary">Quay lại đơn hàng của tôi</a>
        </c:if>
    </div>
</div>

<%@ include file="footer.jsp" %>
