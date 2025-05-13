package servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import utils.DBConnection;  // Import the DBConnection utility class

public class UpdateProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve form values
        String userId = request.getParameter("user_id");
        String firstName = request.getParameter("user_name");
        String lastName = request.getParameter("lname");
        String email = request.getParameter("user_email");
        String address = request.getParameter("user_address");
        String currentPassword = request.getParameter("user_password");
        String newPassword = request.getParameter("new_password");
        String confirmNewPassword = request.getParameter("confirm_new_password");

        // Check if user_id is valid
        if (userId == null || userId.isEmpty()) {
            request.setAttribute("errorMessage", "User ID is missing. Cannot update profile.");
            request.getRequestDispatcher("error.jsp").forward(request, response); // Redirect to an error page
            return;
        }

        // Database connection variables
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Use DBConnection utility class to get the database connection
            conn = DBConnection.getConnection();

            // Update user details in the database
            String updateUserSql = "UPDATE users SET user_name = ?, lname = ?, user_email = ?, user_address = ? WHERE user_id = ?";
            stmt = conn.prepareStatement(updateUserSql);
            stmt.setString(1, firstName);
            stmt.setString(2, lastName);
            stmt.setString(3, email);
            stmt.setString(4, address);
            stmt.setInt(5, Integer.parseInt(userId));  // Safely convert userId to integer

            int rowsUpdated = stmt.executeUpdate();
            boolean passwordChanged = false; // Flag to track if password was changed

            if (rowsUpdated > 0) {
                // If password is changed, update it
                if (newPassword != null && !newPassword.isEmpty() && newPassword.equals(confirmNewPassword)) {
                    // Verify the current password is correct
                    String checkPasswordSql = "SELECT user_password FROM users WHERE user_id = ?";
                    stmt = conn.prepareStatement(checkPasswordSql);
                    stmt.setInt(1, Integer.parseInt(userId));
                    rs = stmt.executeQuery();
                    if (rs.next() && rs.getString("user_password").equals(currentPassword)) {
                        // Password is correct, update it
                        String updatePasswordSql = "UPDATE users SET user_password = ? WHERE user_id = ?";
                        PreparedStatement passwordStmt = conn.prepareStatement(updatePasswordSql);
                        passwordStmt.setString(1, newPassword);
                        passwordStmt.setInt(2, Integer.parseInt(userId));
                        passwordStmt.executeUpdate();
                        passwordChanged = true; // Set flag to true if password is updated
                    } else {
                        // If the current password is incorrect, handle the error
                        request.setAttribute("errorMessage", "Incorrect current password.");
                        request.getRequestDispatcher("profile.jsp?user_id=" + userId).forward(request, response);
                        return;
                    }
                }
            }

            // If password was changed, set success message in request attributes
            if (passwordChanged) {
                request.setAttribute("passwordChanged", true); // Flag for password change success
            }

            // Redirect to the profile page after updating
            response.sendRedirect("profile.jsp?user_id=" + userId);

        } catch (SQLException e) {
            e.printStackTrace();
            // Handle any database errors
            request.setAttribute("errorMessage", "Error updating profile: " + e.getMessage());
            request.getRequestDispatcher("profile.jsp?user_id=" + userId).forward(request, response);
        } catch (NumberFormatException e) {
            // Handle case where user_id is not a valid number
            e.printStackTrace();
            request.setAttribute("errorMessage", "Invalid user ID format.");
            request.getRequestDispatcher("error.jsp").forward(request, response);  // Redirect to an error page
        } finally {
            // Close database resources
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
