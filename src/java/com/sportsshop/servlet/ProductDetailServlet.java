package com.sportsshop.servlet;
import Connection.DatabaseConnection;
import com.sportsshop.model.Product;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
public class ProductDetailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
        // Lấy tham số id từ URL
        String idParam = request.getParameter("id");
       
        // Validate
        if (idParam == null || idParam.trim().isEmpty()) {
            request.setAttribute("message", "Mã sản phẩm không hợp lệ!");
            request.getRequestDispatcher("jsp/product-detail.jsp").forward(request, response);
            return;
        }
       
        Product product = null;
       
        String sql = """
            SELECT 
                sp.MaSP, sp.TenSP, sp.CodeSP, sp.Gia, sp.HinhAnh, sp.MoTa, sp.MaDanhMuc,
                COALESCE(km.PhanTramGiam, 0) AS PhanTramGiam
            FROM SanPham sp
            LEFT JOIN KhuyenMai km ON sp.MaKM = km.MaKM
                AND km.NgayBatDau <= CURDATE()
                AND km.NgayKetThuc >= CURDATE()
            WHERE sp.MaSP = ?
            """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
           
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
               
                // === LẤY % GIẢM & TÍNH GIÁ KHUYẾN MÃI ===
                int phanTramGiam = rs.getInt("PhanTramGiam");
                product.setPhanTramGiam(phanTramGiam);

                double giaKhuyenMai = product.getGia() * (1 - phanTramGiam / 100.0);
                product.setGiaKhuyenMai(Math.round(giaKhuyenMai * 100.0) / 100.0);

                // Debug
                System.out.println("CHI TIẾT SP: " + product.getTenSP() +
                                   " | Giá gốc: " + product.getGia() +
                                   " | Giảm: " + phanTramGiam + "%" +
                                   " | Giá KM: " + product.getGiaKhuyenMai());
            }
           
        } catch (NumberFormatException e) {
            e.printStackTrace();
            System.out.println("Invalid product ID format: " + idParam);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error loading product: " + e.getMessage());
        }
       
        request.setAttribute("product", product);
        request.getRequestDispatcher("jsp/product-detail.jsp").forward(request, response);
    }
}