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

    public void add(KhuyenMai km) throws SQLException {
        String sql = "INSERT INTO KhuyenMai(TenKM, NoiDung, NgayBatDau, NgayKetThuc, PhanTramGiam) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, km.getTenKM());
            ps.setString(2, km.getNoiDung());
            ps.setDate(3, new java.sql.Date(km.getNgayBatDau().getTime()));
            ps.setDate(4, new java.sql.Date(km.getNgayKetThuc().getTime()));
            ps.setDouble(5, km.getPhanTramGiam());
            ps.executeUpdate();
        }
    }

    public void delete(int maKM) throws SQLException {
        String sql = "DELETE FROM KhuyenMai WHERE MaKM = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maKM);
            ps.executeUpdate();
        }
    }
}
