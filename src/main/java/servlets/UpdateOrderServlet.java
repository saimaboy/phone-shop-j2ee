package servlets;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class UpdateOrderServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get order details from the request
        String orderIdStr = request.getParameter("order_id");
        String orderStatus = request.getParameter("order_status");
        String totalStr = request.getParameter("total");

        // Database connection parameters
        String dbUrl = "jdbc:mysql://localhost:3306/phone_shop"; 
        String dbUsername = "root"; 
        String dbPassword = "12345678"; 

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Ensure all required parameters are provided
            if (orderIdStr != null && !orderIdStr.isEmpty() && orderStatus != null && !orderStatus.isEmpty() && totalStr != null && !totalStr.isEmpty()) {
                int orderId = Integer.parseInt(orderIdStr);
                double total = Double.parseDouble(totalStr);

                // Establish a connection to the database
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);

                // SQL query to update order details
                String query = "UPDATE orders SET order_status = ?, total = ? WHERE order_id = ?";
                stmt = conn.prepareStatement(query);
                stmt.setString(1, orderStatus);  // Set the new order status
                stmt.setDouble(2, total);        // Set the updated total
                stmt.setInt(3, orderId);         // Set the order_id to target the correct order

                int rowsUpdated = stmt.executeUpdate();  // Execute the update query

                if (rowsUpdated > 0) {
                    // Successfully updated the order
                    response.sendRedirect("admin-order.jsp");  // Redirect back to the order management page
                } else {
                    // Error updating the order
                    response.getWriter().println("Error updating order.");
                }
            } else {
                // Missing parameters
                response.getWriter().println("Missing parameters. Please ensure all fields are filled.");
            }
        } catch (SQLException | ClassNotFoundException | NumberFormatException e) {
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
