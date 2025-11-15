<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ include file="header.jsp" %>

<h2>📊 Báo cáo & Thống kê</h2>

<!-- === Biểu đồ doanh thu theo tháng === -->
<h3>💰 Doanh thu theo tháng</h3>
<canvas id="chartMonth" width="600" height="300"></canvas>

<!-- === Biểu đồ doanh thu theo danh mục === -->
<h3>📦 Doanh thu theo danh mục</h3>
<canvas id="chartCategory" width="600" height="300"></canvas>

<!-- === Bảng top sản phẩm bán chạy === -->
<h3>🔥 Sản phẩm bán chạy nhất</h3>
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse: collapse;">
    <tr style="background:#eee;">
        <th>Tên sản phẩm</th>
        <th>Số lượng bán</th>
    </tr>
    <c:forEach var="p" items="${topProducts}">
        <tr>
            <td>${p.tenSP}</td>
            <td>${p.soLuong}</td>
        </tr>
    </c:forEach>
</table>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // === Doanh thu theo tháng ===
    const monthLabels = [<c:forEach var="k" items="${revenueByMonth.keySet()}">"${k}",</c:forEach>];
    const monthData = [<c:forEach var="v" items="${revenueByMonth.values()}">${v},</c:forEach>];

    new Chart(document.getElementById('chartMonth'), {
        type: 'line',
        data: {
            labels: monthLabels,
            datasets: [{
                label: 'Doanh thu (VND)',
                data: monthData,
                borderColor: '#007bff',
                fill: false,
                tension: 0.3
            }]
        }
    });

    // === Doanh thu theo danh mục ===
    const catLabels = [<c:forEach var="k" items="${revenueByCategory.keySet()}">"${k}",</c:forEach>];
    const catData = [<c:forEach var="v" items="${revenueByCategory.values()}">${v},</c:forEach>];

    new Chart(document.getElementById('chartCategory'), {
        type: 'pie',
        data: {
            labels: catLabels,
            datasets: [{
                data: catData,
                backgroundColor: ['#FF6384','#36A2EB','#FFCE56','#4CAF50','#FF9800']
            }]
        }
    });
</script>

<%@ include file="footer.jsp" %>
