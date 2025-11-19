<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ include file="header.jsp" %>

<h2>🎁 Quản lý khuyến mãi & Áp dụng hàng loạt</h2>

<form action="${pageContext.request.contextPath}/adminKhuyenMai" method="post" style="margin-bottom: 20px; border: 1px solid #ccc; padding: 20px; border-radius: 8px;">
    
    <div style="margin-bottom: 15px;">
        <h3>1. Thông tin chương trình</h3>
        <input type="text" name="tenKM" placeholder="Tên khuyến mãi" required style="width: 45%; padding: 8px;">
        <input type="text" name="noiDung" placeholder="Nội dung" required style="width: 45%; padding: 8px;">
        <br><br>
        <label>Bắt đầu:</label> <input type="date" name="ngayBatDau" required style="padding: 8px;">
        <label>Kết thúc:</label> <input type="date" name="ngayKetThuc" required style="padding: 8px;">
        <input type="number" step="0.01" name="phanTramGiam" placeholder="% Giảm" required style="width: 100px; padding: 8px;">
    </div>

    <hr>

    <div style="margin-bottom: 15px;">
        <h3>2. Chọn sản phẩm áp dụng (Tùy chọn)</h3>
        <p style="font-size: 0.9em; color: gray;">Tích chọn các sản phẩm muốn áp dụng mã giảm giá này ngay lập tức.</p>
        
        <div style="height: 250px; overflow-y: auto; border: 1px solid #ced4da; padding: 10px; background: #fff; border-radius: 4px;">
    
    <c:if test="${empty listProduct}">
        <div style="text-align: center; padding: 20px; color: #666;">
            Chưa có sản phẩm nào để chọn.
        </div>
    </c:if>
    
    <c:forEach var="sp" items="${listProduct}">
        <div style="display: flex; align-items: center; padding: 8px 0; border-bottom: 1px solid #eee;">
            
            <input type="checkbox" name="selectedProducts" value="${sp.maSP}" 
                   id="chk_${sp.maSP}" 
                   style="width: 18px; height: 18px; margin-right: 10px; cursor: pointer;">
            
            <label for="chk_${sp.maSP}" style="margin: 0; cursor: pointer; flex-grow: 1; display: flex; justify-content: space-between;">
                <span style="font-weight: bold;">${sp.tenSP}</span>
                <span style="color: #28a745; font-weight: bold;">$${sp.gia}</span>
            </label>
            
        </div>
    </c:forEach>
</div>
    </div>

    <button type="submit" style="padding: 10px 20px; background: #28a745; color: white; border: none; cursor: pointer;">
        ➕ Lưu khuyến mãi & Áp dụng
    </button>
</form>

<h3>Danh sách các chương trình đã tạo</h3>
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse: collapse; width: 100%;">
    <tr style="background:#eee;">
        <th>ID</th>
        <th>Tên KM</th>
        <th>Thời gian</th>
        <th>Giảm</th>
        <th>Sản phẩm</th> <th>Xóa</th>
    </tr>
    <c:forEach var="km" items="${listKM}">
        <tr>
            <td>${km.maKM}</td>
            <td>${km.tenKM}</td>
            <td>${km.ngayBatDau} <br> ${km.ngayKetThuc}</td>
            <td style="color: red; font-weight: bold;">${km.phanTramGiam}%</td>
            
            <td>
                <a href="${pageContext.request.contextPath}/adminKhuyenMai?action=chonSP&maKM=${km.maKM}"
                   style="background: #007bff; color: white; padding: 5px 10px; text-decoration: none; border-radius: 4px;">
                   📦 Chọn SP
                </a>
            </td>
            
            <td>
                <a href="${pageContext.request.contextPath}/DeleteKhuyenMaiServlet?maKM=${km.maKM}" 
                   onclick="return confirm('Xóa KM này? Sản phẩm sẽ về giá gốc.')">🗑 Xóa</a>
            </td>
        </tr>
    </c:forEach>
</table>

<%@ include file="footer.jsp" %>