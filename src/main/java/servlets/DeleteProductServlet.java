package servlets;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;

public class DeleteProductServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productId = request.getParameter("product_id");

        // Database connection settings
        String dbUrl = "jdbc:mysql://localhost:3306/phone_shop";
        String dbUsername = "root";
        String dbPassword = "12345678";
        
        // Delete the product from the database
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
            String deleteQuery = "DELETE FROM products WHERE id = ?";
            pstmt = conn.prepareStatement(deleteQuery);
            pstmt.setInt(1, Integer.parseInt(productId));

            int rowsDeleted = pstmt.executeUpdate();
            if (rowsDeleted > 0) {
                response.sendRedirect("ProductManagementPage.jsp");  // Redirect after deletion
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unable to delete the product");
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
