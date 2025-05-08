<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*" %>

<!DOCTYPE html>

<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Product Management</title>
    <%@include file="./components/common.jsp" %>
    <link rel="stylesheet" href="./css/admin.css"/>
    <link rel="stylesheet" href="./css/home.css">
    <link rel="stylesheet" href="./css/root.css">
</head>
<body>
    <%@include file="./components/admin_nav.jsp" %>
    <div class="main-wrapper">
        <div class="container-fluid">
            <h2 class="section-title"><i class="fa-solid fa-box"></i> Manage Products</h2>
            
            <!-- Button to Open Add Product Modal -->
            <div class="row">
                <div class="col-md-12 text-right mb-3">
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addProductModal">
                        <i class="fa-solid fa-plus"></i> Add New Product
                    </button>
                </div>
            </div>

            <!-- Product Table -->
            <div class="table-responsive">
                <table class="table table-hover table-striped">
                    <thead>
                        <tr>
                            <th>Product ID</th>
                            <th>Name</th>
                            <th>Price</th>
                            <th>Description</th>
                            <th>Category</th>
                            <th>Stock Quantity</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        String userIdStr = request.getParameter("user_id");
                            // JDBC setup to fetch products
                            String dbUrl = "jdbc:mysql://localhost:3306/phone_shop"; // Update with your DB info
                            String dbUsername = "root"; // Update with your DB username
                            String dbPassword = "12345678"; // Update with your DB password
                            Connection conn = null;
                            Statement stmt = null;
                            ResultSet rs = null;

                            try {
                                // Establish connection
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
                                
                                // Create a statement
                                stmt = conn.createStatement();
                                
                                // Execute query to fetch products
                                String query = "SELECT id, product_name, price, description, category, stock_quantity FROM products";
                                rs = stmt.executeQuery(query);

                                // Loop through result set and display products
                                while (rs.next()) {
                                    int productId = rs.getInt("id");
                                    String productName = rs.getString("product_name");
                                    double price = rs.getDouble("price");
                                    String description = rs.getString("description");
                                    String category = rs.getString("category");
                                    int stockQuantity = rs.getInt("stock_quantity");
                        %>
                        <tr>
                            <td><%= productId %></td>
                            <td><%= productName %></td>
                            <td>$<%= price %></td>
                            <td><%= description %></td>
                            <td><%= category %></td>
                            <td><%= stockQuantity %></td>
                            <td>
                                <a href="EditProductServlet?product_id=<%= productId %>" class="btn btn-warning">Edit</a>
                                <a href="DeleteProductServlet?product_id=<%= productId %>" class="btn btn-danger">Delete</a>
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

    <!-- Add Product Modal -->
    <div class="modal fade" id="addProductModal" tabindex="-1" aria-labelledby="addProductModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addProductModalLabel">Add New Product</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- Add Product Form -->
                    <form action="AddProductServlet" method="post" enctype="multipart/form-data">
                        <div class="form-group">
                            <label for="product_name">Product Name</label>
                            <input type="text" class="form-control" name="product_name" required/>
                        </div>
                        <div class="form-group">
                            <label for="price">Price</label>
                            <input type="number" class="form-control" name="price" required/>
                        </div>
                        <div class="form-group">
                            <label for="description">Description</label>
                            <textarea class="form-control" name="description"></textarea>
                        </div>
                        <div class="form-group">
                            <label for="category">Category</label>
                            <input type="text" class="form-control" name="category"/>
                        </div>
                        <div class="form-group">
                            <label for="stock_quantity">Stock Quantity</label>
                            <input type="number" class="form-control" name="stock_quantity" required/>
                        </div>
                        <div class="form-group">
                            <label for="image_url">Product Image</label>
                            <input type="file" class="form-control" name="image_url"/>
                        </div>
                        <div class="container">
                            <input class="btn btn-primary" type="submit" value="Add Product">
                            <input class="btn btn-secondary" type="reset" value="Reset">
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <%@include file="./components/footer.jsp" %>
</body>
</html>
