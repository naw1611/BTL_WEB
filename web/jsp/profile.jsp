<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ include file="header.jsp" %>

<div class="profile-container">
    <div class="profile-card">
        <h2>Hồ Sơ Cá Nhân</h2>

        <c:if test="${not empty message}">
            <div class="alert ${messageType == 'error' ? 'alert-error' : 'alert-success'}">
                ${message}
            </div>
        </c:if>

        <!-- THÔNG TIN CÁ NHÂN -->
        <form action="profile" method="post" class="info-form">
            <input type="hidden" name="action" value="updateInfo">
            
            <div class="form-group">
                <label>Tên đăng nhập</label>
                <input type="text" value="${sessionScope.user.username}" disabled>
            </div>

            <div class="form-group">
                <label>Họ và tên</label>
                <input type="text" name="fullName" value="${sessionScope.user.fullName}" required>
            </div>

            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" value="${sessionScope.user.email}" required>
            </div>

            <div class="form-group">
                <label>Số điện thoại</label>
                <input type="text" name="soDienThoai" value="${sessionScope.user.soDienThoai}" required>
            </div>

            <div class="form-group">
                <label>Địa chỉ giao hàng</label>
                <textarea name="diaChi" rows="2" required>${sessionScope.user.diaChi}</textarea>
            </div>

            <button type="submit" class="btn-primary">Cập Nhật Thông Tin</button>
        </form>

        <!-- ĐỔI MẬT KHẨU -->
        <div class="password-section">
            <h3>Đổi Mật Khẩu</h3>
            <form action="profile" method="post" class="password-form">
                <input type="hidden" name="action" value="changePassword">

                <div class="form-group">
                    <label>Mật khẩu hiện tại</label>
                    <input type="password" name="currentPassword" required>
                </div>

                <div class="form-group">
                    <label>Mật khẩu mới</label>
                    <input type="password" name="newPassword" required minlength="6">
                </div>

                <div class="form-group">
                    <label>Xác nhận mật khẩu mới</label>
                    <input type="password" name="confirmPassword" required minlength="6">
                </div>

                <button type="submit" class="btn-danger">Đổi Mật Khẩu</button>
            </form>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>