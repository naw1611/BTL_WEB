package com.sportsshop.servlet;

import Connection.DatabaseConnection;
import com.sportsshop.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;

public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        request.getRequestDispatcher("jsp/profile.jsp").forward(request, response);
    }

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    request.setCharacterEncoding("UTF-8");
    HttpSession session = request.getSession(false);
    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect("login");
        return;
    }

    String action = request.getParameter("action");

    if ("updateInfo".equals(action)) {
        // === CẬP NHẬT THÔNG TIN ===
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String soDienThoai = request.getParameter("soDienThoai");
        String diaChi = request.getParameter("diaChi");

        String sql = "UPDATE Users SET FullName = ?, Email = ?, SoDienThoai = ?, DiaChi = ? WHERE MaUser = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, soDienThoai);
            ps.setString(4, diaChi);
            ps.setInt(5, user.getMaUser());

            if (ps.executeUpdate() > 0) {
                user.setFullName(fullName);
                user.setEmail(email);
                user.setSoDienThoai(soDienThoai);
                user.setDiaChi(diaChi);
                session.setAttribute("user", user);

                request.setAttribute("message", "Cập nhật thông tin thành công!");
                request.setAttribute("messageType", "success");
            } else {
                request.setAttribute("message", "Cập nhật thất bại!");
                request.setAttribute("messageType", "error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Lỗi hệ thống!");
            request.setAttribute("messageType", "error");
        }

    }else if ("changePassword".equals(action)) {
    String currentPassword = request.getParameter("currentPassword");
    String newPassword = request.getParameter("newPassword");
    String confirmPassword = request.getParameter("confirmPassword");
    String storedHash = user.getMatKhau();

    // Nếu chưa có mật khẩu → cho phép đặt lần đầu
    if (storedHash == null || storedHash.trim().isEmpty()) {
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("message", "Mật khẩu xác nhận không khớp!");
            request.setAttribute("messageType", "error");
        } else if (newPassword.length() < 6) {
            request.setAttribute("message", "Mật khẩu phải ít nhất 6 ký tự!");
            request.setAttribute("messageType", "error");
        } else {
            String newHash = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));
            String sql = "UPDATE Users SET MatKhau = ? WHERE MaUser = ?";

            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, newHash);
                ps.setInt(2, user.getMaUser());
                if (ps.executeUpdate() > 0) {
                    user.setMatKhau(newHash);
                    session.setAttribute("user", user);
                    request.setAttribute("message", "Đặt mật khẩu thành công! Bạn đã có thể đổi mật khẩu bình thường.");
                    request.setAttribute("messageType", "success");
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("message", "Lỗi hệ thống!");
                request.setAttribute("messageType", "error");
            }
        }
        // Dừng xử lý, không kiểm tra currentPassword
        request.getRequestDispatcher("jsp/profile.jsp").forward(request, response);
        return;
    }

    // Nếu đã có mật khẩu → kiểm tra bình thường
    if (!BCrypt.checkpw(currentPassword, storedHash)) {
        request.setAttribute("message", "Mật khẩu hiện tại không đúng!");
        request.setAttribute("messageType", "error");
    }
    else if (!newPassword.equals(confirmPassword)) {
        request.setAttribute("message", "Mật khẩu xác nhận không khớp!");
        request.setAttribute("messageType", "error");
    }
    else if (newPassword.length() < 6) {
        request.setAttribute("message", "Mật khẩu mới phải ít nhất 6 ký tự!");
        request.setAttribute("messageType", "error");
    }
    else {
        String newHash = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));
        String sql = "UPDATE Users SET MatKhau = ? WHERE MaUser = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newHash);
            ps.setInt(2, user.getMaUser());
            if (ps.executeUpdate() > 0) {
                user.setMatKhau(newHash);
                session.setAttribute("user", user);
                request.setAttribute("message", "Đổi mật khẩu thành công!");
                request.setAttribute("messageType", "success");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Lỗi hệ thống!");
            request.setAttribute("messageType", "error");
        }
    }
}

    request.getRequestDispatcher("jsp/profile.jsp").forward(request, response);
}
}