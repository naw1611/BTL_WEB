package com.sportsshop.servlet;

import Connection.DatabaseConnection;
import com.sportsshop.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


public class BuyNowServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("message", "Vui lòng đăng nhập trước khi mua hàng!");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
            return;
        }

        try {
            int maSP = Integer.parseInt(request.getParameter("maSP"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            Product product = null;

            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(
                         "SELECT MaSP, TenSP, CodeSP, Gia, HinhAnh FROM SanPham WHERE MaSP = ?")) {

                stmt.setInt(1, maSP);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    // ✅ Dùng SETTER – vì Product.java không có constructor
                    product = new Product();
                    product.setMaSP(rs.getInt("MaSP"));
                    product.setTenSP(rs.getString("TenSP"));
                    product.setCodeSP(rs.getString("CodeSP"));
                    product.setGia(rs.getDouble("Gia"));
                    product.setHinhAnh(rs.getString("HinhAnh"));
                }
            }

            if (product == null) {
                request.setAttribute("message", "Sản phẩm không tồn tại!");
                request.setAttribute("messageType", "error");
                request.getRequestDispatcher("jsp/products.jsp").forward(request, response);
                return;
            }

            // ✅ Gửi dữ liệu sang checkout.jsp – Buy Now Mode
            request.setAttribute("buyNowProduct", product);
            request.setAttribute("buyNowQuantity", quantity);
            request.setAttribute("totalPrice", product.getGia() * quantity);

            request.getRequestDispatcher("jsp/checkout.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Lỗi xử lý dữ liệu!");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("jsp/products.jsp").forward(request, response);
        }
    }
}
