<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        
        
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top">
    <div class="container-fluid">
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarTogglerDemo01" aria-controls="navbarTogglerDemo01" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="container">
            <div class="collapse navbar-collapse mx-lg-5" id="navbarTogglerDemo01">
                <img src="images/trade hub.png" width=170>

                <ul class="navbar-nav nav-dark justify-content-center flex-grow-1 pe-3">
                    <li class="nav-item">
                        <a class="nav-link active mx-lg-3" aria-current="page" href="home.jsp">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link mx-lg-3" aria-current="page" href="contact.jsp">Contact</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link mx-lg-3" aria-current="page" href="about.jsp">About</a>
                    </li>
                </ul> 

                <div class="nav-item">
                   
                    <!-- Example static user options -->
                    <a href="register.jsp">
                        <button type="submit" class="btn btn-secondary mr-2">Sign Up</button>
                    </a>
                    <a class="mx-1" href="login.jsp">
                        <button type="submit" class="btn btn-primary">Log In</button>
                    </a>
                    
                </div>
            </div>
        </div>
    </div>
</nav>

        
        <!-- Homepage Section -->
        <div class="main-wrapper">
            <section class="header container">
              <div class="side-menu">
    <ul>
        <!-- Example of static category links as buttons -->
        <li><a href="products.jsp?category=1" class="btn btn-category">Phones</a></li>
        <li><a href="products.jsp?category=2" class="btn btn-category">Accesories</a></li>
        <li><a href="products.jsp?category=3" class="btn btn-category">Tabs</a></li>
    </ul>
</div>

                <div class="carousel-wrapper">
                    <div id="carouselExampleIndicators" class="carousel slide" data-bs-ride="carousel"> 
                        <div class="carousel-indicators ">
                            <button type="button" data-bs-slide-to="0" class="indicator-btn" aria-current="true" aria-label="Slide 1"></button>
                            <button type="button" data-bs-slide-to="1" class="indicator-btn" aria-label="Slide 2"></button>
                            <button type="button" data-bs-slide-to="2" class="indicator-btn active" aria-label="Slide 3"></button>
                            <button type="button" data-bs-slide-to="3" class="indicator-btn" aria-label="Slide 4"></button>
                            <button type="button" data-bs-slide-to="4" class="indicator-btn" aria-label="Slide 5"></button>
                        </div>
                        <div class="carousel-inner">
                            <div class="carousel-item">
                                <img src="./images/home/working.jpg" class="d-block w-100">
                            </div>
                            <div class="carousel-item">
                                <img src="./images/home/working.jpg" class="d-block w-100">
                            </div>
                            <div class="carousel-item active">
                                <img src="./images/home/working.jpg" class="d-block w-100">
                            </div>
                            <div class="carousel-item">
                                <img src="./images/home/working.jpg" class="d-block w-100">
                            </div>
                            <div class="carousel-item">
                                <img src="./images/home/working.jpg" class="d-block w-100">
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <div class="container px-5">
                <div class="tittle-box my-4">
                    <h4>Today's <a href="products.jsp"><button class="tittle-box-button">View All</button></a></h4>
                    <h1>Flash sales</h1>
                </div>
                <div class="sales row">
                    <!-- Static product example -->
                    <div class="card col-md-4 col-lg-12 border">
                        <a href="">
                            <img src="images/products/sample_product.jpg" class="card-img-top py-2">
                        </a>
                        <div class="card-body">
                            <h5 class="card-title">Product 1</h5>
                        </div>
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item">Rs. 1000.00</li>
                            <li class="list-group-item">
                                <div class="product bottom">
                                    <i class="fa fa-star"></i>
                                    <i class="fa fa-star"></i>
                                    <i class="fa fa-star"></i>
                                    <i class="fa fa-star"></i>
                                </div>
                            </li>
                        </ul>
                        <div class="card-footer">
                            <a href="#" class="card-link"><i class="fa fa-heart" aria-hidden="true"></i></a>
                            <a href="cart.html" class="card-link"><i class="fa fa-shopping-cart" aria-hidden="true"></i></a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="container px-5">
                <div class="carousel-wrapper-mid my-3">
                    <div id="carouselExampleIndicators" class="carousel slide" data-bs-ride="carousel">
                        <div class="carousel-indicators ">
                            <button type="button" data-bs-slide-to="0" class="indicator-btn" aria-current="true" aria-label="Slide 1"></button>
                            <button type="button" data-bs-slide-to="1" class="indicator-btn" aria-label="Slide 2"></button>
                            <button type="button" data-bs-slide-to="2" class="indicator-btn active" aria-label="Slide 3"></button>
                            <button type="button" data-bs-slide-to="3" class="indicator-btn" aria-label="Slide 4"></button>
                            <button type="button" data-bs-slide-to="4" class="indicator-btn" aria-label="Slide 5"></button>
                        </div>
                        <div class="carousel-inner-mid">
                            <div class="carousel-item">
                                <img src="images/home/working.jpg" class="d-block w-100">
                            </div>
                            <div class="carousel-item">
                                <img src="images/home/working.jpg" class="d-block w-100">
                            </div>
                            <div class="carousel-item active">
                                <img src="images/home/working.jpg" class="d-block w-100">
                            </div>
                            <div class="carousel-item">
                                <img src="images/home/working.jpg" class="d-block w-100">
                            </div>
                            <div class="carousel-item">
                                <img src="images/home/working.jpg" class="d-block w-100">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="container px-5">
                <div class="tittle-box my-4">
                    <h4>This Month's <a href="products.html?category=all"><button class="tittle-box-button">View All</button></a></h4>
                    <h1>Best Selling Products</h1>
                </div>
                <div class="category-box">
                    <!-- Static category links -->
                    <a href="products.html?category=1"><button class="catagerory-button">Category 1</button></a>
                    <a href="products.html?category=2"><button class="catagerory-button">Category 2</button></a>
                    <a href="products.html?category=3"><button class="catagerory-button">Category 3</button></a>
                </div>
                <div class="sales row">
                    <!-- Static product example -->
                    <div class="card col-md-4 col-lg-12 border">
                        <a href="">
                            <img src="images/products/sample_product.jpg" class="card-img-top py-2">
                        </a>
                        <div class="card-body">
                            <h5 class="card-title">Product 2</h5>
                        </div>
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item">Rs. 1200.00</li>
                            <li class="list-group-item">
                                <div class="product bottom">
                                    <i class="fa fa-star"></i>
                                    <i class="fa fa-star"></i>
                                    <i class="fa fa-star"></i>
                                    <i class="fa fa-star"></i>
                                </div>
                            </li>
                        </ul>
                        <div class="card-footer">
                            <a href="#" class="card-link"><i class="fa fa-heart" aria-hidden="true"></i></a>
                            <a href="#" class="card-link"><i class="fa fa-shopping-cart" aria-hidden="true"></i></a>
                        </div>
                    </div>
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

       <footer class="footer">
    <div class="container">
        <div class="container-fluid">
            <div class="row">
                <div class="footer-col">
                    <ul>
                        <img src="images/trade  2.png" width="170px">
                        <li><a href="#"><h3>Subscribe</h3></a></li>
                        <li><a href="#"><h3>Get 10% off from your first order</h3></a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <ul>
                        <h3>Support</h3>
                        <li><h4>127/6, High level road, Colombo 5</h4></li>
                        <li><a href="#"><h4>tradehubofficial@gmail.com</h4></a></li>
                        <li><a href="#"><h4>+94767770005</h4></a></li>
                    </ul>
                </div> 
                <div class="footer-col">
                    <ul>
                        <h3>Accounts</h3>
                        <li><a href="account.jsp"><h4>My account</h4></a></li>
                        <li><a href="login.jsp"><h4>Login</h4></a></li>
                        <li><a href="register.jsp"><h4>Register</h4></a></li>
                        <li><a href="cart.jsp"><h4>Cart</h4></a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <ul>
                        <h3>Quick Links</h3>
                        <li><a href="#"><h4>Policy</h4></a></li>
                        <li><a href="#"><h4>Terms of use</h4></a></li>
                        <li><a href="faq.jsp"><h4>FAQ</h4></a></li>
                        <li><a href="contact.jsp"><h4>Contact</h4></a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <ul>
                        <h3>Follow us on</h3>
                        <div class="social-links">
                            <a href="https://www.facebook.com"><i class="fab fa-facebook-f"></i></a>
                            <a href="https://twitter.com"><i class="fab fa-twitter"></i></a>
                            <a href="https://www.instagram.com"><i class="fab fa-instagram"></i></a>
                            <a href="https://www.linkedin.com"><i class="fab fa-linkedin"></i></a>
                        </div>
                    </ul>                        
                </div> 
                <div class="footer-bottom text-center">
                    <p>&copy;Copyright. TradeHub | All rights reserved.</p>
                </div>
            </div>
        </div>
    </div>
</footer>


    </body>
</html>
