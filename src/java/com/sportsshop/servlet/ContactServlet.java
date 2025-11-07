package com.sportsshop.servlet;

import Connection.DatabaseConnection;
import com.sportsshop.model.User;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


public class ContactServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Khi người dùng mở trang Liên hệ
        request.getRequestDispatcher("jsp/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
                     "INSERT INTO LienHe (MaUser, TenKhach, Email, NoiDung, TrangThai) VALUES (?, ?, ?, ?, 'Chưa xử lý')")) {
                HttpSession session = request.getSession(false);
                User user = (session != null && session.getAttribute("user") != null) ?
                            (User) session.getAttribute("user") : null;

                if (user != null) {
                    stmt.setInt(1, user.getMaUser());
                } else {
                    stmt.setNull(1, java.sql.Types.INTEGER);
                }
                stmt.setString(2, name);
                stmt.setString(3, email);
                stmt.setString(4, messageContent);
                stmt.executeUpdate();

                message = "Gửi liên hệ thành công!";
                messageType = "message";
            } catch (Exception e) {
                e.printStackTrace();
                message = "Lỗi hệ thống, thử lại sau!";
            }
        }

        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);
        request.getRequestDispatcher("jsp/contact.jsp").forward(request, response);
    }
}
