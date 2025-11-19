package com.sportsshop.servlet;

import Connection.DatabaseConnection;
import com.sportsshop.model.Product;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException; // ✅ Thêm import này
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class IndexServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Product> products = new ArrayList<>(); // Danh sách Hàng Mới
        List<Product> promotionProducts = new ArrayList<>(); // Danh sách Hàng KM

        try (Connection conn = DatabaseConnection.getConnection()) {

            // ========= 1. LẤY 9 SẢN PHẨM MỚI NHẤT (Đã đúng) =========
            String sqlNew = """
                            SELECT MaSP, CodeSP, TenSP, Gia, HinhAnh 
                            FROM SanPham 
                            WHERE DaXoa = 0
                            ORDER BY MaSP DESC LIMIT 9
                                                      """;
                    

            try (PreparedStatement stmt = conn.prepareStatement(sqlNew);
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    Product p = new Product();
                    p.setMaSP(rs.getInt("MaSP"));
                    p.setCodeSP(rs.getString("CodeSP"));
                    p.setTenSP(rs.getString("TenSP"));
                    p.setGia(rs.getDouble("Gia"));
                    p.setHinhAnh(rs.getString("HinhAnh"));
                    products.add(p);
                }
            }

            // ========= 2. LẤY SẢN PHẨM KHUYẾN MÃI (ĐÃ SỬA LỖI) =========
            
            // ✅ SỬA LỖI 1: Sửa JOIN (dùng MaKM)
            String sqlPromo = "SELECT sp.MaSP, sp.CodeSP, sp.TenSP, sp.Gia, sp.HinhAnh, km.PhanTramGiam " +
                              "FROM SanPham sp " +
                              "JOIN KhuyenMai km ON sp.MaKM = km.MaKM " + // Sửa "km.MaSP" thành "km.MaKM"
                              "WHERE km.NgayBatDau <= CURDATE() " +
                              "  AND km.NgayKetThuc >= CURDATE() " +
                            // "  AND km.TrangThai = 1 " + // ✅ SỬA LỖI 2: Xóa dòng này vì cột không tồn tại
                              "ORDER BY km.PhanTramGiam DESC, sp.MaSP DESC LIMIT 9" ;

            try (PreparedStatement stmt = conn.prepareStatement(sqlPromo);
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    Product p = new Product();
                    p.setMaSP(rs.getInt("MaSP"));
                    p.setCodeSP(rs.getString("CodeSP"));
                    p.setTenSP(rs.getString("TenSP"));
                    p.setGia(rs.getDouble("Gia")); // Giá gốc
                    p.setHinhAnh(rs.getString("HinhAnh"));

                    int phanTramGiam = rs.getInt("PhanTramGiam");
                    p.setPhanTramGiam(phanTramGiam);

                    // Tính giá khuyến mại (Làm tròn về số nguyên)
                    double giaKhuyenMai = p.getGia() * (1 - phanTramGiam / 100.0);
                    p.setGiaKhuyenMai(Math.round(giaKhuyenMai)); 

                    promotionProducts.add(p);
                }
            }

        } catch (SQLException e) { // Bắt lỗi SQL cụ thể
            e.printStackTrace();
            request.setAttribute("message", "Lỗi CSDL: " + e.getMessage());
            request.setAttribute("messageType", "error");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Lỗi tải dữ liệu!");
            request.setAttribute("messageType", "error");
        }

        // ========= TRUYỀN DỮ LIỆU VÀO JSP =========
        request.setAttribute("products", products); // Danh sách hàng mới
        request.setAttribute("promotionProducts", promotionProducts); // Danh sách hàng KM

        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}