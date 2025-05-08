<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>about Page</title>
        <%@include file="./components/common.jsp" %>
        <link rel="stylesheet" href="./css/about.css"/>
        <link rel="stylesheet" type="text/css" href="./css/root.css">
    </head>
    <body>
        
<!--       ---------------------about---------------------------------->
<%@include file="components/nav.jsp" %>
<div class="main-wrapper">
<div id="about">
    <div class="container px-5">
        <div class="row">           
            <div class="col-lg-6 about-col-2">
                <h1 class="sub-title">Our Story</h1>
                <p>Welcome to our e-commerce platform, where convenience meets excellence! At TradeHub, we pride ourselves on providing unparalleled services tailored to your needs.lightning-fast and free delivery, ensuring your purchases arrive promptly at your doorstep.Worried about making the wrong choice? Relax, because with our hassle-free money-back guarantee, your satisfaction is our priority. Whether you're browsing for essential medicines, delightful toys, glamorous beauty products, high-performance sport goods, cutting-edge electronics, or stylish apparel for men and women, we've got you covered. Plus, as an extra touch, enjoy exclusive deals and personalized recommendations, making your shopping experience with us truly exceptional. Discover the convenience of shopping at TradeHub today!</p>
                <p>At TradeHub, we believe in going above and beyond to ensure your satisfaction. That's why we're constantly innovating to provide you with the best possible experience. From seamless navigation on our user-friendly interface to secure payment options, every aspect of your journey with us is carefully crafted with your convenience in mind. Join the thousands of satisfied customers who trust us for their shopping needs. Experience the difference at TradeHub today!</p>  
            </div>
            <div class="col-lg-6 about-col-1">
                <img src="images/about/work-2.png" class="img-fluid" alt="E-commerce">
            </div>
        </div>
    </div>
</div>
<!--------------------services------------------------------------->
 <div class="container px-5">
    <div id="services">
        <div class="row">
            <div class="col-md-6 col-lg-3">
                <div class="service-item text-center">
                    <i class="fa-solid fa-store fa-3x"></i>
                    <h2>10.5k</h2>
                    <p>Sellers active on our site</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="service-item text-center">
                    <i class="fa-sharp fa-solid fa-dollar-sign fa-3x"></i>
                    <h2>33k</h2>
                    <p>Monthly Product Sale</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="service-item text-center">
                    <i class="fa-solid fa-cart-shopping fa-3x"></i>
                    <h2>45.5k</h2>
                    <p>Customers active on our site</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="service-item text-center">
                    <i class="fa-solid fa-sack-dollar fa-3x"></i>
                    <h2>25k</h2>
                    <p>Annual gross sale on our site</p>
                </div>
            </div>
        </div>
    </div>
</div>

<!--------------------------------------icon------------------------------------------------->

<div id="icons">
    <div class="container">
        <div class="row">
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
</div>

<!-- Bootstrap JavaScript CDN -->


        <%@include file="./components/footer.jsp" %>
     
    </body>
</html>

