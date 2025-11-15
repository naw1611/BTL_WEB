package com.sportsshop.servlet;

import Connection.DatabaseConnection;
import com.sportsshop.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.*;

public class AdminProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                loadCategories(request);
                loadPromotions(request);
                request.getRequestDispatcher("jsp/product-add.jsp").forward(request, response);
                break;

            case "edit":
                showEditForm(request, response);
                break;

            case "delete":
                deleteProduct(request, response);
                break;

            default:
                listProducts(request, response);
                break;
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Product> products = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM SanPham WHERE DaXoa = 0 ORDER BY MaSP DESC")) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setMaSP(rs.getInt("MaSP"));
                p.setTenSP(rs.getString("TenSP"));
                p.setCodeSP(rs.getString("CodeSP"));
                p.setGia(rs.getDouble("Gia"));
                p.setSoLuong(rs.getInt("SoLuong"));
                p.setHinhAnh(rs.getString("HinhAnh"));
                p.setMoTa(rs.getString("MoTa"));
                products.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "❌ Lỗi khi tải danh sách sản phẩm!");
        }

        request.setAttribute("products", products);
        request.getRequestDispatcher("jsp/product-list.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM SanPham WHERE MaSP = ?")) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Product p = new Product();
                p.setMaSP(rs.getInt("MaSP"));
                p.setTenSP(rs.getString("TenSP"));
                p.setGia(rs.getDouble("Gia"));
                p.setSoLuong(rs.getInt("SoLuong"));
                p.setMoTa(rs.getString("MoTa"));
                p.setMaDanhMuc(rs.getInt("MaDanhMuc"));
                p.setHinhAnh(rs.getString("HinhAnh"));
                p.setMaKM(rs.getInt("MaKM"));
                request.setAttribute("product", p);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        loadCategories(request);
        loadPromotions(request);

        request.getRequestDispatcher("jsp/product-edit.jsp").forward(request, response);
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE SanPham SET DaXoa = 1 WHERE MaSP = ?")) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("adminProduct?action=list");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("insert".equals(action)) {
            addProduct(request, response);
        } else if ("update".equals(action)) {
            updateProduct(request, response);
        }
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String tenSP = request.getParameter("tenSP");
        String codeSP = request.getParameter("codeSP");
        double gia = Double.parseDouble(request.getParameter("gia"));
        int soLuong = Integer.parseInt(request.getParameter("soLuong"));
        String moTa = request.getParameter("moTa");
        int maDanhMuc = Integer.parseInt(request.getParameter("maDanhMuc"));
        String hinhAnh = request.getParameter("hinhAnh");

        String maKMStr = request.getParameter("maKM");
        Integer maKM = (maKMStr == null || maKMStr.isEmpty()) ? null : Integer.parseInt(maKMStr);

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "INSERT INTO SanPham (TenSP, CodeSP, Gia, SoLuong, MoTa, HinhAnh, MaDanhMuc, MaKM, DaXoa) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0)")) {

            ps.setString(1, tenSP);
            ps.setString(2, codeSP);
            ps.setDouble(3, gia);
            ps.setInt(4, soLuong);
            ps.setString(5, moTa);
            ps.setString(6, hinhAnh);
            ps.setInt(7, maDanhMuc);

            if (maKM == null) ps.setNull(8, java.sql.Types.INTEGER);
            else ps.setInt(8, maKM);

            ps.executeUpdate();

            response.sendRedirect("adminProduct?action=list");

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi khi thêm sản phẩm!");
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String tenSP = request.getParameter("tenSP");
        double gia = Double.parseDouble(request.getParameter("gia"));
        int soLuong = Integer.parseInt(request.getParameter("soLuong"));
        String moTa = request.getParameter("moTa");
        String hinhAnh = request.getParameter("hinhAnh");
        int maDanhMuc = Integer.parseInt(request.getParameter("maDanhMuc"));

        String maKMStr = request.getParameter("maKM");
        Integer maKM = (maKMStr == null || maKMStr.isEmpty()) ? null : Integer.parseInt(maKMStr);

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "UPDATE SanPham SET TenSP=?, Gia=?, SoLuong=?, MoTa=?, HinhAnh=?, MaDanhMuc=?, MaKM=? WHERE MaSP=?")) {

            ps.setString(1, tenSP);
            ps.setDouble(2, gia);
            ps.setInt(3, soLuong);
            ps.setString(4, moTa);
            ps.setString(5, hinhAnh);
            ps.setInt(6, maDanhMuc);

            if (maKM == null) ps.setNull(7, java.sql.Types.INTEGER);
            else ps.setInt(7, maKM);

            ps.setInt(8, id);
            ps.executeUpdate();

            response.sendRedirect("adminProduct?action=list");

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi khi cập nhật sản phẩm!");
        }
    }

    private void loadCategories(HttpServletRequest request) {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM DanhMuc")) {

            ResultSet rs = ps.executeQuery();
            List<Map<String, Object>> categories = new ArrayList<>();

            while (rs.next()) {
                Map<String, Object> cat = new HashMap<>();
                cat.put("MaDanhMuc", rs.getInt("MaDanhMuc"));
                cat.put("TenDanhMuc", rs.getString("TenDanhMuc"));
                categories.add(cat);
            }

            request.setAttribute("categories", categories);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void loadPromotions(HttpServletRequest request) {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM KhuyenMai")) {

            ResultSet rs = ps.executeQuery();
            List<Map<String, Object>> promotions = new ArrayList<>();

            while (rs.next()) {
                Map<String, Object> km = new HashMap<>();
                km.put("MaKM", rs.getInt("MaKM"));
                km.put("TenKM", rs.getString("TenKM"));
                km.put("PhanTramGiam", rs.getDouble("PhanTramGiam"));
                promotions.add(km);
            }

            request.setAttribute("promotions", promotions);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
