package servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import utils.DBConnection;  // Import the DBConnection class

public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set content type
        response.setContentType("text/html");

        // Get form parameters
        String firstName = request.getParameter("user_name");
        String lastName = request.getParameter("lname");
        String email = request.getParameter("user_email");
        String password = request.getParameter("user_password");
        String confirmPassword = request.getParameter("user_seepassword");
        String phone = request.getParameter("user_phone");
        String address = request.getParameter("user_address");

        // Default user type to "customer" if not provided
        String userType = request.getParameter("user_type");
        if (userType == null || userType.isEmpty()) {
            userType = "customer";  // Default to "customer"
        }

        // Initialize PrintWriter to send response
        PrintWriter out = response.getWriter();

        // Simple validation: Check if passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("message", "failure");
            request.setAttribute("messageDetail", "Passwords do not match!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Initialize database connection variables
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Get database connection from the DBConnection utility class
            conn = DBConnection.getConnection();

            // Check if email already exists in the database
            String checkQuery = "SELECT * FROM users WHERE user_email = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
            checkStmt.setString(1, email);
            rs = checkStmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("message", "failure");
                request.setAttribute("messageDetail", "Email already registered. Please try a different one.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            } else {
                // Insert the new user into the database
                String insertQuery = "INSERT INTO users (user_name, lname, user_email, user_password, user_phone, user_address, user_status, user_type) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                stmt = conn.prepareStatement(insertQuery);

                stmt.setString(1, firstName);
                stmt.setString(2, lastName);
                stmt.setString(3, email);
                stmt.setString(4, password);  // In a real scenario, hash the password
                stmt.setString(5, phone);
                stmt.setString(6, address);
                stmt.setInt(7, 1);  // User status (active by default)
                stmt.setString(8, userType);  // Insert user type (customer by default if not selected)

                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected > 0) {
                    request.setAttribute("message", "success");
                    request.setAttribute("messageDetail", "Registration successful! You can now login.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                } else {
                    request.setAttribute("message", "failure");
                    request.setAttribute("messageDetail", "Something went wrong. Please try again.");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "failure");
            request.setAttribute("messageDetail", "Error: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } finally {
            // Close the database resources
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
