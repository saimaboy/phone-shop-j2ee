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
    <!-- Include navigation -->
        <%@include file="./components/nav.jsp" %>
    <div class="main-wrapper">
        <div class="container px-5">
            <section class="item">
                <div class="row mt-5">
                    <div class="main-image col-lg-5 border">
                        <img src="images/products/example_product.jpg" alt="Product Image">
                    </div>
                    <div class="content col-lg-6 col-md-12 col-12">
                        <h2>Example Product Name</h2>
                        <div class="rating">
                            <i class="fa fa-star"></i>
                            <i class="fa fa-star"></i>
                            <i class="fa fa-star"></i>
                            <i class="fa fa-star"></i>
                            <i class="fa fa-star"></i>
                        </div>
                        <span>(150 Reviews) | In-Stock</span>
                        <h5>$ 29.99</h5>
                        <br>
                        <p>This is a description of the example product.</p>
                        <div class="product-container">
                            <div class="quantity-selector">
                                <span class="minus">-</span>
                                <span class="num">01</span>
                                <span class="plus">+</span>
                            </div>
                            <div class="add-to-cart">
                                <a href="cart.jsp?id=1&category=all&page=products"><button type="submit">Add to Cart</button></a>
                                <button type="button" style="background-color: transparent; color: black; border: 1px solid black;" class="add-to-favorites">
                                    <i class="fa-regular fa-heart"></i>
                                </button>
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
                <!-- Example related product -->
                <div class="card col-md-4 col-lg-12 border">
                    <a href="item.jsp?id=2&category=all">
                        <img src="images/products/example_related_product_1.jpg" class="card-img-top py-2">
                    </a>
                    <div class="card-body">
                        <h5 class="card-title">Related Product 1</h5>
                    </div>
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item">$ 19.99</li>
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
                        <a href="cart.jsp?id=2&category=all&page=products" class="card-link"><i class="fa fa-shopping-cart" aria-hidden="true"></i></a>
                    </div>
                </div>

                <!-- Another example related product -->
                <div class="card col-md-4 col-lg-12 border">
                    <a href="item.jsp?id=3&category=all">
                        <img src="images/products/example_related_product_2.jpg" class="card-img-top py-2">
                    </a>
                    <div class="card-body">
                        <h5 class="card-title">Related Product 2</h5>
                    </div>
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item">$ 24.99</li>
                        <li class="list-group-item">
                            <div class="product bottom">
                                <i class="fa fa-star"></i>
                                <i class="fa fa-star"></i>
                                <i class="fa fa-star"></i>
                                <i class="fa fa-star-half-o"></i>
                            </div>
                        </li>
                    </ul>    
                    <div class="card-footer">
                        <a href="#" class="card-link"><i class="fa fa-heart" aria-hidden="true"></i></a>
                        <a href="cart.jsp?id=3&category=all&page=products" class="card-link"><i class="fa fa-shopping-cart" aria-hidden="true"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Include footer -->
       <%@include file="./components/footer.jsp" %>
</body>

</html>

<script>
    const plus = document.querySelector(".plus"),
          minus = document.querySelector(".minus"),
          num = document.querySelector(".num");
    let a = 1;

    plus.addEventListener("click", () => {
        a++;
        a = (a < 10) ? "0" + a : a;
        num.innerText = a;
    });

    minus.addEventListener("click", () => {
        if (a > 1) {
            a--;
            a = (a < 10) ? "0" + a : a;
            num.innerText = a;
        }
    });
</script>
