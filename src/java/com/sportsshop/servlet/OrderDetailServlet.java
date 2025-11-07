package com.sportsshop.servlet;

import com.sportsshop.dao.OrderDAO;
import com.sportsshop.model.Order;
import com.sportsshop.model.OrderDetail;
import com.sportsshop.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class OrderDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        User user = (User) session.getAttribute("user");

        try {
            // Lấy MaDon từ URL (vd: ?id=4)
            int maDon = Integer.parseInt(request.getParameter("id"));
            
            OrderDAO orderDAO = new OrderDAO();
            
            // ✅ [SỬA ĐỔI 1] Lấy thông tin đơn hàng (đã bao gồm thông tin user)
            // Hàm này KHÔNG kiểm tra quyền, chỉ lấy dữ liệu thô
            Order order = orderDAO.getOrderWithUser(maDon);

            // ✅ [SỬA ĐỔI 2] KIỂM TRA BẢO MẬT TẠI SERVLET
            // Nếu:
            // 1. Không tìm thấy đơn hàng (order == null)
            // HOẶC
            // 2. Người xem KHÔNG PHẢI admin VÀ người xem cũng KHÔNG PHẢI chủ đơn hàng
            // -> Thì chặn truy cập
            if (order == null || (!user.getRole().equals("admin") && order.getMaUser() != user.getMaUser())) {
                // Chuyển về trang danh sách (tránh xem trộm)
                response.sendRedirect("order?action=view");
                return;
            }

            // 3. Lấy danh sách sản phẩm (Hàm này không đổi)
            List<OrderDetail> detailList = orderDAO.getOrderDetailsByOrderId(maDon);

            // 4. Gửi 2 bộ dữ liệu này sang JSP
            request.setAttribute("order", order);
            // ✅ [SỬA ĐỔI 3] Gửi với tên "orderDetails" để khớp với tệp JSP cũ (bản admin) của bạn
            request.setAttribute("orderDetails", detailList); 

            // Chuyển đến jsp/order-detail.jsp
            request.getRequestDispatcher("jsp/order-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            // Nếu URL không có ?id=...
            e.printStackTrace();
            response.sendRedirect("order?action=view");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("order?action=view");
        }
    }
}