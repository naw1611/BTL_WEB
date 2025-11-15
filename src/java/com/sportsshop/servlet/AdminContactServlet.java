package com.sportsshop.servlet;

import Connection.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class AdminContactServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "view":
                showContactDetail(request, response);
                break;
            default:
                listContacts(request, response);
                break;
        }
    }

    private void listContacts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, Object>> contacts = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT * FROM LienHe ORDER BY NgayGui DESC")) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> c = new HashMap<>();
                c.put("MaLienHe", rs.getInt("MaLienHe"));
                c.put("TenKhach", rs.getString("TenKhach"));
                c.put("Email", rs.getString("Email"));
                c.put("NoiDung", rs.getString("NoiDung"));
                c.put("NgayGui", rs.getTimestamp("NgayGui"));
                c.put("TrangThai", rs.getString("TrangThai"));
                c.put("PhanHoi", rs.getString("PhanHoi"));
                c.put("NgayPhanHoi", rs.getTimestamp("NgayPhanHoi"));
                contacts.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "❌ Lỗi khi tải danh sách liên hệ!");
        }

        request.setAttribute("contacts", contacts);
        request.getRequestDispatcher("jsp/contact-admin.jsp").forward(request, response);
    }

    private void showContactDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM LienHe WHERE MaLienHe = ?")) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Map<String, Object> c = new HashMap<>();
                c.put("MaLienHe", rs.getInt("MaLienHe"));
                c.put("TenKhach", rs.getString("TenKhach"));
                c.put("Email", rs.getString("Email"));
                c.put("NoiDung", rs.getString("NoiDung"));
                c.put("NgayGui", rs.getTimestamp("NgayGui"));
                c.put("TrangThai", rs.getString("TrangThai"));
                c.put("PhanHoi", rs.getString("PhanHoi"));
                request.setAttribute("contact", c);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("jsp/contact-reply.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("reply".equals(action)) {
            replyContact(request, response);
        }
    }

    private void replyContact(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String replyContent = request.getParameter("reply");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "UPDATE LienHe SET PhanHoi=?, TrangThai=N'Đã phản hồi', NgayPhanHoi=NOW() WHERE MaLienHe=?")) {

            ps.setString(1, replyContent);
            ps.setInt(2, id);
            ps.executeUpdate();

            response.sendRedirect("adminContact?action=list");

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("❌ Lỗi khi phản hồi liên hệ!");
        }
    }
}
