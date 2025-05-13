<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*" %>

<!DOCTYPE html>

<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>User Management</title>
    <%@include file="./components/common.jsp" %>
    <link rel="stylesheet" href="./css/admin.css"/>
    <link rel="stylesheet" href="./css/home.css">
    <link rel="stylesheet" href="./css/root.css">
</head>
<body>
    <%@include file="./components/admin_nav.jsp" %>
    <div class="main-wrapper">
        <div class="container-fluid">
            <h2 class="section-title"><i class="fa-solid fa-users"></i> Manage Users</h2>
            
            <!-- Button to Open Add User Modal -->
            <div class="row">
                <div class="col-md-12 text-right mb-3">
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                        <i class="fa-solid fa-user-plus"></i> Add New User
                    </button>
                </div>
            </div>

            <!-- User Table -->
            <div class="table-responsive">
                <table class="table table-hover table-striped">
                    <thead>
                        <tr>
                            <th>User ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Address</th>
                            <th>User Type</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        // JDBC setup to fetch users
                        String dbUrl = "jdbc:mysql://localhost:3306/phone_shop"; // Update with your DB info
                        String dbUsername = "root"; // Update with your DB username
                        String dbPassword = "12345678"; // Update with your DB password
                        Connection conn = null;
                        Statement stmt = null;
                        ResultSet rs = null;

                        try {
                            // Establish connection
                            conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
                            
                            // Create a statement
                            stmt = conn.createStatement();
                            
                            // Execute query to fetch users
                            String query = "SELECT user_id, user_name, lname, user_email, user_phone, user_address, user_type, user_status FROM users";
                            rs = stmt.executeQuery(query);

                            // Loop through result set and display users
                            while (rs.next()) {
                                int userId = rs.getInt("user_id");
                                String userName = rs.getString("user_name");
                                String lname = rs.getString("lname");
                                String email = rs.getString("user_email");
                                String phone = rs.getString("user_phone");
                                String address = rs.getString("user_address");
                                String userType = rs.getString("user_type");
                                int userStatus = rs.getInt("user_status");
                                String status = (userStatus == 1) ? "Active" : "Inactive";
                        %>
                        <tr>
                            <td><%= userId %></td>
                            <td><%= userName + " " + lname %></td>
                            <td><%= email %></td>
                            <td><%= phone %></td>
                            <td><%= address %></td>
                            <td><%= userType %></td>
                            <td><%= status %></td>
                            <td>
                                <!-- Edit User Button, triggers the edit modal -->
                                <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#editUserModal" 
                                        data-user-id="<%= userId %>"
                                        data-user-name="<%= userName %>"
                                        data-lname="<%= lname %>"
                                        data-user-email="<%= email %>"
                                        data-user-phone="<%= phone %>"
                                        data-user-address="<%= address %>"
                                        data-user-type="<%= userType %>"
                                        data-user-status="<%= userStatus %>">
                                    Edit
                                </button>
                                <a href="DeleteUserServlet?user_id=<%= userId %>" class="btn btn-danger">Delete</a>
                            </td>
                        </tr>
                        <%
                                }
                            } catch (SQLException e) {
                                e.printStackTrace();
                            } finally {
                                try {
                                    if (rs != null) rs.close();
                                    if (stmt != null) stmt.close();
                                    if (conn != null) conn.close();
                                } catch (SQLException e) {
                                    e.printStackTrace();
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Add User Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1" aria-labelledby="addUserModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addUserModalLabel">Add New User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- Add User Form -->
                    <form action="AddUserServlet" method="post">
                        <div class="form-group">
                            <label for="user_name">First Name</label>
                            <input type="text" class="form-control" name="user_name" required/>
                        </div>
                        <div class="form-group">
                            <label for="lname">Last Name</label>
                            <input type="text" class="form-control" name="lname" required/>
                        </div>
                        <div class="form-group">
                            <label for="user_email">Email</label>
                            <input type="email" class="form-control" name="user_email" required/>
                        </div>
                        <div class="form-group">
                            <label for="user_password">Password</label>
                            <input type="password" class="form-control" name="user_password" required/>
                        </div>
                        <div class="form-group">
                            <label for="user_phone">Phone</label>
                            <input type="text" class="form-control" name="user_phone"/>
                        </div>
                        <div class="form-group">
                            <label for="user_address">Address</label>
                            <textarea class="form-control" name="user_address"></textarea>
                        </div>
                        <div class="form-group">
                            <label for="user_type">User Type</label>
                            <select class="form-control" name="user_type">
                                <option value="customer">Customer</option>
                                <option value="employee">Employee</option>
                                <option value="supplier">Supplier</option>
                                <option value="admin">Admin</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="user_status">Status</label>
                            <select class="form-control" name="user_status">
                                <option value="1">Active</option>
                                <option value="0">Inactive</option>
                            </select>
                        </div>
                        <div class="container">
                            <input class="btn btn-primary" type="submit" value="Add User">
                            <input class="btn btn-secondary" type="reset" value="Reset">
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit User Modal -->
    <div class="modal fade" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editUserModalLabel">Edit User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- Edit User Form -->
                    <form action="EditUserServlet" method="post">
                        <input type="hidden" id="edit_user_id" name="user_id"/>
                        <div class="form-group">
                            <label for="edit_user_name">First Name</label>
                            <input type="text" class="form-control" id="edit_user_name" name="user_name" required/>
                        </div>
                        <div class="form-group">
                            <label for="edit_lname">Last Name</label>
                            <input type="text" class="form-control" id="edit_lname" name="lname" required/>
                        </div>
                        <div class="form-group">
                            <label for="edit_user_email">Email</label>
                            <input type="email" class="form-control" id="edit_user_email" name="user_email" required/>
                        </div>
                        <div class="form-group">
                            <label for="edit_user_phone">Phone</label>
                            <input type="text" class="form-control" id="edit_user_phone" name="user_phone"/>
                        </div>
                        <div class="form-group">
                            <label for="edit_user_address">Address</label>
                            <textarea class="form-control" id="edit_user_address" name="user_address"></textarea>
                        </div>
                        <div class="form-group">
                            <label for="edit_user_type">User Type</label>
                            <select class="form-control" id="edit_user_type" name="user_type">
                                <option value="customer">Customer</option>
                                <option value="employee">Employee</option>
                                <option value="supplier">Supplier</option>
                                <option value="admin">Admin</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="edit_user_status">Status</label>
                            <select class="form-control" id="edit_user_status" name="user_status">
                                <option value="1">Active</option>
                                <option value="0">Inactive</option>
                            </select>
                        </div>
                        <div class="container">
                            <input class="btn btn-primary" type="submit" value="Update User">
                            <input class="btn btn-secondary" type="reset" value="Reset">
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <%@include file="./components/footer.jsp" %>

    <script>
        // JavaScript to populate edit modal with user data
        var editModal = document.getElementById('editUserModal');
        editModal.addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            var userId = button.getAttribute('data-user-id');
            var userName = button.getAttribute('data-user-name');
            var lname = button.getAttribute('data-lname');
            var userEmail = button.getAttribute('data-user-email');
            var userPhone = button.getAttribute('data-user-phone');
            var userAddress = button.getAttribute('data-user-address');
            var userType = button.getAttribute('data-user-type');
            var userStatus = button.getAttribute('data-user-status');

            document.getElementById('edit_user_id').value = userId;
            document.getElementById('edit_user_name').value = userName;
            document.getElementById('edit_lname').value = lname;
            document.getElementById('edit_user_email').value = userEmail;
            document.getElementById('edit_user_phone').value = userPhone;
            document.getElementById('edit_user_address').value = userAddress;
            document.getElementById('edit_user_type').value = userType;
            document.getElementById('edit_user_status').value = userStatus;
        });
    </script>
</body>
</html>
