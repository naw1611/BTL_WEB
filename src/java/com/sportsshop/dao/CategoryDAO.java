package com.sportsshop.dao;

import com.sportsshop.model.Category;
import Connection.DatabaseConnection;
import java.sql.*;
import java.util.*;

public class CategoryDAO {

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM danhmuc ORDER BY MaDanhMuc DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category c = new Category();
                c.setMaDanhMuc(rs.getInt("MaDanhMuc"));
                c.setTenDanhMuc(rs.getString("TenDanhMuc"));
                c.setMoTa(rs.getString("MoTa"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Category getCategoryById(int id) {
        String sql = "SELECT * FROM danhmuc WHERE MaDanhMuc = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Category c = new Category();
                c.setMaDanhMuc(rs.getInt("MaDanhMuc"));
                c.setTenDanhMuc(rs.getString("TenDanhMuc"));
                c.setMoTa(rs.getString("MoTa"));
                return c;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertCategory(Category c) {
        String sql = "INSERT INTO danhmuc (TenDanhMuc, MoTa) VALUES (?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getTenDanhMuc());
            ps.setString(2, c.getMoTa());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateCategory(Category c) {
        String sql = "UPDATE danhmuc SET TenDanhMuc=?, MoTa=? WHERE MaDanhMuc=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getTenDanhMuc());
            ps.setString(2, c.getMoTa());
            ps.setInt(3, c.getMaDanhMuc());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteCategory(int id) {
        String sql = "DELETE FROM danhmuc WHERE MaDanhMuc=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
