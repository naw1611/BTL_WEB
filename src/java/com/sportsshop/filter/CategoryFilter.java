/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.sportsshop.filter;

import com.sportsshop.dao.CategoryDAO;
import com.sportsshop.model.Category;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import java.io.IOException;
import java.util.List;

/**
 *
 * @author Admin
 */
@WebFilter("/*")
public class CategoryFilter implements Filter {
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        List<Category> listDanhMuc = categoryDAO.getAllCategories();
        request.setAttribute("listDanhMuc", listDanhMuc);
        chain.doFilter(request, response);
    }
}
