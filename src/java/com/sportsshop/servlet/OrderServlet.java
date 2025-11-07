package com.sportsshop.servlet;

import Connection.DatabaseConnection;
import com.sportsshop.dao.OrderDAO; // ✅ Thêm DAO import
import com.sportsshop.model.Order;   // ✅ Thêm Order import
import com.sportsshop.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.List; // ✅ Thêm List import

public class OrderServlet extends HttpServlet {

    /**
     * Xử lý việc tạo đơn hàng (từ trang checkout)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");
        int maUser = user.getMaUser();
        
        String customerName = request.getParameter("customerName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String note = request.getParameter("note");
        String paymentMethod = request.getParameter("paymentMethod");
        boolean isBuyNow = "true".equals(request.getParameter("buyNow"));

        Connection conn = null;
        PreparedStatement psDonHang = null;
        PreparedStatement psChiTiet = null;
        PreparedStatement psDeleteCart = null;
        ResultSet generatedKeys = null;

        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            int maDonHang = 0;
            double tongTien = 0.0;

            if (isBuyNow) {
                // ========== XỬ LÝ ĐƠN HÀNG "MUA NGAY" ==========
                int maSP = Integer.parseInt(request.getParameter("maSP"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                
                double donGia = getProductPrice(conn, maSP);
                if (donGia == 0.0) {
                     throw new Exception("Sản phẩm (Mã: " + maSP + ") không hợp lệ hoặc đã bị xóa.");
                }
                tongTien = donGia * quantity; 
                
                checkAndReduceStock(conn, maSP, quantity);

                // 1. Tạo đơn hàng chính
                // ✅ Sửa lỗi SQL: MaKH -> MaUser
                String sqlDonHang = "INSERT INTO DonHang (MaUser, TongTien, NgayDat, TrangThai, DiaChiGiao, SDT, TenNguoiNhan) " +
                                  "VALUES (?, ?, NOW(), 'Đã đặt', ?, ?, ?)";
                                  
                psDonHang = conn.prepareStatement(sqlDonHang, Statement.RETURN_GENERATED_KEYS);
                psDonHang.setInt(1, maUser); 
                psDonHang.setDouble(2, tongTien);
                psDonHang.setString(3, address);
                psDonHang.setString(4, phone);
                psDonHang.setString(5, customerName);
                psDonHang.executeUpdate();
                
                generatedKeys = psDonHang.getGeneratedKeys();
                if (generatedKeys.next()) {
                    maDonHang = generatedKeys.getInt(1);
                }
                
                // 2. Thêm chi tiết đơn hàng
                // ✅ Sửa lỗi SQL: MaDonHang -> MaDon
                String sqlChiTiet = "INSERT INTO ChiTietDonHang (MaDon, MaSP, SoLuong, DonGia) " +
                                   "VALUES (?, ?, ?, ?)";
                psChiTiet = conn.prepareStatement(sqlChiTiet);
                psChiTiet.setInt(1, maDonHang);
                psChiTiet.setInt(2, maSP);
                psChiTiet.setInt(3, quantity);
                psChiTiet.setDouble(4, donGia);
                psChiTiet.executeUpdate();
                
            } else {
                // ========== XỬ LÝ ĐƠN HÀNG TỪ GIỎ HÀNG ==========
                
                String[] selectedProducts = request.getParameterValues("selectedProducts");
                
                if (selectedProducts == null || selectedProducts.length == 0) {
                    throw new Exception("Vui lòng chọn sản phẩm để thanh toán!");
                }
                
                for (String maSPStr : selectedProducts) {
                    int maSP = Integer.parseInt(maSPStr);
                    int soLuong = getCartQuantity(conn, maUser, maSP);
                    double donGia = getProductPrice(conn, maSP);
                    tongTien += donGia * soLuong;
                }
                
                // 1. Tạo đơn hàng chính
                // ✅ Sửa lỗi SQL: MaKH -> MaUser
                String sqlDonHang = "INSERT INTO DonHang (MaUser, TongTien, NgayDat, TrangThai, DiaChiGiao, SDT, TenNguoiNhan) " +
                                  "VALUES (?, ?, NOW(), 'Đã đặt', ?, ?, ?)";
                                  
                psDonHang = conn.prepareStatement(sqlDonHang, Statement.RETURN_GENERATED_KEYS);
                psDonHang.setInt(1, maUser); 
                psDonHang.setDouble(2, tongTien);
                psDonHang.setString(3, address);
                psDonHang.setString(4, phone);
                psDonHang.setString(5, customerName);
                psDonHang.executeUpdate();
                
                generatedKeys = psDonHang.getGeneratedKeys();
                if (generatedKeys.next()) {
                    maDonHang = generatedKeys.getInt(1);
                }
                
                // 2. Thêm chi tiết đơn hàng VÀ KIỂM TRA KHO
                // ✅ Sửa lỗi SQL: MaDonHang -> MaDon
                String sqlChiTiet = "INSERT INTO ChiTietDonHang (MaDon, MaSP, SoLuong, DonGia) " +
                                  "VALUES (?, ?, ?, ?)";
                psChiTiet = conn.prepareStatement(sqlChiTiet);
                
                for (String maSPStr : selectedProducts) {
                    int maSP = Integer.parseInt(maSPStr);
                    int soLuong = getCartQuantity(conn, maUser, maSP);
                    double donGia = getProductPrice(conn, maSP);
                    
                    checkAndReduceStock(conn, maSP, soLuong);
                    
                    psChiTiet.setInt(1, maDonHang);
                    psChiTiet.setInt(2, maSP);
                    psChiTiet.setInt(3, soLuong);
                    psChiTiet.setDouble(4, donGia);
                    psChiTiet.addBatch();
                }
                psChiTiet.executeBatch();
                
                // 3. Xóa các sản phẩm đã đặt khỏi giỏ hàng
                String sqlDeleteCart = "DELETE FROM CartItems WHERE MaUser = ? AND MaSP = ?";
                psDeleteCart = conn.prepareStatement(sqlDeleteCart);
                
                for (String maSPStr : selectedProducts) {
                    psDeleteCart.setInt(1, maUser);
                    psDeleteCart.setInt(2, Integer.parseInt(maSPStr));
                    psDeleteCart.addBatch();
                }
                psDeleteCart.executeBatch();
                
                int remainingCount = getRemainingCartCount(conn, maUser);
                session.setAttribute("cartCount", remainingCount);
            }

            conn.commit(); 

            // Chuyển đến trang thành công
            request.setAttribute("maOrder", maDonHang);
            request.setAttribute("totalAmount", tongTien);
            request.getRequestDispatcher("jsp/order-success.jsp").forward(request, response);

        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback(); 
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            
            e.printStackTrace();
            
            session.setAttribute("checkoutError", "Lỗi khi tạo đơn hàng: " + e.getMessage());

            if (isBuyNow) {
                String redirectParams = String.format("maSP=%s&quantity=%s&buyNow=true", 
                                          request.getParameter("maSP"), 
                                          request.getParameter("quantity"));
                response.sendRedirect("checkout?" + redirectParams);
            } else {
                session.setAttribute("selectedProductsForCheckout", request.getParameterValues("selectedProducts"));
                response.sendRedirect("checkout");
            }

        } finally {
            try {
                if (generatedKeys != null) generatedKeys.close();
                if (psDeleteCart != null) psDeleteCart.close();
                if (psChiTiet != null) psChiTiet.close();
                if (psDonHang != null) psDonHang.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Xử lý việc xem danh sách đơn hàng (action=view)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // ✅ [SỬA ĐỔI] Thay thế toàn bộ hàm doGet cũ
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        User user = (User) session.getAttribute("user");
        
        String action = request.getParameter("action");
        
        if ("view".equals(action)) {
            
            // Lấy dữ liệu trước khi chuyển trang
            try {
                OrderDAO orderDAO = new OrderDAO();
                List<Order> orderList = orderDAO.getOrdersByUserId(user.getMaUser());
                
                // Gửi danh sách đơn hàng (orderList) sang JSP
                request.setAttribute("orderList", orderList);
                
                // Chuyển đến jsp/orders.jsp
                request.getRequestDispatcher("jsp/orders.jsp").forward(request, response);
                
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("products"); // Về trang chủ nếu có lỗi
            }
            
        } else {
            response.sendRedirect("products");
        }
    }

    // ========== CÁC HÀM HELPER (Không đổi) ==========

    private void checkAndReduceStock(Connection conn, int maSP, int quantity) throws SQLException, Exception {
        String selectSql = "SELECT TenSP, SoLuong FROM SanPham WHERE MaSP = ? FOR UPDATE";
        String updateSql = "UPDATE SanPham SET SoLuong = ? WHERE MaSP = ?";
        
        String productName = "Sản phẩm (ID: " + maSP + ")";
        int currentStock = 0;
        
        try (PreparedStatement selectPs = conn.prepareStatement(selectSql)) {
            selectPs.setInt(1, maSP);
            try (ResultSet rs = selectPs.executeQuery()) {
                if (rs.next()) {
                    productName = rs.getString("TenSP");
                    currentStock = rs.getInt("SoLuong");
                } else {
                    throw new Exception("Sản phẩm (ID: " + maSP + ") không tồn tại.");
                }
            }
        }

        if (currentStock < quantity) {
            throw new Exception("Sản phẩm [" + productName + "] không đủ số lượng tồn kho (bạn cần " + quantity + ", chỉ còn " + currentStock + ").");
        }
        
        int newStock = currentStock - quantity;
        
        try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
            updatePs.setInt(1, newStock);
            updatePs.setInt(2, maSP);
            updatePs.executeUpdate();
        }
    }

    private double getProductPrice(Connection conn, int maSP) throws SQLException {
        String sql = """
                    SELECT 
                        sp.Gia , km.PhanTramGiam
                    FROM SanPham sp 
                    LEFT JOIN KhuyenMai km ON sp.MaKM = km.MaKM
                        AND km.NgayBatDau <= CURDATE()
                        AND km.NgayKetThuc >= CURDATE()
                    WHERE sp.MaSP = ? """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maSP);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                double giaGoc = rs.getDouble("Gia");
                int phanTramGiam = rs.getInt("PhanTramGiam");
                if(phanTramGiam > 0){
                    double giaMoi = giaGoc * (1 - phanTramGiam/100.0);
                    return Math.round(giaMoi);
                }else
                    return giaGoc;
            }
            return 0.0;
        }
    }


    private int getCartQuantity(Connection conn, int maUser, int maSP) throws SQLException {
        String sql = "SELECT SoLuong FROM CartItems WHERE MaUser = ? AND MaSP = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maUser);
            ps.setInt(2, maSP);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt("SoLuong") : 0;
        }
    }

    private int getRemainingCartCount(Connection conn, int maUser) throws SQLException {
        String sql = "SELECT COALESCE(SUM(SoLuong), 0) FROM CartItems WHERE MaUser = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maUser);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}