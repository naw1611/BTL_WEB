<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="header.jsp" %>

<div class="container main-content">
    <div class="content full-width">
        <div class="success-container">
            <div class="success-icon">✅</div>
            <h2>Đặt Hàng Thành Công!</h2>
            
            <c:if test="${not empty maOrder}">
                <p class="order-info">
                    Mã đơn hàng của bạn: <strong class="order-code">#${maOrder}</strong>
                </p>
            </c:if>
            
            <c:if test="${not empty totalAmount}">
                <p class="order-total">
                    Tổng tiền: <strong class="total-amount">
                        <fmt:formatNumber value="${totalAmount}" pattern="#,###"/> đ
                    </strong>
                </p>
            </c:if>
            
            <p class="thank-you">Cảm ơn bạn đã mua hàng tại <strong>Sports Shop</strong>!</p>
            <p class="contact-info">Chúng tôi sẽ liên hệ với bạn trong thời gian sớm nhất để xác nhận đơn hàng.</p>
 
            <div class="success-actions">
    <a href="${pageContext.request.contextPath}/products" class="btn-continue">🛍️ Tiếp tục mua sắm</a>
    <a href="${pageContext.request.contextPath}/order?action=view" class="btn-view-orders">📦 Xem đơn hàng của tôi</a>
</div>
        </div>
    </div>
</div>

<style>
.success-container {
    text-align: center;
    padding: 50px 20px;
    max-width: 600px;
    margin: 0 auto;
    background: white;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

.success-icon {
    font-size: 80px;
    margin-bottom: 20px;
    animation: scaleIn 0.5s ease-out;
}

@keyframes scaleIn {
    from {
        transform: scale(0);
        opacity: 0;
    }
    to {
        transform: scale(1);
        opacity: 1;
    }
}

.success-container h2 {
    color: #28a745;
    margin-bottom: 20px;
    font-size: 2em;
}

.order-info {
    background: #f8f9fa;
    padding: 20px;
    border-radius: 8px;
    margin: 20px 0;
    font-size: 1.1em;
    border-left: 4px solid #28a745;
}

.order-code {
    color: #e60000;
    font-size: 1.3em;
    display: block;
    margin-top: 10px;
}

.order-total {
    background: #fff3cd;
    padding: 15px;
    border-radius: 8px;
    margin: 20px 0;
    border-left: 4px solid #ffc107;
}

.total-amount {
    color: #e60000;
    font-size: 1.5em;
    display: block;
    margin-top: 5px;
}

.thank-you {
    font-size: 1.2em;
    color: #333;
    margin: 20px 0;
}

.contact-info {
    color: #666;
    margin: 15px 0;
    line-height: 1.6;
}

.success-actions {
    display: flex;
    gap: 15px;
    justify-content: center;
    margin-top: 30px;
    flex-wrap: wrap;
}

.btn-continue,
.btn-view-orders {
    padding: 14px 30px;
    border-radius: 8px;
    text-decoration: none;
    font-weight: bold;
    transition: all 0.3s;
    font-size: 1em;
    display: inline-block;
}

.btn-continue {
    background: linear-gradient(135deg, #007bff, #0056b3);
    color: white;
}

.btn-continue:hover {
    background: linear-gradient(135deg, #0056b3, #004085);
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3);
}

.btn-view-orders {
    background: linear-gradient(135deg, #28a745, #1e7e34);
    color: white;
}

.btn-view-orders:hover {
    background: linear-gradient(135deg, #1e7e34, #155724);
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
}

@media (max-width: 768px) {
    .success-container {
        padding: 30px 15px;
    }
    
    .success-icon {
        font-size: 60px;
    }
    
    .success-container h2 {
        font-size: 1.5em;
    }
    
    .success-actions {
        flex-direction: column;
    }
    
    .btn-continue,
    .btn-view-orders {
        width: 100%;
    }
}
</style>

<%@ include file="footer.jsp" %>