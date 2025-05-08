package servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class DeleteUserServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("user_id");

        // Database connection settings
        String dbUrl = "jdbc:mysql://localhost:3306/phone_shop";  // Update with your DB info
        String dbUsername = "root";  // Update with your DB username
        String dbPassword = "12345678";  // Update with your DB password
        
        // Delete the user from the database
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
            String deleteQuery = "DELETE FROM users WHERE user_id = ?";
            pstmt = conn.prepareStatement(deleteQuery);
            pstmt.setInt(1, Integer.parseInt(userId));

            int rowsDeleted = pstmt.executeUpdate();
            if (rowsDeleted > 0) {
                response.sendRedirect("UserManagementPage.jsp");  // Redirect after deletion
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unable to delete user");
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
