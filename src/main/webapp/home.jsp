<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="servlets.LoginServlet"%>
<%@page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*"%>
<%@page import="java.util.*, java.net.URLEncoder"%>
<%@page import="servlets.AddToCartServlet"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Home page</title>
        <%@include file="./components/common.jsp" %>
        <link rel="stylesheet" href="./css/home.css">
        <link rel="stylesheet" href="./css/root.css">
        <style>
            .side-menu ul {
                list-style: none;
                padding: 0;
                margin: 0;
                padding-top:5rem;
            }

            .side-menu li {
                margin-bottom: 10px;
            }

            .btn-category {
                display: inline-block;
                padding: 10px 20px;
                font-size: 16px;
                text-decoration: none;
                background-color: #008774;
                color: white;
                border-radius: 5px;
                text-align: center;
                width: 100%;
                box-sizing: border-box;
            }

            .btn-category:hover {
                background-color: #0056b3;
            }

            .btn-category i {
                margin-left: 5px;
            }
        </style>
        <script>
            // Function to add to cart
            function addToCart(productId, productName, productPrice, userId) {
                // Check if the cart is already in session
                let cart = JSON.parse(sessionStorage.getItem('cart')) || [];

                // Check if the product already exists in the cart
                let productIndex = cart.findIndex(item => item.productId === productId);

                if (productIndex !== -1) {
                    // If product exists, increase quantity
                    cart[productIndex].quantity++;
                } else {
                    // If product doesn't exist, add to cart with quantity 1
                    cart.push({
                        productId: productId,
                        productName: productName,
                        productPrice: productPrice,
                        userId: userId,
                        quantity: 1
                    });
                }

                // Save the updated cart back to session storage
                sessionStorage.setItem('cart', JSON.stringify(cart));

                alert(productName + " has been added to your cart!");
            }
        </script>
    </head>
    <body>
        <%@include file="./components/nav.jsp" %>

        <div class="main-wrapper">
            <section class="header container">
                <div class="side-menu">
                    <ul>
                        <% 
                            // Get user ID from session
                            String userIdStr = request.getParameter("user_id");
                            if (userIdStr == null) {
                                // If user ID is not found in session, redirect to login page
                                response.sendRedirect("login.jsp");
                                return;
                            }
                        %>

                        <li><a href="products.jsp?category=Phones&user_id=<%= userIdStr %>" class="btn btn-category">Phones</a></li>
                        <li><a href="products.jsp?category=Accessories&user_id=<%= userIdStr %>" class="btn btn-category">Accessories</a></li>
                        <li><a href="products.jsp?category=Tablets&user_id=<%= userIdStr %>" class="btn btn-category">Tabs</a></li>
                    </ul>
                </div>

                <div class="carousel-wrapper">
                    <div id="carouselExampleIndicators" class="carousel slide" data-bs-ride="carousel">
                        <div class="carousel-inner">
                            <div class="carousel-item active">
                                <img src="./images/home/working.jpg" class="d-block w-100">
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Display 5 Products from Database -->
            <div class="container px-5">
                <div class="tittle-box my-4">
                    <h1>Flash Sales</h1>
                </div>

                <div class="sales row">
                    <% 
                        // Database connection variables
                        Connection conn = null;
                        PreparedStatement stmt = null;
                        ResultSet rs = null;
                        String dbURL = "jdbc:mysql://localhost:3306/phone_shop";
                        String dbUsername = "root";
                        String dbPassword = "12345678";

                        try {
                            // Connect to the database
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection(dbURL, dbUsername, dbPassword);
                            
                            // SQL query to fetch 5 products
                            String sql = "SELECT * FROM products LIMIT 5"; 
                            stmt = conn.prepareStatement(sql);
                            rs = stmt.executeQuery();

                            while (rs.next()) {
                                int productId = rs.getInt("id");
                                String productName = rs.getString("product_name");
                                double productPrice = rs.getDouble("price");
                                String productImage = rs.getString("image_url");  // Assuming there's an image_url column

                    %>
                    <div class="card col-md-4 col-lg-12 border">
                        <a href="item.jsp?product_id=<%= productId %>&user_id=<%= userIdStr %>">
                            <img src="<%= productImage %>" class="card-img-top py-2">
                        </a>
                        <div class="card-body">
                            <h5 class="card-title"><%= productName %></h5>
                        </div>
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item">Rs. <%= productPrice %></li>
                        </ul>
                        <div class="card-footer">
                            <!-- Add to Cart button with parameters for product ID, name, price, and user ID -->
                            <a href="javascript:void(0);" class="card-link" onclick="addToCart(<%= productId %>, '<%= productName %>', <%= productPrice %>, '<%= userIdStr %>')">
                                <i class="fa fa-shopping-cart" aria-hidden="true"></i> 
                            </a>
                        </div>
                    </div>
                    <% 
                            }
                        } catch (SQLException | ClassNotFoundException e) {
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
                </div>
            </div>
<div class="container px-5">

                <div class="icon row">

                    <div class="col-md-4">

                        <div class="icon-item text-center">

                            <i class="fa-solid fa-truck fa-3x"></i>

                            <h2>FREE AND FAST DELIVERY</h2>

                            <p>Free delivery for all orders over $140</p>

                        </div>

                    </div>

                    <div class="col-md-4">

                        <div class="icon-item text-center">

                            <i class="fa-solid fa-headphones fa-3x"></i>

                            <h2>24/7 CUSTOMER SERVICE</h2>

                            <p>Friendly 24/7 customer support</p>

                        </div>

                    </div>

                    <div class="col-md-4">

                        <div class="icon-item text-center">

                            <i class="fa-solid fa-credit-card fa-3x"></i>

                            <h2>MONEY BACK GUARANTEE</h2>

                            <p>We return money within 30 days</p>

                        </div>

                    </div>

                </div>

            </div>
        </div>

        <%@include file="./components/footer.jsp" %>
    </body>
</html>
