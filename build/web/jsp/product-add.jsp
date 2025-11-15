<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="header.jsp" %>
<h2>➕ Thêm Sản Phẩm Mới</h2>

<form action="adminProduct" method="post" style="width:400px;">
    <input type="hidden" name="action" value="insert">

    <label>Tên sản phẩm:</label><br>
    <input type="text" name="tenSP" required style="width:100%;"><br><br>

    <label>Mã code:</label><br>
    <input type="text" name="codeSP" required style="width:100%;"><br><br>

    <label>Giá:</label><br>
    <input type="number" name="gia" required min="0" style="width:100%;"><br><br>

    <label>Số lượng:</label><br>
    <input type="number" name="soLuong" required min="0" style="width:100%;"><br><br>

    <label>Mô tả:</label><br>
    <textarea name="moTa" rows="3" style="width:100%;"></textarea><br><br>
    
    <label>Danh mục:</label><br>
<select name="maDanhMuc" required style="width:100%;">
    <option value="">-- Chọn danh mục --</option>
    <c:forEach var="cat" items="${categories}">
        <option value="${cat.MaDanhMuc}">${cat.TenDanhMuc}</option>
    </c:forEach>
</select>
<br><br>

    <!-- 🟢 Thêm phần chọn khuyến mãi -->
<label>Khuyến mãi:</label><br>
<select name="maKM" style="width:100%;">
    <option value="">-- Không áp dụng khuyến mãi --</option>
    <c:forEach var="km" items="${promotions}">
        <option value="${km.MaKM}">
            ${km.TenKM} - Giảm ${km.PhanTramGiam}% (từ <fmt:formatDate value="${km.NgayBatDau}" pattern="dd/MM/yyyy"/> 
            đến <fmt:formatDate value="${km.NgayKetThuc}" pattern="dd/MM/yyyy"/>)
        </option>
    </c:forEach>
</select>
<br><br>

    <label>Ảnh (tên file trong /images/products):</label><br>
    <input type="text" name="hinhAnh" placeholder="vd: ao-bongda.jpg" style="width:100%;"><br><br>

    <button type="submit" style="background:#28a745; color:white; padding:8px 15px; border:none; border-radius:5px;">
        💾 Lưu sản phẩm
    </button>
    <a href="adminProduct?action=list" style="margin-left:10px;">⬅️ Quay lại</a>
</form>

<%@ include file="footer.jsp" %>
