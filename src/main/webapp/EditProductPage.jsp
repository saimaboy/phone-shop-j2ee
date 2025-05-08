<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*,java.net.URLEncoder" %><!-- Include JSTL -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Edit Product</title>
    <link rel="stylesheet" href="./css/admin.css"/>
    <link rel="stylesheet" href="./css/home.css">
    <link rel="stylesheet" href="./css/root.css">
</head>
<body>
    <%@include file="./components/admin_nav.jsp" %>
    <div class="main-wrapper">
        <div class="container-fluid">
            <h2>Edit Product</h2>
            
            <!-- Fetch product from request attribute set by the servlet -->
            <form action="EditProductServlet" method="post">
                <input type="hidden" name="id" value="${product.id}">

                <div class="form-group">
                    <label for="product_name">Product Name</label>
                    <input type="text" class="form-control" name="product_name" value="${product.product_name}" required />
                </div>

                <div class="form-group">
                    <label for="price">Price</label>
                    <input type="text" class="form-control" name="price" value="${product.price}" required />
                </div>

                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea class="form-control" name="description">${product.description}</textarea>
                </div>

                <div class="form-group">
                    <label for="category">Category</label>
                    <input type="text" class="form-control" name="category" value="${product.category}" />
                </div>

                <div class="form-group">
                    <label for="stock_quantity">Stock Quantity</label>
                    <input type="number" class="form-control" name="stock_quantity" value="${product.stock_quantity}" required />
                </div>

                <div class="form-group">
                    <label for="image_url">Product Image URL</label>
                    <input type="text" class="form-control" name="image_url" value="${product.image_url}" />
                </div>

                <button type="submit" class="btn btn-primary">Update Product</button>
            </form>
        </div>
    </div>

    <%@include file="./components/footer.jsp" %>
</body>
</html>
