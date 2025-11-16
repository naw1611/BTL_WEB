<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="header.jsp" %>

<div class="page-container">
    <h2 class="page-title">📦 Chi Tiết Sản Phẩm</h2>

    <!-- THÔNG BÁO -->
    <c:if test="${not empty sessionScope.reviewSuccess}">
        <div class="alert alert-success">
            <span class="alert-icon">✅</span>
            ${sessionScope.reviewSuccess}
        </div>
        <% session.removeAttribute("reviewSuccess"); %>
    </c:if>
    <c:if test="${not empty sessionScope.reviewError}">
        <div class="alert alert-error">
            <span class="alert-icon">❌</span>
            ${sessionScope.reviewError}
        </div>
        <% session.removeAttribute("reviewError"); %>
    </c:if>

    <c:if test="${not empty product}">
        <!-- THÔNG TIN SẢN PHẨM -->
        <div class="product-detail-card">
            <!-- NHÃN GIẢM GIÁ -->
            <c:if test="${product.phanTramGiam > 0}">
                <div class="discount-badge">
                    <span class="discount-percent">-${product.phanTramGiam}%</span>
                </div>
            </c:if>

            <div class="product-detail-grid">
                <!-- HÌNH ẢNH -->
                <div class="product-image-container">
                    <img src="${pageContext.request.contextPath}/images/${product.hinhAnh}"
                         alt="${product.tenSP}"
                         onerror="this.src='${pageContext.request.contextPath}/images/no-image.jpg'"
                         class="product-image">
                </div>

                <!-- THÔNG TIN -->
                <div class="product-info-container">
                    <h3 class="product-title">${product.tenSP}</h3>
                    <p class="product-code">Mã SP: ${product.codeSP}</p>

                    <!-- ĐÁNH GIÁ TRUNG BÌNH -->
                    <div class="product-rating-summary">
                        <div class="stars-display">
                            <c:forEach begin="1" end="5" var="i">
                                <c:choose>
                                    <c:when test="${i <= avgRating}">
                                        <span class="star filled">★</span>
                                    </c:when>
                                    <c:when test="${i - avgRating < 1 && i - avgRating > 0}">
                                        <span class="star half">★</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="star empty">★</span>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>
                        <span class="rating-number">
                            <fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/> / 5.0
                        </span>
                        <span class="rating-count">(${totalReviews} đánh giá)</span>
                    </div>

                    <!-- GIÁ -->
                    <div class="product-price-section">
                        <c:choose>
                            <c:when test="${product.phanTramGiam > 0}">
                                <div class="price-original">
                                    <fmt:formatNumber value="${product.gia}" pattern="#,###"/> ₫
                                </div>
                                <div class="price-sale">
                                    <fmt:formatNumber value="${product.giaKhuyenMai}" pattern="#,###"/> ₫
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="price-normal">
                                    <fmt:formatNumber value="${product.gia}" pattern="#,###"/> ₫
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- MÔ TẢ -->
                    <div class="product-description">
                        <h4 class="section-subtitle">📝 Mô tả sản phẩm</h4>
                        <p>${product.moTa}</p>
                    </div>

                    <!-- NÚT HÀNH ĐỘNG -->
                    <c:if test="${not empty sessionScope.user}">
                        <div class="product-actions">
                            <div class="quantity-selector">
                                <label for="quantity">Số lượng:</label>
                                <input type="number" id="quantity" value="1" min="1" max="99">
                            </div>
                            <button class="btn btn-success" onclick="buyNow(${product.maSP})">
                                <span class="btn-icon">🛒</span> Mua Ngay
                            </button>
                            <button class="btn btn-primary" onclick="addToCart(${product.maSP}, getQuantity())">
                                <span class="btn-icon">🛍️</span> Thêm vào giỏ
                            </button>
                        </div>
                    </c:if>

                    <c:if test="${empty sessionScope.user}">
                        <a href="login" class="btn btn-secondary btn-block">
                            <span class="btn-icon">🔐</span> Đăng nhập để mua hàng
                        </a>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- ===================================== -->
        <!-- PHẦN ĐÁNH GIÁ -->
        <!-- ===================================== -->
        <div class="review-section-card">
            <h3 class="section-title">
                <span class="section-icon">⭐</span> Đánh giá sản phẩm
            </h3>

            <!-- THỐNG KÊ ĐÁNH GIÁ -->
            <div class="rating-statistics">
                <div class="rating-overview">
                    <div class="rating-score">${avgRating > 0 ? String.format("%.1f", avgRating) : "0.0"}</div>
                    <div class="stars-large">
                        <c:forEach begin="1" end="5" var="i">
                            <span class="star ${i <= avgRating ? 'filled' : 'empty'}">★</span>
                        </c:forEach>
                    </div>
                    <div class="rating-text">${totalReviews} đánh giá</div>
                </div>

                <div class="rating-breakdown">
    <!-- 5 SAO -->
    <div class="rating-bar-item">
        <span class="star-label">5 <span class="star-icon">★</span></span>
        <div class="rating-bar">
            <c:set var="percent5" value="${totalReviews > 0 ? (starCounts[5] * 100.0 / totalReviews) : 0}"/>
            <div class="rating-bar-fill" style="width: ${percent5}%"></div>
        </div>
        <span class="rating-count">${starCounts[5]}</span>
    </div>
    
    <!-- 4 SAO -->
    <div class="rating-bar-item">
        <span class="star-label">4 <span class="star-icon">★</span></span>
        <div class="rating-bar">
            <c:set var="percent4" value="${totalReviews > 0 ? (starCounts[4] * 100.0 / totalReviews) : 0}"/>
            <div class="rating-bar-fill" style="width: ${percent4}%"></div>
        </div>
        <span class="rating-count">${starCounts[4]}</span>
    </div>
    
    <!-- 3 SAO -->
    <div class="rating-bar-item">
        <span class="star-label">3 <span class="star-icon">★</span></span>
        <div class="rating-bar">
            <c:set var="percent3" value="${totalReviews > 0 ? (starCounts[3] * 100.0 / totalReviews) : 0}"/>
            <div class="rating-bar-fill" style="width: ${percent3}%"></div>
        </div>
        <span class="rating-count">${starCounts[3]}</span>
    </div>
    
    <!-- 2 SAO -->
    <div class="rating-bar-item">
        <span class="star-label">2 <span class="star-icon">★</span></span>
        <div class="rating-bar">
            <c:set var="percent2" value="${totalReviews > 0 ? (starCounts[2] * 100.0 / totalReviews) : 0}"/>
            <div class="rating-bar-fill" style="width: ${percent2}%"></div>
        </div>
        <span class="rating-count">${starCounts[2]}</span>
    </div>
    
    <!-- 1 SAO -->
    <div class="rating-bar-item">
        <span class="star-label">1 <span class="star-icon">★</span></span>
        <div class="rating-bar">
            <c:set var="percent1" value="${totalReviews > 0 ? (starCounts[1] * 100.0 / totalReviews) : 0}"/>
            <div class="rating-bar-fill" style="width: ${percent1}%"></div>
        </div>
        <span class="rating-count">${starCounts[1]}</span>
    </div>
</div>
            </div>

            <!-- FORM VIẾT ĐÁNH GIÁ -->
            <c:if test="${not empty sessionScope.user}">
                <div class="review-form-card">
                    <h4 class="form-title">✍️ Viết đánh giá của bạn</h4>
                    <form action="review" method="post" onsubmit="return validateReview()">
                        <input type="hidden" name="maSP" value="${product.maSP}">
                        
                        <!-- CHỌN SAO -->
                        <div class="form-group">
                            <label class="form-label">Đánh giá của bạn <span class="required">*</span></label>
                            <div class="star-rating-input">
                                <input type="radio" name="soSao" value="5" id="star5" required>
                                <label for="star5" title="Rất tốt">★</label>
                                <input type="radio" name="soSao" value="4" id="star4">
                                <label for="star4" title="Tốt">★</label>
                                <input type="radio" name="soSao" value="3" id="star3">
                                <label for="star3" title="Bình thường">★</label>
                                <input type="radio" name="soSao" value="2" id="star2">
                                <label for="star2" title="Tệ">★</label>
                                <input type="radio" name="soSao" value="1" id="star1">
                                <label for="star1" title="Rất tệ">★</label>
                            </div>
                        </div>

                        <!-- NỘI DUNG -->
                        <div class="form-group">
                            <label for="noiDung" class="form-label">
                                Nội dung đánh giá <span class="required">*</span>
                            </label>
                            <textarea id="noiDung" name="noiDung" rows="5" 
                                      placeholder="Chia sẻ trải nghiệm của bạn về sản phẩm này... (tối thiểu 10 ký tự)"
                                      maxlength="500" required></textarea>
                            <div class="char-counter">
                                <span id="charCount">0</span> / 500 ký tự
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary btn-submit">
                            <span class="btn-icon">📤</span> Gửi đánh giá
                        </button>
                    </form>
                </div>
            </c:if>

            <c:if test="${empty sessionScope.user}">
                <div class="login-prompt">
                    <p>Bạn cần <a href="login" class="link-primary">đăng nhập</a> để viết đánh giá</p>
                </div>
            </c:if>

            <!-- DANH SÁCH ĐÁNH GIÁ -->
            <div class="reviews-list">
                <h4 class="reviews-list-title">
                    💬 Đánh giá từ khách hàng (${totalReviews})
                </h4>

                <c:if test="${empty reviews}">
                    <div class="empty-reviews">
                        <div class="empty-icon">📝</div>
                        <p>Chưa có đánh giá nào. Hãy là người đầu tiên đánh giá sản phẩm này!</p>
                    </div>
                </c:if>

                <c:forEach var="review" items="${reviews}">
    <div class="review-item">
        <div class="review-header">
            <div class="reviewer-info">
                <div class="reviewer-avatar">
                    ${review.fullName.substring(0, 1).toUpperCase()}
                </div>
                <div class="reviewer-details">
                    <strong class="reviewer-name">${review.fullName}</strong>
                    <div class="review-stars">
                        <c:forEach begin="1" end="5" var="i">
                            <span class="star ${i <= review.soSao ? 'filled' : 'empty'}">★</span>
                        </c:forEach>
                    </div>
                </div>
            </div>
            <div class="review-date">
                <fmt:formatDate value="${review.ngayDanhGia}" pattern="dd/MM/yyyy"/>
            </div>
        </div>
        
        <div class="review-content">
            ${review.noiDung}
        </div>

        <!-- ✅ PHẦN TRẢ LỜI CỦA ADMIN -->
        <c:if test="${not empty review.adminReply}">
            <div class="admin-reply">
                <div class="admin-reply-header">
                    <span class="admin-badge">👨‍💼 Phản hồi từ Admin</span>
                    <span class="admin-reply-date">
                        <fmt:formatDate value="${review.adminReplyDate}" pattern="dd/MM/yyyy HH:mm"/>
                    </span>
                </div>
                <div class="admin-reply-content">
                    ${review.adminReply}
                </div>
            </div>
        </c:if>

        <!-- ✅ FORM TRẢ LỜI CHỈ HIỆN KHI ADMIN ĐĂNG NHẬP VÀ CHƯA TRẢ LỜI -->
        <c:if test="${not empty sessionScope.user && sessionScope.user.role == 'admin' && empty review.adminReply}">
            <div class="admin-reply-form" id="reply-form-${review.maReview}">
                <button class="btn-reply-toggle" onclick="toggleReplyForm(${review.maReview})">
                    💬 Trả lời đánh giá này
                </button>
                <form action="adminReplyReview" method="post" style="display:none;" id="form-${review.maReview}">
                    <input type="hidden" name="maReview" value="${review.maReview}">
                    <input type="hidden" name="maSP" value="${product.maSP}">
                    <textarea name="adminReply" rows="3" 
                              placeholder="Nhập phản hồi của bạn... (tối thiểu 10 ký tự)" 
                              maxlength="500" required></textarea>
                    <div class="reply-actions">
                        <button type="submit" class="btn btn-primary btn-sm">📤 Gửi phản hồi</button>
                        <button type="button" class="btn btn-secondary btn-sm" onclick="toggleReplyForm(${review.maReview})">
                            ❌ Hủy
                        </button>
                    </div>
                </form>
            </div>
        </c:if>

        <!-- ✅ NÚT SỬA PHẢN HỒI (NẾU ĐÃ TRẢ LỜI) -->
        <c:if test="${not empty sessionScope.user && sessionScope.user.role == 'admin' && not empty review.adminReply}">
            <div class="admin-reply-form">
                <button class="btn-reply-toggle btn-edit" onclick="toggleReplyForm(${review.maReview})">
                    ✏️ Sửa phản hồi
                </button>
                <form action="adminReplyReview" method="post" style="display:none;" id="form-${review.maReview}">
                    <input type="hidden" name="maReview" value="${review.maReview}">
                    <input type="hidden" name="maSP" value="${product.maSP}">
                    <textarea name="adminReply" rows="3" 
                              placeholder="Nhập phản hồi của bạn..." 
                              maxlength="500" required>${review.adminReply}</textarea>
                    <div class="reply-actions">
                        <button type="submit" class="btn btn-primary btn-sm">💾 Cập nhật</button>
                        <button type="button" class="btn btn-secondary btn-sm" onclick="toggleReplyForm(${review.maReview})">
                            ❌ Hủy
                        </button>
                    </div>
                </form>
            </div>
        </c:if>
    </div>
</c:forEach>
            </div>
        </div>
    </c:if>

    <c:if test="${empty product}">
        <div class="error-message">
            <div class="error-icon">❌</div>
            <h3>Sản phẩm không tồn tại</h3>
            <p>Sản phẩm bạn đang tìm kiếm không tồn tại hoặc đã bị xóa.</p>
            <a href="home" class="btn btn-primary">← Quay về trang chủ</a>
        </div>
    </c:if>
</div>

<!-- TOAST & LOADING -->
<div id="toast" class="toast"></div>
<div id="loading" class="loading-overlay">
    <div class="spinner"></div>
</div>

<script>
const contextPath = '<%= request.getContextPath() %>';

function getQuantity() {
    const input = document.getElementById('quantity');
    let val = parseInt(input.value) || 1;
    return Math.max(1, Math.min(99, val));
}

function addToCart(maSP, quantity) {
    showLoading(true);
    fetch(contextPath + '/cart', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `action=add&maSP=${maSP}&quantity=${quantity}`
    })
    .then(res => res.json())
    .then(data => {
        showLoading(false);
        if (data.success) {
            showToast(data.message, 'success');
            updateCartCount(data.cartCount);
        } else {
            if (data.needLogin) window.location.href = contextPath + '/login';
            else showToast(data.message || 'Có lỗi xảy ra!', 'error');
        }
    })
    .catch(() => {
        showLoading(false);
        showToast('Lỗi kết nối server!', 'error');
    });
}

function buyNow(maSP) {
    const qty = getQuantity();
    window.location.href = `${contextPath}/checkout?buyNow=true&maSP=${maSP}&quantity=${qty}`;
}

function showToast(message, type) {
    const toast = document.getElementById('toast');
    toast.textContent = message;
    toast.className = `toast show ${type}`;
    setTimeout(() => toast.className = 'toast', 3000);
}

function showLoading(show) {
    document.getElementById('loading').style.display = show ? 'flex' : 'none';
}

function updateCartCount(count) {
    const badge = document.getElementById('cart-count');
    if (badge) {
        badge.textContent = count;
        badge.style.display = count > 0 ? 'inline-block' : 'none';
    }
}

// ĐẾM KÝ TỰ
const textarea = document.getElementById('noiDung');
if (textarea) {
    textarea.addEventListener('input', function() {
        document.getElementById('charCount').textContent = this.value.length;
    });
}

// VALIDATE ĐÁNH GIÁ
function validateReview() {
    const rating = document.querySelector('input[name="soSao"]:checked');
    const content = document.getElementById('noiDung').value.trim();
    
    if (!rating) {
        showToast('⚠️ Vui lòng chọn số sao!', 'error');
        return false;
    }
    if (content.length < 10) {
        showToast('⚠️ Nội dung phải có ít nhất 10 ký tự!', 'error');
        return false;
    }
    return true;
}
// ✅ TOGGLE FORM TRẢ LỜI
function toggleReplyForm(maReview) {
    const form = document.getElementById('form-' + maReview);
    if (form.style.display === 'none' || form.style.display === '') {
        form.style.display = 'block';
        form.querySelector('textarea').focus();
    } else {
        form.style.display = 'none';
    }
}

// AUTO SCROLL
window.addEventListener('load', () => {
    if (document.querySelector('.alert')) {
        setTimeout(() => {
            document.querySelector('.review-section-card')?.scrollIntoView({ 
                behavior: 'smooth', 
                block: 'start' 
            });
        }, 300);
    }
});
</script>

<style>
/* ==================== GLOBAL ==================== */
* { box-sizing: border-box; }
.page-container { max-width: 1200px; margin: 0 auto; padding: 20px; }
.page-title { font-size: 2em; margin-bottom: 25px; color: #2c3e50; font-weight: 700; }

/* ==================== ALERT ==================== */
.alert { padding: 15px 20px; border-radius: 10px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; animation: slideDown 0.4s ease; }
.alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
.alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
.alert-icon { font-size: 1.3em; }

@keyframes slideDown { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }

/* ==================== PRODUCT CARD ==================== */
.product-detail-card { background: #fff; border-radius: 20px; box-shadow: 0 10px 40px rgba(0,0,0,0.08); padding: 40px; margin-bottom: 30px; position: relative; overflow: hidden; }

.discount-badge { position: absolute; top: 20px; right: 20px; background: linear-gradient(135deg, #e74c3c, #c0392b); color: white; padding: 12px 20px; border-radius: 50px; font-weight: 700; font-size: 1.1em; box-shadow: 0 4px 15px rgba(231,76,60,0.4); z-index: 10; animation: pulse 2s infinite; }

@keyframes pulse { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.05); } }

.product-detail-grid { display: grid; grid-template-columns: 400px 1fr; gap: 40px; align-items: start; }

.product-image-container { background: #f8f9fa; border-radius: 15px; padding: 20px; border: 2px solid #e9ecef; overflow: hidden; position: relative; }

.product-image { width: 100%; height: 400px; object-fit: contain; transition: transform 0.3s; }
.product-image:hover { transform: scale(1.05); }

.product-info-container { display: flex; flex-direction: column; gap: 20px; }

.product-title { font-size: 2.2em; font-weight: 700; color: #2c3e50; margin: 0; line-height: 1.3; }

.product-code { color: #7f8c8d; font-size: 1em; margin: 0; }

/* ==================== RATING SUMMARY ==================== */
.product-rating-summary { display: flex; align-items: center; gap: 12px; padding: 15px 0; border-bottom: 2px solid #ecf0f1; }

.stars-display { display: flex; gap: 3px; }

.star { font-size: 1.4em; transition: all 0.2s; }
.star.filled { color: #f39c12; text-shadow: 0 2px 4px rgba(243,156,18,0.3); }
.star.half { background: linear-gradient(90deg, #f39c12 50%, #bdc3c7 50%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
.star.empty { color: #bdc3c7; }

.rating-number { font-size: 1.3em; font-weight: 700; color: #f39c12; }

.rating-count { color: #7f8c8d; font-size: 0.95em; }

/* ==================== PRICE ==================== */
.product-price-section { padding: 20px 0; }

.price-original { font-size: 1.2em; color: #95a5a6; text-decoration: line-through; margin-bottom: 8px; }

.price-sale { font-size: 2.5em; font-weight: 700; color: #e74c3c; }

.price-normal { font-size: 2.5em; font-weight: 700; color: #27ae60; }

/* ==================== DESCRIPTION ==================== */
.product-description { background: #f8f9fa; padding: 20px; border-radius: 12px; border-left: 4px solid #3498db; }

.section-subtitle { font-size: 1.2em; margin: 0 0 10px; color: #2c3e50; }

.product-description p { line-height: 1.7; color: #555; margin: 0; }

/* ==================== ACTIONS ==================== */
.product-actions { display: flex; gap: 15px; align-items: center; padding-top: 20px; flex-wrap: wrap; }

.quantity-selector { display: flex; align-items: center; gap: 10px; }

.quantity-selector label { font-weight: 600; color: #2c3e50; }

.quantity-selector input { width: 80px; padding: 12px; border: 2px solid #ddd; border-radius: 8px; text-align: center; font-size: 1.1em; font-weight: 600; }

.quantity-selector input:focus { outline: none; border-color: #3498db; }

/* ==================== BUTTONS ==================== */
.btn { padding: 14px 28px; border: none; border-radius: 10px; font-weight: 600; font-size: 1.05em; cursor: pointer; transition: all 0.3s; display: inline-flex; align-items: center; gap: 8px; text-decoration: none; justify-content: center; }

.btn-primary { background: linear-gradient(135deg, #3498db, #2980b9); color: white; box-shadow: 0 4px 15px rgba(52,152,219,0.3); }
.btn-primary:hover { background: linear-gradient(135deg, #2980b9, #21618c); transform: translateY(-2px); box-shadow: 0 6px 20px rgba(52,152,219,0.4); }

.btn-success { background: linear-gradient(135deg, #27ae60, #229954); color: white; box-shadow: 0 4px 15px rgba(39,174,96,0.3); }
.btn-success:hover { background: linear-gradient(135deg, #229954, #1e8449); transform: translateY(-2px); box-shadow: 0 6px 20px rgba(39,174,96,0.4); }

.btn-secondary { background: #95a5a6; color: white; }
.btn-secondary:hover { background: #7f8c8d; }

.btn-block { width: 100%; }

.btn-icon { font-size: 1.2em; }

/* ==================== REVIEW SECTION ==================== */
.review-section-card { background: #fff; border-radius: 20px; box-shadow: 0 10px 40px rgba(0,0,0,0.08); padding: 40px; }

.section-title { font-size: 1.8em; font-weight: 700; color: #2c3e50; margin: 0 0 30px; display: flex; align-items: center; gap: 10px; border-bottom: 3px solid #3498db; padding-bottom: 15px; }

.section-icon { font-size: 1.2em; }

/* ==================== RATING STATISTICS ==================== */
.rating-statistics { display: grid; grid-template-columns: 250px 1fr; gap: 40px; background: linear-gradient(135deg, #ecf0f1, #bdc3c7); border-radius: 15px; padding: 30px; margin-bottom: 30px; }

.rating-overview { text-align: center; }

.rating-score { font-size: 4em; font-weight: 700; color: #f39c12; line-height: 1; }

.stars-large { font-size: 1.8em; margin: 15px 0; }

.rating-text { color: #555; font-size: 1.1em; }

.rating-breakdown { display: flex; flex-direction: column; gap: 12px; }

.rating-bar-item { display: flex; align-items: center; gap: 15px; }

.star-label { min-width: 60px; font-weight: 600; color: #2c3e50; display: flex; align-items: center; gap: 5px; }

.star-icon { color: #f39c12; }

.rating-bar { flex: 1; height: 10px; background: #ecf0f1; border-radius: 10px; overflow: hidden; position: relative; }

.rating-bar-fill { height: 100%; background: linear-gradient(90deg, #f39c12, #e67e22); border-radius: 10px; transition: width 0.6s ease; }

.rating-count { min-width: 50px; text-align: right; font-weight: 600; color: #7f8c8d; }

/* ==================== REVIEW FORM ==================== */
.review-form-card { background: #f8f9fa; border-radius: 15px; padding: 30px; margin-bottom: 30px; border: 2px solid #e9ecef; }

.form-title { font-size: 1.4em; font-weight: 600; color: #2c3e50; margin: 0 0 20px; }

.form-group { margin-bottom: 25px; }

.form-label { display: block; font-weight: 600; color: #2c3e50; margin-bottom: 10px; font-size: 1.05em; }

.required { color: #e74c3c; }

.star-rating-input { display: flex; flex-direction: row-reverse; justify-content: flex-end; gap: 8px; }

.star-rating-input input { display: none; }

.star-rating-input label { font-size: 3em; color: #bdc3c7; cursor: pointer; transition: all 0.2s; }

.star-rating-input label:hover,
.star-rating-input label:hover ~ label,
.star-rating-input input:checked ~ label { color: #f39c12; transform: scale(1.15); filter: drop-shadow(0 2px 4px rgba(243,156,18,0.4)); }

textarea { width: 100%; padding: 15px; border: 2px solid #ddd; border-radius: 10px; font-family: inherit; font-size: 1em; resize: vertical; transition: border-color 0.3s; }

textarea:focus { outline: none; border-color: #3498db; }

.char-counter { text-align: right; font-size: 0.9em; color: #7f8c8d; margin-top: 8px; }

.btn-submit { width: 100%; font-size: 1.1em; }

/* ==================== LOGIN PROMPT ==================== */
.login-prompt { background: #ecf0f1; padding: 25px; border-radius: 12px; text-align: center; margin-bottom: 30px; }

.login-prompt p { margin: 0; color: #555; font-size: 1.1em; }

.link-primary { color: #3498db; font-weight: 600; text-decoration: none; }
.link-primary:hover { text-decoration: underline; }

/* ==================== REVIEWS LIST ==================== */
.reviews-list { margin-top: 30px; }

.reviews-list-title { font-size: 1.4em; font-weight: 600; color: #2c3e50; margin: 0 0 20px; }

.empty-reviews { text-align: center; padding: 60px 20px; background: #f8f9fa; border-radius: 15px; }

.empty-icon { font-size: 4em; margin-bottom: 15px; }

.empty-reviews p { color: #7f8c8d; font-size: 1.1em; margin: 0; }

.review-item { background: #fff; border: 2px solid #ecf0f1; border-radius: 12px; padding: 25px; margin-bottom: 15px; transition: all 0.3s; }

.review-item:hover { border-color: #3498db; box-shadow: 0 5px 20px rgba(52,152,219,0.15); transform: translateY(-3px); }

.review-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 15px; padding-bottom: 15px; border-bottom: 1px solid #ecf0f1; }

.reviewer-info { display: flex; align-items: center; gap: 15px; }

.reviewer-avatar { width: 50px; height: 50px; border-radius: 50%; background: linear-gradient(135deg, #3498db, #2980b9); color: white; display: flex; align-items:
                       center; justify-content: center; font-size: 1.5em; font-weight: 700; box-shadow: 0 3px 10px rgba(52,152,219,0.3); }

.reviewer-details { display: flex; flex-direction: column; gap: 5px; }

.reviewer-name { font-size: 1.1em; color: #2c3e50; }

.review-stars { display: flex; gap: 3px; }

.review-stars .star { font-size: 1.2em; }

.review-date { color: #95a5a6; font-size: 0.9em; }

.review-content { line-height: 1.8; color: #555; font-size: 1.05em; white-space: pre-wrap; }

/* ==================== ERROR MESSAGE ==================== */
.error-message { text-align: center; padding: 80px 20px; background: #fff; border-radius: 20px; box-shadow: 0 10px 40px rgba(0,0,0,0.08); }

.error-icon { font-size: 5em; margin-bottom: 20px; }

.error-message h3 { font-size: 2em; color: #e74c3c; margin: 0 0 15px; }

.error-message p { color: #7f8c8d; font-size: 1.1em; margin-bottom: 30px; }

/* ==================== TOAST ==================== */
.toast { position: fixed; bottom: 30px; right: 30px; padding: 18px 28px; border-radius: 12px; font-weight: 600; font-size: 1.05em; opacity: 0; transform: translateY(20px); transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55); z-index: 10000; box-shadow: 0 8px 25px rgba(0,0,0,0.15); max-width: 350px; color: white; }

.toast.show { opacity: 1; transform: translateY(0); }

.toast.success { background: linear-gradient(135deg, #27ae60, #229954); }

.toast.error { background: linear-gradient(135deg, #e74c3c, #c0392b); }

/* ==================== LOADING ==================== */
.loading-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.7); display: none; justify-content: center; align-items: center; z-index: 9999; backdrop-filter: blur(5px); }

.spinner { width: 60px; height: 60px; border: 6px solid rgba(255,255,255,0.3); border-top-color: #3498db; border-radius: 50%; animation: spin 0.8s linear infinite; }
/* ==================== ADMIN REPLY ==================== */
.admin-reply {
    margin-top: 15px;
    padding: 15px 20px;
    background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
    border-left: 4px solid #4caf50;
    border-radius: 10px;
}

.admin-reply-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
}

.admin-badge {
    background: #4caf50;
    color: white;
    padding: 5px 12px;
    border-radius: 20px;
    font-size: 0.9em;
    font-weight: 600;
}

.admin-reply-date {
    color: #666;
    font-size: 0.85em;
}

.admin-reply-content {
    line-height: 1.6;
    color: #2e7d32;
    font-size: 1em;
}

/* FORM TRẢ LỜI */
.admin-reply-form {
    margin-top: 15px;
}

.btn-reply-toggle {
    background: linear-gradient(135deg, #3498db, #2980b9);
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 600;
    font-size: 0.95em;
    transition: all 0.3s;
}

.btn-reply-toggle:hover {
    background: linear-gradient(135deg, #2980b9, #21618c);
    transform: translateY(-2px);
}

.btn-reply-toggle.btn-edit {
    background: linear-gradient(135deg, #f39c12, #e67e22);
}

.btn-reply-toggle.btn-edit:hover {
    background: linear-gradient(135deg, #e67e22, #d35400);
}

.admin-reply-form form {
    margin-top: 15px;
    padding: 20px;
    background: #f8f9fa;
    border-radius: 10px;
    border: 2px solid #e9ecef;
}

.admin-reply-form textarea {
    width: 100%;
    padding: 12px;
    border: 2px solid #ddd;
    border-radius: 8px;
    font-family: inherit;
    font-size: 1em;
    resize: vertical;
    transition: border-color 0.3s;
}

.admin-reply-form textarea:focus {
    outline: none;
    border-color: #3498db;
}

.reply-actions {
    display: flex;
    gap: 10px;
    margin-top: 12px;
}

.btn-sm {
    padding: 8px 16px;
    font-size: 0.95em;
}

/* RESPONSIVE */
@media (max-width: 768px) {
    .admin-reply-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 8px;
    }
    
    .reply-actions {
        flex-direction: column;
    }
    
    .btn-sm {
        width: 100%;
    }
}
@keyframes spin { to { transform: rotate(360deg); } }

/* ==================== RESPONSIVE ==================== */
@media (max-width: 992px) {
    .product-detail-grid { grid-template-columns: 1fr; }
    .product-image { height: 350px; }
    .rating-statistics { grid-template-columns: 1fr; text-align: center; }
    .rating-breakdown { max-width: 500px; margin: 0 auto; }
}

@media (max-width: 768px) {
    .page-container { padding: 15px; }
    .page-title { font-size: 1.6em; }
    .product-detail-card, .review-section-card { padding: 25px; border-radius: 15px; }
    .product-title { font-size: 1.7em; }
    .price-sale, .price-normal { font-size: 2em; }
    .product-actions { flex-direction: column; }
    .btn { width: 100%; }
    .quantity-selector { width: 100%; justify-content: space-between; }
    .rating-score { font-size: 3em; }
    .stars-large { font-size: 1.5em; }
    .section-title { font-size: 1.5em; }
    .reviewer-avatar { width: 40px; height: 40px; font-size: 1.2em; }
    .toast { bottom: 20px; right: 20px; left: 20px; max-width: none; }
}

@media (max-width: 480px) {
    .product-image { height: 280px; }
    .star-rating-input label { font-size: 2.5em; }
    .rating-overview { padding-bottom: 20px; border-bottom: 2px solid #bdc3c7; margin-bottom: 20px; }
}

/* ==================== ANIMATIONS ==================== */
@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }

@keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }

.product-detail-card { animation: fadeIn 0.5s ease; }

.review-section-card { animation: slideUp 0.6s ease; }

.review-item { animation: slideUp 0.4s ease; }
.review-item:nth-child(1) { animation-delay: 0.1s; }
.review-item:nth-child(2) { animation-delay: 0.2s; }
.review-item:nth-child(3) { animation-delay: 0.3s; }

/* ==================== PRINT STYLES ==================== */
@media print {
    .btn, .product-actions, .review-form-card, .toast, .loading-overlay { display: none !important; }
    .page-container { max-width: 100%; }
    .product-detail-card, .review-section-card { box-shadow: none; border: 1px solid #ddd; }
}
</style>

<%@ include file="footer.jsp" %>