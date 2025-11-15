package com.sportsshop.servlet;

import Connection.DatabaseConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.*;

public class AdminReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Map<String, Double> revenueByMonth = new LinkedHashMap<>();
        Map<String, Double> revenueByCategory = new LinkedHashMap<>();
        List<Map<String, Object>> topProducts = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection()) {

            // === 1️⃣ Tổng doanh thu theo tháng ===
            String sqlMonth = """
                SELECT MONTH(NgayDat) AS Thang, SUM(TongTien) AS DoanhThu
                FROM DonHang
                WHERE TrangThai = 'Đã giao hàng'
                GROUP BY MONTH(NgayDat)
                ORDER BY Thang
            """;
            try (PreparedStatement ps = conn.prepareStatement(sqlMonth);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    revenueByMonth.put("Tháng " + rs.getInt("Thang"), rs.getDouble("DoanhThu"));
                }
            }

            // === 2️⃣ Doanh thu theo danh mục ===
            String sqlCategory = """
                SELECT dm.TenDanhMuc AS category, 
                       SUM(ct.SoLuong * ct.DonGia) AS totalRevenue
                FROM ChiTietDonHang ct
                JOIN SanPham sp ON ct.MaSP = sp.MaSP
                JOIN DanhMuc dm ON sp.MaDanhMuc = dm.MaDanhMuc
                JOIN DonHang dh ON ct.MaDon = dh.MaDon
                WHERE dh.TrangThai = 'Đã giao hàng'
                GROUP BY dm.TenDanhMuc
                ORDER BY totalRevenue DESC
            """;
            try (PreparedStatement ps = conn.prepareStatement(sqlCategory);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    revenueByCategory.put(rs.getString("category"), rs.getDouble("totalRevenue"));
                }
            }

            // === 3️⃣ Top 5 sản phẩm bán chạy ===
            String sqlTop = """
                SELECT sp.TenSP, SUM(ct.SoLuong) AS SoLuongBan
                FROM ChiTietDonHang ct
                JOIN SanPham sp ON ct.MaSP = sp.MaSP
                JOIN DonHang dh ON ct.MaDon = dh.MaDon
                WHERE dh.TrangThai = 'Đã giao hàng'
                GROUP BY sp.TenSP
                ORDER BY SoLuongBan DESC
                LIMIT 5
            """;
            try (PreparedStatement ps = conn.prepareStatement(sqlTop);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("tenSP", rs.getString("TenSP"));
                    item.put("soLuong", rs.getInt("SoLuongBan"));
                    topProducts.add(item);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("revenueByMonth", revenueByMonth);
        request.setAttribute("revenueByCategory", revenueByCategory);
        request.setAttribute("topProducts", topProducts);

        request.getRequestDispatcher("jsp/report-dashboard.jsp").forward(request, response);
    }
}
