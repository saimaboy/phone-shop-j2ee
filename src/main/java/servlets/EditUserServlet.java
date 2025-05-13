package servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

public class EditUserServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // User class with necessary getter and setter methods
    public static class User {
        private int userId;
        private String userName;
        private String lname;
        private String userEmail;
        private String userPassword;
        private String userPhone;
        private String userAddress;
        private int userStatus;
        private String userType;

        // Getter and setter for userId
        public int getUserId() {
            return userId;
        }

        public void setUserId(int userId) {
            this.userId = userId;
        }

        // Getter and setter for userName
        public String getUserName() {
            return userName;
        }

        public void setUserName(String userName) {
            this.userName = userName;
        }

        // Getter and setter for lname
        public String getLname() {
            return lname;
        }

        public void setLname(String lname) {
            this.lname = lname;
        }

        // Getter and setter for userEmail
        public String getUserEmail() {
            return userEmail;
        }

        public void setUserEmail(String userEmail) {
            this.userEmail = userEmail;
        }

        // Getter and setter for userPassword
        public String getUserPassword() {
            return userPassword;
        }

        public void setUserPassword(String userPassword) {
            this.userPassword = userPassword;
        }

        // Getter and setter for userPhone
        public String getUserPhone() {
            return userPhone;
        }

        public void setUserPhone(String userPhone) {
            this.userPhone = userPhone;
        }

        // Getter and setter for userAddress
        public String getUserAddress() {
            return userAddress;
        }

        public void setUserAddress(String userAddress) {
            this.userAddress = userAddress;
        }

        // Getter and setter for userStatus
        public int getUserStatus() {
            return userStatus;
        }

        public void setUserStatus(int userStatus) {
            this.userStatus = userStatus;
        }

        // Getter and setter for userType
        public String getUserType() {
            return userType;
        }

        public void setUserType(String userType) {
            this.userType = userType;
        }
    }

    // Display the user details for editing
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("user_id");

        // Database connection settings
        String dbUrl = "jdbc:mysql://localhost:3306/phone_shop";  // Update with your DB info
        String dbUsername = "root";  // Update with your DB username
        String dbPassword = "12345678";  // Update with your DB password

        // Load MySQL JDBC driver
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
            return;
        }

        // Fetch user details for editing
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        User user = null;  // Create a User object to hold the data

        try {
            conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
            String selectQuery = "SELECT * FROM users WHERE user_id = ?";
            pstmt = conn.prepareStatement(selectQuery);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                // Assuming the user table has columns: user_id, user_name, lname, user_email, etc.
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUserName(rs.getString("user_name"));
                user.setLname(rs.getString("lname"));
                user.setUserEmail(rs.getString("user_email"));
                user.setUserPassword(rs.getString("user_password"));
                user.setUserPhone(rs.getString("user_phone"));
                user.setUserAddress(rs.getString("user_address"));
                user.setUserStatus(rs.getInt("user_status"));
                user.setUserType(rs.getString("user_type"));
            }

            // Pass the user object to the JSP for rendering
            request.setAttribute("user", user);
            RequestDispatcher dispatcher = request.getRequestDispatcher("edit_user.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
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

    // Handle the form submission to update user details
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("user_id");
        String userName = request.getParameter("user_name");
        String lname = request.getParameter("lname");
        String userEmail = request.getParameter("user_email");
        String userPassword = request.getParameter("user_password"); // Password is optional, can be empty
        String userPhone = request.getParameter("user_phone");
        String userAddress = request.getParameter("user_address");
        int userStatus = Integer.parseInt(request.getParameter("user_status"));
        String userType = request.getParameter("user_type");

        // Database connection settings
        String dbUrl = "jdbc:mysql://localhost:3306/phone_shop";  // Update with your DB info
        String dbUsername = "root";  // Update with your DB username
        String dbPassword = "12345678";  // Update with your DB password

        // Load MySQL JDBC driver
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
            return;
        }

        // Update user details
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);

            String updateQuery;
            int parameterIndex = 1; // Keep track of the parameter index

            if (userPassword != null && !userPassword.trim().isEmpty()) {
                // If password is provided, include it in the update query
                updateQuery = "UPDATE users SET user_name = ?, lname = ?, user_email = ?, user_password = ?, user_phone = ?, user_address = ?, user_status = ?, user_type = ? WHERE user_id = ?";
                pstmt = conn.prepareStatement(updateQuery);
                pstmt.setString(parameterIndex++, userName);
                pstmt.setString(parameterIndex++, lname);
                pstmt.setString(parameterIndex++, userEmail);
                pstmt.setString(parameterIndex++, userPassword);
                pstmt.setString(parameterIndex++, userPhone);
                pstmt.setString(parameterIndex++, userAddress);
                pstmt.setInt(parameterIndex++, userStatus);
                pstmt.setString(parameterIndex++, userType);
                pstmt.setInt(parameterIndex++, Integer.parseInt(userId)); // Set the user ID last
            } else {
                // If no password, do not set it
                updateQuery = "UPDATE users SET user_name = ?, lname = ?, user_email = ?, user_phone = ?, user_address = ?, user_status = ?, user_type = ? WHERE user_id = ?";
                pstmt = conn.prepareStatement(updateQuery);
                pstmt.setString(parameterIndex++, userName);
                pstmt.setString(parameterIndex++, lname);
                pstmt.setString(parameterIndex++, userEmail);
                pstmt.setString(parameterIndex++, userPhone);
                pstmt.setString(parameterIndex++, userAddress);
                pstmt.setInt(parameterIndex++, userStatus);
                pstmt.setString(parameterIndex++, userType);
                pstmt.setInt(parameterIndex++, Integer.parseInt(userId)); // Set the user ID last
            }

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                response.sendRedirect("admin-user.jsp?status=success");
            } else {
                response.sendRedirect("admin-user.jsp?status=fail");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("admin-user.jsp?status=error");
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