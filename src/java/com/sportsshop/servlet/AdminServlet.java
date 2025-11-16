package com.sportsshop.servlet;

import Connection.DatabaseConnection;
import com.sportsshop.model.Order;
import com.sportsshop.model.OrderDetail;
import com.sportsshop.model.Product;
import com.sportsshop.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import com.itextpdf.text.Document;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.PdfPTable;
import com.sportsshop.dao.CategoryDAO;
import com.sportsshop.model.Category;


public class AdminServlet extends HttpServlet 
{
    private final CategoryDAO categoryDAO = new CategoryDAO();

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

        // 🟩 Lấy danh mục cho menu trái (dùng chung cho các trang JSP)
List<Category> listDanhMuc = categoryDAO.getAllCategories();
request.setAttribute("listDanhMuc", listDanhMuc);

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "detail":
            case "print":
                showOrderDetail(request, response, action);
                break;

            case "exportExcel":
                exportExcel(request, response);
                break;

            case "exportPDF":
                exportPDF(request, response);
                break;

            default:
                listOrders(request, response);
                break;
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    List<Order> orders = new ArrayList<>();

    String orderId = request.getParameter("orderId");
    String customerName = request.getParameter("customerName");
    String fromDate = request.getParameter("fromDate");
    String toDate = request.getParameter("toDate");

    List<Object> params = new ArrayList<>();
    StringBuilder sql = new StringBuilder(
            "SELECT d.MaDon, d.NgayDat, d.TongTien, d.DiaChiGiao, d.TrangThai, " +
                    "u.MaUser, u.FullName, u.Email, u.SoDienThoai " +
                    "FROM DonHang d JOIN Users u ON d.MaUser = u.MaUser WHERE 1=1 ");

    if (orderId != null && !orderId.isEmpty()) {
        sql.append(" AND d.MaDon = ?");
        params.add(Integer.parseInt(orderId));
    }
    if (customerName != null && !customerName.isEmpty()) {
        sql.append(" AND u.FullName LIKE ?");
        params.add("%" + customerName + "%");
    }
    if (fromDate != null && !fromDate.isEmpty()) {
        sql.append(" AND d.NgayDat >= ?");
        params.add(fromDate + " 00:00:00");
    }
    if (toDate != null && !toDate.isEmpty()) {
        sql.append(" AND d.NgayDat <= ?");
        params.add(toDate + " 23:59:59");
    }
    sql.append(" ORDER BY d.MaDon DESC");

    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
        
        // Gán parameters
        for (int i = 0; i < params.size(); i++) {
            stmt.setObject(i + 1, params.get(i));
        }
        
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            Order order = new Order();
            order.setMaDon(rs.getInt("MaDon"));
            order.setNgayDat(rs.getTimestamp("NgayDat"));
            order.setTongTien(rs.getDouble("TongTien"));
            order.setDiaChiGiao(rs.getString("DiaChiGiao"));
            order.setTrangThai(rs.getString("TrangThai"));

            User user = new User();
            user.setMaUser(rs.getInt("MaUser"));
            user.setFullName(rs.getString("FullName"));
            user.setEmail(rs.getString("Email"));
            user.setSoDienThoai(rs.getString("SoDienThoai"));
            order.setUser(user);

            orders.add(order);
        }
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("message", "Lỗi khi lấy danh sách đơn hàng: " + e.getMessage());
        request.setAttribute("messageType", "error");
    }

    request.setAttribute("orders", orders);
    request.getRequestDispatcher("jsp/admin.jsp").forward(request, response);
}

    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {
        int maDon = Integer.parseInt(request.getParameter("maDon"));
        Order order = null;
        List<OrderDetail> orderDetails = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(
                    "SELECT d.MaDon, d.NgayDat, d.TongTien, d.DiaChiGiao, d.TrangThai, " +
                            "u.MaUser, u.FullName, u.Email, u.SoDienThoai " +
                            "FROM DonHang d JOIN Users u ON d.MaUser = u.MaUser WHERE d.MaDon = ?");
            stmt.setInt(1, maDon);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                order = new Order();
                order.setMaDon(rs.getInt("MaDon"));
                order.setNgayDat(rs.getTimestamp("NgayDat"));
                order.setTongTien(rs.getDouble("TongTien"));
                order.setDiaChiGiao(rs.getString("DiaChiGiao"));
                order.setTrangThai(rs.getString("TrangThai"));

                User user = new User();
                user.setMaUser(rs.getInt("MaUser"));
                user.setFullName(rs.getString("FullName"));
                user.setEmail(rs.getString("Email"));
                user.setSoDienThoai(rs.getString("SoDienThoai"));
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

        if ("print".equals(action)) {
            request.getRequestDispatcher("jsp/order-print.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("jsp/order-detail.jsp").forward(request, response);
        }
    }

    private void exportExcel(HttpServletRequest request, HttpServletResponse response) throws IOException {
    
    String orderId = request.getParameter("orderId");
    String customerName = request.getParameter("customerName");
    String fromDate = request.getParameter("fromDate");
    String toDate = request.getParameter("toDate");

    List<Object> params = new ArrayList<>();
    StringBuilder sql = new StringBuilder(
            "SELECT d.MaDon, u.FullName, d.NgayDat, d.TongTien, d.TrangThai, d.DiaChiGiao " +
            "FROM DonHang d JOIN Users u ON d.MaUser = u.MaUser " +
            "WHERE d.TrangThai != 'Đã hủy' "); // ✅ THÊM ĐIỀU KIỆN NÀY

    if (orderId != null && !orderId.isEmpty()) {
        sql.append(" AND d.MaDon = ?");
        params.add(Integer.parseInt(orderId));
    }
    if (customerName != null && !customerName.isEmpty()) {
        sql.append(" AND u.FullName LIKE ?");
        params.add("%" + customerName + "%");
    }
    if (fromDate != null && !fromDate.isEmpty()) {
        sql.append(" AND d.NgayDat >= ?");
        params.add(fromDate + " 00:00:00");
    }
    if (toDate != null && !toDate.isEmpty()) {
        sql.append(" AND d.NgayDat <= ?");
        params.add(toDate + " 23:59:59");
    }
    sql.append(" ORDER BY d.MaDon DESC");

    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
        
        for (int i = 0; i < params.size(); i++) {
            stmt.setObject(i + 1, params.get(i));
        }
        
        ResultSet rs = stmt.executeQuery();

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("DanhSachDonHang");
        Row header = sheet.createRow(0);
        
        String[] headers = {"Mã Đơn", "Tên Khách Hàng", "Ngày Đặt", "Tổng Tiền", "Trạng Thái", "Địa Chỉ Giao"};
        for (int i = 0; i < headers.length; i++) {
            header.createCell(i).setCellValue(headers[i]);
        }

        int rowIndex = 1;
        while (rs.next()) {
            Row row = sheet.createRow(rowIndex++);
            row.createCell(0).setCellValue(rs.getInt("MaDon"));
            row.createCell(1).setCellValue(rs.getString("FullName"));
            row.createCell(2).setCellValue(rs.getTimestamp("NgayDat").toString());
            row.createCell(3).setCellValue(rs.getDouble("TongTien"));
            row.createCell(4).setCellValue(rs.getString("TrangThai"));
            row.createCell(5).setCellValue(rs.getString("DiaChiGiao"));
        }

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=DonHang.xlsx");
        workbook.write(response.getOutputStream());
        workbook.close();
        
    } catch (Exception e) {
        e.printStackTrace();
        response.setContentType("text/html; charset=UTF-8");
        response.getWriter().println("<script>alert('Lỗi xuất Excel: " + e.getMessage() + "'); window.history.back();</script>");
    }
}

    private void exportPDF(HttpServletRequest request, HttpServletResponse response) throws IOException {
    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition", "attachment; filename=DonHang.pdf");

    String orderId = request.getParameter("orderId");
    String customerName = request.getParameter("customerName");
    String fromDate = request.getParameter("fromDate");
    String toDate = request.getParameter("toDate");

    Document document = new Document(PageSize.A4);
    
    StringBuilder sql = new StringBuilder(
            "SELECT d.MaDon, d.NgayDat, d.TongTien, d.TrangThai, d.DiaChiGiao, u.FullName " +
            "FROM DonHang d JOIN Users u ON d.MaUser = u.MaUser " +
            "WHERE d.TrangThai != 'Đã hủy' "); // ✅ THÊM ĐIỀU KIỆN NÀY

    List<Object> params = new ArrayList<>();

    if (orderId != null && !orderId.isEmpty()) {
        sql.append(" AND d.MaDon = ?");
        params.add(Integer.parseInt(orderId));
    }
    if (customerName != null && !customerName.isEmpty()) {
        sql.append(" AND u.FullName LIKE ?");
        params.add("%" + customerName + "%");
    }
    if (fromDate != null && !fromDate.isEmpty()) {
        sql.append(" AND d.NgayDat >= ?");
        params.add(fromDate + " 00:00:00");
    }
    if (toDate != null && !toDate.isEmpty()) {
        sql.append(" AND d.NgayDat <= ?");
        params.add(toDate + " 23:59:59");
    }
    sql.append(" ORDER BY d.MaDon DESC");

    try (OutputStream out = response.getOutputStream();
         Connection conn = DatabaseConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

        for (int i = 0; i < params.size(); i++) {
            stmt.setObject(i + 1, params.get(i));
        }

        ResultSet rs = stmt.executeQuery();
        PdfWriter.getInstance(document, out);
        document.open();

        String fontPath = getServletContext().getRealPath("/WEB-INF/fonts/times.ttf");
        BaseFont bf;
        
        if (fontPath != null && new java.io.File(fontPath).exists()) {
            bf = BaseFont.createFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        } else {
            bf = BaseFont.createFont("C:\\Windows\\Fonts\\Times New Roman\\times.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        }
        
        Font fontTitle = new Font(bf, 14, Font.BOLD);
        Font fontNormal = new Font(bf, 11);
        Font fontHeader = new Font(bf, 12, Font.BOLD);

        document.add(new Paragraph("BÁO CÁO ĐƠN HÀNG", fontTitle));
        document.add(new Paragraph("Ngày tạo: " + new java.util.Date(), fontNormal));
        document.add(new Paragraph("(Không bao gồm đơn đã hủy)", fontNormal)); // ✅ GHI CHÚ
        
        if (orderId != null && !orderId.isEmpty()) {
            document.add(new Paragraph("Mã đơn: " + orderId, fontNormal));
        }
        if (customerName != null && !customerName.isEmpty()) {
            document.add(new Paragraph("Khách hàng: " + customerName, fontNormal));
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            document.add(new Paragraph("Từ ngày: " + fromDate, fontNormal));
        }
        if (toDate != null && !toDate.isEmpty()) {
            document.add(new Paragraph("Đến ngày: " + toDate, fontNormal));
        }
        
        document.add(Chunk.NEWLINE);

        PdfPTable table = new PdfPTable(6);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{8, 20, 20, 18, 15, 19});

        String[] headers = {"Mã Đơn", "Khách Hàng", "Ngày Đặt", "Tổng Tiền", "Trạng Thái", "Địa Chỉ"};
        for (String h : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(h, fontHeader));
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setBackgroundColor(new com.itextpdf.text.BaseColor(230, 230, 230));
            table.addCell(cell);
        }

        int count = 0;
        double totalAmount = 0;

        while (rs.next()) {
            count++;
            double orderTotal = rs.getDouble("TongTien");
            totalAmount += orderTotal;

            table.addCell(new Phrase(String.valueOf(rs.getInt("MaDon")), fontNormal));
            table.addCell(new Phrase(rs.getString("FullName"), fontNormal));
            table.addCell(new Phrase(rs.getTimestamp("NgayDat").toString(), fontNormal));
            table.addCell(new Phrase(String.format("%,.0f đ", orderTotal), fontNormal));
            table.addCell(new Phrase(rs.getString("TrangThai"), fontNormal));
            table.addCell(new Phrase(rs.getString("DiaChiGiao"), fontNormal));
        }

        document.add(table);
        
        document.add(Chunk.NEWLINE);
        document.add(new Paragraph("Tổng số đơn hàng: " + count, fontHeader));
        document.add(new Paragraph("Tổng doanh thu: " + String.format("%,.0f đ", totalAmount), fontHeader));

        document.close();
        out.flush();

    } catch (Exception e) {
        e.printStackTrace();
        response.setContentType("text/html; charset=UTF-8");
        response.getWriter().println("<script>alert('Lỗi xuất PDF: " + e.getMessage() + "'); window.history.back();</script>");
    }
}
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
        if ("updateStatus".equals(action)) {
            int maDon = Integer.parseInt(request.getParameter("maDon"));
            String status = request.getParameter("status");

            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(
                         "UPDATE DonHang SET TrangThai = ? WHERE MaDon = ?")) {
                stmt.setString(1, status);
                stmt.setInt(2, maDon);
                stmt.executeUpdate();
                response.sendRedirect("admin?action=detail&maDon=" + maDon + "&success=1");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin?action=detail&maDon=" + maDon + "&error=1");
            }
        }
    }
} 