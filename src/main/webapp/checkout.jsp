<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page import="java.util.*, java.net.URLEncoder" %>
<%@ page import="utils.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout</title>
    <%@ include file="./components/common.jsp" %>
    <link rel="stylesheet" href="./css/acc.css">
    <link rel="stylesheet" href="./css/home.css">
    <link rel="stylesheet" href="./css/root.css">
    <style>
        /* Styling the order summary section */
        .order-summary-section {
            margin-top: 2rem;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        /* Header styling */
        .order-summary-section h2 {
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 15px;
            color: #333;
        }

        /* Table styling */
        .order-summary-table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
        }

        .order-summary-table th, .order-summary-table td {
            padding: 12px 15px;
            text-align: left;
            font-size: 1rem;
            border-bottom: 1px solid #ddd;
        }

        /* Table headers */
        .order-summary-table th {
            background-color: #008774;
            color: white;
            font-weight: bold;
            text-transform: uppercase;
        }

        /* Hover effect on rows */
        .order-summary-table tr:hover {
            background-color: #f2f2f2;
        }

        /* Table footer styling */
        .order-summary-table tfoot tr {
            font-weight: bold;
            background-color: #f4f4f4;
        }

        .order-summary-table #total-price {
            color: #008774;
            font-size: 1.2rem;
            font-weight: bold;
        }

        /* Responsive design: Make the table scrollable on smaller screens */
        @media (max-width: 768px) {
            .order-summary-table {
                overflow-x: auto;
                display: block;
                white-space: nowrap;
            }

            .order-summary-table th, .order-summary-table td {
                white-space: nowrap;
            }
        }
    </style>

    <script>
        // Function to load cart data and populate order summary
        function loadCart(cartData) {
            const orderItemsContainer = document.getElementById('order-items');
            let total = 0;

            orderItemsContainer.innerHTML = '';

            if (cartData.length === 0) {
                orderItemsContainer.innerHTML = '<tr><td colspan="4">Your cart is empty.</td></tr>';
                document.getElementById('total-price').innerHTML = '$0.00'; // Ensure total is displayed as $0.00
                return;
            }

            cartData.forEach(item => {
                const subtotal = item.productPrice * item.quantity;
                total += subtotal;

                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${item.productName}</td>
                    <td>${item.quantity}</td>
                    <td>$${item.productPrice}</td>
                    <td>$${subtotal.toFixed(2)}</td>
                `;
                orderItemsContainer.appendChild(row);
            });

            // Update total price with two decimal places
            document.getElementById('total-price').innerHTML = `$${total.toFixed(2)}`;

            // Set cart data in hidden input field
            document.getElementById('cart-data').value = JSON.stringify(cartData);
        }

        // Fetch URL parameters for user_id and cart data
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            const userId = urlParams.get('user_id');  // Get user ID from URL
            const cartData = JSON.parse(decodeURIComponent(urlParams.get('cart'))); // Get cart data from URL

            // Populate the form with user data and cart data
            document.getElementById('user-id').value = userId;
            loadCart(cartData);
        };

        // Credit card validation (16 digits)
        function validateCreditCard() {
            const cc = document.getElementById("credit-card").value;
            const ccPattern = /^\d{16}$/;
            if (!ccPattern.test(cc)) {
                alert("Credit Card Number must be 16 digits.");
                return false;
            }
            return true;
        }

        // Expiry date formatting (auto-insert `/` after 2 digits)
        function formatExpiryDate(event) {
            const input = event.target;
            let value = input.value.replace(/\D/g, ''); // Remove non-numeric characters

            if (value.length >= 2) {
                value = value.slice(0, 2) + '/' + value.slice(2, 4); // Insert '/' after 2 digits
            }

            input.value = value;
        }
    </script>
</head>
<body>
    <%@ include file="./components/nav.jsp" %>

    <div class="main-wrapper">
        <div class="container">
            <div class="col-md-6 form-container">
                <div class="form-box">
                    <h1>Checkout</h1>
                    <%  
                        // Fetch user details based on user_id
                        String userId = request.getParameter("user_id");
                        String firstName = "", lastName = "", email = "";
                        
                        if (userId != null) {
                            Connection conn = null;
                            PreparedStatement stmt = null;
                            ResultSet rs = null;
                            try {
                                conn = DBConnection.getConnection();
                                String query = "SELECT user_name, lname, user_email FROM users WHERE user_id = ?";
                                stmt = conn.prepareStatement(query);
                                stmt.setString(1, userId);
                                rs = stmt.executeQuery();

                                if (rs.next()) {
                                    firstName = rs.getString("user_name");
                                    lastName = rs.getString("lname");
                                    email = rs.getString("user_email");
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
                        }
                    %>
                    
                    <form id="checkout-form" action="PlaceOrderServlet" method="post" onsubmit="return validateCreditCard()">
                        <input type="hidden" name="user_id" id="user-id" value="<%= userId %>">
                        <input type="hidden" name="cart" id="cart-data">
                        <div class="row g-3">
                            <div class="input-container col-lg-12">
                                <label for="first-name" class="form-label">First Name</label>
                                <input type="text" id="first-name" name="shipping_first_name" class="form-control" placeholder="First Name" value="<%= firstName %>">
                            </div>
                            <div class="input-container col-lg-12">
                                <label for="last-name" class="form-label">Last Name</label>
                                <input type="text" name="shipping_last_name" class="form-control" placeholder="Last Name" value="<%= lastName %>">
                            </div>
                            <div class="input-container col-lg-12">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" id="email" name="email" class="form-control" placeholder="youremail@sample.com" value="<%= email %>" readonly>
                            </div>
                            <div class="input-container col-lg-12">
                                <label for="shipping-address" class="form-label">Shipping Address</label>
                                <input type="text" id="shipping-address" name="shipping_address" class="form-control" placeholder="Shipping Address">
                            </div>
                        </div>

                        <div class="row g-3">
                            <div class="input-container col-lg-12">
                                <label for="payment-method" class="form-label">Payment Method</label>
                                <select id="payment-method" name="payment_method" class="form-control">
                                    <option value="credit_card">Credit Card</option>
                                    <option value="paypal">PayPal</option>
                                    <option value="bank_transfer">Bank Transfer</option>
                                </select>
                            </div>
                            <div class="input-container col-lg-12">
                                <label for="credit-card" class="form-label">Credit Card Number</label>
                                <input type="text" name="credit_card" class="form-control" placeholder="#### #### #### ####" id="credit-card" maxlength="16">
                            </div>
                            <div class="input-container col-lg-12">
                                <label for="expiry-date" class="form-label">Expiry Date</label>
                                <input type="text" id="expiry-date" name="expiry_date" class="form-control" placeholder="MM/YY" maxlength="5" oninput="formatExpiryDate(event)">
                            </div>
                            <div class="input-container col-lg-12">
                                <label for="cvv" class="form-label">CVV</label>
                                <input type="text" id="cvv" name="cvv" class="form-control" placeholder="CVV"  maxlength="3">
                            </div>
                        </div>

                        <div class="order-summary-section">
                            <h2>Order Summary</h2>
                            <table class="order-summary-table">
                                <thead>
                                    <tr>
                                        <th>Product</th>
                                        <th>Quantity</th>
                                        <th>Price</th>
                                        <th>Total</th>
                                    </tr>
                                </thead>
                                <tbody id="order-items">
                                    </tbody>
                                <tfoot>
                                    <tr>
                                        <td colspan="3">Total</td>
                                        <td id="total-price">$0</td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>

                        <div class="button-container">
                            <button type="button" class="btn-primary" onclick="window.history.back()">Cancel</button>
                            <button type="submit" class="btn-primary" id="submit-payment">Place Order</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="./components/footer.jsp" %>
</body>
</html>
