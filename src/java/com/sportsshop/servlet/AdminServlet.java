package com.sportsshop.servlet;

import Connection.DatabaseConnection;
import com.sportsshop.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.sql.Date;
import java.util.*;

public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
            !"admin".equals(((User) session.getAttribute("user")).getRole())) {
            request.setAttribute("message", "Bạn không có quyền truy cập!");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
            return;
        }

        String action = request.getParameter("action");

        // 🔍 Xử lý tìm kiếm
        if ("searchOrders".equals(action)) {
            searchOrders(request, response);
            return;
        }

        // ✅ Cho phép xử lý GET huỷ đơn (link a href)
        if ("updateStatus".equals(action)) {
            doPost(request, response);
            return;
        }

        // 🔍 Xem chi tiết hoặc in đơn
        if ("detail".equals(action) || "print".equals(action)) {
            int maDon = Integer.parseInt(request.getParameter("maDon"));
            Order order = null;
            List<OrderDetail> orderDetails = new ArrayList<>();

            try (Connection conn = DatabaseConnection.getConnection()) {
                PreparedStatement stmt = conn.prepareStatement(
                    "SELECT d.MaDon, d.NgayDat, d.TongTien, d.DiaChiGiao, d.TrangThai, " +
                    "u.MaUser, u.FullName, u.Email, u.SDT " +
                    "FROM DonHang d JOIN Users u ON d.MaUser = u.MaUser WHERE d.MaDon = ?");
                stmt.setInt(1, maDon);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    order = new Order();
                    order.setMaDon(rs.getInt("MaDon"));
                    order.setNgayDat(rs.getDate("NgayDat"));
                    order.setTongTien(rs.getDouble("TongTien"));
                    order.setDiaChiGiao(rs.getString("DiaChiGiao"));
                    order.setTrangThai(rs.getString("TrangThai"));
                    User user = new User();
                    user.setMaUser(rs.getInt("MaUser"));
                    user.setFullName(rs.getString("FullName"));
                    user.setEmail(rs.getString("Email"));
                    user.setSoDienThoai(rs.getString("SDT"));
                    order.setUser(user);
                }

                stmt = conn.prepareStatement(
                    "SELECT cd.MaChiTiet, cd.MaDon, cd.SoLuong, cd.DonGia, " +
                    "sp.MaSP, sp.TenSP, sp.CodeSP, sp.Gia, sp.HinhAnh " +
                    "FROM ChiTietDonHang cd JOIN SanPham sp ON cd.MaSP = sp.MaSP WHERE cd.MaDon = ?");
                stmt.setInt(1, maDon);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    OrderDetail detail = new OrderDetail();
                    detail.setMaChiTiet(rs.getInt("MaChiTiet"));
                    detail.setMaDon(rs.getInt("MaDon"));
                    detail.setSoLuong(rs.getInt("SoLuong"));
                    detail.setDonGia(rs.getDouble("DonGia"));
                    Product product = new Product();
                    product.setMaSP(rs.getInt("MaSP"));
                    product.setTenSP(rs.getString("TenSP"));
                    product.setCodeSP(rs.getString("CodeSP"));
                    product.setGia(rs.getDouble("Gia"));
                    product.setHinhAnh(rs.getString("HinhAnh"));
                    detail.setProduct(product);
                    orderDetails.add(detail);
                }

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("message", "Lỗi khi lấy chi tiết đơn hàng!");
                request.setAttribute("messageType", "error");
            }

            request.setAttribute("order", order);
            request.setAttribute("orderDetails", orderDetails);
            request.getRequestDispatcher("jsp/order-detail.jsp").forward(request, response);
            return;
        }

        // 📋 Mặc định: danh sách đơn hàng
        List<Order> orders = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                 "SELECT d.MaDon, d.NgayDat, d.TongTien, d.DiaChiGiao, d.TrangThai, " +
                 "u.MaUser, u.FullName, u.Email " +
                 "FROM DonHang d JOIN Users u ON d.MaUser = u.MaUser ORDER BY d.NgayDat DESC")) {

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setMaDon(rs.getInt("MaDon"));
                order.setNgayDat(rs.getDate("NgayDat"));
                order.setTongTien(rs.getDouble("TongTien"));
                order.setDiaChiGiao(rs.getString("DiaChiGiao"));
                order.setTrangThai(rs.getString("TrangThai"));
                User user = new User();
                user.setMaUser(rs.getInt("MaUser"));
                user.setFullName(rs.getString("FullName"));
                user.setEmail(rs.getString("Email"));
                order.setUser(user);
                orders.add(order);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Lỗi khi lấy danh sách đơn hàng!");
            request.setAttribute("messageType", "error");
        }

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("jsp/admin.jsp").forward(request, response);
    }

    // ============================
    // 🧩 HÀM TÌM KIẾM ĐƠN HÀNG
    // ============================
    private void searchOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Order> orders = new ArrayList<>();
        String orderId = request.getParameter("orderId");
        String customerName = request.getParameter("customerName");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        StringBuilder sql = new StringBuilder(
            "SELECT d.MaDon, d.NgayDat, d.TongTien, d.DiaChiGiao, d.TrangThai, " +
            "u.MaUser, u.FullName, u.Email " +
            "FROM DonHang d JOIN Users u ON d.MaUser = u.MaUser WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (orderId != null && !orderId.isEmpty()) {
            sql.append("AND d.MaDon = ? ");
            params.add(Integer.parseInt(orderId));
        }

        if (customerName != null && !customerName.isEmpty()) {
            sql.append("AND u.FullName LIKE ? ");
            params.add("%" + customerName + "%");
        }

        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append("AND d.NgayDat >= ? ");
            params.add(Date.valueOf(fromDate));
        }

        if (toDate != null && !toDate.isEmpty()) {
            sql.append("AND d.NgayDat <= ? ");
            params.add(Date.valueOf(toDate));
        }

        sql.append("ORDER BY d.NgayDat DESC");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setMaDon(rs.getInt("MaDon"));
                order.setNgayDat(rs.getDate("NgayDat"));
                order.setTongTien(rs.getDouble("TongTien"));
                order.setDiaChiGiao(rs.getString("DiaChiGiao"));
                order.setTrangThai(rs.getString("TrangThai"));
                User user = new User();
                user.setMaUser(rs.getInt("MaUser"));
                user.setFullName(rs.getString("FullName"));
                user.setEmail(rs.getString("Email"));
                order.setUser(user);
                orders.add(order);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Lỗi khi tìm kiếm đơn hàng!");
            request.setAttribute("messageType", "error");
        }

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("jsp/admin.jsp").forward(request, response);
    }

    // ============================
    // 🧩 HÀM CẬP NHẬT TRẠNG THÁI
    // ============================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
            !"admin".equals(((User) session.getAttribute("user")).getRole())) {
            request.setAttribute("message", "Bạn không có quyền truy cập!");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
            return;
        }

        String action = request.getParameter("action");
        if (!"updateStatus".equals(action)) return;

        int maDon = Integer.parseInt(request.getParameter("maDon"));
        String status = request.getParameter("status");

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);

            String currentStatus = null;
            try (PreparedStatement psCur = conn.prepareStatement(
                    "SELECT TrangThai FROM DonHang WHERE MaDon = ?")) {
                psCur.setInt(1, maDon);
                ResultSet rsCur = psCur.executeQuery();
                if (rsCur.next()) currentStatus = rsCur.getString("TrangThai");
            }

            if (!"Đã hủy".equalsIgnoreCase(currentStatus) && "Đã hủy".equalsIgnoreCase(status)) {
                PreparedStatement psDetail = conn.prepareStatement(
                    "SELECT MaSP, SoLuong FROM ChiTietDonHang WHERE MaDon = ?");
                psDetail.setInt(1, maDon);
                ResultSet rs = psDetail.executeQuery();

                while (rs.next()) {
                    int maSP = rs.getInt("MaSP");
                    int soLuong = rs.getInt("SoLuong");

                    PreparedStatement psUpdate = conn.prepareStatement(
                        "UPDATE SanPham SET SoLuong = SoLuong + ? WHERE MaSP = ?");
                    psUpdate.setInt(1, soLuong);
                    psUpdate.setInt(2, maSP);
                    psUpdate.executeUpdate();
                    psUpdate.close();
                }
                psDetail.close();
            }

            PreparedStatement psUpdateStatus = conn.prepareStatement(
                "UPDATE DonHang SET TrangThai = ? WHERE MaDon = ?");
            psUpdateStatus.setString(1, status);
            psUpdateStatus.setInt(2, maDon);
            psUpdateStatus.executeUpdate();
            psUpdateStatus.close();

            conn.commit();
            response.sendRedirect("admin?action=detail&maDon=" + maDon + "&success=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin?action=detail&maDon=" + maDon + "&error=1");
        }
    }
}
