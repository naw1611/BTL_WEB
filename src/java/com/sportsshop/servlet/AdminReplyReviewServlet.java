package com.sportsshop.servlet;

import Connection.DatabaseConnection;
import com.sportsshop.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class AdminReplyReviewServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // ✅ CHỈ ADMIN MỚI TRẢ LỜI ĐƯỢC
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("login");
            return;
        }

        String maReview = request.getParameter("maReview");
        String maSP = request.getParameter("maSP");
        String adminReply = request.getParameter("adminReply");

        // ✅ VALIDATE
        if (maReview == null || adminReply == null || adminReply.trim().isEmpty()) {
            session.setAttribute("reviewError", "Nội dung trả lời không được để trống!");
            response.sendRedirect("product-detail?id=" + maSP);
            return;
        }

        if (adminReply.trim().length() < 10) {
            session.setAttribute("reviewError", "Nội dung trả lời phải có ít nhất 10 ký tự!");
            response.sendRedirect("product-detail?id=" + maSP);
            return;
        }

        if (adminReply.trim().length() > 500) {
            session.setAttribute("reviewError", "Nội dung trả lời không được vượt quá 500 ký tự!");
            response.sendRedirect("product-detail?id=" + maSP);
            return;
        }

        // ✅ LƯU PHẢN HỒI
        String sql = "UPDATE Reviews SET AdminReply = ?, AdminReplyDate = NOW() WHERE MaReview = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, adminReply.trim());
            ps.setInt(2, Integer.parseInt(maReview));
            
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                session.setAttribute("reviewSuccess", "✅ Đã trả lời đánh giá thành công!");
            } else {
                session.setAttribute("reviewError", "Trả lời đánh giá thất bại. Vui lòng thử lại!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("reviewError", "Lỗi hệ thống: " + e.getMessage());
        }

        response.sendRedirect("product-detail?id=" + maSP);
    }
}