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
 
<c:if test="${sessionScope.phuongThucThanhToan == 'Chuyển khoản'}">
    <div class="bank-transfer-guide">
        <h3 style="color:#0066cc; text-align:left; margin:25px 0 15px;">
            Hướng dẫn chuyển khoản
        </h3>
        <div style="background:#f8f9fa; padding:20px; border-radius:10px; border:1px solid #e9ecef; text-align:left;">
            <table style="width:100%; font-size:0.95em; line-height:1.8;">
                <tr>
                    <td style="width:35%; font-weight:600; color:#333;">Ngân hàng:</td>
                    <td><strong>Vietcombank</strong></td>
                </tr>
                <tr>
                    <td style="font-weight:600; color:#333;">Số tài khoản:</td>
                    <td><code style="background:#eee; padding:4px 8px; border-radius:4px; font-family:monospace; font-size:1.1em;">
                        1234 5678 9012
                    </code></td>
                </tr>
                <tr>
                    <td style="font-weight:600; color:#333;">Chủ tài khoản:</td>
                    <td><strong>NGUYỄN VĂN A</strong></td>
                </tr>
                <tr>
                    <td style="font-weight:600; color:#333;">Nội dung chuyển khoản:</td>
                    <td>
                        <div style="background:#fff3cd; padding:10px; border-radius:6px; border:1px solid #ffeaa7; font-weight:bold; font-family:monospace;">
                            #${maOrder}
                        </div>
                        <small style="color:#e74c3c; display:block; margin-top:5px;">
                            Vui lòng ghi đúng nội dung để xác nhận nhanh
                        </small>
                    </td>
                </tr>
            </table>
            <div style="margin-top:20px; padding:15px; background:#e3f2fd; border-radius:8px; font-size:0.9em; color:#1976d2;">
                <strong>Lưu ý:</strong> Chúng tôi sẽ xác nhận đơn hàng trong vòng <strong>24 giờ</strong> sau khi nhận được tiền. Vui lòng giữ lại biên lai.
            </div>
        </div>
    </div>
</c:if>
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