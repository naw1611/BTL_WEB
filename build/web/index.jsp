<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="jsp/header.jsp" %>
<h2>Chào mừng bạn đến với Shop </h2>
<div class="product-grid">
    <img src="<%= request.getContextPath() %>/images/chaomung.jpg" alt="Sports Shop Logo" style="width: 100%">
</div>

<h2>Hàng Mới</h2>

<!-- =================== CAROUSEL TRƯỢT NGANG (THAY THẾ PRODUCT-GRID) =================== -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
<style>
    .product-swiper {
        padding: 20px 0;
        margin: 20px 0;
        position: relative;
    }
    .swiper-slide {
        display: flex;
        justify-content: center;
    }
    .product {
        width: 100% !important;
        height: 100%;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        padding: 18px;
    }
    .product img {
        height: 180px;
        object-fit: contain;
        background: #f9f9f9;
        margin-bottom: 12px;
    }
    .product h3 {
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        font-size: 1.1em;
        margin: 10px 0;
    }
    .product .price {
        color: var(--danger);
        font-weight: bold;
        font-size: 1.2em;
        margin: 8px 0;
    }
    .product-actions {
        display: flex;
        gap: 8px;
        margin-top: 10px;
    }
    .btn-buy-now,
    .btn-add-to-cart {
        flex: 1;
        padding: 10px;
        font-size: 0.9em;
        border: none;
        border-radius: 8px;
        font-weight: bold;
        cursor: pointer;
        transition: all 0.3s;
    }
    .btn-buy-now {
        background: var(--success);
        color: white;
    }
    .btn-buy-now:hover {
        background: #218838;
        transform: translateY(-2px);
    }
    .btn-add-to-cart {
        background: #0066cc;
        color: white;
    }
    .btn-add-to-cart:hover {
        background: #0066cc;
        transform: translateY(-2px);
    }
    .swiper-button-next,
    .swiper-button-prev {
        width: 40px;
        height: 40px;
        background: rgba(0,0,0,0.6);
        border-radius: 50%;
        color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
    }
    .swiper-button-next:after,
    .swiper-button-prev:after {
        font-size: 16px;
    }
    .swiper-pagination-bullet {
        background: #ccc;
        opacity: 1;
    }
    .swiper-pagination-bullet-active {
        background: var(--main-color);
    }
</style>

<div class="swiper product-swiper">
    <div class="swiper-wrapper">
        <c:forEach var="product" items="${products}">
            <div class="swiper-slide">
                <div class="product">
                    <a href="product-detail?id=${product.maSP}">
                        <img src="${pageContext.request.contextPath}/images/${product.hinhAnh}"
                             alt="${product.tenSP}"
                             onerror="this.src='${pageContext.request.contextPath}/images/no-image.jpg'">
                        <h3>${product.tenSP}</h3>
                        <p><strong>Mã:</strong> ${product.codeSP}</p>
                        <p class="price"><strong>Giá:</strong> <fmt:formatNumber value="${product.gia}" pattern="#,###"/> VNĐ</p>
                    </a>

                    <c:if test="${not empty sessionScope.user}">
                <div class="product-actions">
                <button class="btn-buy-now" onclick="buyNow(${product.maSP})">⚡ Mua Ngay</button>
                <button class="btn-add-to-cart" onclick="addToCart(${product.maSP},1)">🛒 Thêm vào giỏ</button>
            </div>
            </c:if>
                    <c:if test="${empty sessionScope.user}">
                        <a href="login" class="btn-login-required">🔒 Đăng nhập để mua</a>
                    </c:if>
                </div>
            </div>
        </c:forEach>
    </div>
    <div class="swiper-button-next"></div>
    <div class="swiper-button-prev"></div>
    <div class="swiper-pagination"></div>
</div>

<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        new Swiper('.product-swiper', {
            slidesPerView: 1,
            spaceBetween: 20,
            loop: true,
            autoplay: { delay: 4000, disableOnInteraction: false },
            pagination: { el: '.swiper-pagination', clickable: true },
            navigation: { nextEl: '.swiper-button-next', prevEl: '.swiper-button-prev' },
            breakpoints: {
                576: { slidesPerView: 2 },
                768: { slidesPerView: 3 },
                992: { slidesPerView: 4 },
                1200: { slidesPerView: 5 }
            }
        });
    });
</script>
<!-- ================================================================================ -->

<h2>Hàng Khuyến Mại</h2>

<!-- =================== CAROUSEL TRƯỢT NGANG (THAY THẾ PRODUCT-GRID) =================== -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />


<div class="swiper product-swiper">
        <div class="swiper-wrapper">
            <c:forEach var="product" items="${promotionProducts}">
                <div class="swiper-slide">
                    <div class="product" style="position:relative; border:2px solid #e74c3c; background:#fff8f8; border-radius:12px; overflow:hidden;">
                        <!-- Nhãn giảm giá -->
                        <div style="position:absolute; top:8px; right:8px; background:#e74c3c; color:white; padding:4px 10px; border-radius:20px; font-size:12px; font-weight:bold; z-index:10; box-shadow:0 2px 5px rgba(0,0,0,0.2);">
                            -${product.phanTramGiam}%
                        </div>

                        <a href="product-detail?id=${product.maSP}" style="text-decoration:none; color:inherit;">
                            <img src="${pageContext.request.contextPath}/images/${product.hinhAnh}"
                                 alt="${product.tenSP}"
                                 onerror="this.src='${pageContext.request.contextPath}/images/no-image.jpg'"
                                 style="width:100%; height:180px; object-fit:contain; background:#f9f9f9; border-radius:8px; margin-bottom:12px;">

                            <h3 style="margin:8px 0; font-size:1.1em; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; padding:0 8px;">
                                ${product.tenSP}
                            </h3>

                            <p style="margin:5px 0; font-size:0.9em; color:#555; padding:0 8px;">
                                <strong>Mã:</strong> ${product.codeSP}
                            </p>

                            <!-- GIÁ KHUYẾN MẠI - HIỂN THỊ 2 DÒNG -->
<div style="margin:15px 0; text-align:center; padding:0 8px;">
    <div style="color:#999; font-size:1em; text-decoration:line-through; margin-bottom:4px;">
        <fmt:formatNumber value="${product.gia}" pattern="#,###"/> VNĐ
    </div>
    <div style="color:#e74c3c; font-weight:bold; font-size:1.5em;">
        <fmt:formatNumber value="${product.giaKhuyenMai}" pattern="#,###"/> VNĐ
    </div>
</div>
    </a>
                    <c:if test="${not empty sessionScope.user}">
                <div class="product-actions">
                <button class="btn-buy-now" onclick="buyNow(${product.maSP})">⚡ Mua Ngay</button>
                <button class="btn-add-to-cart" onclick="addToCart(${product.maSP},1)">🛒 Thêm vào giỏ</button>
            </div>
            </c:if>
                    <c:if test="${empty sessionScope.user}">
                        <a href="login" class="btn-login-required">🔒 Đăng nhập để mua</a>
                    </c:if>
                </div>
            </div>
        </c:forEach>
    </div>
    <div class="swiper-button-next"></div>
    <div class="swiper-button-prev"></div>
    <div class="swiper-pagination"></div>
</div>

<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        new Swiper('.product-swiper', {
            slidesPerView: 1,
            spaceBetween: 20,
            loop: true,
            autoplay: { delay: 4000, disableOnInteraction: false },
            pagination: { el: '.swiper-pagination', clickable: true },
            navigation: { nextEl: '.swiper-button-next', prevEl: '.swiper-button-prev' },
            breakpoints: {
                576: { slidesPerView: 2 },
                768: { slidesPerView: 3 },
                992: { slidesPerView: 4 },
                1200: { slidesPerView: 5 }
            }
        });
    });
</script>
<!-- ================================================================================ -->

<!-- Thông báo nếu không có sản phẩm -->
<c:if test="${empty products}">
    <p style="text-align:center; color:#888; margin:30px 0; font-style:italic;">
        Chưa có sản phẩm nào trong cửa hàng!
    </p>
</c:if>

<!-- Nút xem tất cả -->
<c:if test="${not empty products}">
    <div style="text-align:center; margin:30px 0;">
        <a href="products" style="background:#0066cc; color:white; padding:12px 30px; text-decoration:none; border-radius:5px; font-weight:bold;">
            Xem Tất Cả Sản Phẩm
        </a>
    </div>
</c:if>

<!-- TOAST -->
<div id="toast-notification"></div>
<!-- LOADING -->
<div id="loading-overlay" class="loading-overlay">
    <div class="loading-spinner"></div>
</div>

<!-- JAVASCRIPT (GIỮ NGUYÊN) -->
<script>
var contextPath = '<%= request.getContextPath() %>';
/* THÊM VÀO GIỎ HÀNG */
function addToCart(maSP, quantity) {
    showLoading(true);
    var xhr = new XMLHttpRequest();
    xhr.open('POST', contextPath + '/cart', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onload = function () {
        showLoading(false);
        if (xhr.status === 200) {
            let response = JSON.parse(xhr.responseText);
            if (response.success) {
                showToast(response.message, 'success');
                updateCartCount(response.cartCount);
            } else {
                if (response.needLogin) {
                    window.location.href = contextPath + '/login';
                } else {
                    showToast(response.message, 'error');
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
/* MUA NGAY */
function buyNow(maSP) {
    var quantity = 1;
    window.location.href = contextPath + '/checkout?buyNow=true&maSP=' + maSP + '&quantity=' + quantity;
}
/* TOAST MESSAGE */
function showToast(message, type) {
    var toast = document.getElementById("toast-notification");
    toast.textContent = message;
    toast.className = "toast-notification show " + type;
    setTimeout(function () {
        toast.className = "toast-notification";
    }, 3000);
}
/* LOADING */
function showLoading(show) {
    document.getElementById("loading-overlay").style.display = show ? "flex" : "none";
}
/* UPDATE GIỎ HÀNG */
function updateCartCount(count) {
    var badge = document.getElementById("cart-count");
    if (badge) {
        badge.textContent = count;
        badge.style.display = count > 0 ? "inline-block" : "none";
    }
}
</script>

<%@ include file="jsp/footer.jsp" %>