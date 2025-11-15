<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ include file="header.jsp" %>

<h2>👥 Quản lý người dùng</h2>

<table border="1" cellspacing="0" cellpadding="8" style="width:100%; text-align:center;">
    <thead style="background:#007bff; color:white;">
        <tr>
            <th>Mã</th>
            <th>Tên đăng nhập</th>
            <th>Họ tên</th>
            <th>Email</th>
            <th>Điện thoại</th>
            <th>Địa chỉ</th>
            <th>Ngày tạo</th>
            <th>Quyền</th>
            <th>Trạng thái</th>
            <th>Hành động</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="u" items="${users}">
            <tr>
                <td>${u.maUser}</td>
                <td>${u.username}</td>
                <td>${u.fullName}</td>
                <td>${u.email}</td>
                <td>${u.soDienThoai}</td>
                <td>${u.diaChi}</td>
                <td>${u.ngayTao}</td>
                <td>
                    <c:choose>
                        <c:when test="${u.role == 'admin'}">
                            <span style="color:red; font-weight:bold;">Admin</span>
                        </c:when>
                        <c:otherwise>
                            Người dùng
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${u.trangThai}">
                            <span style="color:green;">Hoạt động</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color:red;">Bị khóa</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <a href="adminUser?action=edit&id=${u.maUser}" style="text-decoration:none;">✏️ Sửa</a>
                    <a href="adminUser?action=history&id=${u.maUser}">🧾 Lịch sử mua hàng</a>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>

<%@ include file="footer.jsp" %>
