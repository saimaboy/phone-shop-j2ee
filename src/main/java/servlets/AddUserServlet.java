package servlets;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class AddUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get user details from the request
        String firstName = request.getParameter("user_name");
        String lastName = request.getParameter("lname");
        String email = request.getParameter("user_email");
        String password = request.getParameter("user_password");
        String phone = request.getParameter("user_phone");
        String address = request.getParameter("user_address");
        String userType = request.getParameter("user_type");
        String userStatusStr = request.getParameter("user_status");
        int userStatus = Integer.parseInt(userStatusStr);  // 1 for active, 0 for inactive
        
        // Database connection parameters
        String dbUrl = "jdbc:mysql://localhost:3306/phone_shop";
        String dbUsername = "root"; 
        String dbPassword = "12345678"; 

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Establish connection to the database
        	Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);

            // SQL query to insert a new user
            String query = "INSERT INTO users (user_name, lname, user_email, user_password, user_phone, user_address, user_type, user_status) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            
            stmt = conn.prepareStatement(query);
            stmt.setString(1, firstName);      // First Name
            stmt.setString(2, lastName);       // Last Name
            stmt.setString(3, email);          // Email
            stmt.setString(4, password);       // Password
            stmt.setString(5, phone);          // Phone
            stmt.setString(6, address);        // Address
            stmt.setString(7, userType);       // User Type
            stmt.setInt(8, userStatus);        // User Status (Active or Inactive)
            
            int rowsInserted = stmt.executeUpdate();  // Execute the insert query

            if (rowsInserted > 0) {
                // Successfully added the new user
                response.sendRedirect("admin-user.jsp");  // Redirect to the User Management page
            } else {
                // Error adding the user
                response.getWriter().println("Error adding user.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        } catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
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
