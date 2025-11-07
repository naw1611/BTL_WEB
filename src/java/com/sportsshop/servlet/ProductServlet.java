package com.sportsshop.servlet;

import Connection.DatabaseConnection;
import com.sportsshop.model.Product;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ProductServlet extends HttpServlet {
    private static final int PAGE_SIZE = 9;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Product> products = new ArrayList<>();
        String search = request.getParameter("search");
        String category = request.getParameter("category");
        String pageParam = request.getParameter("page");
        int currentPage = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        int offset = (currentPage - 1) * PAGE_SIZE;

        // === XÂY DỰNG SQL ĐỘNG ===
        StringBuilder sql = new StringBuilder("SELECT sp.*, km.PhanTramGiam " + // Lấy thêm cột PhanTramGiam
            "FROM SanPham sp " +
            "LEFT JOIN KhuyenMai km ON sp.MaKM = km.MaKM " + // JOIN 2 bảng
            "    AND km.NgayBatDau <= CURDATE() " + // Điều kiện KM còn hạn
            "    AND km.NgayKetThuc >= CURDATE() " +
            "WHERE 1=1" // Bắt đầu lọc
        );
        StringBuilder countSql = new StringBuilder("SELECT COUNT(*) FROM SanPham WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            String pattern = "%" + search.trim() + "%";
            sql.append(" AND (TenSP LIKE ? OR CodeSP LIKE ?)");
            countSql.append(" AND (TenSP LIKE ? OR CodeSP LIKE ?)");
            params.add(pattern);
            params.add(pattern);
        }
        if (category != null && !category.isEmpty()) {
            sql.append(" AND MaDanhMuc = ?");
            countSql.append(" AND MaDanhMuc = ?");
            params.add(Integer.parseInt(category));
        }

        sql.append(" LIMIT ? OFFSET ?");
        params.add(PAGE_SIZE);
        params.add(offset);

        // === TÍNH TỔNG SỐ TRANG ===
        int totalProducts = 0;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(countSql.toString())) {
            for (int i = 0; i < params.size() - 2; i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) totalProducts = rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);

        // === LẤY DANH SÁCH SẢN PHẨM ===
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setMaSP(rs.getInt("MaSP"));
                p.setTenSP(rs.getString("TenSP"));
                p.setCodeSP(rs.getString("CodeSP"));
                p.setGia(rs.getDouble("Gia"));
                p.setHinhAnh(rs.getString("HinhAnh"));
                p.setMoTa(rs.getString("MoTa"));
                p.setMaDanhMuc(rs.getInt("MaDanhMuc"));
                // ✅ SỬA LỖI 3: Lấy % giảm và tính giá mới
                int phanTramGiam = rs.getInt("PhanTramGiam"); // Sẽ là 0 nếu LEFT JOIN không thấy
                p.setPhanTramGiam(phanTramGiam);
                
                if (phanTramGiam > 0) {
                    double giaKhuyenMai = p.getGia() * (1 - phanTramGiam / 100.0);
                    p.setGiaKhuyenMai(Math.round(giaKhuyenMai)); // Làm tròn
                }
                 products.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // === GỬI DỮ LIỆU QUA JSP ===
        request.setAttribute("products", products);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("jsp/products.jsp").forward(request, response);
    }
}