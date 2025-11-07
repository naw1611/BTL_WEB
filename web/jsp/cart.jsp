<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="header.jsp" %>

<h2>Giỏ Hàng Của Bạn</h2>

<c:if test="${empty cartItems}">
    <div style="text-align:center; padding:50px; color:#888;">
        <p style="font-size:1.2em;">🛒 Giỏ hàng của bạn đang trống!</p>
        <a href="products" class="btn-continue-shopping">Tiếp tục mua sắm</a>
    </div>
</c:if>

<c:if test="${not empty cartItems}">
    <form id="cart-form" action="checkout" method="post">
        <div class="cart-container">
            <div class="cart-header">
                <div class="cart-checkbox">
                    <input type="checkbox" id="select-all" onchange="toggleSelectAll(this)">
                    <label for="select-all">Chọn tất cả</label>
                </div>
                <div class="cart-product">Sản phẩm</div>
                <div class="cart-price">Đơn giá</div>
                <div class="cart-quantity">Số lượng</div>
                <div class="cart-total">Thành tiền</div>
                <div class="cart-action">Thao tác</div>
            </div>

            <c:forEach var="item" items="${cartItems}">
                <div class="cart-item" data-masp="${item.product.maSP}">
                    <div class="cart-checkbox">
                        <input type="checkbox" 
                               name="selectedProducts" 
                               value="${item.product.maSP}" 
                               class="product-checkbox"
                               onchange="calculateTotal()">
                    </div>

                    <div class="cart-product">
                        <img src="<%= request.getContextPath() %>/images/${item.product.hinhAnh}" 
                             alt="${item.product.tenSP}"
                             onerror="this.src='<%= request.getContextPath() %>/images/no-image.jpg'">
                        <div class="product-info">
                            <h4>${item.product.tenSP}</h4>
                            <p>Mã: ${item.product.codeSP}</p>
                             <small style="color: #666;">Tồn kho: ${item.product.soLuong}</small>
                        </div>
                    </div>

                    <div class="cart-price">
    <c:choose>
        <c:when test="${item.product.phanTramGiam > 0}">
            <div style="text-decoration: line-through; color:#999; font-size:0.9em;">
                <fmt:formatNumber value="${item.product.gia}" pattern="#,###"/> đ
            </div>
            <div style="color:#e74c3c; font-weight:bold;">
                <fmt:formatNumber value="${item.product.giaKhuyenMai}" pattern="#,###"/> đ
            </div>
            <div style="font-size:0.8em; color:#e74c3c;">Giảm ${item.product.phanTramGiam}%</div>
        </c:when>
        <c:otherwise>
            <fmt:formatNumber value="${item.product.gia}" pattern="#,###"/> đ
        </c:otherwise>
    </c:choose>
</div>


                    <div class="cart-quantity">
                        <button type="button" class="qty-btn" onclick="updateQuantity(${item.product.maSP}, -1, ${item.product.soLuong})">-</button>
                        <input type="number" 
                               id="qty-${item.product.maSP}" 
                               value="${item.soLuong}" 
                               min="1" 
                               readonly
                               data-price="${(item.product.phanTramGiam > 0 ? item.product.giaKhuyenMai : item.product.gia)}"
                               data-stock="${item.product.soLuong}">
                        <button type="button" class="qty-btn" onclick="updateQuantity(${item.product.maSP}, 1, ${item.product.soLuong})">+</button>
                    </div>

                    <div class="cart-total">
    <strong class="item-total" id="total-${item.product.maSP}">
        <fmt:formatNumber 
            value="${(item.product.phanTramGiam > 0 ? item.product.giaKhuyenMai : item.product.gia) * item.soLuong}" 
            pattern="#,###"/> đ
    </strong>
</div>


                    <div class="cart-action">
                        <button type="button" class="btn-delete" onclick="removeFromCart(${item.product.maSP})">
                            🗑️ Xóa
                        </button>
                    </div>
                </div>
            </c:forEach>
        </div>

        <div class="cart-summary">
            <div class="summary-row">
                <span>Sản phẩm đã chọn:</span>
                <strong id="selected-count">0</strong>
            </div>
            <div class="summary-row">
                <span>Tổng tiền tạm tính:</span>
                <strong id="total-amount" style="color:#e60000; font-size:1.5em;">0 đ</strong>
            </div>
            <div class="summary-actions">
                <button type="button" class="btn-delete-selected" onclick="deleteSelected()">
                    🗑️ Xóa sản phẩm đã chọn
                </button>
                <button type="submit" class="btn-checkout" id="btn-checkout" disabled>
                    💳 Thanh toán (<span id="checkout-count">0</span>)
                </button>
            </div>
        </div>
    </form>
</c:if>

<div id="toast-notification"></div>

<div id="loading-overlay" class="loading-overlay">
    <div class="loading-spinner"></div>
</div>

<script>
var contextPath = '<%= request.getContextPath() %>';

// Chọn tất cả
function toggleSelectAll(checkbox) {
    var checkboxes = document.querySelectorAll('.product-checkbox');
    checkboxes.forEach(function(cb) {
        cb.checked = checkbox.checked;
    });
    calculateTotal();
}

// Tính tổng tiền
function calculateTotal() {
    var checkboxes = document.querySelectorAll('.product-checkbox:checked');
    var total = 0;
    var count = 0;

    checkboxes.forEach(function(cb) {
        var maSP = cb.value;
        var qtyInput = document.getElementById('qty-' + maSP);
        var price = parseFloat(qtyInput.getAttribute('data-price'));
        var quantity = parseInt(qtyInput.value);
        
        total += price * quantity;
        count++;
    });

    document.getElementById('selected-count').textContent = count + ' sản phẩm';
    document.getElementById('total-amount').textContent = formatNumber(total) + ' đ';
    document.getElementById('checkout-count').textContent = count;
    
    var btnCheckout = document.getElementById('btn-checkout');
    if (count > 0) {
        btnCheckout.disabled = false;
        btnCheckout.style.opacity = '1';
        btnCheckout.style.cursor = 'pointer';
    } else {
        btnCheckout.disabled = true;
        btnCheckout.style.opacity = '0.5';
        btnCheckout.style.cursor = 'not-allowed';
    }
}

// Cập nhật số lượng
// ✅ [SỬA LỖI] Đã sửa hàm này
function updateQuantity(maSP, change, stock) {
    var qtyInput = document.getElementById('qty-' + maSP);
    var currentQty = parseInt(qtyInput.value);
    var newQty = currentQty + change;
    
    if (newQty < 1) {
        showToast('Số lượng tối thiểu là 1!', 'error');
        return;
    }

    // Kiểm tra tồn kho phía Client (để phản hồi nhanh)
    if (newQty > stock) {
        showToast('Số lượng vượt quá tồn kho (chỉ còn ' + stock + ')!', 'error');
        return;
    }
    
    showLoading(true);
    
    var xhr = new XMLHttpRequest();
    // ✅ [SỬA LỖI 1] URL phải là /cart
    xhr.open('POST', contextPath + '/cart', true); 
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    
    xhr.onload = function() {
        showLoading(false);
        
        if (xhr.status === 200) {
            try {
                var data = JSON.parse(xhr.responseText);
                
                if (data.success) {
                    qtyInput.value = newQty;
                    
                    var price = parseFloat(qtyInput.getAttribute('data-price'));
                    var itemTotal = price * newQty;
                    document.getElementById('total-' + maSP).textContent = formatNumber(itemTotal) + ' đ';
                    
                    calculateTotal();
                    // showToast('Đã cập nhật số lượng!', 'success');
                } else {
                    showToast(data.message, 'error');
                }
            } catch (e) {
                console.error('Parse error:', e);
                showToast('Lỗi xử lý dữ liệu!', 'error');
            }
        } else {
            showToast('Lỗi kết nối server!', 'error');
        }
    };
    
    xhr.onerror = function() {
        showLoading(false);
        showToast('Không thể kết nối đến server!', 'error');
    };
    
    // ✅ [SỬA LỖI 2] Thêm "action=update"
    var params = 'action=update&maSP=' + maSP + '&quantity=' + newQty;
    xhr.send(params);
}

// Xóa sản phẩm
function removeFromCart(maSP) {
    if (!confirm('Bạn có chắc muốn xóa sản phẩm này?')) {
        return;
    }
    
    showLoading(true);
    
    var xhr = new XMLHttpRequest();
    xhr.open('POST', contextPath + '/cart', true); 
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    
    xhr.onload = function() {
        showLoading(false);
        
        if (xhr.status === 200) {
            try {
                var data = JSON.parse(xhr.responseText);
                
                if (data.success) {
                    showToast('Đã xóa sản phẩm!', 'success');
                    
                    var item = document.querySelector('.cart-item[data-masp="' + maSP + '"]');
                    if (item) {
                        item.remove();
                    }
                    
                    if (data.cartCount !== undefined) {
                        updateCartCount(data.cartCount);
                    }
                    
                    calculateTotal();
                    
                    var remaining = document.querySelectorAll('.cart-item').length;
                    if (remaining === 0) {
                        setTimeout(function() {
                            location.reload();
                        }, 1000);
                    }
                } else {
                    showToast(data.message, 'error');
                }
            } catch (e) {
                console.error('Parse error:', e);
                showToast('Lỗi xử lý dữ liệu!', 'error');
            }
        } else {
            showToast('Lỗi kết nối server!', 'error');
        }
    };
    
    xhr.onerror = function() {
        showLoading(false);
        showToast('Không thể kết nối đến server!', 'error');
    };
    
    xhr.send('action=remove&maSP=' + maSP);
}
// Xóa các SP đã chọn
function deleteSelected() {
    var checkboxes = document.querySelectorAll('.product-checkbox:checked');
    
    if (checkboxes.length === 0) {
        showToast('Vui lòng chọn sản phẩm cần xóa!', 'error');
        return;
    }
    
    if (!confirm('Bạn có chắc muốn xóa ' + checkboxes.length + ' sản phẩm đã chọn?')) {
        return;
    }
    
    var maSPs = [];
    checkboxes.forEach(function(cb) {
        maSPs.push(cb.value);
    });
    
    showLoading(true);
    
    var xhr = new XMLHttpRequest();
    xhr.open('POST', contextPath + '/cart', true); 
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    
    xhr.onload = function() {
        showLoading(false);
        
        if (xhr.status === 200) {
            try {
                var data = JSON.parse(xhr.responseText);
                
                if (data.success) {
                    showToast('Đã xóa ' + maSPs.length + ' sản phẩm!', 'success');
                    
                    setTimeout(function() {
                        location.reload();
                    }, 1000);
                } else {
                    showToast(data.message, 'error');
                }
            } catch (e) {
                console.error('Parse error:', e);
                showToast('Lỗi xử lý dữ liệu!', 'error');
            }
        } else {
            showToast('Lỗi kết nối server!', 'error');
        }
    };
    
    xhr.onerror = function() {
        showLoading(false);
        showToast('Không thể kết nối đến server!', 'error');
    };
    
    xhr.send('action=remove-multiple&maSPs=' + maSPs.join(','));
}

// Format số tiền
function formatNumber(num) {
    return Math.round(num).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

// Hiển thị toast
function showToast(message, type) {
    var toast = document.getElementById('toast-notification');
    toast.textContent = message;
    toast.className = 'toast-notification show ' + type;
    
    setTimeout(function() {
        toast.className = 'toast-notification';
    }, 3000);
}

// Cập nhật cart count
function updateCartCount(count) {
    var badge = document.getElementById('cart-count');
    if (badge) {
        badge.textContent = count;
        badge.style.display = count > 0 ? 'inline-block' : 'none';
    }
}

// Hiển thị loading
function showLoading(show) {
    var overlay = document.getElementById('loading-overlay');
    if (overlay) {
        overlay.style.display = show ? 'flex' : 'none';
    }
}

// Khi trang load
document.addEventListener('DOMContentLoaded', function() {
    calculateTotal();
    
    var form = document.getElementById('cart-form');
    if (form) {
        form.addEventListener('submit', function(e) {
            var checkboxes = document.querySelectorAll('.product-checkbox:checked');
            
            if (checkboxes.length === 0) {
                e.preventDefault();
                showToast('Vui lòng chọn sản phẩm cần thanh toán!', 'error');
                return false;
            }
            
            return true;
        });
    }
});
</script>

<style>
/* CSS CỦA BẠN (GIỮ NGUYÊN) */
.cart-container {
    background: white;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    margin-bottom: 20px;
}
.cart-header {
    display: grid;
    grid-template-columns: 50px 2fr 1fr 1.5fr 1fr 100px;
    gap: 15px;
    padding: 15px 20px;
    background: #f8f9fa;
    border-bottom: 2px solid #dee2e6;
    font-weight: bold;
    align-items: center;
}
.cart-item {
    display: grid;
    grid-template-columns: 50px 2fr 1fr 1.5fr 1fr 100px;
    gap: 15px;
    padding: 20px;
    border-bottom: 1px solid #eee;
    align-items: center;
    transition: background 0.2s;
}
.cart-item:hover {
    background: #f8f9fa;
}
.cart-checkbox {
    text-align: center;
}
.cart-checkbox input[type="checkbox"] {
    width: 18px;
    height: 18px;
    cursor: pointer;
}
.cart-product {
    display: flex;
    gap: 15px;
    align-items: center;
}
.cart-product img {
    width: 80px;
    height: 80px;
    object-fit: cover;
    border-radius: 5px;
    border: 1px solid #ddd;
}
.product-info h4 {
    margin: 0 0 5px 0;
    font-size: 1em;
    color: #333;
}
.product-info p {
    margin: 0;
    color: #888;
    font-size: 0.9em;
}
.cart-price,
.cart-total {
    text-align: center;
    font-size: 1.1em;
}
.cart-quantity {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 5px;
}
.qty-btn {
    width: 30px;
    height: 30px;
    border: 1px solid #ddd;
    background: white;
    cursor: pointer;
    border-radius: 3px;
    font-size: 1.2em;
    transition: all 0.2s;
}
.qty-btn:hover {
    background: #e9ecef;
    border-color: #adb5bd;
}
.cart-quantity input {
    width: 50px;
    height: 30px;
    text-align: center;
    border: 1px solid #ddd;
    border-radius: 3px;
    font-size: 1em;
}
.cart-action {
    text-align: center;
}
.btn-delete {
    padding: 8px 15px;
    background: #dc3545;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-size: 0.9em;
    transition: all 0.2s;
}
.btn-delete:hover {
    background: #c82333;
    transform: translateY(-2px);
}
.cart-summary {
    background: white;
    border-radius: 8px;
    padding: 20px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    max-width: 400px;
    margin-left: auto;
}
.summary-row {
    display: flex;
    justify-content: space-between;
    padding: 10px 0;
    border-bottom: 1px solid #eee;
}
.summary-row:last-of-type {
    border-bottom: 2px solid #dee2e6;
    padding-bottom: 15px;
    margin-bottom: 15px;
}
.summary-actions {
    display: flex;
    gap: 10px;
    margin-top: 15px;
}
.btn-delete-selected {
    flex: 1;
    padding: 12px;
    background: #6c757d;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-weight: bold;
    transition: all 0.3s;
}
.btn-delete-selected:hover {
    background: #5a6268;
    transform: translateY(-2px);
}
.btn-checkout {
    flex: 2;
    padding: 12px;
    background: linear-gradient(135deg, #ff6b6b, #ee5a6f);
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-weight: bold;
    font-size: 1.1em;
    transition: all 0.3s;
}
.btn-checkout:not(:disabled):hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(255, 107, 107, 0.4);
}
.btn-checkout:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}
.btn-continue-shopping {
    display: inline-block;
    margin-top: 20px;
    padding: 12px 30px;
    background: #007bff;
    color: white;
    text-decoration: none;
    border-radius: 5px;
    font-weight: bold;
    transition: all 0.3s;
}
.btn-continue-shopping:hover {
    background: #0056b3;
    transform: translateY(-2px);
}
.loading-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.6);
    display: none;
    justify-content: center;
    align-items: center;
    z-index: 9999;
}
.loading-spinner {
    width: 50px;
    height: 50px;
    border: 5px solid #f3f3f3;
    border-top: 5px solid #3498db;
    border-radius: 50%;
    animation: spin 1s linear infinite;
}
@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}
@media (max-width: 768px) {
    .cart-header,
    .cart-item {
        grid-template-columns: 1fr;
        text-align: center;
    }
    .cart-product {
        flex-direction: column;
    }
    .cart-summary {
        max-width: 100%;
    }
    .summary-actions {
        flex-direction: column;
    }
}

</style>

<%@ include file="footer.jsp" %>