package servlets;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class CancelOrderServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderIdStr = request.getParameter("order_id");
        
        // Database connection parameters
        String dbUrl = "jdbc:mysql://localhost:3306/phone_shop"; 
        String dbUsername = "root"; 
        String dbPassword = "12345678"; 

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Check if order_id is provided
            if (orderIdStr != null) {
                int orderId = Integer.parseInt(orderIdStr);

                // Establish a connection to the database
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
                
                // SQL query to update the order status to "Cancelled"
                String query = "UPDATE orders SET order_status = ? WHERE order_id = ?";
                stmt = conn.prepareStatement(query);
                stmt.setString(1, "Cancelled");  // Set status to "Cancelled"
                stmt.setInt(2, orderId);         // Set the order_id to target the correct order
                
                int rowsUpdated = stmt.executeUpdate();  // Execute the update query

                if (rowsUpdated > 0) {
                    // Successfully cancelled the order
                    response.sendRedirect("admin-order.jsp");  // Redirect back to the order management page
                } else {
                    // Error cancelling the order
                    response.getWriter().println("Error cancelling order.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
