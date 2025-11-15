package com.sportsshop.servlet;

import com.sportsshop.dao.KhuyenMaiDAO;
import com.sportsshop.model.KhuyenMai;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.SQLException;
import java.util.*;

public class AdminKhuyenMaiServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<KhuyenMai> list = new KhuyenMaiDAO().getAll();
            req.setAttribute("listKM", list);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        req.getRequestDispatcher("jsp/admin-khuyenmai.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String tenKM = req.getParameter("tenKM");
        String noiDung = req.getParameter("noiDung");
        String ngayBatDau = req.getParameter("ngayBatDau");
        String ngayKetThuc = req.getParameter("ngayKetThuc");
        double phanTramGiam = Double.parseDouble(req.getParameter("phanTramGiam"));

        KhuyenMai km = new KhuyenMai();
        km.setTenKM(tenKM);
        km.setNoiDung(noiDung);
        km.setNgayBatDau(java.sql.Date.valueOf(ngayBatDau));
        km.setNgayKetThuc(java.sql.Date.valueOf(ngayKetThuc));
        km.setPhanTramGiam(phanTramGiam);

        try {
            new KhuyenMaiDAO().add(km);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        resp.sendRedirect("adminKhuyenMai?action=list");
    }
}
