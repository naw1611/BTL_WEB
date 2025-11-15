<%@page import="com.sportsshop.model.Category"%>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<h2>DANH MỤC</h2>
<hr>
<ul>
    <%
        // Lấy danh sách danh mục từ request (được servlet truyền vào)
        List<Category> listDanhMuc = (List<Category>) request.getAttribute("listDanhMuc");

        if (listDanhMuc != null) {
            for (Category dm : listDanhMuc) {
    %>
                <li><a href="products?category=<%= dm.getMaDanhMuc() %>"><%= dm.getTenDanhMuc() %></a></li>
    <%
            }
        } else {
    %>
            <li>Không có danh mục nào</li>
    <%
        }
    %>
</ul>
