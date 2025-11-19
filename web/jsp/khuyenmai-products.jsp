<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ include file="header.jsp" %>

<div style="max-width: 800px; margin: 20px auto;">
    <h2>🎁 Chọn sản phẩm cho Khuyến mãi #${maKM}</h2>
    <p><a href="${pageContext.request.contextPath}/adminKhuyenMai">⬅ Quay lại danh sách</a></p>

    <form action="${pageContext.request.contextPath}/adminKhuyenMai" method="post">
        <input type="hidden" name="action" value="updateProductList">
        <input type="hidden" name="maKM" value="${maKM}">

        <div style="height: 400px; overflow-y: auto; border: 1px solid #ccc; padding: 15px; background: #fff;">
            <c:forEach var="sp" items="${listProduct}">
                <c:set var="isChecked" value="${sp.maKM == maKM ? 'checked' : ''}" />
                
                <div style="display: flex; align-items: center; border-bottom: 1px solid #eee; padding: 8px 0;">
                    <input type="checkbox" name="selectedProducts" value="${sp.maSP}" id="p_${sp.maSP}" 
                           style="width: 20px; height: 20px; margin-right: 15px;" ${isChecked}>
                    
                    <label for="p_${sp.maSP}" style="flex-grow: 1; cursor: pointer;">
                        <b>${sp.tenSP}</b> 
                        <span style="float: right; color: green;">$${sp.gia}</span>
                        
                        <c:if test="${sp.maKM != 0 && sp.maKM != maKM}">
                            <br><small style="color: red;">(Đang thuộc KM ID: ${sp.maKM} - Nếu chọn sẽ bị ghi đè)</small>
                        </c:if>
                    </label>
                </div>
            </c:forEach>
        </div>

        <div style="margin-top: 20px; text-align: right;">
            <button type="submit" style="padding: 12px 25px; background: #28a745; color: white; border: none; font-size: 16px; cursor: pointer;">
                💾 Lưu thay đổi
            </button>
        </div>
    </form>
</div>

<%@ include file="footer.jsp" %>