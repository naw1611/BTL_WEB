package com.sportsshop.dao;

import Connection.DatabaseConnection;
import com.sportsshop.model.Order;
import com.sportsshop.model.OrderDetail;
import com.sportsshop.model.Product;
import com.sportsshop.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    /**
     * HÀM 1: Lấy tất cả đơn hàng của một người dùng
     * (Dùng cho trang 'orders.jsp')
     */
    public List<Order> getOrdersByUserId(int maUser) {
        List<Order> orderList = new ArrayList<>();
        String sql = "SELECT MaDon, MaUser, NgayDat, TongTien, TrangThai, DiaChiGiao, SDT, TenNguoiNhan " +
                     "FROM DonHang WHERE MaUser = ? ORDER BY NgayDat DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maUser);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order order = new Order();
                order.setMaDon(rs.getInt("MaDon"));
                order.setMaUser(rs.getInt("MaUser"));
                order.setNgayDat(rs.getTimestamp("NgayDat"));
                order.setTongTien(rs.getDouble("TongTien"));
                order.setTrangThai(rs.getString("TrangThai"));
                order.setDiaChiGiao(rs.getString("DiaChiGiao"));
                order.setSdt(rs.getString("SDT"));
                order.setTenNguoiNhan(rs.getString("TenNguoiNhan"));
                
                orderList.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orderList;
    }

    
    /**
     * HÀM 2: Lấy thông tin đơn hàng VÀ thông tin người đặt
     * (Dùng cho 'OrderDetailServlet' để tích hợp Admin & Customer)
     *
     * ✅ [ĐÃ SỬA LỖI] Đã sửa "KhachHang kh" thành "users u" để khớp CSDL.
     */
    public Order getOrderWithUser(int maDon) {
        Order order = null;
        
        // Sửa câu SQL để JOIN với bảng "users"
        String sql = "SELECT dh.*, u.FullName, u.Email " +
                     "FROM DonHang dh " +
                     "JOIN users u ON dh.MaUser = u.MaUser " +
                     "WHERE dh.MaDon = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maDon);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
    order = new Order();
    order.setMaDon(rs.getInt("MaDon"));
    order.setMaUser(rs.getInt("MaUser"));
    order.setNgayDat(rs.getTimestamp("NgayDat"));
    order.setTongTien(rs.getDouble("TongTien"));
    order.setTrangThai(rs.getString("TrangThai"));
    order.setDiaChiGiao(rs.getString("DiaChiGiao"));
    order.setSdt(rs.getString("SDT"));
    order.setTenNguoiNhan(rs.getString("TenNguoiNhan"));

    // ⭐ THÊM 2 DÒNG NÀY
    order.setPhuongThucThanhToan(rs.getString("PhuongThucThanhToan"));
    order.setAnhChuyenKhoan(rs.getString("AnhChuyenKhoan"));

    // Load User
    User user = new User();
    user.setMaUser(rs.getInt("MaUser"));
    user.setFullName(rs.getString("FullName"));
    user.setEmail(rs.getString("Email"));

    order.setUser(user);
}

        } catch (Exception e) {
            e.printStackTrace();
        }
        return order; // Bây giờ sẽ trả về đối tượng Order (không phải null)
    }

    /**
     * HÀM 3: Lấy danh sách sản phẩm trong 1 đơn hàng
     * (Dùng cho 'OrderDetailServlet')
     */
    public List<OrderDetail> getOrderDetailsByOrderId(int maDon) {
        List<OrderDetail> details = new ArrayList<>();
        // Dùng JOIN để lấy Tên SP, Hình ảnh từ bảng SanPham
        String sql = "SELECT ct.*, sp.TenSP, sp.HinhAnh, sp.CodeSP " +
                     "FROM ChiTietDonHang ct " +
                     "JOIN SanPham sp ON ct.MaSP = sp.MaSP " +
                     "WHERE ct.MaDon = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maDon);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderDetail detail = new OrderDetail();
                detail.setMaChiTiet(rs.getInt("MaChiTiet"));
                detail.setMaDon(rs.getInt("MaDon"));
                detail.setSoLuong(rs.getInt("SoLuong"));
                detail.setDonGia(rs.getDouble("DonGia"));

                Product product = new Product();
                product.setMaSP(rs.getInt("MaSP"));
                product.setTenSP(rs.getString("TenSP"));
                product.setHinhAnh(rs.getString("HinhAnh"));
                product.setCodeSP(rs.getString("CodeSP"));
                
                detail.setProduct(product);
                
                details.add(detail);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return details;
    }
}