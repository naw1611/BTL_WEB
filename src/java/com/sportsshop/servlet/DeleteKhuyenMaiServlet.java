package com.sportsshop.servlet;

import com.sportsshop.dao.KhuyenMaiDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

// QUAN TRỌNG: Không dùng @WebServlet
public class DeleteKhuyenMaiServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        try {
            int maKM = Integer.parseInt(req.getParameter("maKM"));
            new KhuyenMaiDAO().delete(maKM); 
            
        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
        }
        
        // Chuyển hướng về trang danh sách (khớp với web.xml)
        resp.sendRedirect(req.getContextPath() + "/adminKhuyenMai");
    }
}