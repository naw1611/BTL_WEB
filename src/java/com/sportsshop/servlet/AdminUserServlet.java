package com.sportsshop.servlet;

import Connection.DatabaseConnection;
import com.sportsshop.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.*;

public class AdminUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "edit":
                showEditForm(request, response);
                break;
            case "history":
                showOrderHistory(request, response);
                break;
            default:
                listUsers(request, response);
                break;
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<User> users = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM Users ORDER BY MaUser DESC")) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setMaUser(rs.getInt("MaUser"));
                u.setUsername(rs.getString("Username"));
                u.setFullName(rs.getString("FullName"));
                u.setMatKhau(rs.getString("MatKhau"));
                u.setEmail(rs.getString("Email"));
                u.setSoDienThoai(rs.getString("SoDienThoai"));
                u.setDiaChi(rs.getString("DiaChi"));
                u.setNgayTao(rs.getDate("NgayTao"));
                u.setRole(rs.getString("Role"));
                u.setTrangThai(rs.getBoolean("TrangThai")); // dùng boolean thay vì int
                users.add(u);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("users", users);
        request.getRequestDispatcher("jsp/user-list.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM Users WHERE MaUser = ?")) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User u = new User();
                u.setMaUser(rs.getInt("MaUser"));
                u.setUsername(rs.getString("Username"));
                u.setFullName(rs.getString("FullName"));
                u.setMatKhau(rs.getString("MatKhau"));
                u.setEmail(rs.getString("Email"));
                u.setSoDienThoai(rs.getString("SoDienThoai"));
                u.setDiaChi(rs.getString("DiaChi"));
                u.setNgayTao(rs.getDate("NgayTao"));
                u.setRole(rs.getString("Role"));
                u.setTrangThai(rs.getBoolean("TrangThai"));
                request.setAttribute("user", u);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("jsp/user-edit.jsp").forward(request, response);
    }
    private void showOrderHistory(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    int userId = Integer.parseInt(request.getParameter("id"));
    List<Map<String, Object>> orders = new ArrayList<>();

    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(
             "SELECT d.MaDon, d.NgayDat, d.TongTien, d.TrangThai " +
             "FROM DonHang d WHERE d.MaUser = ? ORDER BY d.NgayDat DESC")) {

        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, Object> order = new HashMap<>();
            order.put("maDon", rs.getInt("MaDon"));
            order.put("ngayDat", rs.getTimestamp("NgayDat"));
            order.put("tongTien", rs.getDouble("TongTien"));
            order.put("trangThai", rs.getString("TrangThai"));
            orders.add(order);
        }

    } catch (SQLException e) {
        e.printStackTrace();
        request.setAttribute("message", "Lỗi khi tải lịch sử mua hàng!");
    }

    request.setAttribute("orders", orders);
    request.getRequestDispatcher("jsp/user-history.jsp").forward(request, response);
}


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String action = request.getParameter("action");
        if ("update".equals(action)) {
            updateUser(request, response);
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String role = request.getParameter("role");
        boolean trangThai = Boolean.parseBoolean(request.getParameter("trangThai"));

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "UPDATE Users SET Role = ?, TrangThai = ? WHERE MaUser = ?")) {

            ps.setString(1, role);
            ps.setBoolean(2, trangThai);
            ps.setInt(3, id);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("adminUser?action=list");
    }
}
