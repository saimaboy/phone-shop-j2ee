<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile</title>
    <%@include file="./components/common.jsp" %>
    <link rel="stylesheet" href="./css/acc.css">
    <link rel="stylesheet" href="./css/home.css">
    <link rel="stylesheet" href="./css/root.css">
</head>
<body>
    <%@include file="./components/admin_nav.jsp" %>
      <!-- Error Message Section -->
      <% 
        // Check if password was changed
        Boolean passwordChanged = (Boolean) request.getAttribute("passwordChanged");
        if (passwordChanged != null && passwordChanged) {
    %>
        <script>
            alert("Password changed successfully!");
        </script>
    <% 
        }
    %>
    <% 
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (errorMessage != null && !errorMessage.isEmpty()) {
    %>
        <div class="error-message">
            <h3>Error:</h3>
            <p><%= errorMessage %></p>
        </div>
    <% 
        }
    %>

    <% 
        // Retrieve user_id from the URL
        String userId = request.getParameter("user_id");

        // Database connection variables
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        String dbURL = "jdbc:mysql://localhost:3306/phone_shop";
        String dbUsername = "root";
        String dbPassword = "12345678";

        try {
            // Load MySQL JDBC driver and establish the connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUsername, dbPassword);

            // SQL query to fetch user details based on user_id
            String userSql = "SELECT * FROM users WHERE user_id = ?";
            stmt = conn.prepareStatement(userSql);
            stmt.setInt(1, Integer.parseInt(userId));
            rs = stmt.executeQuery();

            // Check if user exists and fetch details
            if (rs.next()) {
                String firstName = rs.getString("user_name");
                String lastName = rs.getString("lname");
                String email = rs.getString("user_email");
                String address = rs.getString("user_address");

                // Set attributes for use in the form
                request.setAttribute("firstName", firstName);
                request.setAttribute("lastName", lastName);
                request.setAttribute("email", email);
                request.setAttribute("address", address);
            }

            // SQL query to fetch user orders based on user_id
            String orderSql = "SELECT * FROM orders WHERE user_id = ?";
            stmt = conn.prepareStatement(orderSql);
            stmt.setInt(1, Integer.parseInt(userId));
            rs = stmt.executeQuery();
            request.setAttribute("orderHistory", rs);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
   

  
%>
    <div class="main-wrapper">
        <div class="container">
            <div class="col-md-6 form-container">
                <div class="form-box">
                    <h1>Edit Your Profile</h1>
                    <form action="AdminUpdateProfileServlet" method="post">
                        <input type="hidden" name="user_id" value="<%= request.getParameter("user_id") %>">
                        <div class="row g-3">
                            <div class="input-container col-lg-6">
                                <label for="first-name" class="form-label">First Name</label>
                                <input type="text" id="first-name" name="user_name" class="form-control" placeholder="First Name" 
                                       value="<%= request.getAttribute("firstName") != null ? request.getAttribute("firstName") : "" %>">
                            </div>
                            <div class="input-container col-lg-6">
                                <label for="last-name" class="form-label">Last Name</label>
                                <input type="text" name="lname" class="form-control" placeholder="Last Name" 
                                       value="<%= request.getAttribute("lastName") != null ? request.getAttribute("lastName") : "" %>">
                            </div>
                        </div>

                        <div class="input-container col-lg-12">
                            <label for="email" class="form-label">Email</label>
                            <input type="text" id="email" name="user_email" class="form-control" placeholder="youremail@sample.com"
                                   value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" readonly>
                        </div>

                        <div class="input-container col-lg-12">
                            <label for="address" class="form-label">Address</label>
                            <input type="text" id="address" name="user_address" class="form-control" placeholder="Address"
                                   value="<%= request.getAttribute("address") != null ? request.getAttribute("address") : "" %>">
                        </div>

                        <div class="input-container col-lg-12">
                            <label for="password-changes" class="form-label">Password Changes</label>
                            <input type="password" name="user_password" id="current-password" class="form-control" placeholder="Current Password">
                            <br>
                            <input type="password" name="new_password" id="new-password" class="form-control" placeholder="New Password">
                            <br>
                            <input type="password" name="confirm_new_password" id="confirm-new-password" class="form-control" placeholder="Confirm New Password">
                        </div>

                        <div class="button-container">
                            <button type="submit" class="btn-primary">Cancel</button>
                            <button type="submit" class="btn-primary">Save Changes</button>
                        <a href="login.jsp" class="btn-danger">Logout</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        

    <%@include file="./components/footer.jsp" %>
</body>
</html>