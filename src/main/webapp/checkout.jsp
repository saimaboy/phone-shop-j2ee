<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout</title>
    <%@include file="./components/common.jsp" %>
    <link rel="stylesheet" href="./css/acc.css">
    <link rel="stylesheet" href="./css/home.css">
    <link rel="stylesheet" href="./css/root.css">

    <!-- Include Stripe.js -->
    <script src="https://js.stripe.com/v3/"></script>
</head>
<body>
    <%@include file="./components/nav.jsp" %>

    <div class="main-wrapper">
        <div class="container">
            <div class="col-md-6 form-container">
                <div class="form-box">
                    <h1>Checkout</h1>
                    <form id="checkout-form" action="PlaceOrder" method="post">
                        <div class="row g-3">
                            <!-- Shipping Address Section -->
                            <div class="input-container col-lg-12">
                                <label for="first-name" class="form-label">First Name</label>
                                <input type="text" id="first-name" name="shipping_first_name" class="form-control" placeholder="First Name">
                            </div>
                            <div class="input-container col-lg-12">
                                <label for="last-name" class="form-label">Last Name</label>
                                <input type="text" name="shipping_last_name" class="form-control" placeholder="Last Name">
                            </div>
                            <div class="input-container col-lg-12">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" id="email" name="email" class="form-control" placeholder="youremail@sample.com">
                            </div>
                            <div class="input-container col-lg-12">
                                <label for="shipping-address" class="form-label">Shipping Address</label>
                                <input type="text" id="shipping-address" name="shipping_address" class="form-control" placeholder="Shipping Address">
                            </div>
                        </div>

                        <!-- Payment Information Section -->
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
                                <!-- Stripe Element for Card Input -->
                                <div id="card-element" class="form-control"></div>
                            </div>
                            <div class="input-container col-lg-12">
                                <label for="expiry-date" class="form-label">Expiry Date</label>
                                <input type="text" id="expiry-date" name="expiry_date" class="form-control" placeholder="MM/YY">
                            </div>
                            <div class="input-container col-lg-12">
                                <label for="cvv" class="form-label">CVV</label>
                                <input type="text" id="cvv" name="cvv" class="form-control" placeholder="CVV">
                            </div>
                        </div>

                        <!-- Order Summary Section -->
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
                                    <!-- Sample Order Details -->
                                    <!-- Dynamically populated order items go here -->
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

    <%@include file="./components/footer.jsp" %>

    <script>
        // Function to get URL parameters
        function getUrlParameters() {
            const urlParams = new URLSearchParams(window.location.search);
            let cartItems = [];
            for (let [key, value] of urlParams.entries()) {
                if (key.startsWith('productId')) {
                    const productId = value;
                    const quantity = urlParams.get('quantity' + productId);
                    cartItems.push({ productId, quantity });
                }
            }
            return cartItems;
        }

        // Function to populate order summary
        function populateOrderSummary() {
            const cartItems = getUrlParameters();
            const orderItemsTable = document.getElementById('order-items');
            let totalPrice = 0;

            cartItems.forEach(item => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>Product ${item.productId}</td>
                    <td>${item.quantity}</td>
                    <td>$100</td>
                    <td>$${item.quantity * 100}</td>
                `;
                orderItemsTable.appendChild(row);
                totalPrice += item.quantity * 100; // Assuming price is $100 for each item
            });

            document.getElementById('total-price').innerText = `$${totalPrice}`;
        }

        // Call function to populate order summary
        populateOrderSummary();

        // Initialize Stripe and Elements
        var stripe = Stripe('sk_test_51R7IsZFKBuG4KLiqTfZQ1WKUE5C7wlFOrWHg813Nv5uTr3SSTU2BqaUkMbmgh13saKHsinK0TWA5xdCwwtLcxQzs00udJJUKfa'); // Replace with your Stripe public key
        var elements = stripe.elements();

        // Create an instance of the card Element
        var card = elements.create('card');
        
        // Mount the card Element into the DOM
        card.mount('#card-element');

        // Handle form submission
        document.getElementById('checkout-form').addEventListener('submit', function(event) {
            event.preventDefault();

            // Create a payment method
            stripe.createPaymentMethod({
                type: 'card',
                card: card,
                billing_details: {
                    name: document.getElementById('first-name').value + ' ' + document.getElementById('last-name').value,
                    email: document.getElementById('email').value
                },
            }).then(function(result) {
                if (result.error) {
                    // Handle error
                    alert(result.error.message);
                } else {
                    // Send the payment method ID to your server for processing
                    var paymentMethodId = result.paymentMethod.id;
                    
                    // You can send paymentMethodId to your server to complete the payment
                    // This would be done using an AJAX request to your backend API
                    console.log(paymentMethodId);
                    
                    // Example: Use fetch to send data to your backend
                    fetch('/process-payment', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({
                            payment_method_id: paymentMethodId,
                            shipping_first_name: document.getElementById('first-name').value,
                            shipping_last_name: document.getElementById('last-name').value,
                            shipping_address: document.getElementById('shipping-address').value,
                        })
                    }).then(function(response) {
                        return response.json();
                    }).then(function(data) {
                        if (data.success) {
                            // Redirect to success page
                            window.location.href = "/success";
                        } else {
                            // Handle error response
                            alert('Payment failed: ' + data.error);
                        }
                    });
                }
            });
        });
    </script>
</body>
</html>
