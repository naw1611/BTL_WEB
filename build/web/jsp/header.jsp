<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sports Shop</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="page-wrapper">
        <div class="banner">
            <img src="<%= request.getContextPath() %>/images/logo.jpg" alt="Sports Shop Logo" style="width: 100px;">
        </div>
        
        <div class="top-menu">
            <ul>
                <li><a href="<%= request.getContextPath() %>/index"><i class="fas fa-home"></i> Trang Chủ</a></li>
                <li><a href="<%= request.getContextPath() %>/products"><i class="fas fa-tshirt"></i> Sản Phẩm</a></li>
                
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li class="user-greeting">
    <a href="<%= request.getContextPath() %>/profile">
        <i class="fas fa-user"></i> Chào, <strong>${sessionScope.user.fullName}</strong>
    </a>
</li>
                        
                        <c:if test="${sessionScope.user.role == 'user'}">
                        <li><a href="<%= request.getContextPath() %>/contact"><i class="fas fa-envelope"></i> Liên Hệ</a></li>
                        <li>
                            <a href="<%= request.getContextPath() %>/order?action=view">
                                <i class="fas fa-file-invoice"></i> Đơn hàng của tôi
                            </a>
                        </li>
                        </c:if>
                        
                        <c:if test="${sessionScope.user.role == 'admin'}">
                            <li><a href="<%= request.getContextPath() %>/admin"><i class="fas fa-cog"></i> Quản Lý</a></li>
                        </c:if>
                        <li><a href="<%= request.getContextPath() %>/logout"><i class="fas fa-sign-out-alt"></i> Đăng Xuất</a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="<%= request.getContextPath() %>/register"><i class="fas fa-user-plus"></i> Đăng Ký</a></li>
                        <li><a href="<%= request.getContextPath() %>/login"><i class="fas fa-sign-in-alt"></i> Đăng Nhập</a></li>
                    </c:otherwise>
                </c:choose>
                <c:if test="${sessionScope.user.role == 'user'}">
                <li class="cart-link">
                    <a href="<%= request.getContextPath() %>/cart">
                        <i class="fas fa-shopping-cart"></i> Giỏ Hàng 
                        <span id="cart-count" class="cart-badge">
                            ${sessionScope.cartCount != null ? sessionScope.cartCount : 0}
                        </span>
                    </a>
                </li>
                </c:if>
                <c:if test="${sessionScope.user.role == 'admin'}">
                    <li><a href="adminReport">📈 Báo cáo & Thống kê</a></li>
                </c:if>
            </ul>
        </div>
        
        <div class="main-content">
            <div class="container">
                <div class="left-menu">
                    <%@ include file="left-menu.jsp" %>
                </div>
                <div class="content">
