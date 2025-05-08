package servlets;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;

public class UpdateOrderStatusServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderId = request.getParameter("order_id");
        String status = request.getParameter("status");
        
        // Database connection settings
        String dbUrl = "jdbc:mysql://localhost:3308/phone_shop";
        String dbUsername = "root";
        String dbPassword = "12345678";
        
        // Update order status in the database
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
            String updateQuery = "UPDATE orders SET order_status = ? WHERE order_id = ?";
            pstmt = conn.prepareStatement(updateQuery);
            pstmt.setString(1, status);
            pstmt.setInt(2, Integer.parseInt(orderId));

            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                response.sendRedirect("OrderManagementPage.jsp");  // Redirect to order management page after update
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unable to update order status");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
