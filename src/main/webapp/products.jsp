<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="utils.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Products</title>
    <link rel="stylesheet" href="./css/product.css"/>
    <%@include file="./components/common.jsp" %>
    <link rel="stylesheet" href="./css/home.css">
    <link rel="stylesheet" href="./css/root.css">
</head>
<body>
    <%@include file="./components/nav.jsp" %>

    <div class="main-wrapper">
        <div class="container px-5">
            <div class="product row my-5">
                <% 
                    String userIdStr = request.getParameter("user_id");
                    String category = request.getParameter("category"); // Get category from URL
                    
                    // Fetch products based on the category
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;

                    try {
                        conn = DBConnection.getConnection();
                        String sql = "SELECT * FROM products WHERE category = ?"; 
                        stmt = conn.prepareStatement(sql);
                        stmt.setString(1, category); // Use the category passed from URL
                        rs = stmt.executeQuery();

                        while (rs.next()) {
                            int productId = rs.getInt("id");
                            String productName = rs.getString("product_name");
                            double productPrice = rs.getDouble("price");
                            String productImage = rs.getString("image_url");
                            String productDescription = rs.getString("description");
                            int stockQuantity = rs.getInt("stock_quantity");

                            String stockStatus = "Available";
                            if (stockQuantity == 0) {
                                stockStatus = "Out of Stock";
                            } else if (stockQuantity < 5) {
                                stockStatus = "Low Stock";
                            }
                %>
                <div class="card col-md-4 col-lg-12 border">
                    <a href="item.jsp?product_id=<%= productId %>&category=<%= category %>&user_id=<%= userIdStr %>">
                        <img src="<%= productImage %>" class="card-img-top py-2">
                    </a>
                    <div class="card-body">
                        <h5 class="card-title"><%= productName %></h5>
                    </div>
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item">$ <%= productPrice %></li>
                        <li class="list-group-item text-center">
                            <strong>Status: </strong><%= stockStatus %>
                        </li>
                    </ul>
                    <div class="card-footer">
                        <!-- Pass user_id to the addToCart function -->
                        <a href="javascript:void(0);" class="card-link" onclick="addToCart(<%= productId %>, '<%= productName %>', <%= productPrice %>, '<%= userIdStr %>')">
                            <i class="fa fa-shopping-cart" aria-hidden="true"></i> 
                        </a>
                    </div>
                </div>
                <% 
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                %>
            </div>
        </div>
    </div>

    <%@include file="./components/footer.jsp" %>

    <script>
        // Add to Cart function using JSON
        function addToCart(productId, productName, productPrice, userId) {
            // Check if cart exists in localStorage
            let cart = JSON.parse(localStorage.getItem('cart')) || [];

            // Check if the product already exists in the cart
            let productIndex = cart.findIndex(item => item.productId === productId);
            
            if (productIndex !== -1) {
                // If product exists, increase the quantity
                cart[productIndex].quantity += 1;
            } else {
                // Add new product to cart
                cart.push({ productId, productName, productPrice, quantity: 1, userId });
            }

            // Save updated cart in localStorage
            localStorage.setItem('cart', JSON.stringify(cart));

            // Alert user
            alert(productName + " added to the cart!");
        }
    </script>
</body>
</html>
