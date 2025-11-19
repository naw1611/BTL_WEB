package com.sportsshop.dao;

import Connection.DatabaseConnection;
import com.sportsshop.model.KhuyenMai;
import java.sql.*;
import java.util.*;

public class KhuyenMaiDAO {

    public List<KhuyenMai> getAll() throws SQLException {
        List<KhuyenMai> list = new ArrayList<>();
        String sql = "SELECT * FROM KhuyenMai ORDER BY NgayBatDau DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                KhuyenMai km = new KhuyenMai();
                km.setMaKM(rs.getInt("MaKM"));
                km.setTenKM(rs.getString("TenKM"));
                km.setNoiDung(rs.getString("NoiDung"));
                km.setNgayBatDau(rs.getDate("NgayBatDau"));
                km.setNgayKetThuc(rs.getDate("NgayKetThuc"));
                km.setPhanTramGiam(rs.getDouble("PhanTramGiam"));
                list.add(km);
            }
        }
        return list;
    }
    
// Đổi từ void -> int
public int add(KhuyenMai km) throws SQLException {
    String sql = "INSERT INTO KhuyenMai(TenKM, NoiDung, NgayBatDau, NgayKetThuc, PhanTramGiam) VALUES (?, ?, ?, ?, ?)";
    // Thêm Statement.RETURN_GENERATED_KEYS để lấy ID tự tăng
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
         
        ps.setString(1, km.getTenKM());
        ps.setString(2, km.getNoiDung());
        ps.setDate(3, new java.sql.Date(km.getNgayBatDau().getTime()));
        ps.setDate(4, new java.sql.Date(km.getNgayKetThuc().getTime()));
        ps.setDouble(5, km.getPhanTramGiam());
        
        ps.executeUpdate();

        // Lấy ID vừa sinh ra
        try (ResultSet rs = ps.getGeneratedKeys()) {
            if (rs.next()) {
                return rs.getInt(1); // Trả về MaKM vừa tạo
            }
        }
    }
    return -1; // Lỗi hoặc không lấy được ID
}

    public void delete(int maKM) throws SQLException {
    Connection conn = null;
    PreparedStatement psUpdateSanPham = null;
    PreparedStatement psDeleteKM = null;
    
    String sqlUpdateSanPham = "UPDATE SanPham SET MaKM = NULL WHERE MaKM = ?";
    String sqlDeleteKM = "DELETE FROM KhuyenMai WHERE MaKM = ?";

    try {
        conn = DatabaseConnection.getConnection();
        // Bắt đầu Transaction
        conn.setAutoCommit(false); 

        // 1. Gỡ khuyến mãi này ra khỏi tất cả sản phẩm
        psUpdateSanPham = conn.prepareStatement(sqlUpdateSanPham);
        psUpdateSanPham.setInt(1, maKM);
        psUpdateSanPham.executeUpdate();

        // 2. Bây giờ mới xóa khuyến mãi
        psDeleteKM = conn.prepareStatement(sqlDeleteKM);
        psDeleteKM.setInt(1, maKM);
        psDeleteKM.executeUpdate();

        // 3. Lưu vĩnh viễn
        conn.commit();

    } catch (SQLException e) {
        // Nếu có lỗi, hủy bỏ mọi thay đổi
        if (conn != null) conn.rollback();
        e.printStackTrace(); // Ném lỗi ra để Servlet biết
        throw e;
    } finally {
        // Đóng kết nối
        if (psUpdateSanPham != null) psUpdateSanPham.close();
        if (psDeleteKM != null) psDeleteKM.close();
        if (conn != null) {
            conn.setAutoCommit(true);
            conn.close();
        }
    }
}
}
