<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Item</title>
  <link rel="stylesheet" href="./css/item.css">
  <%@include file="./components/common.jsp" %>
  <link rel="stylesheet" href="./css/home.css">
  <link rel="stylesheet" href="./css/root.css">
</head>

<body>
    <%@include file="./components/nav.jsp" %>

    <div class="main-wrapper">
        <div class="container px-5">
            <section class="item">
                <div class="row mt-5">
                    <div class="main-image col-lg-5 border">
                        <%
                            // Get product_id and user_id from the URL parameters
                            String productId = request.getParameter("product_id");
                            String userId = request.getParameter("user_id");

                            // Database connection setup
                            Connection conn = null;
                            PreparedStatement stmt = null;
                            ResultSet rs = null;
                            String dbURL = "jdbc:mysql://localhost:3306/phone_shop";
                            String dbUsername = "root";
                            String dbPassword = "12345678";

                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                conn = DriverManager.getConnection(dbURL, dbUsername, dbPassword);

                                // Query to fetch the product details based on product_id
                                String sql = "SELECT * FROM products WHERE id = ?";
                                stmt = conn.prepareStatement(sql);
                                stmt.setInt(1, Integer.parseInt(productId));
                                rs = stmt.executeQuery();

                                if (rs.next()) {
                                    String productName = rs.getString("product_name");
                                    String productImage = rs.getString("image_url");
                                    String description = rs.getString("description");
                                    double price = rs.getDouble("price");
                                    String category = rs.getString("category");
                        %>

                        <img src="/shop<%= productImage %>" alt="Product Image">
                    </div>

                    <div class="content col-lg-6 col-md-12 col-12">
                        <h2><%= productName %></h2>
                        <div class="rating">
                            <i class="fa fa-star"></i>
                            <i class="fa fa-star"></i>
                            <i class="fa fa-star"></i>
                            <i class="fa fa-star"></i>
                            <i class="fa fa-star"></i>
                        </div>
                        <span>(150 Reviews) | In-Stock</span>
                        <h5>$ <%= price %></h5>
                        <br>
                        <p><%= description %></p>
                        <div class="product-container">
                           
                            <div class="add-to-cart">
                                <!-- Add to Cart Button -->
                                <button type="button" class="btn btn-primary" onclick="addToCart(<%= productId %>, '<%= productName %>', <%= price %>, '<%= userId %>')">Add to Cart</button>
                            </div>
                        </div>
                        <div class="delivery-info">
                            <h2><i class="fa fa-truck"></i> Free Delivery</h2>
                            <p>Enter your postal code for Delivery Availability</p>
                            <br>
                            <h2><i class="fa-solid fa-rotate"></i> Return Delivery</h2>
                            <p>
                                <span class="delivery-icon"></span>
                                Free 30 Days Delivery Returns. <a href="#">Details</a>
                            </p>
                        </div>
                    </div>
                </div>
            </section>

            <div class="tittle-box my-4">
                <h4>Related Items</h4>
            </div>

            <div class="product row my-5">
                <%
                    // Fetch related products based on the same category
                    String relatedSql = "SELECT * FROM products WHERE category = ? LIMIT 4";
                    stmt = conn.prepareStatement(relatedSql);
                    stmt.setString(1, rs.getString("category"));
                    ResultSet relatedRs = stmt.executeQuery();

                    while (relatedRs.next()) {
                        int relatedProductId = relatedRs.getInt("id");
                        String relatedProductName = relatedRs.getString("product_name");
                        double relatedProductPrice = relatedRs.getDouble("price");
                        String relatedProductImage = relatedRs.getString("image_url");
                %>

                <div class="card col-md-4 col-lg-12 border">
                    <a href="item.jsp?product_id=<%= relatedProductId %>&user_id=<%= userId %>">
                        <img src="/shop<%= relatedProductImage %>" class="card-img-top py-2">
                    </a>
                    <div class="card-body">
                        <h5 class="card-title"><%= relatedProductName %></h5>
                    </div>
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item">$ <%= relatedProductPrice %></li>
                    </ul>
                    <div class="card-footer">
                        <a href="#" class="card-link"><i class="fa fa-heart" aria-hidden="true"></i></a>
                       <a href="javascript:void(0);" onclick="addToCart(<%= relatedProductId %>, '<%= relatedProductName %>', <%= relatedProductPrice %>, '<%= userId %>')" class="card-link"><i class="fa fa-shopping-cart" aria-hidden="true"></i></a>
                    </div>
                </div>

                <%
                    } // End while loop for related products
                    } else {
                        // What to display if the product is not found
                        out.println("<p>Product not found.</p>");
                    }
                } catch (SQLException | ClassNotFoundException e) {
                    e.printStackTrace();
                    out.println("<p>Error fetching product details.</p>");
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
            </div>
        </div>
    </div>

    <%@include file="./components/footer.jsp" %>
</body>

</html>

<script>
    // Add to Cart function using localStorage
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
