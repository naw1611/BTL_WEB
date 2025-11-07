<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="header.jsp" %>

<h2>Danh Sách Sản Phẩm</h2>

<!-- 🔍 THANH TÌM KIẾM -->
<div class="search-bar">
    <form action="products" method="get">
        <input type="text" name="search" placeholder="Tìm tên hoặc mã sản phẩm..."
               value="<c:out value='${param.search}'/>">
        <c:if test="${not empty param.category}">
            <input type="hidden" name="category" value="${param.category}">
        </c:if>
        <button type="submit">Tìm</button>
    </form>
</div>

<!-- 🛍️ DANH SÁCH SẢN PHẨM -->
<div class="product-grid">
    <c:forEach var="product" items="${products}">

        <!-- TÁCH TRƯỜNG HỢP CÓ KHUYẾN MÃI / KHÔNG KHUYẾN MÃI -->
        <c:choose>
            <c:when test="${product.phanTramGiam > 0}">
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

                        <!-- GIÁ KHUYẾN MÃI -->
                        <div style="margin:15px 0; text-align:center; padding:0 8px;">
                            <div style="color:#999; font-size:1em; text-decoration:line-through; margin-bottom:4px;">
                                <fmt:formatNumber value="${product.gia}" pattern="#,###"/> VNĐ
                            </div>
                            <div style="color:#e74c3c; font-weight:bold; font-size:1.5em;">
                                <fmt:formatNumber value="${product.giaKhuyenMai}" pattern="#,###"/> VNĐ
                            </div>
                        </div>
                    </a>
            </c:when>

            <c:otherwise>
                <div class="product" style="border:1px solid #ddd; background:#fff; border-radius:12px; overflow:hidden;">
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

                        <!-- GIÁ BÌNH THƯỜNG -->
                        <div style="margin:10px 0; text-align:center; color:#333; font-weight:bold; font-size:1.3em;">
                            <fmt:formatNumber value="${product.gia}" pattern="#,###"/> VNĐ
                        </div>
                    </a>
            </c:otherwise>
        </c:choose>

        <!-- NÚT HÀNH ĐỘNG -->
        <c:if test="${not empty sessionScope.user}">
            <div class="product-actions">
                <button class="btn-buy-now" onclick="buyNow(${product.maSP})">⚡ Mua Ngay</button>
                <button class="btn-add-to-cart" onclick="addToCart(${product.maSP},1)">🛒 Thêm vào giỏ</button>
            </div>
        </c:if>

        <c:if test="${empty sessionScope.user}">
            <a href="login" class="btn-login-required">🔒 Đăng nhập để mua</a>
        </c:if>

        </div> <!-- đóng .product -->
    </c:forEach>
</div>

<!-- ⚠️ KHÔNG CÓ SẢN PHẨM -->
<c:if test="${empty products}">
    <p style="text-align:center; color:#888; margin:30px 0; font-style:italic;">
        Không tìm thấy sản phẩm nào phù hợp!
    </p>
</c:if>

<!-- 📄 PHÂN TRANG -->
<c:if test="${not empty products}">
    <div class="pagination">
        <c:if test="${currentPage > 1}">
            <a href="products?page=${currentPage - 1}
                <c:if test='${not empty param.search}'>&amp;search=${param.search}</c:if>
                <c:if test='${not empty param.category}'>&amp;category=${param.category}</c:if>">‹ Trước</a>
        </c:if>

        <c:forEach begin="1" end="${totalPages}" var="i">
            <c:choose>
                <c:when test="${i == currentPage}">
                    <span class="current">${i}</span>
                </c:when>
                <c:otherwise>
                    <a href="products?page=${i}
                        <c:if test='${not empty param.search}'>&amp;search=${param.search}</c:if>
                        <c:if test='${not empty param.category}'>&amp;category=${param.category}</c:if>">${i}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <c:if test="${currentPage < totalPages}">
            <a href="products?page=${currentPage + 1}
                <c:if test='${not empty param.search}'>&amp;search=${param.search}</c:if>
                <c:if test='${not empty param.category}'>&amp;category=${param.category}</c:if>">Sau ›</a>
        </c:if>
    </div>
</c:if>

<!-- 🔔 TOAST -->
<div id="toast-notification"></div>

<!-- ⏳ LOADING -->
<div id="loading-overlay" class="loading-overlay">
    <div class="loading-spinner"></div>
</div>

<!-- 💡 JAVASCRIPT -->
<script>
var contextPath = '<%= request.getContextPath() %>';

/* ✅ THÊM VÀO GIỎ HÀNG */
function addToCart(maSP, quantity) {
    showLoading(true);

    var xhr = new XMLHttpRequest();
    xhr.open('POST', contextPath + '/cart', true); 
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    xhr.onload = function () {
        showLoading(false);
        if (xhr.status === 200) {
            try {
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
            } catch (e) {
                showToast("Lỗi phản hồi từ máy chủ!", "error");
            }
        } else {
            showToast("Lỗi máy chủ (" + xhr.status + ")", "error");
        }
    };

    xhr.onerror = function () {
        showLoading(false);
        showToast("Lỗi kết nối server!", "error");
    };

    xhr.send("action=add&maSP=" + encodeURIComponent(maSP) + "&quantity=" + encodeURIComponent(quantity));
}

/* ✅ MUA NGAY */
function buyNow(maSP) {
    var quantity = 1;
    window.location.href = contextPath + '/checkout?buyNow=true&maSP=' 
        + encodeURIComponent(maSP) + '&quantity=' + encodeURIComponent(quantity);
}

/* ✅ TOAST MESSAGE */
function showToast(message, type) {
    var toast = document.getElementById("toast-notification");
    toast.textContent = message;
    toast.className = "toast-notification show " + type;
    setTimeout(function () {
        toast.className = "toast-notification";
    }, 3000);
}

/* ✅ LOADING */
function showLoading(show) {
    document.getElementById("loading-overlay").style.display = show ? "flex" : "none";
}

/* ✅ CẬP NHẬT GIỎ HÀNG */
function updateCartCount(count) {
    var badge = document.getElementById("cart-count");
    if (badge) {
        badge.textContent = count;
        badge.style.display = count > 0 ? "inline-block" : "none";
    }
}
</script>

<%@ include file="footer.jsp" %>
