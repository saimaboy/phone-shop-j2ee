package servlets;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.sql.*;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
                 maxFileSize = 1024 * 1024 * 5,   // 5MB
                 maxRequestSize = 1024 * 1024 * 10) // 10MB
public class EditProductServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        String productIdStr = request.getParameter("product_id");
        String productName = request.getParameter("product_name");

        // Handle price and stock quantity - check for null and empty values
        String priceStr = request.getParameter("price");
        String stockQuantityStr = request.getParameter("stock_quantity");

        double price = 0.0;
        int stockQuantity = 0;

        // Validate and parse price if valid
        if (priceStr != null && !priceStr.trim().isEmpty()) {
            try {
                price = Double.parseDouble(priceStr);
            } catch (NumberFormatException e) {
                // Handle invalid format if necessary
                e.printStackTrace();
            }
        }

        // Validate and parse stock quantity if valid
        if (stockQuantityStr != null && !stockQuantityStr.trim().isEmpty()) {
            try {
                stockQuantity = Integer.parseInt(stockQuantityStr);
            } catch (NumberFormatException e) {
                // Handle invalid format if necessary
                e.printStackTrace();
            }
        }

        String description = request.getParameter("description");
        String category = request.getParameter("category");

        // Handle file upload for image
        Part imagePart = request.getPart("image_url");
        String imageUrl = null;

        if (imagePart != null && imagePart.getSize() > 0) {
            String fileName = imagePart.getSubmittedFileName();
            String uploadDir = getServletContext().getRealPath("/uploads");

            // Ensure the directory exists
            File dir = new File(uploadDir);
            if (!dir.exists()) {
                dir.mkdirs();  // Creates the directory if it doesn't exist
            }

            File uploadFile = new File(uploadDir, fileName);

            try {
                imagePart.write(uploadFile.getAbsolutePath());
                imageUrl = "/uploads/" + fileName;
            } catch (IOException e) {
                e.printStackTrace();
                response.getWriter().println("Error uploading file: " + e.getMessage());
                response.sendRedirect("employee-product.jsp?status=error");
                return;
            }
        }

        // Database connection details
        String dbUrl = "jdbc:mysql://localhost:3306/phone_shop";
        String dbUsername = "root";
        String dbPassword = "12345678";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Connect to the database
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);

            // Update query
            String query = "UPDATE products SET product_name = ?, price = ?, description = ?, category = ?, stock_quantity = ?, image_url = ? WHERE id = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, productName);
            pstmt.setDouble(2, price);
            pstmt.setString(3, description);
            pstmt.setString(4, category);
            pstmt.setInt(5, stockQuantity);
            pstmt.setString(6, imageUrl);
            pstmt.setInt(7, Integer.parseInt(productIdStr)); // Parse the product ID

            // Execute update
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                response.sendRedirect("employee-product.jsp?status=success");
            } else {
                response.sendRedirect("employee-product.jsp?status=error");
            }
        } catch (Exception e) {
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
