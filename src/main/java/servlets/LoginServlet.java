package servlets;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;
import utils.DBConnection;  // Import the DBConnection class
import java.util.logging.Level;
import java.util.logging.Logger;
import java.security.MessageDigest;  // For password hashing
import java.security.NoSuchAlgorithmException;

public class LoginServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get user input from the form
        String email = request.getParameter("user_email");
        String password = request.getParameter("user_password");

        // Declare database-related variables
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Validate input (to prevent SQL injection or empty fields)
            if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
                request.setAttribute("loginMessage", "failure");
                request.setAttribute("errorMessage", "Email and password are required.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // Hash the password before querying the database


            // Get database connection from the DBConnection class
            conn = DBConnection.getConnection();  // Use the utility class for connection

            // SQL query to find the user based on email and hashed password
            String sql = "SELECT * FROM users WHERE user_email = ? AND user_password = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, password);

            rs = stmt.executeQuery();

            // Check if the user exists
            if (rs.next()) {
                String userType = rs.getString("user_type"); // Assuming "user_type" is the field in your DB
                int userIdStr = rs.getInt("user_id"); // Assuming "user_id" is the field in your DB

                // Set user details in the session
                HttpSession session = request.getSession();
                session.setAttribute("userEmail", email);
                session.setAttribute("userType", userType);
                session.setAttribute("userIdStr", userIdStr); // Store user_id in session

                // Set success message for login
                request.setAttribute("loginMessage", "success");

                // Redirect based on the user role, passing the user_id in the URL
                if ("customer".equalsIgnoreCase(userType)) {
                    response.sendRedirect("home.jsp?user_id=" + userIdStr); // Redirect to the customer home page with user_id
                } else if ("admin".equalsIgnoreCase(userType)) {
                    response.sendRedirect("admin-dashboard.jsp?user_id=" + userIdStr); // Redirect to admin dashboard with user_id
                } else if ("employee".equalsIgnoreCase(userType)) {
                    response.sendRedirect("employee-dashboard.jsp?user_id=" + userIdStr); // Redirect to employee dashboard with user_id
                } else if ("supplier".equalsIgnoreCase(userType)) {
                    response.sendRedirect("supplier-dashboard.jsp?user_id=" + userIdStr); // Redirect to supplier dashboard with user_id
                } else {
                    // If user type is unknown or not assigned, show error message
                    request.setAttribute("errorMessage", "Invalid user type");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } else {
                // Invalid login credentials
                request.setAttribute("loginMessage", "failure");
                request.setAttribute("errorMessage", "Invalid email or password.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error occurred while attempting login.", e);
            // Handle database errors
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }  catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error occurred.", e);
            // Handle other unexpected errors
            request.setAttribute("errorMessage", "Unexpected error: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } finally {
            // Close the database resources
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources.", e);
            }
        }
    }

    
}
