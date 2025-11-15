package com.sportsshop.servlet;

import Connection.DatabaseConnection;
import com.sportsshop.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class ContactServlet extends HttpServlet {

    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");

    String action = request.getParameter("action");
    if ("history".equals(action)) {
        showContactHistory(request, response);
    } else {
        request.getRequestDispatcher("jsp/contact.jsp").forward(request, response);
    }
}

private void showContactHistory(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    HttpSession session = request.getSession(false);
    User user = (session != null) ? (User) session.getAttribute("user") : null;

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(
             "SELECT * FROM LienHe WHERE MaUser = ? ORDER BY NgayGui DESC")) {
        ps.setInt(1, user.getMaUser());
        ResultSet rs = ps.executeQuery();
        List<Map<String, Object>> contacts = new ArrayList<>();
        while (rs.next()) {
            Map<String, Object> c = new HashMap<>();
            c.put("MaLienHe", rs.getInt("MaLienHe"));
            c.put("NoiDung", rs.getString("NoiDung"));
            c.put("PhanHoi", rs.getString("PhanHoi"));
            c.put("TrangThai", rs.getString("TrangThai"));
            c.put("NgayGui", rs.getTimestamp("NgayGui"));
            c.put("NgayPhanHoi", rs.getTimestamp("NgayPhanHoi"));
            contacts.add(c);
        }
        request.setAttribute("contacts", contacts);
    } catch (Exception e) {
        e.printStackTrace();
    }

    request.getRequestDispatcher("jsp/contact-history.jsp").forward(request, response);
}


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String messageContent = request.getParameter("message");
        String message = null;
        String messageType = "error";

        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            messageContent == null || messageContent.trim().isEmpty()) {
            message = "Vui lòng điền đầy đủ thông tin!";
        } else if (!email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            message = "Email không đúng định dạng!";
        } else {
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(
                     "INSERT INTO LienHe (MaUser, TenKhach, Email, NoiDung, TrangThai, NgayGui) " +
                     "VALUES (?, ?, ?, ?, N'Chưa xử lý', NOW())")) {

                HttpSession session = request.getSession(false);
                User user = (session != null && session.getAttribute("user") != null)
                        ? (User) session.getAttribute("user") : null;

                if (user != null) {
                    stmt.setInt(1, user.getMaUser());
                } else {
                    stmt.setNull(1, java.sql.Types.INTEGER);
                }

                stmt.setString(2, name);
                stmt.setString(3, email);
                stmt.setString(4, messageContent);
                stmt.executeUpdate();

                message = "✅ Gửi liên hệ thành công! Chúng tôi sẽ phản hồi sớm.";
                messageType = "message";
            } catch (Exception e) {
                e.printStackTrace();
                message = "❌ Lỗi hệ thống, vui lòng thử lại sau!";
            }
        }

        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);
        request.getRequestDispatcher("jsp/contact.jsp").forward(request, response);
    }
}
