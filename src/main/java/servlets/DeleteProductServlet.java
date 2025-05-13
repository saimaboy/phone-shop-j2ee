package servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

public class DeleteProductServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productIdStr = request.getParameter("product_id");

        // Database connection settings
        String dbUrl = "jdbc:mysql://localhost:3306/phone_shop";  // Update with your DB info
        String dbUsername = "root";  // Update with your DB username
        String dbPassword = "12345678";  // Update with your DB password
        
        // Database connection
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Establish connection
            conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
            
            // Step 1: Delete related records from the 'order_items' table where product_id matches
            String deleteOrderItemsQuery = "DELETE FROM order_items WHERE product_id = ?";
            pstmt = conn.prepareStatement(deleteOrderItemsQuery);
            pstmt.setString(1, productIdStr);
            pstmt.executeUpdate();  // Execute the delete from the order_items table

            // Step 2: Delete related records from the 'orders' table where product_id is involved
            String deleteOrdersQuery = "DELETE FROM orders WHERE order_id IN (SELECT order_id FROM order_items WHERE product_id = ?)";
            pstmt = conn.prepareStatement(deleteOrdersQuery);
            pstmt.setString(1, productIdStr);
            pstmt.executeUpdate();  // Execute the delete from the orders table

            // Step 3: Delete related records from the 'cart' table where product_id matches
            String deleteCartQuery = "DELETE FROM cart WHERE product_id = ?";
            pstmt = conn.prepareStatement(deleteCartQuery);
            pstmt.setString(1, productIdStr);
            pstmt.executeUpdate();  // Execute the delete from the cart table

            // Step 4: Now delete the product from the 'products' table
            String deleteProductQuery = "DELETE FROM products WHERE id = ?";
            pstmt = conn.prepareStatement(deleteProductQuery);
            pstmt.setString(1, productIdStr);
            
            // Execute delete
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                response.sendRedirect("employee-product.jsp?status=success");
            } else {
                response.sendRedirect("employee-product.jsp?status=fail");
            }

        } catch (SQLException e) {
            // Handle database errors
            e.printStackTrace();
            response.sendRedirect("employee-product.jsp?status=error");
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
