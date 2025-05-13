package servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

public class DeleteUserServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve user ID from the request
        String userIdStr = request.getParameter("user_id");
        
        // Set up database connection parameters
        String dbUrl = "jdbc:mysql://localhost:3306/phone_shop"; // Update with your DB info
        String dbUsername = "root"; // Update with your DB username
        String dbPassword = "12345678"; // Update with your DB password
        
        // Database connection
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Establish connection
            conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
            
            // Step 1: Delete related records from the 'order_items' table
            String deleteOrderItemsQuery = "DELETE FROM order_items WHERE order_id IN (SELECT order_id FROM orders WHERE user_id = ?)";
            pstmt = conn.prepareStatement(deleteOrderItemsQuery);
            pstmt.setString(1, userIdStr);
            pstmt.executeUpdate(); // Execute the delete from the order_items table
            
            // Step 2: Delete related records from the 'orders' table
            String deleteOrderQuery = "DELETE FROM orders WHERE user_id = ?";
            pstmt = conn.prepareStatement(deleteOrderQuery);
            pstmt.setString(1, userIdStr);
            pstmt.executeUpdate(); // Execute the delete from the orders table

            // Step 3: Delete related records from the 'cart' table
            String deleteCartQuery = "DELETE FROM cart WHERE user_id = ?";
            pstmt = conn.prepareStatement(deleteCartQuery);
            pstmt.setString(1, userIdStr);
            pstmt.executeUpdate(); // Execute the delete from the cart table

            // Step 4: Now, delete the user record
            String deleteUserQuery = "DELETE FROM users WHERE user_id = ?";
            pstmt = conn.prepareStatement(deleteUserQuery);
            pstmt.setString(1, userIdStr);
            
            // Execute delete
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                // Redirect to a success page or show success message
                response.sendRedirect("admin-user.jsp");
            } else {
                // Handle case where no rows were deleted
                response.sendRedirect("admin-user.jsp");
            }

        } catch (SQLException e) {
            // Handle database errors
            e.printStackTrace();
            response.sendRedirect("admin-user.jsp");
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
