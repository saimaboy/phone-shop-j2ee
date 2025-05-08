package servlets;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;

public class EditProductServlet extends HttpServlet {
    
    // Display the product for editing
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productId = request.getParameter("product_id");

        // Database connection settings
        String dbUrl = "jdbc:mysql://localhost:3306/phone_shop";
        String dbUsername = "root";
        String dbPassword = "12345678";
        
        // Fetch the product details for editing
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
            String selectQuery = "SELECT * FROM products WHERE id = ?";
            pstmt = conn.prepareStatement(selectQuery);
            pstmt.setInt(1, Integer.parseInt(productId));
            rs = pstmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("product", rs);  // Set the product data in request scope
                RequestDispatcher dispatcher = request.getRequestDispatcher("EditProductPage.jsp");  // Forward to the edit page
                dispatcher.forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
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

    // Handle the form submission to update the product
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productId = request.getParameter("id");
        String productName = request.getParameter("product_name");
        String price = request.getParameter("price");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String stockQuantity = request.getParameter("stock_quantity");
        String imageUrl = request.getParameter("image_url");

        // Database connection settings
        String dbUrl = "jdbc:mysql://localhost:3306/phone_shop";
        String dbUsername = "root";
        String dbPassword = "12345678";
        
        // Update the product in the database
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
            String updateQuery = "UPDATE products SET product_name = ?, price = ?, description = ?, category = ?, stock_quantity = ?, image_url = ? WHERE id = ?";
            pstmt = conn.prepareStatement(updateQuery);
            pstmt.setString(1, productName);
            pstmt.setDouble(2, Double.parseDouble(price));
            pstmt.setString(3, description);
            pstmt.setString(4, category);
            pstmt.setInt(5, Integer.parseInt(stockQuantity));
            pstmt.setString(6, imageUrl);
            pstmt.setInt(7, Integer.parseInt(productId));

            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                response.sendRedirect("ProductManagementPage.jsp");  // Redirect to product management page after update
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unable to update product");
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
