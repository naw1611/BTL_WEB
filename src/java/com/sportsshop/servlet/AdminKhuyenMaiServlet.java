package com.sportsshop.servlet;

import com.sportsshop.dao.KhuyenMaiDAO;
import com.sportsshop.dao.ProductDAO;
import com.sportsshop.model.KhuyenMai;
import com.sportsshop.model.Product;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.SQLException;
import java.util.List;

public class AdminKhuyenMaiServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String action = req.getParameter("action");

        // === LUỒNG 1: Mở trang chọn sản phẩm riêng ===
        if ("chonSP".equals(action)) {
            try {
                int maKM = Integer.parseInt(req.getParameter("maKM"));
                // Lấy list sản phẩm để hiển thị
                List<Product> listProduct = new ProductDAO().getAll();
                
                req.setAttribute("maKM", maKM);
                req.setAttribute("listProduct", listProduct);
                
                // Chuyển sang file JSP mới
                req.getRequestDispatcher("jsp/khuyenmai-products.jsp").forward(req, resp);
                return; 
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // === LUỒNG 2: Mặc định (Hiển thị danh sách KM ở trang chủ) ===
try {
    // Lấy danh sách Khuyến Mãi
    List<KhuyenMai> list = new KhuyenMaiDAO().getAll();
    req.setAttribute("listKM", list);

    // --- THÊM ĐOẠN NÀY VÀO ---
    // Lấy danh sách Sản Phẩm để hiển thị ở cái khung "Tùy chọn"
    List<Product> listProduct = new ProductDAO().getAll();
    req.setAttribute("listProduct", listProduct);
    // -------------------------

} catch (SQLException e) {
    e.printStackTrace();
}
req.getRequestDispatcher("jsp/admin-khuyenmai.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        // === LUỒNG XỬ LÝ: Cập nhật sản phẩm cho KM cũ ===
        if ("updateProductList".equals(action)) {
            int maKM = Integer.parseInt(req.getParameter("maKM"));
            String[] selectedProductIds = req.getParameterValues("selectedProducts");
            
            try {
                new ProductDAO().updatePromotionProducts(maKM, selectedProductIds);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            // Xong thì quay về trang chủ
            resp.sendRedirect(req.getContextPath() + "/adminKhuyenMai");
            return;
        }

        // === LUỒNG XỬ LÝ: Thêm KM Mới (Giữ nguyên code cũ của bạn) ===
        // ... (Phần code thêm KM mới bạn giữ nguyên ở đây)
        String tenKM = req.getParameter("tenKM");
        String noiDung = req.getParameter("noiDung");
        String ngayBatDau = req.getParameter("ngayBatDau");
        String ngayKetThuc = req.getParameter("ngayKetThuc");
        double phanTramGiam = Double.parseDouble(req.getParameter("phanTramGiam"));

        KhuyenMai km = new KhuyenMai();
        km.setTenKM(tenKM);
        km.setNoiDung(noiDung);
        km.setNgayBatDau(java.sql.Date.valueOf(ngayBatDau));
        km.setNgayKetThuc(java.sql.Date.valueOf(ngayKetThuc));
        km.setPhanTramGiam(phanTramGiam);

        try {
            new KhuyenMaiDAO().add(km);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        resp.sendRedirect(req.getContextPath() + "/adminKhuyenMai");
    }
}