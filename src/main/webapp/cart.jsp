<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="servlets.UpdateCartServlet" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cart</title>
        <%@include file="./components/common.jsp" %>
        <link rel="stylesheet" href="./css/cart.css"/>
        <link rel="stylesheet" href="./css/home.css">
        <link rel="stylesheet" href="./css/root.css">
        <script>
    // Function to update cart item when quantity changes
    function updateCart(productId, quantity) {
        fetch('UpdateCartServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: `product_id=${productId}&quantity=${quantity}`
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Update the cart's subtotal and total on the page
                document.getElementById('subPrice' + productId).innerText = 'Rs.' + data.subtotal;
                document.getElementById('tot').innerText = 'Total: Rs.' + data.total;
            } else {
                alert('Failed to update cart');
            }
        })
        .catch(error => console.error('Error:', error));
    }

    // Function to handle "Update Cart" button click
   // Function to handle "Update Cart" button click
function updateCartButton() {
    const updatedQuantities = [];

    // Loop through all quantity input fields and gather the updated data
    const quantityInputs = document.querySelectorAll('.quantity');
    quantityInputs.forEach(input => {
        const productId = input.id.replace('textInput', '');  // Extract productId from input id
        const quantity = input.value;
        updatedQuantities.push({ productId, quantity });
    });

    // Send the updated cart data to the server
    fetch('UpdateCartServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: updatedQuantities.map(item => `product_id=${item.productId}&quantity=${item.quantity}`).join('&')
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Update the cart's subtotal and total on the page
            document.getElementById('tot').innerText = 'Total: Rs.' + data.total;
        } else {
            alert('Failed to update cart');
        }
    })
    .catch(error => console.error('Error:', error));
}

</script>

    </head>
    <body>
        <%@include file="./components/nav.jsp" %>

        <div class="main-wrapper">
            <div class="container cart-box"> 
                <div class="container-fluid">
                    <table class="table1" border="0" width="1200px" height="250px">
                        <tr class="tr0">
                            <td class="pr">Product</td>
                            <td>Price</td>
                            <td>Quantity</td>
                            <td>Subtotal</td>
                            <td>Action</td>
                        </tr>
                        
                        <% 
                            // Retrieve user_id from the URL
                            String userId = request.getParameter("user_id");
                            double total = 0;
                            
                            if (userId != null) {
                                // Convert userId to int
                                int userIdInt = Integer.parseInt(userId);
                                
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
                                    
                                    // Fetch cart items for the user
                                    String sql = "SELECT p.id, p.product_name, p.price, p.image_url, c.quantity FROM cart c " +
                                                 "JOIN products p ON c.product_id = p.id WHERE c.user_id = ?";
                                    stmt = conn.prepareStatement(sql);
                                    stmt.setInt(1, userIdInt); // Now using the correct int value
                                    rs = stmt.executeQuery();

                                    while (rs.next()) {
                                        int productId = rs.getInt("id");
                                        String productName = rs.getString("product_name");
                                        double productPrice = rs.getDouble("price");
                                        String productImage = rs.getString("image_url");
                                        int quantity = rs.getInt("quantity");
                                        double subtotal = productPrice * quantity;
                                        total += subtotal;
                        %>

                        <tr id="row<%= productId %>" class="tr1 shadow-sm">
                            <td class="td"><img src="<%= productImage %>" alt="item-image" width="90px"><%= productName %></td>
                            <td id="itemPrice<%= productId %>" value="<%= productPrice %>">Rs.<%= productPrice %></td>
                            <td>
                                <div class="box rounded shadow-sm">
                                    <input class="quantity" id="textInput<%= productId %>" value="<%= quantity %>" type="number" min="1" onchange="updateCart(<%= productId %>, this.value)">
                                </div>
                            </td>
                            <td id="subPrice<%= productId %>" value="<%= subtotal %>">Rs.<%= subtotal %></td>
                            <td><button class="btn-delete" onclick="removeItem(<%= productId %>)">Remove</button></td>
                        </tr>

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
                            }
                        %>
                    </table>

                    <a href="index.jsp"><button class="b1 rounded"><b>Return To Shop</b></button></a>
                    <button class="b2 rounded" onclick="updateCartButton()">Update Cart</button>

                    <button class="b3 rounded">Coupon Code</button>
                    <button class="b4 rounded">Apply coupon</button>

                    <div class="box1 rounded">
                        <h4>Cart Total</h4>
                        <h5>
                            <div class="box2" id="subTot"><pre>Subtotal: Rs.<%= total %></pre></div>
                            <div class="box2"><pre>Shipping: Free</pre></div>
                            <div class="box2" id="tot"><pre>Total: Rs.<%= total %></pre></div>
                        </h5>
                        <form action="CheckoutServlet" method="post">
                            <button type="submit" class="b5 rounded">Proceed To Checkout</button>
                        </form>
                    </div>
                    <br><br>
                </div>
            </div> 
        </div>

        <%@include file="./components/footer.jsp" %>
    </body>
    <script>
    var stripe = Stripe('sk_test_51R7IsZFKBuG4KLiqTfZQ1WKUE5C7wlFOrWHg813Nv5uTr3SSTU2BqaUkMbmgh13saKHsinK0TWA5xdCwwtLcxQzs00udJJUKfa'); // Replace with your publishable key
    var elements = stripe.elements();
    var cardElement = elements.create('card');
    cardElement.mount('#card-element');

    document.getElementById('checkout-button').addEventListener('click', function () {
        fetch('/CheckoutServlet', {
            method: 'POST',
        })
        .then(function (response) {
            return response.json();
        })
        .then(function (data) {
            var clientSecret = data.clientSecret;

            stripe.confirmCardPayment(clientSecret, {
                payment_method: {
                    card: cardElement,
                }
            }).then(function (result) {
                if (result.error) {
                    alert('Payment failed: ' + result.error.message);
                } else {
                    if (result.paymentIntent.status === 'succeeded') {
                        alert('Payment successful!');
                    }
                }
            });
        })
        .catch(function (error) {
            console.error('Error:', error);
            alert('Payment failed.');
        });
    });
</script>
</html>
