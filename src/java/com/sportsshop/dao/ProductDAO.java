package com.sportsshop.dao;

import Connection.DatabaseConnection;
import com.sportsshop.model.Product;
import java.sql.*;
import java.util.*;

public class ProductDAO {

    // Lấy tất cả sản phẩm
    public List<Product> getAll() throws SQLException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM SanPham WHERE DaXoa = 0";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product p = new Product();
                p.setMaSP(rs.getInt("MaSP"));
                p.setTenSP(rs.getString("TenSP"));
                p.setGia(rs.getDouble("Gia"));
                p.setMaKM(rs.getInt("MaKM")); // Quan trọng: Để biết nó đang thuộc KM nào
                list.add(p);
            }
        }
        return list;
    }

    // Cập nhật danh sách sản phẩm cho 1 khuyến mãi
    public void updatePromotionProducts(int maKM, String[] productIds) throws SQLException {
        Connection conn = null;
        PreparedStatement psReset = null;
        PreparedStatement psUpdate = null;

        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false); // Dùng Transaction

            // BƯỚC 1: Reset các sản phẩm đang thuộc KM này về NULL (Gỡ sạch trước)
            String sqlReset = "UPDATE SanPham SET MaKM = NULL WHERE MaKM = ?";
            psReset = conn.prepareStatement(sqlReset);
            psReset.setInt(1, maKM);
            psReset.executeUpdate();

            // BƯỚC 2: Gán lại danh sách mới (nếu có chọn)
            if (productIds != null && productIds.length > 0) {
                StringBuilder sqlUpdate = new StringBuilder("UPDATE SanPham SET MaKM = ? WHERE MaSP IN (");
                for (int i = 0; i < productIds.length; i++) {
                    sqlUpdate.append(i == 0 ? "?" : ", ?");
                }
                sqlUpdate.append(")");

                psUpdate = conn.prepareStatement(sqlUpdate.toString());
                psUpdate.setInt(1, maKM);
                for (int i = 0; i < productIds.length; i++) {
                    psUpdate.setInt(i + 2, Integer.parseInt(productIds[i]));
                }
                psUpdate.executeUpdate();
            }

            conn.commit(); // Lưu thay đổi
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            e.printStackTrace();
            throw e;
        } finally {
            if (psReset != null) psReset.close();
            if (psUpdate != null) psUpdate.close();
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }
}