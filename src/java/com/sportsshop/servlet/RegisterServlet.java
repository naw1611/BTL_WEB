package com.sportsshop.servlet;

import Connection.DatabaseConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

public class RegisterServlet extends HttpServlet {
    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    request.getRequestDispatcher("jsp/register.jsp").forward(request, response);
}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validation
        String message = null;
        if (fullName == null || fullName.trim().isEmpty() ||
            username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            address == null || address.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            message = "Vui lòng điền đầy đủ các trường!";
        } else if (!email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            message = "Email không đúng định dạng!";
        } else if (!phone.matches("^[0-9]{10}$")) {
            message = "Số điện thoại phải là 10 số!";
        } else if (!password.equals(confirmPassword)) {
            message = "Mật khẩu không khớp!";
        } else {
            // Kiểm tra username và email đã tồn tại
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(
                     "SELECT COUNT(*) FROM Users WHERE Username = ? OR Email = ?")) {
                stmt.setString(1, username);
                stmt.setString(2, email);
                ResultSet rs = stmt.executeQuery();
                rs.next();
                if (rs.getInt(1) > 0) {
                    message = "Tên đăng nhập hoặc email đã tồn tại!";
                }
            } catch (Exception e) {
                e.printStackTrace();
                message = "Lỗi hệ thống, thử lại sau!";
            }
        }

        if (message == null) {
            // Hash mật khẩu và lưu vào DB
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(
                     "INSERT INTO Users (FullName, Username, Email, SoDienThoai, DiaChi, MatKhau, Role) " +
                     "VALUES (?, ?, ?, ?, ?, ?, 'user')")) {
                stmt.setString(1, fullName);
                stmt.setString(2, username);
                stmt.setString(3, email);
                stmt.setString(4, phone);
                stmt.setString(5, address);
                stmt.setString(6, hashedPassword);
                stmt.executeUpdate();
                message = "Đăng ký thành công! Vui lòng đăng nhập.";
            } catch (Exception e) {
                e.printStackTrace();
                message = "Lỗi khi lưu tài khoản, thử lại sau!";
            }
        }

        request.setAttribute("message", message);
        request.getRequestDispatcher("jsp/register.jsp").forward(request, response);
    }
}