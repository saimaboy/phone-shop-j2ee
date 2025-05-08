package servlets;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;

public class EditOrderServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderId = request.getParameter("order_id");

        // Database connection settings
        String dbUrl = "jdbc:mysql://localhost:3306/phone_shop";
        String dbUsername = "root";
        String dbPassword = "12345678";
        
        // Fetch the order details to pre-fill the edit form
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
            String selectQuery = "SELECT * FROM orders WHERE order_id = ?";
            pstmt = conn.prepareStatement(selectQuery);
            pstmt.setInt(1, Integer.parseInt(orderId));
            rs = pstmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("order", rs);  // Set order data as request attribute
                RequestDispatcher dispatcher = request.getRequestDispatcher("EditOrderPage.jsp");  // Forward to the edit page
                dispatcher.forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Method to handle the form submission for updating the order
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderId = request.getParameter("order_id");
        String orderStatus = request.getParameter("order_status");  // Example: Could be updated from the form

        // Database connection settings
        String dbUrl = "jdbc:mysql://localhost:3306/phone_shop";
        String dbUsername = "root";
        String dbPassword = "12345678";
        
        // Update order in the database
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
            String updateQuery = "UPDATE orders SET order_status = ? WHERE order_id = ?";
            pstmt = conn.prepareStatement(updateQuery);
            pstmt.setString(1, orderStatus);
            pstmt.setInt(2, Integer.parseInt(orderId));

            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                response.sendRedirect("OrderManagementPage.jsp");  // Redirect after updating
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unable to update order");
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
