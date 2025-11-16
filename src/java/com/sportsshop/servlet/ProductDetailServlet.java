package com.sportsshop.servlet;

import Connection.DatabaseConnection;
import com.sportsshop.model.Product;
import com.sportsshop.model.Review;
import com.sportsshop.dao.CategoryDAO;
import com.sportsshop.model.Category;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class ProductDetailServlet extends HttpServlet {
    
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 🟩 Lấy danh mục cho menu trái
        List<Category> listDanhMuc = categoryDAO.getAllCategories();
        request.setAttribute("listDanhMuc", listDanhMuc);

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            request.setAttribute("message", "Mã sản phẩm không hợp lệ!");
            request.getRequestDispatcher("jsp/product-detail.jsp").forward(request, response);
            return;
        }

        Product product = null;
        List<Review> reviews = new ArrayList<>();
        double avgRating = 0;
        int totalReviews = 0;
        int[] starCounts = new int[6]; // Index 0 không dùng, 1-5 là số sao

        // === LẤY CHI TIẾT SẢN PHẨM ===
        String sqlProduct = """
            SELECT
                sp.MaSP, sp.TenSP, sp.CodeSP, sp.Gia, sp.HinhAnh, sp.MoTa, sp.MaDanhMuc,
                COALESCE(km.PhanTramGiam, 0) AS PhanTramGiam
            FROM SanPham sp
            LEFT JOIN KhuyenMai km ON sp.MaKM = km.MaKM
                AND km.NgayBatDau <= CURDATE()
                AND km.NgayKetThuc >= CURDATE()
            WHERE sp.MaSP = ?
            """;

        // === LẤY DANH SÁCH ĐÁNH GIÁ ===
        String sqlReviews = """
    SELECT r.MaReview, r.SoSao, r.NoiDung, r.NgayDanhGia, r.MaUser, 
           r.AdminReply, r.AdminReplyDate, u.FullName 
    FROM Reviews r 
    JOIN Users u ON r.MaUser = u.MaUser 
    WHERE r.MaSP = ? 
    ORDER BY r.NgayDanhGia DESC
    """;

        // === THỐNG KÊ SAO ===
        String sqlStats = """
            SELECT 
                AVG(SoSao) AS AvgRating,
                COUNT(*) AS TotalReviews,
                SUM(CASE WHEN SoSao = 5 THEN 1 ELSE 0 END) AS Star5,
                SUM(CASE WHEN SoSao = 4 THEN 1 ELSE 0 END) AS Star4,
                SUM(CASE WHEN SoSao = 3 THEN 1 ELSE 0 END) AS Star3,
                SUM(CASE WHEN SoSao = 2 THEN 1 ELSE 0 END) AS Star2,
                SUM(CASE WHEN SoSao = 1 THEN 1 ELSE 0 END) AS Star1
            FROM Reviews WHERE MaSP = ?
            """;

        try (Connection conn = DatabaseConnection.getConnection()) {

            // 1. Lấy sản phẩm
            try (PreparedStatement stmt = conn.prepareStatement(sqlProduct)) {
                stmt.setInt(1, Integer.parseInt(idParam));
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    product = new Product();
                    product.setMaSP(rs.getInt("MaSP"));
                    product.setTenSP(rs.getString("TenSP"));
                    product.setCodeSP(rs.getString("CodeSP"));
                    product.setGia(rs.getDouble("Gia"));
                    product.setHinhAnh(rs.getString("HinhAnh"));
                    product.setMoTa(rs.getString("MoTa"));
                    product.setMaDanhMuc(rs.getInt("MaDanhMuc"));

                    int phanTramGiam = rs.getInt("PhanTramGiam");
                    product.setPhanTramGiam(phanTramGiam);
                    double giaKhuyenMai = product.getGia() * (1 - phanTramGiam / 100.0);
                    product.setGiaKhuyenMai(Math.round(giaKhuyenMai * 100.0) / 100.0);
                }
            }

            // 2. Lấy thống kê sao
            if (product != null) {
                try (PreparedStatement stmt = conn.prepareStatement(sqlStats)) {
                    stmt.setInt(1, product.getMaSP());
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        avgRating = rs.getDouble("AvgRating");
                        totalReviews = rs.getInt("TotalReviews");
                        starCounts[5] = rs.getInt("Star5");
                        starCounts[4] = rs.getInt("Star4");
                        starCounts[3] = rs.getInt("Star3");
                        starCounts[2] = rs.getInt("Star2");
                        starCounts[1] = rs.getInt("Star1");
                    }
                }
            }

            // 3. Lấy đánh giá
            if (product != null) {
                try (PreparedStatement stmt = conn.prepareStatement(sqlReviews)) {
                    stmt.setInt(1, product.getMaSP());
                    ResultSet rs = stmt.executeQuery();
                    while (rs.next()) {
                        Review r = new Review();
                        r.setMaReview(rs.getInt("MaReview"));
                        r.setMaUser(rs.getInt("MaUser"));
                        r.setSoSao(rs.getInt("SoSao"));
                        r.setNoiDung(rs.getString("NoiDung"));
                        r.setNgayDanhGia(rs.getTimestamp("NgayDanhGia"));
                        r.setFullName(rs.getString("FullName"));
                        r.setAdminReply(rs.getString("AdminReply")); // ✅ THÊM
                        r.setAdminReplyDate(rs.getTimestamp("AdminReplyDate")); // ✅ THÊM
                        reviews.add(r);
                    }
                }
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            System.out.println("Invalid product ID format: " + idParam);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error loading product or reviews: " + e.getMessage());
        }

        // Gửi dữ liệu sang JSP
        request.setAttribute("product", product);
        request.setAttribute("reviews", reviews);
        request.setAttribute("avgRating", avgRating);
        request.setAttribute("totalReviews", totalReviews);
        request.setAttribute("starCounts", starCounts);
        
        request.getRequestDispatcher("jsp/product-detail.jsp").forward(request, response);
    }
}