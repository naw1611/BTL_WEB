package com.sportsshop.servlet;

import Connection.DatabaseConnection;
import com.sportsshop.dao.OrderDAO;
import com.sportsshop.model.Order;
import com.sportsshop.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.sql.*;
import java.util.List;

@MultipartConfig(fileSizeThreshold = 1024*1024, maxFileSize = 1024*1024*5, maxRequestSize = 1024*1024*10)
public class OrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ... (TOÀN BỘ CODE doPost CỦA BẠN - GIỮ NGUYÊN KHÔNG THAY ĐỔI) ...
        // ... (Logic tạo đơn hàng, trừ kho, v.v.) ...

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

        Part filePart = null;
        String anhChuyenKhoan = null;

        if ("Bank".equals(paymentMethod)) {
            filePart = request.getPart("anhChuyenKhoan");
            if (filePart == null || filePart.getSize() == 0) {
                session.setAttribute("checkoutError", "Vui lòng upload ảnh chuyển khoản!");
                redirectBack(request, response, isBuyNow);
                return;
            }
        }

        Connection conn = null;
        PreparedStatement psDonHang = null;
        PreparedStatement psChiTiet = null;
        PreparedStatement psDeleteCart = null;
        ResultSet generatedKeys = null;

        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            int maDonHang = 0;
            double tongTien = 0.0;

            if (isBuyNow) {
                int maSP = Integer.parseInt(request.getParameter("maSP"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                double donGia = getProductPrice(conn, maSP);
                if (donGia == 0.0) throw new Exception("Sản phẩm không hợp lệ.");
                tongTien = donGia * quantity;
                checkAndReduceStock(conn, maSP, quantity);

                maDonHang = createOrderHeader(conn, maUser, tongTien, address, phone, customerName);
                insertOrderDetail(conn, maDonHang, maSP, quantity, donGia);

            } else {
                String[] selectedProducts = request.getParameterValues("selectedProducts");
                if (selectedProducts == null || selectedProducts.length == 0) {
                    throw new Exception("Vui lòng chọn sản phẩm!");
                }

                for (String maSPStr : selectedProducts) {
                    int maSP = Integer.parseInt(maSPStr);
                    int soLuong = getCartQuantity(conn, maUser, maSP);
                    double donGia = getProductPrice(conn, maSP);
                    tongTien += donGia * soLuong;
                }

                maDonHang = createOrderHeader(conn, maUser, tongTien, address, phone, customerName);

                for (String maSPStr : selectedProducts) {
                    int maSP = Integer.parseInt(maSPStr);
                    int soLuong = getCartQuantity(conn, maUser, maSP);
                    double donGia = getProductPrice(conn, maSP);
                    checkAndReduceStock(conn, maSP, soLuong);
                    insertOrderDetail(conn, maDonHang, maSP, soLuong, donGia);
                }
                
                deleteCartItems(conn, maUser, selectedProducts);
                session.setAttribute("cartCount", getRemainingCartCount(conn, maUser));
            }

            // XỬ LÝ THANH TOÁN (ĐÃ SỬA TỪ LẦN TRƯỚC)
            if ("Bank".equals(paymentMethod)) {
                String fileName = maDonHang + "_" + extractFileName(filePart);
                String uploadPath = getServletContext().getRealPath("") + "uploads/chuyen-khoan/";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                filePart.write(uploadPath + fileName);
                anhChuyenKhoan = "uploads/chuyen-khoan/" + fileName;
                
                updatePaymentInfo(conn, maDonHang, "Chuyển khoản", anhChuyenKhoan);
                
                conn.commit();
                session.setAttribute("maOrder", maDonHang);
                session.setAttribute("totalAmount", tongTien);
                session.setAttribute("phuongThucThanhToan", "Chuyển khoản");
                
                response.sendRedirect(request.getContextPath() + "/jsp/order-success.jsp");

            } else if ("COD".equals(paymentMethod)) {
                updatePaymentInfo(conn, maDonHang, "COD", null);
                
                conn.commit();
                session.setAttribute("maOrder", maDonHang);
                session.setAttribute("totalAmount", tongTien);
                session.setAttribute("phuongThucThanhToan", "COD");

                response.sendRedirect(request.getContextPath() + "/jsp/order-success.jsp");

            } else if ("VNPAY".equals(paymentMethod)) {
                updatePaymentInfo(conn, maDonHang, "VNPAY", null);
                conn.commit();
                
                String vnpayUrl = request.getContextPath() + "/vnpayPaymentServlet?orderId=" + maDonHang + "&amount=" + (long)tongTien;
                response.sendRedirect(vnpayUrl);

            } else {
                throw new Exception("Phương thức thanh toán không hợp lệ: " + paymentMethod);
            }

        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace(); // In lỗi ra log server
            session.setAttribute("checkoutError", "Lỗi: " + e.getMessage());
            redirectBack(request, response, isBuyNow);
        } finally {
            closeResources(generatedKeys, psDeleteCart, psChiTiet, psDonHang, conn);
        }
    }

    /**
     * Xử lý việc xem danh sách đơn hàng (action=view)
     * 🔴 [ĐÃ SỬA] Thêm logic cho action=cancel
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        
        String action = request.getParameter("action");
        
        if ("view".equals(action)) {
            
            try {
                OrderDAO orderDAO = new OrderDAO();
                List<Order> orderList = orderDAO.getOrdersByUserId(user.getMaUser());
                
                request.setAttribute("orderList", orderList);
                
                // Kiểm tra xem có thông báo (từ hàm hủy đơn) không
                String cancelMessage = (String) session.getAttribute("cancelMessage");
                if (cancelMessage != null) {
                    request.setAttribute("message", cancelMessage);
                    session.removeAttribute("cancelMessage");
                }
                
                request.getRequestDispatcher("jsp/orders.jsp").forward(request, response);
                
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/products");
            }
            
        } 
        // 🟢 [THÊM MỚI] Logic xử lý hủy đơn
        else if ("cancel".equals(action)) {
            cancelOrder(request, response, user.getMaUser());
        } 
        // ---
        else {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }

    // 🟢 [HÀM MỚI] XỬ LÝ HỦY ĐƠN VÀ HOÀN KHO
    private void cancelOrder(HttpServletRequest request, HttpServletResponse response, int maUser)
        throws ServletException, IOException {
        
        String maDonStr = request.getParameter("id");
        if (maDonStr == null || maDonStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/order?action=view");
            return;
        }

        int maDon = Integer.parseInt(maDonStr);
        HttpSession session = request.getSession();
        Connection conn = null;
        PreparedStatement psGetItems = null;
        PreparedStatement psUpdateStock = null;
        PreparedStatement psCancelOrder = null;
        ResultSet rsItems = null;

        // SQL để lấy chi tiết sản phẩm trong đơn
        String sqlGetItems = "SELECT MaSP, SoLuong FROM ChiTietDonHang WHERE MaDon = ?";
        
        // SQL để cập nhật (cộng) lại số lượng tồn kho
        String sqlUpdateStock = "UPDATE SanPham SET SoLuong = SoLuong + ? WHERE MaSP = ?";
        
        // SQL để hủy đơn (QUAN TRỌNG: Thêm 'AND MaUser = ?' để bảo mật)
        // Chỉ hủy đơn nếu trạng thái là "Đã đặt"
        String sqlCancelOrder = "UPDATE DonHang SET TrangThai = 'Đã hủy' " +
                                "WHERE MaDon = ? AND MaUser = ? AND TrangThai = 'Đã đặt'";

        try {
            conn = DatabaseConnection.getConnection();
            // BẮT ĐẦU TRANSACTION
            conn.setAutoCommit(false); 

            // 1. Lấy tất cả sản phẩm và số lượng trong đơn hàng
            psGetItems = conn.prepareStatement(sqlGetItems);
            psGetItems.setInt(1, maDon);
            rsItems = psGetItems.executeQuery();

            // 2. Chuẩn bị câu lệnh batch để hoàn kho
            psUpdateStock = conn.prepareStatement(sqlUpdateStock);
            
            while (rsItems.next()) {
                int maSP = rsItems.getInt("MaSP");
                int soLuong = rsItems.getInt("SoLuong");
                
                psUpdateStock.setInt(1, soLuong);    // SoLuong = SoLuong + ?
                psUpdateStock.setInt(2, maSP);      // WHERE MaSP = ?
                psUpdateStock.addBatch(); // Thêm vào lô
            }
            
            // 3. Thực thi hoàn kho (chạy batch update)
            psUpdateStock.executeBatch(); 

            // 4. Cập nhật trạng thái đơn hàng thành "Đã hủy"
            psCancelOrder = conn.prepareStatement(sqlCancelOrder);
            psCancelOrder.setInt(1, maDon);
            psCancelOrder.setInt(2, maUser); // Đảm bảo user này sở hữu đơn hàng
            int rowsAffected = psCancelOrder.executeUpdate();

            if (rowsAffected > 0) {
                // 5. Nếu mọi thứ thành công, LƯU VĨNH VIỄN thay đổi
                conn.commit(); 
                session.setAttribute("cancelMessage", "Đã hủy thành công đơn hàng #" + maDon);
            } else {
                // Đơn hàng không tồn tại, HOẶC không thuộc về user này, HOẶC đã được giao/hủy
                conn.rollback();
                session.setAttribute("cancelMessage", "Không thể hủy đơn hàng #" + maDon + ". Đơn hàng có thể đã được xử lý hoặc không tồn tại.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            // 6. Nếu có bất kỳ lỗi nào, HỦY BỎ mọi thay đổi
            if (conn != null) {
                try {
                    conn.rollback();
                    System.out.println("Rollback do lỗi: " + e.getMessage());
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            session.setAttribute("cancelMessage", "Lỗi khi hủy đơn hàng: " + e.getMessage());
        } finally {
            // 7. Đóng tất cả kết nối và bật lại auto-commit
            try { if (rsItems != null) rsItems.close(); } catch (SQLException e) { /* ignored */ }
            try { if (psGetItems != null) psGetItems.close(); } catch (SQLException e) { /* ignored */ }
            try { if (psUpdateStock != null) psUpdateStock.close(); } catch (SQLException e) { /* ignored */ }
            try { if (psCancelOrder != null) psCancelOrder.close(); } catch (SQLException e) { /* ignored */ }
            try { 
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) { /* ignored */ }
        }
        
        // 8. Chuyển hướng người dùng về trang danh sách đơn hàng
        response.sendRedirect(request.getContextPath() + "/order?action=view");
    }

    // === CÁC HÀM HELPER CÒN LẠI (GIỮ NGUYÊN) ===

    private int createOrderHeader(Connection conn, int maUser, double tongTien, String address, String phone, String name)
            throws SQLException {
        String sql = "INSERT INTO DonHang (MaUser, TongTien, NgayDat, TrangThai, DiaChiGiao, SDT, TenNguoiNhan) " +
                     "VALUES (?, ?, NOW(), 'Đã đặt', ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, maUser);
            ps.setDouble(2, tongTien);
            ps.setString(3, address);
            ps.setString(4, phone);
            ps.setString(5, name);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    private void insertOrderDetail(Connection conn, int maDon, int maSP, int qty, double price) throws SQLException {
        String sql = "INSERT INTO ChiTietDonHang (MaDon, MaSP, SoLuong, DonGia) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maDon);
            ps.setInt(2, maSP);
            ps.setInt(3, qty);
            ps.setDouble(4, price);
            ps.executeUpdate();
        }
    }

    private void updatePaymentInfo(Connection conn, int maDon, String method, String image) throws SQLException {
        String sql = "UPDATE DonHang SET PhuongThucThanhToan = ?, AnhChuyenKhoan = ? WHERE MaDon = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, method);
            ps.setString(2, image);
            ps.setInt(3, maDon);
            ps.executeUpdate();
        }
    }

    private void deleteCartItems(Connection conn, int maUser, String[] selectedProducts) throws SQLException {
        String sql = "DELETE FROM CartItems WHERE MaUser = ? AND MaSP = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (String maSPStr : selectedProducts) {
                ps.setInt(1, maUser);
                ps.setInt(2, Integer.parseInt(maSPStr));
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String token : contentDisp.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1).replace("\"", "");
            }
        }
        return "chuyenkhoan_" + System.currentTimeMillis() + ".jpg";
    }

    private void redirectBack(HttpServletRequest req, HttpServletResponse res, boolean isBuyNow) throws IOException {
        String contextPath = req.getContextPath();
        if (isBuyNow) {
            String params = String.format("maSP=%s&quantity=%s&buyNow=true",
                    req.getParameter("maSP"), req.getParameter("quantity"));
            res.sendRedirect(contextPath + "/checkout?" + params);
        } else {
            HttpSession session = req.getSession();
            session.setAttribute("selectedProductsForCheckout", req.getParameterValues("selectedProducts"));
            res.sendRedirect(contextPath + "/checkout");
        }
    }

    private void closeResources(AutoCloseable... resources) {
        for (AutoCloseable r : resources) {
            if (r != null) try { r.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
    
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