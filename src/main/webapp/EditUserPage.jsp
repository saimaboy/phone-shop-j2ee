<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*,java.net.URLEncoder" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Edit User</title>
    <link rel="stylesheet" href="./css/admin.css"/>
    <link rel="stylesheet" href="./css/home.css">
    <link rel="stylesheet" href="./css/root.css">
</head>
<body>
    <%@include file="./components/admin_nav.jsp" %>
    <div class="main-wrapper">
        <div class="container-fluid">
            <h2>Edit User</h2>
            
            <!-- Fetch user from request attribute set by the servlet -->
            <form action="EditUserServlet" method="post">
                <input type="hidden" name="user_id" value="${user.userId}">

                <div class="form-group">
                    <label for="user_name">First Name</label>
                    <input type="text" class="form-control" name="user_name" value="${user.userName}" required />
                </div>

                <div class="form-group">
                    <label for="lname">Last Name</label>
                    <input type="text" class="form-control" name="lname" value="${user.lname}" required />
                </div>

                <div class="form-group">
                    <label for="user_email">Email</label>
                    <input type="email" class="form-control" name="user_email" value="${user.userEmail}" required />
                </div>

                <div class="form-group">
                    <label for="user_phone">Phone</label>
                    <input type="text" class="form-control" name="user_phone" value="${user.userPhone}" />
                </div>

                <div class="form-group">
                    <label for="user_address">Address</label>
                    <textarea class="form-control" name="user_address">${user.userAddress}</textarea>
                </div>

                <div class="form-group">
                    <label for="user_type">User Type</label>
                    <select class="form-control" name="user_type">
                        <option value="customer" ${user.userType == 'customer' ? 'selected' : ''}>Customer</option>
                        <option value="employee" ${user.userType == 'employee' ? 'selected' : ''}>Employee</option>
                        <option value="supplier" ${user.userType == 'supplier' ? 'selected' : ''}>Supplier</option>
                        <option value="admin" ${user.userType == 'admin' ? 'selected' : ''}>Admin</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="user_status">Status</label>
                    <select class="form-control" name="user_status">
                        <option value="1" ${user.userStatus == 1 ? 'selected' : ''}>Active</option>
                        <option value="0" ${user.userStatus == 0 ? 'selected' : ''}>Inactive</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary">Update User</button>
            </form>
        </div>
    </div>

    <%@include file="./components/footer.jsp" %>
</body>
</html>
