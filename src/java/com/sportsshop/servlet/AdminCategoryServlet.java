package com.sportsshop.servlet;

import com.sportsshop.dao.CategoryDAO;
import com.sportsshop.model.Category;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class AdminCategoryServlet extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAO();
    

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";
        List<Category> listDanhMuc = categoryDAO.getAllCategories();
        request.setAttribute("listDanhMuc", listDanhMuc);

        switch (action) {
            case "add":
                request.getRequestDispatcher("jsp/category-add.jsp").forward(request, response);
                break;
            case "edit":
                int id = Integer.parseInt(request.getParameter("id"));
                Category cat = categoryDAO.getCategoryById(id);
                request.setAttribute("category", cat);
                request.getRequestDispatcher("jsp/category-edit.jsp").forward(request, response);
                break;
            default:
                List<Category> list = categoryDAO.getAllCategories();
                request.setAttribute("categories", list);
                request.getRequestDispatcher("jsp/category-list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String action = request.getParameter("action");

        if ("insert".equals(action)) {
            Category c = new Category();
            c.setTenDanhMuc(request.getParameter("tenDanhMuc"));
            c.setMoTa(request.getParameter("moTa"));
            categoryDAO.insertCategory(c);
        } else if ("update".equals(action)) {
            Category c = new Category();
            c.setMaDanhMuc(Integer.parseInt(request.getParameter("id")));
            c.setTenDanhMuc(request.getParameter("tenDanhMuc"));
            c.setMoTa(request.getParameter("moTa"));
            categoryDAO.updateCategory(c);
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            categoryDAO.deleteCategory(id);
        }

        response.sendRedirect("adminCategory?action=list");
    }
}
