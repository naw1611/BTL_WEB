package com.sportsshop.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class VerifyCodeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // ✅ Kiểm tra session hợp lệ
        if (session == null || session.getAttribute("verificationCode") == null) {
            response.sendRedirect("login");
            return;
        }
        
        // ✅ Cho phép hiển thị trang nhập mã
        request.getRequestDispatcher("jsp/verifyCode.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        // ✅ XỬ LÝ GỬI LẠI MÃ
        if ("resend".equals(action)) {
            resendCode(request, response);
            return;
        }
        
        // ✅ XỬ LÝ XÁC NHẬN MÃ
        String inputCode = request.getParameter("code");
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            response.sendRedirect("login");
            return;
        }
        
        // ✅ Validate input
        if (inputCode == null || inputCode.trim().isEmpty()) {
            request.setAttribute("message", "Vui lòng nhập mã xác nhận!");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("jsp/verifyCode.jsp").forward(request, response);
            return;
        }
        
        String storedCode = (String) session.getAttribute("verificationCode");
        
        if (storedCode != null && storedCode.equals(inputCode.trim())) {
            // ✅ Mã đúng → chuyển sang đặt lại mật khẩu
            response.sendRedirect("resetPassword");
        } else {
            // ❌ Mã sai
            request.setAttribute("message", "Mã xác nhận không đúng hoặc đã hết hạn!");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("jsp/verifyCode.jsp").forward(request, response);
        }
    }
    
    // ✅ THÊM CHỨC NĂNG GỬI LẠI MÃ
    private void resendCode(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("resetEmail") == null) {
            response.sendRedirect("login");
            return;
        }
        
        String email = (String) session.getAttribute("resetEmail");
        String newCode = generateVerificationCode();
        
        // Cập nhật mã mới
        session.setAttribute("verificationCode", newCode);
        session.setMaxInactiveInterval(300); // Reset thời gian 5 phút
        
        // Gửi email
        if (sendVerificationEmail(email, newCode)) {
            request.setAttribute("message", "Mã mới đã được gửi đến email của bạn!");
            request.setAttribute("messageType", "success");
        } else {
            request.setAttribute("message", "Gửi lại mã thất bại. Vui lòng thử lại!");
            request.setAttribute("messageType", "error");
        }
        
        request.getRequestDispatcher("jsp/verifyCode.jsp").forward(request, response);
    }
    
    private String generateVerificationCode() {
        return String.format("%06d", new java.util.Random().nextInt(1000000));
    }
    
    private boolean sendVerificationEmail(String toEmail, String code) {
        // ✅ Copy từ ForgotPasswordServlet (hoặc tạo class EmailUtil chung)
        final String fromEmail = "namanh272xh@gmail.com";
        final String appPassword = "vrxw eekw qvlz fldh";

        java.util.Properties props = new java.util.Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        jakarta.mail.Session session = jakarta.mail.Session.getInstance(props, 
            new jakarta.mail.Authenticator() {
                @Override
                protected jakarta.mail.PasswordAuthentication getPasswordAuthentication() {
                    return new jakarta.mail.PasswordAuthentication(fromEmail, appPassword);
                }
            });

        try {
            jakarta.mail.Message message = new jakarta.mail.internet.MimeMessage(session);
            message.setFrom(new jakarta.mail.internet.InternetAddress(fromEmail));
            message.setRecipients(jakarta.mail.Message.RecipientType.TO, 
                jakarta.mail.internet.InternetAddress.parse(toEmail));
            message.setSubject("=?UTF-8?B?" + java.util.Base64.getEncoder().encodeToString(
                "Mã khôi phục mật khẩu - Sports Shop".getBytes("UTF-8")) + "?=");
            
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
            jakarta.mail.Transport.send(message);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}