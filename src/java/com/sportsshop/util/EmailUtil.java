package com.sportsshop.util;

import com.sportsshop.model.Order;
import com.sportsshop.model.OrderDetail;
import com.sportsshop.model.Product;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.io.InputStream;
import java.util.Properties;

public class EmailUtil {
    private static Properties loadProperties() {
        Properties props = new Properties();
        try (InputStream is = EmailUtil.class.getClassLoader().getResourceAsStream("email.properties")) {
            props.load(is);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return props;
    }

    public static void sendOrderConfirmation(String toEmail, Order order, java.util.List<OrderDetail> orderDetails) {
        Properties props = loadProperties();
        String from = props.getProperty("mail.from");
        String password = props.getProperty("mail.password");

        // Cấu hình session
        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Xác Nhận Đơn Hàng #" + order.getMaDon() + " - Sports Shop");

            // Nội dung HTML
            String htmlContent = buildEmailHtml(order, orderDetails);
            message.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("Email sent successfully to " + toEmail);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    private static String buildEmailHtml(Order order, java.util.List<OrderDetail> orderDetails) {
        StringBuilder sb = new StringBuilder();
        sb.append("<!DOCTYPE html><html><head>");
        sb.append("<meta charset='UTF-8'>");
        sb.append("<style>");
        sb.append("body{font-family:Arial,sans-serif;background:#f4f4f4;margin:0;padding:20px}");
        sb.append(".container{max-width:600px;margin:auto;background:white;padding:20px;border-radius:8px;box-shadow:0 0 10px rgba(0,0,0,0.1)}");
        sb.append("h1{color:#0066cc}");
        sb.append("table{width:100%;border-collapse:collapse;margin:20px 0}");
        sb.append("th,td{border:1px solid #ddd;padding:8px;text-align:left}");
        sb.append("th{background:#f0f0f0}");
        sb.append(".total{font-weight:bold;font-size:1.2em}");
        sb.append(".footer{margin-top:30px;color:#777;font-size:0.9em}");
        sb.append("</style></head><body>");
        sb.append("<div class='container'>");
        sb.append("<h1>Cảm ơn bạn đã đặt hàng!</h1>");
        sb.append("<p>Đơn hàng của bạn đã được xác nhận. Dưới đây là chi tiết:</p>");
        sb.append("<p><strong>Mã đơn hàng:</strong> #").append(order.getMaDon()).append("</p>");
        sb.append("<p><strong>Ngày đặt:</strong> ").append(order.getNgayDat()).append("</p>");
        sb.append("<p><strong>Địa chỉ giao:</strong> ").append(order.getDiaChiGiao()).append("</p>");

        sb.append("<h3>Chi tiết sản phẩm</h3>");
        sb.append("<table><tr><th>Sản phẩm</th><th>SL</th><th>Đơn giá</th><th>Thành tiền</th></tr>");
        for (OrderDetail item : orderDetails) {
            Product p = item.getProduct();
            double total = p.getGia() * item.getSoLuong();
            sb.append("<tr>");
            sb.append("<td>").append(p.getTenSP()).append(" (").append(p.getCodeSP()).append(")</td>");
            sb.append("<td>").append(item.getSoLuong()).append("</td>");
            sb.append("<td>").append(String.format("%,.0f", p.getGia())).append(" VNĐ</td>");
            sb.append("<td>").append(String.format("%,.0f", total)).append(" VNĐ</td>");
            sb.append("</tr>");
        }
        sb.append("<tr class='total'><td colspan='3'>Tổng cộng:</td>");
        sb.append("<td>").append(String.format("%,.0f", order.getTongTien())).append(" VNĐ</td></tr>");
        sb.append("</table>");

        sb.append("<p>Chúng tôi sẽ xử lý đơn hàng và giao hàng sớm nhất!</p>");
        sb.append("<div class='footer'>");
        sb.append("<p>Sports Shop - Chuyên dụng cụ thể thao chất lượng cao</p>");
        sb.append("<p>Email: support@sportsshop.com | Hotline: 0123.456.789</p>");
        sb.append("</div></div></body></html>");

        return sb.toString();
    }
}