<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*" %>


<!DOCTYPE html>

<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Admin Dashboard</title>
    <%@include file="./components/common.jsp" %>
    <link rel="stylesheet" href="./css/admin.css"/>
    <link rel="stylesheet" href="./css/home.css">
    <link rel="stylesheet" href="./css/root.css">
</head>
<body>
    <%@include file="./components/employee_nav.jsp" %>
    <div class="main-wrapper">
        <div class="container-fluid admin-dashboard">
            <div class="row">
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body text-center">
                            <img src="images/admin/profile.png" class="img-fluid rounded-circle" style="max-width:125px;" alt="Profile">
                            <h2 id="user-count">
                                <%
                                    String userIdStr = request.getParameter("user_id");
                                    // JDBC setup for user count
                                    String dbUrl = "jdbc:mysql://localhost:3306/phone_shop"; // Update with your DB info
                                    String dbUsername = "root"; // Update with your DB username
                                    String dbPassword = "12345678"; // Update with your DB password
                                    Connection conn = null;
                                    Statement stmt = null;
                                    ResultSet rs = null;

                                    try {
                                        Class.forName("com.mysql.cj.jdbc.Driver");
                                        // Establish connection
                                        conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
                                        stmt = conn.createStatement();
                                        String query = "SELECT COUNT(*) AS total_users FROM users";
                                        rs = stmt.executeQuery(query);
                                        if (rs.next()) {
                                            out.print(rs.getInt("total_users"));
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
                            </h2>
                            <h5 class="text-uppercase" style="color:#008774;">Total Users</h5>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body text-center">
                            <img src="images/admin/category.png" class="img-fluid rounded-circle" style="max-width:125px;" alt="Orders">
                            <h2 id="category-count">
                                <%
                                    // JDBC setup for category count
                                    Connection connOrders = null;
                                    Statement stmtOrders = null;
                                    ResultSet rsOrders = null;
                                    String dbUrlOrders = "jdbc:mysql://localhost:3306/phone_shop"; // Ensure consistent DB info
                                    String dbUsernameOrders = "root";
                                    String dbPasswordOrders = "12345678";
                                    try {
                                        Class.forName("com.mysql.cj.jdbc.Driver");
                                        connOrders = DriverManager.getConnection(dbUrlOrders, dbUsernameOrders, dbPasswordOrders);
                                        stmtOrders = connOrders.createStatement();
                                        String queryOrders = "SELECT COUNT(*) AS total_orders FROM orders";
                                        rsOrders = stmtOrders.executeQuery(queryOrders);
                                        if (rsOrders.next()) {
                                            out.print(rsOrders.getInt("total_orders"));
                                        }
                                    } catch (SQLException e) {
                                        e.printStackTrace();
                                    } finally {
                                        try {
                                            if (rsOrders != null) rsOrders.close();
                                            if (stmtOrders != null) stmtOrders.close();
                                            if (connOrders != null) connOrders.close();
                                        } catch (SQLException e) {
                                            e.printStackTrace();
                                        }
                                    }
                                %>
                            </h2>
                            <h5 class="text-uppercase" style="color:#008774;">Total Orders</h5>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body text-center">
                            <img src="images/admin/product.png" class="img-fluid rounded-circle" style="max-width:125px;" alt="Product">
                            <h2 id="product-count">
                                <%
                                    // JDBC setup for product count
                                    Connection connProducts = null;
                                    Statement stmtProducts = null;
                                    ResultSet rsProducts = null;
                                    String dbUrlProducts = "jdbc:mysql://localhost:3306/phone_shop"; // Ensure consistent DB info
                                    String dbUsernameProducts = "root";
                                    String dbPasswordProducts = "12345678";
                                    try {
                                        Class.forName("com.mysql.cj.jdbc.Driver");
                                        connProducts = DriverManager.getConnection(dbUrlProducts, dbUsernameProducts, dbPasswordProducts);
                                        stmtProducts = connProducts.createStatement();
                                        String queryProducts = "SELECT COUNT(*) AS total_products FROM products";
                                        rsProducts = stmtProducts.executeQuery(queryProducts);
                                        if (rsProducts.next()) {
                                            out.print(rsProducts.getInt("total_products"));
                                        }
                                    } catch (SQLException e) {
                                        e.printStackTrace();
                                    } finally {
                                        try {
                                            if (rsProducts != null) rsProducts.close();
                                            if (stmtProducts != null) stmtProducts.close();
                                            if (connProducts != null) connProducts.close();
                                        } catch (SQLException e) {
                                            e.printStackTrace();
                                        }
                                    }
                                %>
                            </h2>
                            <h5 class="text-uppercase" style="color:#008774;">Total Products</h5>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@include file="./components/footer.jsp" %>
</body>
</html>