package servlets;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;

public class CancelOrderServlet extends HttpServlet {
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
        
        // Delete the order from the database
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
            String deleteQuery = "DELETE FROM orders WHERE order_id = ?";
            pstmt = conn.prepareStatement(deleteQuery);
            pstmt.setInt(1, Integer.parseInt(orderId));

            int rowsDeleted = pstmt.executeUpdate();
            if (rowsDeleted > 0) {
                response.sendRedirect("OrderManagementPage.jsp");  // Redirect after deletion
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unable to cancel the order");
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
