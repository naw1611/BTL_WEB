package com.sportsshop.servlet;

import Connection.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import org.mindrot.jbcrypt.BCrypt;

public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // ✅ Kiểm tra session hợp lệ
        if (session == null || session.getAttribute("resetUserId") == null) {
            response.sendRedirect("login");
            return;
        }
        
        request.getRequestDispatcher("jsp/resetPassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("resetUserId") == null) {
            response.sendRedirect("login");
            return;
        }
        
        String message;
        String messageType = "error";
        
        // ✅ Validate đầy đủ
        if (newPassword == null || newPassword.trim().isEmpty()) {
            message = "Vui lòng nhập mật khẩu mới!";
        } else if (newPassword.length() < 6) {
            message = "Mật khẩu phải có ít nhất 6 ký tự!";
        } else if (confirmPassword == null || !newPassword.equals(confirmPassword)) {
            message = "Mật khẩu xác nhận không khớp!";
        } else {
            Integer userId = (Integer) session.getAttribute("resetUserId");
            String hashed = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));
            
            String sql = "UPDATE Users SET MatKhau = ? WHERE MaUser = ?";
            
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                
                ps.setString(1, hashed);
                ps.setInt(2, userId);
                int rows = ps.executeUpdate();
                
                if (rows > 0) {
                    // ✅ Xóa toàn bộ dữ liệu tạm trong session
                    session.removeAttribute("verificationCode");
                    session.removeAttribute("resetUserId");
                    session.removeAttribute("resetEmail");
                    
                    message = "✅ Đặt lại mật khẩu thành công! Vui lòng đăng nhập lại.";
                    messageType = "success";
                    
                    request.setAttribute("message", message);
                    request.setAttribute("messageType", messageType);
                    request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
                    return;
                } else {
                    message = "Cập nhật mật khẩu thất bại! Vui lòng thử lại.";
                }
            } catch (Exception e) {
                e.printStackTrace();
                message = "Lỗi hệ thống: " + e.getMessage();
            }
        }
        
        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);
        request.getRequestDispatcher("jsp/resetPassword.jsp").forward(request, response);
    }
}