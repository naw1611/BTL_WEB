package com.sportsshop.servlet;

import Connection.DatabaseConnection;
import com.sportsshop.model.CartItem;
import com.sportsshop.model.Product;
import com.sportsshop.model.User;
import org.json.JSONObject;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        
        // ✅ [THÊM MỚI] Lấy lỗi (nếu có) từ OrderServlet
        String errorMessage = (String) session.getAttribute("checkoutError");
        if (errorMessage != null) {
            request.setAttribute("message", errorMessage);
            request.setAttribute("messageType", "error");
            session.removeAttribute("checkoutError"); // Xóa lỗi sau khi hiển thị
        }
        
        String path = request.getServletPath();
        String isBuyNow = request.getParameter("buyNow");

        // =======================================================
        // === 💡 LOGIC XỬ LÝ "MUA NGAY" (BUY NOW) ===
        // =======================================================
        if ("true".equals(isBuyNow) && path.equals("/checkout")) {
            
            try {
                int maSP = Integer.parseInt(request.getParameter("maSP"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                
                Product product = getProductById(maSP);
                
                if (product == null) {
                    response.sendRedirect("products");
                    return;
                }
                
                // ✅ [THÊM MỚI] Kiểm tra tồn kho trước khi cho vào checkout "Mua Ngay"
                if (product.getSoLuong() < quantity) {
                    session.setAttribute("checkoutError", "Sản phẩm [" + product.getTenSP() + "] không đủ số lượng tồn kho (chỉ còn " + product.getSoLuong() + ").");
                    response.sendRedirect("products"); // Hoặc quay lại trang chi tiết SP
                    return;
                }

                List<CartItem> cartItems = new ArrayList<>();
                CartItem item = new CartItem();
                item.setSoLuong(quantity);
                item.setProduct(product);
                cartItems.add(item);
                
                double price = (product.getPhanTramGiam() > 0)
        ? product.getGiaKhuyenMai()
        : product.getGia();
double totalCart = price * quantity;


                request.setAttribute("cartItems", cartItems);
                request.setAttribute("totalCart", totalCart);
                request.setAttribute("isBuyNowCheckout", true); 

                request.getRequestDispatcher("jsp/checkout.jsp").forward(request, response);
                return;

            } catch (NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect("products");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("products");
                return;
            }
        }

        // =======================================================
        // === 💡 LOGIC GIỎ HÀNG (TỪ CSDL) ===
        // =======================================================
        
        int maUser = ((User) session.getAttribute("user")).getMaUser();
        
        // ✅ LẤY DANH SÁCH SẢN PHẨM ĐÃ CHỌN (nếu có)
        String[] selectedProducts = request.getParameterValues("selectedProducts");
        if (selectedProducts == null || selectedProducts.length == 0) {
             // Lấy từ attribute (khi POST /checkout)
            selectedProducts = (String[]) request.getAttribute("selectedProducts");
        }
         // ✅ [THÊM MỚI] Lấy từ session (khi OrderServlet bị lỗi và redirect về)
        if (selectedProducts == null || selectedProducts.length == 0) {
            selectedProducts = (String[]) session.getAttribute("selectedProductsForCheckout");
            if (selectedProducts != null) {
                session.removeAttribute("selectedProductsForCheckout");
            }
        }
        
        List<CartItem> cartItems = new ArrayList<>();
        double totalCart = 0.0;

        try (Connection conn = DatabaseConnection.getConnection()) {
            
            String sql;
            PreparedStatement stmt;
            
            // Nếu có selectedProducts, chỉ lấy các sản phẩm đó
            if (selectedProducts != null && selectedProducts.length > 0) {
                StringBuilder placeholders = new StringBuilder();
                for (int i = 0; i < selectedProducts.length; i++) {
                    placeholders.append("?");
                    if (i < selectedProducts.length - 1) {
                        placeholders.append(",");
                    }
                }
                
                sql = """
                    SELECT 
                        ci.MaCart, ci.MaUser, ci.MaSP, ci.SoLuong,
                        sp.TenSP, sp.CodeSP, sp.Gia, sp.HinhAnh, sp.SoLuong AS SoLuongTon,
                        COALESCE(km.PhanTramGiam, 0) AS PhanTramGiam
                    FROM CartItems ci
                    JOIN SanPham sp ON ci.MaSP = sp.MaSP
                    LEFT JOIN KhuyenMai km ON sp.MaKM = km.MaKM
                        AND km.NgayBatDau <= CURDATE()
                        AND km.NgayKetThuc >= CURDATE()
                    WHERE ci.MaUser = ? AND ci.MaSP IN (""" + placeholders + ")";
                
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, maUser);
                
                for (int i = 0; i < selectedProducts.length; i++) {
                    stmt.setInt(i + 2, Integer.parseInt(selectedProducts[i]));
                }
                
            } else {
                // Lấy toàn bộ giỏ hàng
                sql = """
                    SELECT 
                        ci.MaCart, ci.MaUser, ci.MaSP, ci.SoLuong,
                        sp.TenSP, sp.CodeSP, sp.Gia, sp.HinhAnh, sp.SoLuong AS SoLuongTon,
                        COALESCE(km.PhanTramGiam, 0) AS PhanTramGiam
                    FROM CartItems ci
                    JOIN SanPham sp ON ci.MaSP = sp.MaSP
                    LEFT JOIN KhuyenMai km ON sp.MaKM = km.MaKM
                        AND km.NgayBatDau <= CURDATE()
                        AND km.NgayKetThuc >= CURDATE()
                    WHERE ci.MaUser = ? """;
                
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, maUser);
            }
            
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                CartItem item = new CartItem();
                item.setMaCart(rs.getInt("MaCart"));
                item.setMaUser(rs.getInt("MaUser"));
                item.setSoLuong(rs.getInt("SoLuong"));

                Product product = new Product();
                product.setMaSP(rs.getInt("MaSP"));
                product.setTenSP(rs.getString("TenSP"));
                product.setCodeSP(rs.getString("CodeSP"));
                product.setGia(rs.getDouble("Gia"));
                product.setHinhAnh(rs.getString("HinhAnh"));
                product.setSoLuong(rs.getInt("SoLuongTon")); // Lấy số lượng tồn kho

                // TÍNH GIÁ KHUYẾN MÃI
                int phanTramGiam = rs.getInt("PhanTramGiam");
                product.setPhanTramGiam(phanTramGiam);
                double giaKM = product.getGia() * (1 - phanTramGiam / 100.0);
                product.setGiaKhuyenMai(Math.round(giaKM * 100.0) / 100.0);

                item.setProduct(product);
                cartItems.add(item);

                // DÙNG GIÁ KHUYẾN MÃI ĐỂ TÍNH TỔNG
                double price = product.getGiaKhuyenMai() > 0 ? product.getGiaKhuyenMai() : product.getGia();
                totalCart += price * item.getSoLuong();
            }
            
            stmt.close();
            
            // Cập nhật cartCount trong session (chỉ khi xem toàn bộ giỏ)
            if (selectedProducts == null) {
                int totalQty = cartItems.stream()
                                        .mapToInt(CartItem::getSoLuong)
                                        .sum();
                session.setAttribute("cartCount", totalQty);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalCart", totalCart);

        if (path.equals("/checkout")) {
            request.getRequestDispatcher("jsp/checkout.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("jsp/cart.jsp").forward(request, response);
    }

    // Helper: Lấy sản phẩm (và cả số lượng tồn kho)
    private Product getProductById(int maSP) throws SQLException {
        Product product = null;
        String sql = """
            SELECT sp.*, COALESCE(km.PhanTramGiam, 0) AS PhanTramGiam
            FROM SanPham sp
            LEFT JOIN KhuyenMai km ON sp.MaKM = km.MaKM
                AND km.NgayBatDau <= CURDATE()
                AND km.NgayKetThuc >= CURDATE()
            WHERE sp.MaSP = ?""";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, maSP);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    product = new Product();
                    product.setMaSP(rs.getInt("MaSP"));
                    product.setTenSP(rs.getString("TenSP"));
                    product.setCodeSP(rs.getString("CodeSP"));
                    product.setGia(rs.getDouble("Gia"));
                    product.setHinhAnh(rs.getString("HinhAnh"));
                    product.setSoLuong(rs.getInt("SoLuong")); // Lấy số lượng tồn
             int phanTramGiam = rs.getInt("PhanTramGiam");
                product.setPhanTramGiam(phanTramGiam);
                double giaKM = product.getGia() * (1 - phanTramGiam / 100.0);
                product.setGiaKhuyenMai(Math.round(giaKM * 100.0) / 100.0);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        }
        return product;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String path = request.getServletPath();

        // ✅ ============= XỬ LÝ POST TỪ CART.JSP ĐẾN CHECKOUT =============
        if (path.equals("/checkout")) {
            
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect("login");
                return;
            }
            
            String[] selectedProducts = request.getParameterValues("selectedProducts");
            
            if (selectedProducts == null || selectedProducts.length == 0) {
                response.sendRedirect("cart");
                return;
            }
            
            // Chuyển selectedProducts sang doGet để xử lý
            request.setAttribute("selectedProducts", selectedProducts);
            doGet(request, response);
            return;
        }

        // ============= XỬ LÝ AJAX REQUESTS (TRẢ VỀ JSON) =============
        if (path.equals("/cart") && request.getParameter("action") != null) {

            response.setContentType("application/json; charset=UTF-8");
            PrintWriter out = response.getWriter();
            JSONObject json = new JSONObject();

            if (session == null || session.getAttribute("user") == null) {
                json.put("success", false);
                json.put("message", "Vui lòng đăng nhập!");
                json.put("needLogin", true);
                out.print(json.toString());
                return;
            }

            int maUser = ((User) session.getAttribute("user")).getMaUser();
            String action = request.getParameter("action");

            try (Connection conn = DatabaseConnection.getConnection()) {

                if ("add".equals(action)) {
                    int maSP = Integer.parseInt(request.getParameter("maSP"));
                    int quantity = Integer.parseInt(request.getParameter("quantity"));

                    // ✅ [THÊM MỚI] Kiểm tra tồn kho trước khi thêm
                    int currentStock = getStock(conn, maSP);
                    if (currentStock < quantity) {
                         json.put("success", false);
                         json.put("message", "Sản phẩm không đủ số lượng (chỉ còn " + currentStock + ")!");
                         out.print(json.toString());
                         return;
                    }

                    String checkSQL = "SELECT MaCart, SoLuong FROM CartItems WHERE MaUser = ? AND MaSP = ?";
                    try (PreparedStatement checkStmt = conn.prepareStatement(checkSQL)) {
                        checkStmt.setInt(1, maUser);
                        checkStmt.setInt(2, maSP);
                        ResultSet rs = checkStmt.executeQuery();

                        if (rs.next()) {
                            int newQty = rs.getInt("SoLuong") + quantity;
                            
                             // ✅ [THÊM MỚI] Kiểm tra tồn kho khi cộng dồn
                            if (currentStock < newQty) {
                                json.put("success", false);
                                json.put("message", "Số lượng trong giỏ vượt quá tồn kho (chỉ còn " + currentStock + ")!");
                                out.print(json.toString());
                                return;
                            }
                            
                            String updateSQL = "UPDATE CartItems SET SoLuong = ? WHERE MaCart = ?";
                            try (PreparedStatement updateStmt = conn.prepareStatement(updateSQL)) {
                                updateStmt.setInt(1, newQty);
                                updateStmt.setInt(2, rs.getInt("MaCart"));
                                updateStmt.executeUpdate();
                            }
                            json.put("message", "Đã cập nhật số lượng!");
                        } else {
                            String insertSQL = "INSERT INTO CartItems (MaUser, MaSP, SoLuong) VALUES (?, ?, ?)";
                            try (PreparedStatement insertStmt = conn.prepareStatement(insertSQL)) {
                                insertStmt.setInt(1, maUser);
                                insertStmt.setInt(2, maSP);
                                insertStmt.setInt(3, quantity);
                                insertStmt.executeUpdate();
                            }
                            json.put("message", "Đã thêm vào giỏ hàng!");
                        }
                    }

                    int cartCount = getCartCount(maUser, conn);
                    session.setAttribute("cartCount", cartCount);
                    json.put("success", true);
                    json.put("cartCount", cartCount);
                }

                else if ("update".equals(action)) {
                    int maSP = Integer.parseInt(request.getParameter("maSP"));
                    int quantity = Integer.parseInt(request.getParameter("quantity"));
                    if (quantity < 1) {
                        json.put("success", false);
                        json.put("message", "Số lượng phải lớn hơn 0!");
                    } else {
                        
                        // ✅ [THÊM MỚI] Kiểm tra tồn kho khi cập nhật
                        int currentStock = getStock(conn, maSP);
                        if (currentStock < quantity) {
                            json.put("success", false);
                            json.put("message", "Số lượng vượt quá tồn kho (chỉ còn " + currentStock + ")!");
                            out.print(json.toString());
                            return;
                        }

                        String sql = "UPDATE CartItems SET SoLuong = ? WHERE MaUser = ? AND MaSP = ?";
                        try (PreparedStatement ps = conn.prepareStatement(sql)) {
                            ps.setInt(1, quantity);
                            ps.setInt(2, maUser);
                            ps.setInt(3, maSP);
                            int rows = ps.executeUpdate();
                            json.put("success", rows > 0);
                            json.put("message", rows > 0 ? "Cập nhật thành công!" : "Không tìm thấy sản phẩm!");
                        }
                    }
                }

                else if ("remove".equals(action)) {
                    int maSP = Integer.parseInt(request.getParameter("maSP"));
                    String sql = "DELETE FROM CartItems WHERE MaUser = ? AND MaSP = ?";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setInt(1, maUser);
                        ps.setInt(2, maSP);
                        ps.executeUpdate();
                    }
                    int cartCount = getCartCount(maUser, conn);
                    session.setAttribute("cartCount", cartCount);
                    json.put("success", true);
                    json.put("message", "Đã xóa sản phẩm!");
                    json.put("cartCount", cartCount);
                }

                else if ("remove-multiple".equals(action)) {
                    String[] ids = request.getParameter("maSPs").split(",");
                    String sql = "DELETE FROM CartItems WHERE MaUser = ? AND MaSP = ?";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        for (String id : ids) {
                            ps.setInt(1, maUser);
                            ps.setInt(2, Integer.parseInt(id.trim()));
                            ps.addBatch();
                        }
                        ps.executeBatch();
                    }
                    int cartCount = getCartCount(maUser, conn);
                    session.setAttribute("cartCount", cartCount);
                    json.put("success", true);
                    json.put("message", "Đã xóa " + ids.length + " sản phẩm!");
                    json.put("cartCount", cartCount);
                }

            } catch (Exception e) {
                e.printStackTrace();
                json.put("success", false);
                json.put("message", "Lỗi hệ thống!");
            }

            out.print(json.toString());
            out.flush();
            return;
        }

        // ============= XỬ LÝ FORM THÔNG THƯỜNG =============
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        response.sendRedirect("cart");
    }

    private int getCartCount(int maUser, Connection conn) throws SQLException {
        String sql = "SELECT COALESCE(SUM(SoLuong), 0) FROM CartItems WHERE MaUser = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maUser);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    // ✅ [THÊM MỚI] Hàm helper để lấy số lượng tồn kho
    private int getStock(Connection conn, int maSP) throws SQLException {
        String sql = "SELECT SoLuong FROM SanPham WHERE MaSP = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maSP);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt("SoLuong") : 0;
            }
        }
    }
}