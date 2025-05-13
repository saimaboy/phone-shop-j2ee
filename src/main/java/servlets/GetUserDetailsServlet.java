package servlets;

import utils.DBConnection;
import java.sql.*;
import com.google.gson.Gson;
import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class GetUserDetailsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIdStr = request.getParameter("user_id");

        if (userIdStr == null || userIdStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("User ID is missing.");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            User user = getUserDetails(userId);

            if (user == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("User not found.");
            } else {
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print(new Gson().toJson(user));  // Send the user data as JSON
                out.flush();
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid user ID.");
        }
    }

    private User getUserDetails(int userId) {
        User user = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            String query = "SELECT user_name, lname, user_email FROM users WHERE user_id = ?";
            ps = conn.prepareStatement(query);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setFirstName(rs.getString("user_name"));
                user.setLastName(rs.getString("lname"));
                user.setEmail(rs.getString("user_email"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return user;
    }

    public class User {
        private String firstName;
        private String lastName;
        private String email;

        public String getFirstName() {
            return firstName;
        }

        public void setFirstName(String firstName) {
            this.firstName = firstName;
        }

        public String getLastName() {
            return lastName;
        }

        public void setLastName(String lastName) {
            this.lastName = lastName;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }
    }
}
