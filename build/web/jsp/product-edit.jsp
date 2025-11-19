<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="header.jsp" %>
<html>
<head>
    <title>Sửa Sản Phẩm</title>
</head>
<body>
    <h2>✏️ Sửa Sản Phẩm</h2>

    <form action="${pageContext.request.contextPath}/adminProduct" method="post" enctype="multipart/form-data">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id" value="${product.maSP}">

        <label>Tên sản phẩm:</label><br>
        <input type="text" name="tenSP" value="${product.tenSP}" required><br><br>
        <label>Giá:</label><br>
        <input type="number" name="gia" value="${product.gia}" required><br><br>
        <label>Số lượng:</label><br>
        <input type="number" name="soLuong" value="${product.soLuong}" required><br><br>
        <label>Mô tả:</label><br>
        <textarea name="moTa" rows="3">${product.moTa}</textarea><br><br>
        <label>Danh mục:</label><br>
        <select name="maDanhMuc" required>
            <option value="">-- Chọn danh mục --</option>
            <c:forEach var="cat" items="${categories}">
                <option value="${cat.MaDanhMuc}" 
                        <c:if test="${product.maDanhMuc == cat.MaDanhMuc}">selected</c:if>>
                    ${cat.TenDanhMuc}
                </option>
            </c:forEach>
        </select><br><br>
        <label>Khuyến mại:</label><br>
        <select name="maKM">
            <option value="">-- Không áp dụng khuyến mại --</option>
            <c:forEach var="km" items="${promotions}">
                <option value="${km.MaKM}"
                        <c:if test="${product.maKM == km.MaKM}">selected</c:if>>
                    ${km.TenKM} - Giảm ${km.PhanTramGiam}%
                </option>
            </c:forEach>
        </select><br><br>

        <label>Ảnh hiện tại:</label><br>
        <img src="${pageContext.request.contextPath}/images/${product.hinhAnh}" 
             alt="${product.tenSP}" 
             style="width:100px; height:100px; object-fit:contain; border:1px solid #ddd; border-radius:4px;">
        <br><br>
        
        <input type="hidden" name="hinhAnhCu" value="${product.hinhAnh}">
        
        <label>Chọn ảnh mới (Bỏ trống nếu không muốn đổi):</label><br>
        <input type="file" name="hinhAnhMoi" accept="image/*"><br><br>


        <button type="submit">💾 Lưu thay đổi</button>
        <a href="${pageContext.request.contextPath}/adminProduct?action=list">↩ Quay lại</a>
    </form>
</body>
</html>