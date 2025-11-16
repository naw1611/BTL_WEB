package com.sportsshop.servlet;

import Connection.DatabaseConnection;
import com.sportsshop.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.Properties;
import java.util.Random;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String identifier = request.getParameter("identifier");
        String forgotMessage = null;
        String forgotMessageType = "error";

        if (identifier == null || identifier.trim().isEmpty()) {
            forgotMessage = "Vui lòng nhập email hoặc số điện thoại!";
        } else {
            User user = findUserByIdentifier(identifier.trim());
            if (user == null) {
                forgotMessage = "Không tìm thấy tài khoản với thông tin này!";
            } else {
                String code = generateVerificationCode();
                HttpSession session = request.getSession();
                session.setAttribute("verificationCode", code);
                session.setAttribute("resetUserId", user.getMaUser());
                session.setAttribute("resetEmail", user.getEmail()); // ✅ Lưu email để gửi lại
                session.setMaxInactiveInterval(300); // 5 phút

                // GỬI EMAIL
                if (sendVerificationEmail(user.getEmail(), code)) {
                    response.sendRedirect("verifyCode");
                    return;
                } else {
                    forgotMessage = "Gửi mã thất bại. Vui lòng kiểm tra email và thử lại!";
                }
            }
        }

        request.setAttribute("forgotMessage", forgotMessage);
        request.setAttribute("forgotMessageType", forgotMessageType);
        request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
    }

    private User findUserByIdentifier(String identifier) {
        String sql = "SELECT MaUser, Email FROM Users WHERE Email = ? OR SoDienThoai = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, identifier);
            ps.setString(2, identifier);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setMaUser(rs.getInt("MaUser"));
                user.setEmail(rs.getString("Email"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private String generateVerificationCode() {
        Random random = new Random();
        return String.format("%06d", random.nextInt(1000000));
    }

    private boolean sendVerificationEmail(String toEmail, String code) {
        final String fromEmail = "namanh272xh@gmail.com";
        final String appPassword = "vrxw eekw qvlz fldh";

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com"); // ✅ Thêm dòng này

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, appPassword);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("=?UTF-8?B?" + java.util.Base64.getEncoder().encodeToString(
                "Mã khôi phục mật khẩu - Sports Shop".getBytes("UTF-8")) + "?=");
            
            // ✅ Sửa email content dùng HTML đúng chuẩn
            String emailContent = 
                "<html><body style='font-family: Arial, sans-serif;'>" +
                "<h2 style='color: #2196F3;'>🔐 Khôi phục mật khẩu</h2>" +
                "<p>Chào bạn,</p>" +
                "<p>Mã xác nhận khôi phục mật khẩu của bạn là:</p>" +
                "<div style='background: #f5f5f5; padding: 15px; text-align: center; margin: 20px 0;'>" +
                "<h1 style='color: #d32f2f; letter-spacing: 5px; margin: 0;'>" + code + "</h1>" +
                "</div>" +
                "<p><strong>⏰ Mã có hiệu lực trong 5 phút.</strong></p>" +
                "<p>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.</p>" +
                "<hr style='border: none; border-top: 1px solid #ddd; margin: 20px 0;'>" +
                "<p style='color: #666; font-size: 12px;'>Trân trọng,<br><strong>Sports Shop Team</strong></p>" +
                "</body></html>";

            message.setContent(emailContent, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("✅ Email sent successfully to: " + toEmail);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("❌ Failed to send email: " + e.getMessage());
            return false;
        }
    }
}