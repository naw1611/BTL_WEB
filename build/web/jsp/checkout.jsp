<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="header.jsp" %>

<div class="container main-content">
    <div class="checkout-container">
        <h2 class="checkout-title">
            <c:choose>
                <c:when test="${isBuyNowCheckout}">
                    🛒 Thanh toán - Mua Ngay
                </c:when>
                <c:otherwise>
                    🛒 Thanh toán - Giỏ hàng
                </c:otherwise>
            </c:choose>
        </h2>

        <c:if test="${not empty message}">
            <div class="alert alert-${messageType}">
                ${message}
            </div>
        </c:if>

        <div class="order-summary">
            <h3>📦 Sản phẩm đặt mua</h3>
            
            <table class="checkout-table">
                <thead>
                    <tr>
                        <th style="width: 100px;">Hình ảnh</th>
                        <th>Tên sản phẩm</th>
                        <th style="width: 100px; text-align: center;">Số lượng</th>
                        <th style="width: 150px; text-align: right;">Đơn giá</th>
                        <th style="width: 150px; text-align: right;">Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
    <c:forEach var="item" items="${cartItems}">
        
        <%-- ✅ SỬA LỖI 1: Thêm 3 dòng này để định nghĩa biến --%>
        <c:set var="isPromo" value="${item.product.phanTramGiam > 0}" />
        <c:set var="price" value="${isPromo ? item.product.giaKhuyenMai : item.product.gia}" />
        <c:set var="itemTotal" value="${price * item.soLuong}" />
        
        <tr>
            <td class="product-image-td">
                <img src="<%= request.getContextPath() %>/images/${item.product.hinhAnh}" 
                     alt="${item.product.tenSP}" 
                     class="product-thumb"
                     onerror="this.src='<%= request.getContextPath() %>/images/no-image.jpg'">
            </td>
            <td>
                <strong>${item.product.tenSP}</strong><br>
                <small style="color: #888;">Mã: ${item.product.codeSP}</small>
            </td>
            <td style="text-align: center;">
                <span class="quantity-badge">${item.soLuong}</span>
            </td>
            
            <%-- ✅ SỬA LỖI 2: Dùng <span> thay vì <div> để căn lề đúng --%>
            <td class="price-col">
                <c:choose>
                    <c:when test="${isPromo}">
                        <span style="display: block; text-decoration: line-through; color:#999; font-size:0.9em;">
                            <fmt:formatNumber value="${item.product.gia}" pattern="#,###"/> đ
                        </span>
                        <span style="display: block; color:#e74c3c; font-weight:bold;">
                            <fmt:formatNumber value="${item.product.giaKhuyenMai}" pattern="#,###"/> đ
                        </span>
                    </c:when>
                    <c:otherwise>
                        <fmt:formatNumber value="${item.product.gia}" pattern="#,###"/> đ
                    </c:otherwise>
                </c:choose>
            </td>
            
            <td class="price-col total-col">
                <strong><fmt:formatNumber value="${itemTotal}" pattern="#,###"/> đ</strong>
            </td>
        </tr>
    </c:forEach>
</tbody>
                <tfoot>
                    <tr class="total-row">
                        <td colspan="4" style="text-align: right; font-weight: bold;">
                            TỔNG CỘNG:
                        </td>
                        <td class="final-total">
                            <fmt:formatNumber value="${totalCart}" pattern="#,###"/> đ
                        </td>
                    </tr>
                </tfoot>
            </table>
        </div>

        <div class="customer-info">
            <h3>📋 Thông tin giao hàng</h3>
            
            <form action="order" 
      method="POST" 
      enctype="multipart/form-data"
      class="order-form" 
      id="checkoutForm">

                
                <c:choose>
                    <c:when test="${isBuyNowCheckout}">
                        <input type="hidden" name="buyNow" value="true">
                        
                        <c:forEach var="item" items="${cartItems}">
                            <input type="hidden" name="maSP" value="${item.product.maSP}">
                            <input type="hidden" name="quantity" value="${item.soLuong}">
                            
                            </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <input type="hidden" name="buyNow" value="false">
                        
                        <c:forEach var="item" items="${cartItems}">
                            <input type="hidden" name="selectedProducts" value="${item.product.maSP}">
                        </c:forEach>

                    </c:otherwise>
                </c:choose>
                
                <div class="form-group">
                    <label for="customerName">
                        <i class="icon">👤</i> Họ và tên <span class="required">*</span>
                    </label>
                    <input type="text" 
                           id="customerName" 
                           name="customerName" 
                           placeholder="Nhập họ tên đầy đủ" 
                           required
                           value="${user.fullName}">
                </div>

                <div class="form-group">
                    <label for="phone">
                        <i class="icon">📞</i> Số điện thoại <span class="required">*</span>
                    </label>
                    <input type="tel" 
                           id="phone" 
                           name="phone" 
                           placeholder="Nhập số điện thoại" 
                           pattern="[0-9]{10,11}"
                           required
                           value="${user.soDienThoai}">
                    <small>Vui lòng nhập 10-11 số</small>
                </div>

                <div class="form-group">
                    <label for="email">
                        <i class="icon">📧</i> Email
                    </label>
                    <input type="email" 
                           id="email" 
                           name="email" 
                           placeholder="Nhập email (tùy chọn)"
                           value="${user.email}">
                </div>

                <div class="form-group">
                    <label for="address">
                        <i class="icon">📍</i> Địa chỉ giao hàng <span class="required">*</span>
                    </label>
                    <textarea id="address" 
                              name="address" 
                              rows="3" 
                              placeholder="Nhập địa chỉ chi tiết (số nhà, đường, phường/xã, quận/huyện, tỉnh/thành phố)" 
                              required>${user.diaChi}</textarea>
                </div>

                <div class="form-group">
                    <label for="note">
                        <i class="icon">📝</i> Ghi chú đơn hàng
                    </label>
                    <textarea id="note" 
                              name="note" 
                              rows="2" 
                              placeholder="Ghi chú về đơn hàng (tùy chọn)"></textarea>
                </div>

                <div class="form-group">
                    <label for="paymentMethod">
                        <i class="icon">💳</i> Hình thức thanh toán <span class="required">*</span>
                    </label>
                    <select id="paymentMethod" name="paymentMethod" required>
                        <option value="COD">💵 Thanh toán khi nhận hàng (COD)</option>
                        <option value="Bank">🏦 Chuyển khoản ngân hàng</option>
                    </select>
                </div>

                <!-- PHẦN HIỂN THỊ KHI CHỌN CHUYỂN KHOẢN -->
<div id="bankTransferInfo" style="display:none; margin-top:20px; padding:20px; background:#f8f9fa; border-radius:10px; border:1px solid #e9ecef;">
    <h4 style="margin-top:0; color:#0066cc;">Thông tin chuyển khoản</h4>
    <div style="display:flex; gap:20px; flex-wrap:wrap; font-size:0.95em;">
        <div style="flex:1; min-width:200px;">
            <p><strong>Ngân hàng:</strong> Vietcombank</p>
            <p><strong>Số tài khoản:</strong> <span style="font-family:monospace; background:#eee; padding:2px 6px; border-radius:4px;">1234 5678 9012</span></p>
            <p><strong>Chủ tài khoản:</strong> NGUYỄN VĂN A</p>
        </div>
        <div style="flex:1; min-width:200px;">
            <p><strong>Nội dung chuyển khoản:</strong></p>
            <p style="font-family:monospace; background:#fff3cd; padding:8px; border-radius:6px; border:1px solid #ffeaa7; font-weight:bold;" id="maDonContent">
                DH20251116123456
            </p>
            <small style="color:#e74c3c;">Vui lòng ghi đúng nội dung để xác nhận nhanh</small>
        </div>
    </div>

    <div style="margin-top:20px;">
        <label style="display:block; margin-bottom:8px; font-weight:600;">
            Upload ảnh chuyển khoản <span class="required">*</span>
        </label>
        <input type="file" name="anhChuyenKhoan" id="anhChuyenKhoan" accept="image/*" 
               style="width:100%; padding:10px; border:2px dashed #ddd; border-radius:8px; background:#fff;">
        <small style="color:#666; display:block; margin-top:5px;">
            Định dạng: JPG, PNG | Tối đa 5MB
        </small>
    </div>
</div>
                <div class="order-total-box">
                    <div class="total-row">
                        <span>Tạm tính:</span>
                        <span><fmt:formatNumber value="${totalCart}" pattern="#,###"/> đ</span>
                    </div>
                    <div class="total-row">
                        <span>Phí vận chuyển:</span>
                        <span>Miễn phí</span>
                    </div>
                    <div class="total-row final">
                        <span>TỔNG THANH TOÁN:</span>
                        <span class="final-amount">
                            <fmt:formatNumber value="${totalCart}" pattern="#,###"/> đ
                        </span>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="button" class="btn-back" onclick="history.back()">
                        ← Quay lại
                    </button>
                    <button type="submit" class="btn-submit" id="submitBtn">
                        ✓ Xác nhận đặt hàng
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
                        
<!-- THÊM JS MỚI SAU </form> -->
<script>
document.getElementById('paymentMethod').addEventListener('change', function() {
    const bankInfo = document.getElementById('bankTransferInfo');
    const fileInput = document.getElementById('anhChuyenKhoan');
    if (this.value === 'Bank') {
        bankInfo.style.display = 'block';
        fileInput.setAttribute('required', 'required');
    } else {
        bankInfo.style.display = 'none';
        fileInput.removeAttribute('required');
    }
});

// Tự động sinh mã đơn tạm (để hiển thị nội dung chuyển khoản)
document.addEventListener('DOMContentLoaded', function() {
    const maDon = 'DH' + new Date().getTime();
    document.getElementById('maDonContent').textContent = maDon;
    // Trigger change để ẩn/hiện nếu mặc định là COD
    document.getElementById('paymentMethod').dispatchEvent(new Event('change'));
});

// Validate file
document.getElementById('anhChuyenKhoan').addEventListener('change', function() {
    const file = this.files[0];
    if (file) {
        if (file.size > 5 * 1024 * 1024) {
            alert('Ảnh tối đa 5MB!');
            this.value = '';
        }
        if (!['image/jpeg', 'image/png'].includes(file.type)) {
            alert('Chỉ chấp nhận JPG, PNG!');
            this.value = '';
        }
    }
});
</script>

<style>
/* CSS CỦA BẠN (GIỮ NGUYÊN) */
.checkout-container {
    max-width: 1200px;
    margin: 30px auto;
    padding: 20px;
}
.checkout-title {
    text-align: center;
    color: #333;
    margin-bottom: 30px;
    font-size: 2em;
    border-bottom: 3px solid #007bff;
    padding-bottom: 15px;
}
.alert {
    padding: 15px 20px;
    border-radius: 8px;
    margin-bottom: 20px;
    font-weight: 500;
}
.alert-success {
    background: #d4edda;
    color: #155724;
    border: 1px solid #c3e6cb;
}
.alert-error {
    background: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
}
.order-summary {
    background: white;
    padding: 25px;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    margin-bottom: 30px;
}
.order-summary h3 {
    margin-bottom: 20px;
    color: #333;
    font-size: 1.4em;
}
.checkout-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 20px;
}
.checkout-table thead {
    background: #f8f9fa;
}
.checkout-table th {
    padding: 15px;
    text-align: left;
    font-weight: bold;
    color: #333;
    border-bottom: 2px solid #dee2e6;
}
.checkout-table td {
    padding: 15px;
    border-bottom: 1px solid #eee;
    vertical-align: middle;
}
.product-thumb {
    width: 80px;
    height: 80px;
    object-fit: cover;
    border-radius: 8px;
    border: 1px solid #ddd;
}
.quantity-badge {
    background: #007bff;
    color: white;
    padding: 5px 15px;
    border-radius: 20px;
    font-weight: bold;
}
.price-col {
    text-align: right;
    color: #e60000;
    font-weight: 500;
}
.total-row {
    background: #f8f9fa;
    font-size: 1.2em;
}
.final-total {
    color: #e60000;
    font-size: 1.5em;
    font-weight: bold;
    text-align: right;
}
.customer-info {
    background: white;
    padding: 25px;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}
.customer-info h3 {
    margin-bottom: 25px;
    color: #333;
    font-size: 1.4em;
}
.form-group {
    margin-bottom: 20px;
}
.form-group label {
    display: block;
    margin-bottom: 8px;
    font-weight: 600;
    color: #333;
    font-size: 1em;
}
.form-group label .icon {
    margin-right: 5px;
}
.required {
    color: #e60000;
}
.form-group input[type="text"],
.form-group input[type="tel"],
.form-group input[type="email"],
.form-group textarea,
.form-group select {
    width: 100%;
    padding: 12px 15px;
    border: 2px solid #ddd;
    border-radius: 8px;
    font-size: 1em;
    transition: all 0.3s;
}
.form-group input:focus,
.form-group textarea:focus,
.form-group select:focus {
    outline: none;
    border-color: #007bff;
    box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
}
.form-group small {
    display: block;
    margin-top: 5px;
    color: #666;
    font-size: 0.9em;
}
.order-total-box {
    background: #f8f9fa;
    padding: 20px;
    border-radius: 8px;
    margin: 25px 0;
}
.order-total-box .total-row {
    display: flex;
    justify-content: space-between;
    padding: 10px 0;
    font-size: 1em;
}
.order-total-box .total-row.final {
    border-top: 2px solid #dee2e6;
    margin-top: 10px;
    padding-top: 15px;
    font-size: 1.3em;
    font-weight: bold;
}
.final-amount {
    color: #e60000;
    font-size: 1.4em;
}
.form-actions {
    display: flex;
    gap: 15px;
    margin-top: 30px;
}
.btn-back,
.btn-submit {
    flex: 1;
    padding: 15px 30px;
    border: none;
    border-radius: 8px;
    font-size: 1.1em;
    font-weight: bold;
    cursor: pointer;
    transition: all 0.3s;
}
.btn-back {
    background: #6c757d;
    color: white;
}
.btn-back:hover {
    background: #5a6268;
    transform: translateY(-2px);
}
.btn-submit {
    background: linear-gradient(135deg, #28a745, #20c997);
    color: white;
}
.btn-submit:hover {
    background: linear-gradient(135deg, #20c997, #28a745);
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
}
@media (max-width: 768px) {
    .checkout-table {
        font-size: 0.9em;
    }
    .product-thumb {
        width: 60px;
        height: 60px;
    }
    .form-actions {
        flex-direction: column;
    }
    .checkout-title {
        font-size: 1.5em;
    }
}
</style>

<script>
document.getElementById('checkoutForm').addEventListener('submit', function(e) {
    const submitBtn = document.getElementById('submitBtn');
    
    // Disable button để tránh submit nhiều lần
    submitBtn.disabled = true;
    submitBtn.textContent = '⏳ Đang xử lý...';
    submitBtn.style.opacity = '0.6';
});

// Validation số điện thoại
document.getElementById('phone').addEventListener('input', function(e) {
    this.value = this.value.replace(/[^0-9]/g, '');
});
</script>

<%@ include file="footer.jsp" %>