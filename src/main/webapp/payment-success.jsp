<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Payment Success</title>
        <link rel="stylesheet" href="./css/styles.css"/>
         <%@include file="./components/common.jsp" %>
        <link rel="stylesheet" href="./css/home.css">
        <link rel="stylesheet" href="./css/root.css">
    </head>
    <body>
        <!-- Include navigation -->
             <%@include file="./components/nav.jsp" %>
        <div class="main-wrapper">
            <div class="container">
                <div class="row">
                    <div class="col-md-12 text-center mt-5">
                        <i class="fa-solid fa-circle-check text-success" style="font-size: 5rem;"></i>
                        <h1 class="mt-3">Payment Successful!</h1>
                        <p>Your order has been placed successfully.</p>
                        
                        <!-- Display error message if any -->
                        <div class="alert alert-warning mt-3" id="error-message" style="display: none;">
                            There was an issue clearing your cart.
                        </div>
                        
                        <div class="mt-4">
                            <a href="index.jsp" class="btn btn-primary me-2">Continue Shopping</a>
                            <form action="ClearCartServlet" method="post" class="d-inline" id="clear-cart-form">
                                <input type="hidden" name="userId" value="123"> <!-- Example userId -->
                                <button type="submit" class="btn btn-warning">Clear Cart</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Include footer -->
         <%@include file="./components/footer.jsp" %>
    </body>
</html>
