package com.sportsshop.servlet;

import Connection.DatabaseConnection;
import com.sportsshop.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class ReviewServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String maSP = request.getParameter("maSP");
        String soSao = request.getParameter("soSao");
        String noiDung = request.getParameter("noiDung");

        if (maSP == null || soSao == null || noiDung == null || noiDung.trim().isEmpty()) {
            session.setAttribute("reviewError", "Vui lòng điền đầy đủ thông tin!");
            response.sendRedirect(request.getContextPath() + "/product-detail?id=" + maSP);
            return;
        }

        int rating;
        try {
            rating = Integer.parseInt(soSao);
            if (rating < 1 || rating > 5 || noiDung.trim().length() < 10 || noiDung.trim().length() > 500) {
                session.setAttribute("reviewError", "Dữ liệu không hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/product-detail?id=" + maSP);
                return;
            }
        } catch (NumberFormatException e) {
            session.setAttribute("reviewError", "Số sao không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/product-detail?id=" + maSP);
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            // KIỂM TRA ĐÃ MUA
            String sqlCheck = "SELECT COUNT(*) FROM ChiTietDonHang cd JOIN DonHang d ON cd.MaDon = d.MaDon WHERE d.MaUser = ? AND cd.MaSP = ? AND d.TrangThai = 'Đã giao hàng'";
            try (PreparedStatement ps = conn.prepareStatement(sqlCheck)) {
                ps.setInt(1, user.getMaUser());
                ps.setInt(2, Integer.parseInt(maSP));
                if (ps.executeQuery().next() && ps.getResultSet().getInt(1) == 0) {
                    session.setAttribute("reviewError", "Bạn chỉ được đánh giá sản phẩm đã mua!");
                    response.sendRedirect(request.getContextPath() + "/product-detail?id=" + maSP);
                    return;
                }
            }

            // KIỂM TRA ĐÃ ĐÁNH GIÁ
            String sqlReview = "SELECT COUNT(*) FROM Reviews WHERE MaSP = ? AND MaUser = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlReview)) {
                ps.setInt(1, Integer.parseInt(maSP));
                ps.setInt(2, user.getMaUser());
                if (ps.executeQuery().next() && ps.getResultSet().getInt(1) > 0) {
                    session.setAttribute("reviewError", "Bạn đã đánh giá sản phẩm này rồi!");
                    response.sendRedirect(request.getContextPath() + "/product-detail?id=" + maSP);
                    return;
                }
            }

            // LƯU ĐÁNH GIÁ
            String sqlInsert = "INSERT INTO Reviews (MaSP, MaUser, SoSao, NoiDung, NgayDanhGia) VALUES (?, ?, ?, ?, NOW())";
            try (PreparedStatement ps = conn.prepareStatement(sqlInsert)) {
                ps.setInt(1, Integer.parseInt(maSP));
                ps.setInt(2, user.getMaUser());
                ps.setInt(3, rating);
                ps.setString(4, noiDung.trim());
                if (ps.executeUpdate() > 0) {
                    session.setAttribute("reviewSuccess", "Cảm ơn bạn đã đánh giá!");
                }
            }
        } catch (Exception e) {
            session.setAttribute("reviewError", "Lỗi hệ thống!");
        }

        response.sendRedirect(request.getContextPath() + "/product-detail?id=" + maSP);
    }
}