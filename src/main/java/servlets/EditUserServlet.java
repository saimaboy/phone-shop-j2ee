package servlets;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;

public class EditUserServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	// Display the user details for editing
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("user_id");

        // Database connection settings
        String dbUrl = "jdbc:mysql://localhost:3306/phone_shop";  // Update with your DB info
        String dbUsername = "root";  // Update with your DB username
        String dbPassword = "1234567";  // Update with your DB password
        
        // Fetch user details for editing
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        User user = null;  // Create a User object to hold the data

        try {
            conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
            String selectQuery = "SELECT * FROM users WHERE user_id = ?";
            pstmt = conn.prepareStatement(selectQuery);
            pstmt.setInt(1, Integer.parseInt(userId));
            rs = pstmt.executeQuery();

            if (rs.next()) {
                // Create User object and set data
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUserName(rs.getString("user_name"));
                user.setLname(rs.getString("lname"));
                user.setUserEmail(rs.getString("user_email"));
                user.setUserPhone(rs.getString("user_phone"));
                user.setUserAddress(rs.getString("user_address"));
                user.setUserType(rs.getString("user_type"));
                user.setUserStatus(rs.getInt("user_status"));
                
                // Set user object as request attribute
                request.setAttribute("user", user);
                RequestDispatcher dispatcher = request.getRequestDispatcher("EditUserPage.jsp");  // Forward to the edit page
                dispatcher.forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
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

    // Handle the form submission to update the user
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("user_id");
        String userName = request.getParameter("user_name");
        String lname = request.getParameter("lname");
        String email = request.getParameter("user_email");
        String phone = request.getParameter("user_phone");
        String address = request.getParameter("user_address");
        String userType = request.getParameter("user_type");
        String userStatus = request.getParameter("user_status");

        // Database connection settings
        String dbUrl = "jdbc:mysql://localhost:3306/phone_shop";  // Update with your DB info
        String dbUsername = "root";  // Update with your DB username
        String dbPassword = "12345678";  // Update with your DB password
        
        // Update the user in the database
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
            String updateQuery = "UPDATE users SET user_name = ?, lname = ?, user_email = ?, user_phone = ?, user_address = ?, user_type = ?, user_status = ? WHERE user_id = ?";
            pstmt = conn.prepareStatement(updateQuery);
            pstmt.setString(1, userName);
            pstmt.setString(2, lname);
            pstmt.setString(3, email);
            pstmt.setString(4, phone);
            pstmt.setString(5, address);
            pstmt.setString(6, userType);
            pstmt.setInt(7, Integer.parseInt(userStatus));
            pstmt.setInt(8, Integer.parseInt(userId));

            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                response.sendRedirect("UserManagementPage.jsp");  // Redirect to user management page after update
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unable to update user");
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
