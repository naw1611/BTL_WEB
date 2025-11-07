<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="header.jsp" %>

<h2>Chi Tiết Sản Phẩm</h2>

<c:if test="${not empty product}">
    <!-- CONTAINER CHÍNH - POSITION RELATIVE ĐỂ ĐẶT NHÃN % -->
    <div class="product-detail-container" style="position:relative;">

        <!-- NHÃN % GIẢM GIÁ (GÓC TRÊN BÊN PHẢI) -->
        <c:if test="${product.phanTramGiam > 0}">
            <div style="position:absolute; top:20px; right:20px; background:#e74c3c; color:white; padding:8px 16px; border-radius:30px; font-weight:bold; font-size:1.1em; box-shadow:0 3px 8px rgba(0,0,0,0.2); z-index:10;">
                Giảm ${product.phanTramGiam}%
            </div>
        </c:if>

        <!-- HÌNH ẢNH -->
        <div class="product-image">
            <img src="${pageContext.request.contextPath}/images/${product.hinhAnh}"
                 alt="${product.tenSP}"
                 onerror="this.src='${pageContext.request.contextPath}/images/no-image.jpg'"
                 style="width:100%; height:100%; object-fit:contain; border-radius:12px; border:1px solid #eee;">
        </div>

        <!-- THÔNG TIN -->
        <div class="product-info">
            <h3 class="product-name">${product.tenSP} (${product.codeSP})</h3>

            <!-- GIÁ KHUYẾN MÃI 2 DÒNG -->
            <p class="product-price">
                <strong>Giá:</strong>
                <c:choose>
                    <c:when test="${product.phanTramGiam > 0}">
                        <div style="margin:15px 0; text-align:left;">
                            <div style="color:#999; font-size:1.2em; text-decoration:line-through; margin-bottom:6px;">
                                <fmt:formatNumber value="${product.gia}" pattern="#,###"/> VNĐ
                            </div>
                            <div style="color:#e74c3c; font-weight:bold; font-size:2em;">
                                <fmt:formatNumber value="${product.giaKhuyenMai}" pattern="#,###"/> VNĐ
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <span style="color:#e60000; font-weight:bold; font-size:2em;">
                            <fmt:formatNumber value="${product.gia}" pattern="#,###"/> VNĐ
                        </span>
                    </c:otherwise>
                </c:choose>
            </p>

            <p class="product-desc"><strong>Mô tả:</strong> ${product.moTa}</p>

            <!-- NÚT HÀNH ĐỘNG -->
            <c:if test="${not empty sessionScope.user}">
                <div class="product-actions" style="display:flex; gap:15px; align-items:center; margin-top:25px;">
                    <!-- SỐ LƯỢNG -->
                    <div style="display:flex; align-items:center; gap:10px;">
                        <label for="quantity" style="margin:0; font-weight:500; white-space:nowrap; font-size:1em;">Số lượng:</label>
                        <input type="number" id="quantity" name="quantity" value="1" min="1" max="99" required
                               style="width:70px; padding:8px; border:1px solid #ddd; border-radius:6px; text-align:center; font-size:1em;">
                    </div>
                    <!-- NÚT MUA NGAY -->
                    <button class="btn-buy-now" onclick="buyNow(${product.maSP})"
                            style="flex:1; padding:14px; background:#28a745; color:white; border:none; border-radius:8px; font-weight:bold; font-size:1.1em; cursor:pointer; transition:all 0.3s;">
                        Mua Ngay
                    </button>
                    <!-- NÚT THÊM VÀO GIỎ -->
                    <button class="btn-add-to-cart" onclick="addToCart(${product.maSP}, getQuantity())"
                            style="flex:1; padding:14px; background:#0066cc; color:white; border:none; border-radius:8px; font-weight:bold; font-size:1.1em; cursor:pointer; transition:all 0.3s;">
                        Thêm vào giỏ
                    </button>
                </div>
            </c:if>

            <c:if test="${empty sessionScope.user}">
                <a href="login" class="btn-login-required"
                   style="display:block; text-align:center; padding:14px; background:#6c757d; color:white; border-radius:8px; text-decoration:none; margin-top:25px; font-weight:bold; font-size:1.1em;">
                    Đăng nhập để mua
                </a>
            </c:if>
        </div>
    </div>
</c:if>

<!-- KHÔNG TÌM THẤY SẢN PHẨM -->
<c:if test="${empty product}">
    <p class="error-msg">Sản phẩm không tồn tại!</p>
</c:if>

<!-- TOAST & LOADING -->
<div id="toast-notification" class="toast-notification"></div>
<div id="loading-overlay" class="loading-overlay">
    <div class="spinner"></div>
</div>

<script>
var contextPath = '<%= request.getContextPath() %>';

// LẤY SỐ LƯỢNG ĐÚNG (1-99)
function getQuantity() {
    const qty = document.getElementById('quantity');
    let val = parseInt(qty.value, 10);
    if (isNaN(val) || val < 1) {
        qty.value = 1;
        return 1;
    }
    return val > 99 ? 99 : val;
}

// THÊM VÀO GIỎ
function addToCart(maSP, quantity) {
    showLoading(true);
    const xhr = new XMLHttpRequest();
    xhr.open('POST', contextPath + '/cart', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onload = function () {
        showLoading(false);
        if (xhr.status === 200) {
            const response = JSON.parse(xhr.responseText);
            if (response.success) {
                showToast(response.message, 'success');
                updateCartCount(response.cartCount);
            } else {
                if (response.needLogin) {
                    window.location.href = contextPath + '/login';
                } else {
                    showToast(response鼎.message || 'Lỗi!', 'error');
                }
            }
        }
    };
    xhr.onerror = function () {
        showLoading(false);
        showToast("Lỗi kết nối server!", "error");
    };
    xhr.send("action=add&maSP=" + maSP + "&quantity=" + quantity);
}

// MUA NGAY
function buyNow(maSP) {
    window.location.href = contextPath + '/checkout?buyNow=true&maSP=' + maSP + '&quantity=1';
}

// TOAST
function showToast(message, type) {
    const toast = document.getElementById("toast-notification");
    toast.textContent = message;
    toast.className = "toast-notification show " + type;
    setTimeout(() => toast.className = "toast-notification", 3000);
}

// LOADING
function showLoading(show) {
    document.getElementById("loading-overlay").style.display = show ? "flex" : "none";
}

// CẬP NHẬT GIỎ HÀNG
function updateCartCount(count) {
    const badge = document.getElementById("cart-count");
    if (badge) {
        badge.textContent = count;
        badge.style.display = count > 0 ? "inline-block" : "none";
    }
}
</script>

<style>
/* CONTAINER */
.product-detail-container {
    display: flex;
    gap: 30px;
    margin: 20px 0;
    background: #fff;
    padding: 30px;
    border-radius: 16px;
    box-shadow: 0 6px 20px rgba(0,0,0,0.1);
    position: relative;
}

/* HÌNH ẢNH */
.product-image {
    flex: 0 0 380px;
    height: 380px;
    background: #f9f9f9;
    border-radius: 12px;
    overflow: hidden;
    border: 1px solid #eee;
}

/* THÔNG TIN */
.product-info {
    flex: 1;
    display: flex;
    flex-direction: column;
}
.product-name {
    font-size: 1.9em;
    margin: 0 0 12px;
    color: #333;
    font-weight: 600;
}
.product-price {
    margin: 18px 0;
    font-size: 1.1em;
}
.product-desc {
    line-height: 1.7;
    color: #555;
    margin: 18px 0;
    font-size: 1.05em;
}

/* NÚT */
.btn-buy-now, .btn-add-to-cart {
    transition: all 0.3s ease;
}
.btn-buy-now:hover {
    background: #218838 !important;
    transform: translateY(-2px);
}
.btn-add-to-cart:hover {
    background: #004d99 !important;
    transform: translateY(-2px);
}

/* ERROR */
.error-msg {
    text-align: center;
    color: #dc3545;
    font-size: 1.3em;
    padding: 40px;
    background: #fff;
    border-radius: 12px;
    margin: 20px 0;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

/* TOAST */
.toast-notification {
    position: fixed;
    bottom: 20px;
    right: 20px;
    padding: 15px 25px;
    color: white;
    border-radius: 8px;
    font-weight: bold;
    opacity: 0;
    transform: translateY(20px);
    transition: all 0.3s ease;
    z-index: 10000;
    box-shadow: 0 4px 12px rgba(0,0,0,0.2);
    min-width: 200px;
    text-align: center;
}
.toast-notification.show {
    opacity: 1;
    transform: translateY(0);
}
.toast-notification.success { background: linear-gradient(135deg, #28a745, #20c997); }
.toast-notification.error { background: linear-gradient(135deg, #dc3545, #e83e8c); }

/* LOADING */
.loading-overlay {
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background: rgba(0,0,0,0.6);
    display: none;
    justify-content: center;
    align-items: center;
    z-index: 9999;
}
.spinner {
    width: 50px;
    height: 50px;
    border: 5px solid #f3f3f3;
    border-top: 5px solid #0066cc;
    border-radius: 50%;
    animation: spin 1s linear infinite;
}
@keyframes spin {
    to { transform: rotate(360deg); }
}
</style>

<%@ include file="footer.jsp" %>