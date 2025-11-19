package com.sportsshop.servlet;

import Connection.DatabaseConnection;
import com.sportsshop.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig; // 🟢 1. THÊM IMPORT NÀY
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.Paths; // 🟢 THÊM IMPORT NÀY
import java.sql.*;
import java.util.*;

// 🟢 2. THÊM ANNOTATION NÀY ĐỂ NHẬN TỆP TIN
@MultipartConfig(fileSizeThreshold = 1024*1024, maxFileSize = 1024*1024*5, maxRequestSize = 1024*1024*10)
public class AdminProductServlet extends HttpServlet {

    // --- Hàm helper để lấy tên file từ Part ---
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                // Lấy tên file, bỏ qua các dấu ngoặc kép
                return Paths.get(token.substring(token.indexOf("=") + 2, token.length() - 1)).getFileName().toString();
            }
        }
        return null;
    }

    // --- Hàm helper để lưu file ---
    private String saveUploadedFile(Part filePart, HttpServletRequest request) throws IOException {
        String fileName = getFileName(filePart);
        if (fileName != null && !fileName.isEmpty()) {
            // Lấy đường dẫn thực tế đến thư mục /images trong dự án của bạn
            String uploadPath = request.getServletContext().getRealPath("") + File.separator + "images";
            
            // Tạo thư mục nếu chưa có
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Ghi tệp
            filePart.write(uploadPath + File.separator + fileName);
            return fileName; // Trả về tên file đã lưu
        }
        return null; // Trả về null nếu không có file
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // ... (Code doGet của bạn giữ nguyên) ...
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                loadCategories(request);
                loadPromotions(request);
                request.getRequestDispatcher("jsp/product-add.jsp").forward(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteProduct(request, response);
                break;
            case "trash":
                listTrashProducts(request, response); // Hàm xem thùng rác
                break;
            case "restore":
                restoreProduct(request, response);    // Hàm khôi phục
            break;
            default: // 'list'
                listProducts(request, response);
                break;
        }
    }
    
    // ... (Các hàm listProducts, getTotalProducts, showEditForm giữ nguyên) ...

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8"); // Đặt UTF-8 lên đầu

        String action = request.getParameter("action");
        if ("insert".equals(action)) {
            addProduct(request, response);
        } else if ("update".equals(action)) {
            updateProduct(request, response);
        }
    }

    // 🔴 HÀM addProduct ĐÃ SỬA
    private void addProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException { // Thêm ServletException

        String hinhAnhFileName = null;
        try {
            // 1. Xử lý upload file ảnh
            Part filePart = request.getPart("hinhAnh"); // Lấy file từ input name="hinhAnh"
            hinhAnhFileName = saveUploadedFile(filePart, request);
            
            if (hinhAnhFileName == null) {
                // (Tùy chọn: bạn có thể đặt một ảnh mặc định nếu không upload)
                hinhAnhFileName = "no-image.jpg"; 
            }

            // 2. Lấy các thông tin khác
            String tenSP = request.getParameter("tenSP");
            String codeSP = request.getParameter("codeSP");
            double gia = Double.parseDouble(request.getParameter("gia"));
            int soLuong = Integer.parseInt(request.getParameter("soLuong"));
            String moTa = request.getParameter("moTa");
            int maDanhMuc = Integer.parseInt(request.getParameter("maDanhMuc"));
            
            String maKMStr = request.getParameter("maKM");
            Integer maKM = (maKMStr == null || maKMStr.isEmpty() || maKMStr.equals("")) ? null : Integer.parseInt(maKMStr);

            // 3. Lưu vào CSDL
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                         "INSERT INTO SanPham (TenSP, CodeSP, Gia, SoLuong, MoTa, HinhAnh, MaDanhMuc, MaKM, DaXoa) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0)")) {

                ps.setString(1, tenSP);
                ps.setString(2, codeSP);
                ps.setDouble(3, gia);
                ps.setInt(4, soLuong);
                ps.setString(5, moTa);
                ps.setString(6, hinhAnhFileName); // Dùng tên file đã upload
                ps.setInt(7, maDanhMuc);

                if (maKM == null) ps.setNull(8, java.sql.Types.INTEGER);
                else ps.setInt(8, maKM);

                ps.executeUpdate();
                
                // Sửa redirect: Dùng contextPath
                response.sendRedirect(request.getContextPath() + "/adminProduct?action=list");

            } catch (SQLException e) {
                e.printStackTrace();
                response.getWriter().println("Lỗi khi thêm sản phẩm!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Lỗi xử lý upload tệp", e);
        }
    }

    // 🔴 HÀM updateProduct ĐÃ SỬA
    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException { // Thêm ServletException

        String hinhAnhDeLuu;
        try {
            // 1. Xử lý upload file ảnh mới (nếu có)
            Part filePart = request.getPart("hinhAnhMoi"); // Lấy file từ input name="hinhAnhMoi"
            String tenFileMoi = getFileName(filePart);
            
            String hinhAnhCu = request.getParameter("hinhAnhCu"); // Lấy tên file cũ

            if (tenFileMoi != null && !tenFileMoi.isEmpty()) {
                // Nếu có file mới -> Lưu file mới
                hinhAnhDeLuu = saveUploadedFile(filePart, request);
                // (Tùy chọn: Xóa file ảnh cũ (hinhAnhCu) khỏi thư mục /images)
            } else {
                // Nếu không có file mới -> Giữ nguyên tên file cũ
                hinhAnhDeLuu = hinhAnhCu;
            }

            // 2. Lấy các thông tin khác
            int id = Integer.parseInt(request.getParameter("id"));
            String tenSP = request.getParameter("tenSP");
            double gia = Double.parseDouble(request.getParameter("gia"));
            int soLuong = Integer.parseInt(request.getParameter("soLuong"));
            String moTa = request.getParameter("moTa");
            int maDanhMuc = Integer.parseInt(request.getParameter("maDanhMuc"));
            
            String maKMStr = request.getParameter("maKM");
            Integer maKM = (maKMStr == null || maKMStr.isEmpty() || maKMStr.equals("")) ? null : Integer.parseInt(maKMStr);

            // 3. Cập nhật CSDL
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                         "UPDATE SanPham SET TenSP=?, Gia=?, SoLuong=?, MoTa=?, HinhAnh=?, MaDanhMuc=?, MaKM=? WHERE MaSP=?")) {

                ps.setString(1, tenSP);
                ps.setDouble(2, gia);
                ps.setInt(3, soLuong);
                ps.setString(4, moTa);
                ps.setString(5, hinhAnhDeLuu); // Dùng tên file đúng
                ps.setInt(6, maDanhMuc);

                if (maKM == null) ps.setNull(7, java.sql.Types.INTEGER);
                else ps.setInt(7, maKM);

                ps.setInt(8, id);
                ps.executeUpdate();

                // Sửa redirect: Dùng contextPath
                response.sendRedirect(request.getContextPath() + "/adminProduct?action=list");

            } catch (SQLException e) {
                e.printStackTrace();
                response.getWriter().println("Lỗi khi cập nhật sản phẩm!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Lỗi xử lý upload tệp", e);
        }
    }
    
    // ... (Các hàm deleteProduct, loadCategories, loadPromotions, listProducts... giữ nguyên) ...
    // ... (Bạn cần dán các hàm còn lại của bạn vào đây) ...
    private int getTotalProducts() {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM SanPham WHERE DaXoa = 0";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> products = new ArrayList<>();
        int pageSize = 8; 
        int currentPage = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }
        int totalProducts = getTotalProducts();
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
        int offset = (currentPage - 1) * pageSize;
        String sql = "SELECT * FROM SanPham WHERE DaXoa = 0 ORDER BY MaSP DESC LIMIT ? OFFSET ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pageSize);
            ps.setInt(2, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setMaSP(rs.getInt("MaSP"));
                p.setTenSP(rs.getString("TenSP"));
                p.setCodeSP(rs.getString("CodeSP"));
                p.setGia(rs.getDouble("Gia"));
                p.setSoLuong(rs.getInt("SoLuong"));
                p.setHinhAnh(rs.getString("HinhAnh"));
                p.setMoTa(rs.getString("MoTa"));
                products.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        request.setAttribute("products", products);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        request.getRequestDispatcher("jsp/product-list.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM SanPham WHERE MaSP = ?")) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Product p = new Product();
                p.setMaSP(rs.getInt("MaSP"));
                p.setTenSP(rs.getString("TenSP"));
                p.setGia(rs.getDouble("Gia"));
                p.setSoLuong(rs.getInt("SoLuong"));
                p.setMoTa(rs.getString("MoTa"));
                p.setMaDanhMuc(rs.getInt("MaDanhMuc"));
                p.setHinhAnh(rs.getString("HinhAnh"));
                p.setMaKM(rs.getInt("MaKM"));
                request.setAttribute("product", p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        loadCategories(request);
        loadPromotions(request);
        request.getRequestDispatcher("jsp/product-edit.jsp").forward(request, response);
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE SanPham SET DaXoa = 1 WHERE MaSP = ?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/adminProduct?action=list");
    }

    private void loadCategories(HttpServletRequest request) {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM DanhMuc")) {
            ResultSet rs = ps.executeQuery();
            List<Map<String, Object>> categories = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> cat = new HashMap<>();
                cat.put("MaDanhMuc", rs.getInt("MaDanhMuc"));
                cat.put("TenDanhMuc", rs.getString("TenDanhMuc"));
                categories.add(cat);
            }
            request.setAttribute("categories", categories);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 🟢 1. HÀM HIỂN THỊ THÙNG RÁC
    private void listTrashProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> trashList = new ArrayList<>();
        // Lấy danh sách có DaXoa = 1
        String sql = "SELECT * FROM SanPham WHERE DaXoa = 1 ORDER BY MaSP DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setMaSP(rs.getInt("MaSP"));
                p.setTenSP(rs.getString("TenSP"));
                p.setGia(rs.getDouble("Gia"));
                p.setSoLuong(rs.getInt("SoLuong"));
                p.setHinhAnh(rs.getString("HinhAnh"));
                p.setMaDanhMuc(rs.getInt("MaDanhMuc"));
                p.setMaKM(rs.getInt("MaKM"));
                trashList.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        request.setAttribute("trashList", trashList);
        // Chuyển sang trang giao diện thùng rác (bạn sẽ tạo ở bước 3)
        request.getRequestDispatcher("jsp/product-trash.jsp").forward(request, response);
    }

    // 🟢 2. HÀM KHÔI PHỤC SẢN PHẨM
    private void restoreProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        
        // Chuyển DaXoa từ 1 về 0
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE SanPham SET DaXoa = 0 WHERE MaSP = ?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // Khôi phục xong thì load lại trang thùng rác
        response.sendRedirect(request.getContextPath() + "/adminProduct?action=trash");
    }
    
    private void loadPromotions(HttpServletRequest request) {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM KhuyenMai")) {
            ResultSet rs = ps.executeQuery();
            List<Map<String, Object>> promotions = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> km = new HashMap<>();
                km.put("MaKM", rs.getInt("MaKM"));
                km.put("TenKM", rs.getString("TenKM"));
                km.put("PhanTramGiam", rs.getDouble("PhanTramGiam"));
                promotions.add(km);
            }
            request.setAttribute("promotions", promotions);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}