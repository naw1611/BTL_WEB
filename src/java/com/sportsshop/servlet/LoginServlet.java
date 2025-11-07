package com.sportsshop.servlet;

import Connection.DatabaseConnection;
import com.sportsshop.model.User;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiển thị form đăng nhập
        request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String usernameOrEmail = request.getParameter("usernameOrEmail");
        String password = request.getParameter("password");
        String message = null;
        String messageType = "error";

        // Validate đầu vào
        if (usernameOrEmail == null || usernameOrEmail.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            message = "Vui lòng điền đầy đủ thông tin!";
        } else {
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(
                     "SELECT MaUser, FullName, Username, Email, SoDienThoai, DiaChi, MatKhau, Role " +
                     "FROM Users WHERE Username = ? OR Email = ?")) {
                stmt.setString(1, usernameOrEmail.trim());
                stmt.setString(2, usernameOrEmail.trim());
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    String hashedPassword = rs.getString("MatKhau");
                    if (BCrypt.checkpw(password, hashedPassword)) {
                        // Tạo user object
                        User user = new User();
                        user.setMaUser(rs.getInt("MaUser"));
                        user.setFullName(rs.getString("FullName"));
                        user.setUsername(rs.getString("Username"));
                        user.setEmail(rs.getString("Email"));
                        user.setSoDienThoai(rs.getString("SoDienThoai"));
                        user.setDiaChi(rs.getString("DiaChi"));
                        user.setRole(rs.getString("Role")); // ← QUAN TRỌNG: có role

                        // LẤY SESSION HIỆN TẠI (KHÔNG TẠO MỚI)
                        HttpSession session = request.getSession(false);
                        if (session == null) {
                            session = request.getSession(); // Chỉ tạo nếu chưa có
                        }
                        session.setAttribute("user", user);

                        // Đăng nhập thành công → về trang chủ
                        response.sendRedirect("index.jsp");
                        return;
                    } else {
                        message = "Mật khẩu không đúng!";
                    }
                } else {
                    message = "Tên đăng nhập hoặc email không tồn tại!";
                }
            } catch (Exception e) {
                e.printStackTrace();
                message = "Lỗi hệ thống, vui lòng thử lại sau!";
            }
        }

        // Đăng nhập thất bại → quay lại form
        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);
        request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
    }
}