<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Order Management</title>
    <%@include file="./components/common.jsp" %>
    <link rel="stylesheet" href="./css/admin.css"/>
    <link rel="stylesheet" href="./css/home.css">
    <link rel="stylesheet" href="./css/root.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <%@include file="./components/admin_nav.jsp" %>
    <div class="main-wrapper">
        <div class="container-fluid">
            <h2 class="section-title"><i class="fa-solid fa-boxes"></i> Manage Orders</h2>
            <div class="table-responsive">
                <table class="table table-hover table-striped">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>User ID</th>
                            <th>Order Date</th>
                            <th>Status</th>
                            <th>Total</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        String userIdParam = request.getParameter("user_id"); // Renamed variable
                        // JDBC setup
                        String dbUrl = "jdbc:mysql://localhost:3306/phone_shop"; // Update with your DB info
                        String dbUsername = "root"; // Update with your DB username
                        String dbPassword = "12345678"; // Update with your DB password
                        Connection conn = null;
                        Statement stmt = null;
                        ResultSet rs = null;

                        try {
                            // Establish a connection
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
                            
                            // Create a statement
                            stmt = conn.createStatement();
                            
                            // Execute the query to fetch orders
                            String query = "SELECT order_id, user_id, order_date, order_status, total FROM orders";
                            rs = stmt.executeQuery(query);

                            // Loop through the result set and display orders
                            while (rs.next()) {
                                int orderId = rs.getInt("order_id");
                                int userIdFromDb = rs.getInt("user_id"); // Renamed variable
                                String orderDate = rs.getString("order_date");
                                String orderStatus = rs.getString("order_status");
                                double total = rs.getDouble("total");
                        %>
                        <tr>
                            <td><%= orderId %></td>
                            <td><%= userIdFromDb %></td> <!-- Use the renamed variable -->
                            <td><%= orderDate %></td>
                            <td><%= orderStatus %></td>
                            <td>$<%= total %></td>
                            <td>
                                <a href="UpdateOrderStatusServlet?order_id=<%= orderId %>&status=Shipped" class="btn btn-success">Mark as Shipped</a>
                                <a href="UpdateOrderStatusServlet?order_id=<%= orderId %>&status=Delivered" class="btn btn-success">Mark as Delivered</a>
                                <a href="CancelOrderServlet?order_id=<%= orderId %>" class="btn btn-danger">Cancel</a>
                                <!-- Trigger the Modal -->
                                <button type="button" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#editOrderModal<%= orderId %>">Edit</button>

                                <!-- Modal -->
                                <div class="modal fade" id="editOrderModal<%= orderId %>" tabindex="-1" aria-labelledby="editOrderModalLabel" aria-hidden="true">
                                  <div class="modal-dialog">
                                    <div class="modal-content">
                                      <div class="modal-header">
                                        <h5 class="modal-title" id="editOrderModalLabel">Edit Order</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                      </div>
                                      <div class="modal-body">
                                        <form action="UpdateOrderServlet" method="POST">
                                          <input type="hidden" name="order_id" value="<%= orderId %>">
                                          <div class="form-group">
                                            <label for="user_id">User ID</label>
                                            <input type="text" id="user_id" name="user_id" class="form-control" value="<%= userIdFromDb %>" readonly>
                                          </div>

                                          <div class="form-group">
                                            <label for="order_date">Order Date</label>
                                            <input type="text" id="order_date" name="order_date" class="form-control" value="<%= orderDate %>" readonly>
                                          </div>

                                          <div class="form-group">
                                            <label for="order_status">Order Status</label>
                                            <select id="order_status" name="order_status" class="form-control">
                                              <option value="Pending" <%= orderStatus.equals("Pending") ? "selected" : "" %>>Pending</option>
                                              <option value="Shipped" <%= orderStatus.equals("Shipped") ? "selected" : "" %>>Shipped</option>
                                              <option value="Delivered" <%= orderStatus.equals("Delivered") ? "selected" : "" %>>Delivered</option>
                                              <option value="Cancelled" <%= orderStatus.equals("Cancelled") ? "selected" : "" %>>Cancelled</option>
                                            </select>
                                          </div>

                                          <div class="form-group">
                                            <label for="total">Total</label>
                                            <input type="number" id="total" name="total" class="form-control" value="<%= total %>" step="0.01">
                                          </div>

                                          <button type="submit" class="btn btn-primary">Update Order</button>
                                        </form>
                                      </div>
                                    </div>
                                  </div>
                                </div>
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

    <%@include file="./components/footer.jsp" %>
</body>
</html>
