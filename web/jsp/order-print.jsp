<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>In Đơn Hàng #${order.maDon}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; color: #333; }
        h2 { text-align: center; margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background-color: #f8f8f8; }
        .total { text-align: right; font-weight: bold; font-size: 1.1em; }
        .info { margin-bottom: 25px; }
        .info p { margin: 4px 0; }
        .footer { text-align: center; margin-top: 40px; font-size: 0.9em; color: #666; }
        @media print {
            .no-print { display: none; }
        }
    </style>
</head>
<body>

    <h2>HÓA ĐƠN ĐƠN HÀNG #${order.maDon}</h2>

    <div class="info">
        <p><strong>Khách hàng:</strong> ${order.user.fullName}</p>
        <p><strong>Email:</strong> ${order.user.email}</p>
        <p><strong>SĐT:</strong> ${order.user.soDienThoai}</p>
        <p><strong>Địa chỉ giao:</strong> ${order.diaChiGiao}</p>
        <p><strong>Ngày đặt:</strong> <fmt:formatDate value="${order.ngayDat}" pattern="HH:mm dd/MM/yyyy"/></p>
        <p><strong>Trạng thái:</strong> ${order.trangThai}</p>
    </div>

    <table>
        <thead>
            <tr>
                <th>Sản phẩm</th>
                <th>Mã SP</th>
                <th>Giá</th>
                <th>Số lượng</th>
                <th>Tổng</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="item" items="${orderDetails}">
                <tr>
                    <td>${item.product.tenSP}</td>
                    <td>${item.product.codeSP}</td>
                    <td><fmt:formatNumber value="${item.donGia}" type="number"/> VNĐ</td>
                    <td>${item.soLuong}</td>
                    <td><fmt:formatNumber value="${item.soLuong * item.donGia}" type="number"/> VNĐ</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <p class="total">
        Tổng cộng: 
        <fmt:formatNumber value="${order.tongTien}" type="number"/> VNĐ
    </p>

    <div class="no-print" style="text-align:center; margin-top:30px;">
        <button onclick="window.print()">🖨 In / Lưu PDF</button>
        <a href="admin" style="margin-left:20px;">Quay lại</a>
    </div>

    <div class="footer">
        <hr>
        <p>Cửa hàng thể thao SportsShop - Hotline: 0123.456.789</p>
        <p>Trang này được tạo tự động vào <fmt:formatDate value="<%= new java.util.Date() %>" pattern="HH:mm dd/MM/yyyy"/></p>
    </div>

</body>
</html>
