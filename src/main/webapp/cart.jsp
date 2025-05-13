<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*"%>
<%@page import="java.util.*,javax.sql.*, java.net.URLEncoder"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Cart</title>
    <%@include file="./components/common.jsp" %>
    <link rel="stylesheet" href="./css/cart.css"/>
    <link rel="stylesheet" href="./css/home.css">
    <link rel="stylesheet" href="./css/root.css">
    <script>
        // Load Cart from localStorage
        function loadCart() {
            const cart = JSON.parse(localStorage.getItem('cart')) || [];
            const cartTable = document.getElementById('cart-table');
            const totalPriceContainer = document.getElementById('tot');
            let total = 0;

            // Clear previous cart items
            cartTable.innerHTML = '';

            // Check if cart is empty
            if (cart.length === 0) {
                cartTable.innerHTML = '<tr><td colspan="5">Your cart is empty.</td></tr>';
                totalPriceContainer.innerHTML = 'Total: Rs. 0.00'; // Ensure total is displayed as Rs. 0.00
                return;
            }

            // Display cart items
            cart.forEach(item => {
                const subtotal = item.productPrice * item.quantity;
                total += subtotal;

                const row = document.createElement('tr');
                row.innerHTML = `
                    <td><img src="${item.productImage}" alt="item-image" width="90px">${item.productName}</td>
                    <td>Rs. ${item.productPrice}</td>
                    <td>
                        <input class="quantity" id="textInput${item.productId}" value="${item.quantity}" type="number" min="1" onchange="updateCart(${item.productId}, this.value)">
                    </td>
                    <td id="subPrice${item.productId}">Rs. ${subtotal.toFixed(2)}</td> <!-- Ensure subtotal is displayed with two decimal places -->
                    <td><button class="btn-delete" onclick="removeItem(${item.productId})">Remove</button></td>
                `;
                cartTable.appendChild(row);
            });

            // Update total price with two decimal places
            totalPriceContainer.innerHTML = 'Total: Rs. ' + total.toFixed(2); // Ensure total is displayed with two decimal places
        }

        // Function to update cart item when quantity changes
        function updateCart(productId, quantity) {
            const cart = JSON.parse(localStorage.getItem('cart')) || [];
            const productIndex = cart.findIndex(item => item.productId === productId);

            if (productIndex !== -1) {
                cart[productIndex].quantity = quantity;
                localStorage.setItem('cart', JSON.stringify(cart));
                loadCart(); // Reload the cart with updated data
            }
        }

        // Function to remove an item from the cart
        function removeItem(productId) {
            let cart = JSON.parse(localStorage.getItem('cart')) || [];
            cart = cart.filter(item => item.productId !== productId); // Remove item by productId
            localStorage.setItem('cart', JSON.stringify(cart));
            loadCart(); // Reload the cart to reflect the change
        }

        // Function to update the entire cart when the "Update Cart" button is clicked
        function updateCartButton() {
            const updatedQuantities = [];

            // Loop through all quantity input fields and gather the updated data
            const quantityInputs = document.querySelectorAll('.quantity');
            quantityInputs.forEach(input => {
                const productId = input.id.replace('textInput', '');  // Extract productId from input id
                const quantity = input.value;
                updatedQuantities.push({ productId, quantity });
            });

            // Update the cart data in localStorage
            let cart = JSON.parse(localStorage.getItem('cart')) || [];
            updatedQuantities.forEach(item => {
                const productIndex = cart.findIndex(cartItem => cartItem.productId === item.productId);
                if (productIndex !== -1) {
                    cart[productIndex].quantity = item.quantity;
                }
            });

            localStorage.setItem('cart', JSON.stringify(cart));
            loadCart(); // Reload the cart with updated data
        }

        // Function to handle "Proceed to Checkout" button click
        function proceedToCheckout() {
            const cart = JSON.parse(localStorage.getItem('cart')) || [];
            
            // Get user_id from URL parameters
            const urlParams = new URLSearchParams(window.location.search);
            const userIdStr = urlParams.get('user_id');  // Extract the user_id from the URL

            if (cart.length === 0) {
                alert('Your cart is empty!');
                return;
            }

            // Encode the cart data and send it to the checkout page
            const cartData = encodeURIComponent(JSON.stringify(cart));

            // Redirect to the checkout page, passing the user_id and cart data as URL parameters
            window.location.href = `checkout.jsp?user_id=${userIdStr}&cart=${cartData}`;
        }

        // Initialize the cart when the page loads
        window.onload = loadCart;
    </script>
</head>
<body>
 <%@include file="./components/nav.jsp" %>
    <div class="main-wrapper">

        <div class="container cart-box">
            <div class="container-fluid">
                <table class="table1" border="0" width="1200px" height="250px">
                    <thead>
                        <tr class="tr0">
                            <td class="pr">Product</td>
                            <td>Price</td>
                            <td>Quantity</td>
                            <td>Subtotal</td>
                            <td>Action</td>
                        </tr>
                    </thead>
                    <tbody id="cart-table">
                        </tbody>
                </table>

                <a href="home.jsp"><button class="b1 rounded"><b>Return To Shop</b></button></a>
                <button class="b2 rounded" onclick="updateCartButton()">Update Cart</button>

            

                <div class="box1 rounded">
                    <h4>Cart Total</h4>
                    <h5>

                        <div class="box2"><pre>Shipping: Free</pre></div>
                        <div class="box2" id="tot"><pre>Total: Rs. 0</pre></div>
                    </h5>
                    <button class="b5 rounded"  onclick="proceedToCheckout()">Proceed To Checkout</button>

                </div>
                <br><br>
            </div>
        </div>
    </div>
     <%@include file="./components/footer.jsp" %>
</body>
</html>
