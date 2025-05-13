<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.*,java.net.URLEncoder" %>
<%@ page import="servlets.LoginServlet" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
        <%@include file="./components/common.jsp" %>
        <link rel="stylesheet" type="text/css" href="./css/login.css">
        <link rel="stylesheet" type="text/css" href="./css/root.css">
    </head>
    <body>
        <div class="main-wrapper">
            <div class="container">
                <div class="row">
                    <div class="container-fluid">
                        <div class="col-md-8 image-container">
                            <img src="./images/login/login.svg">
                        </div>
                    </div>

                    <div class="container-fluid">
                        <div class="col-md-6 form-container">
                            <form action="LoginServlet" method="post" class="form">
                                <div class="login-box">
                                    <%@include file="./components/message.jsp" %>
                                    <h1>Log in to Exclusive</h1>
                                    <p><b>Enter your details below</b></p> 

                                    <!-- Display Inline Error Messages -->
                                    <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
                                    <div class="error-message" style="color:red;">
                                        <%= errorMessage != null ? errorMessage : "" %>
                                    </div>

                                    <div class="user-box">
                                        <input type="text" name="user_email" required>
                                        <label>Email</label>
                                    </div> 
                                    <div class="user-box">
                                        <input type="password" name="user_password" required>
                                        <label>Password</label>
                                    </div>

                                    <div class="remember-forget">
                                        <label> 
                                            <input type="checkbox"> Remember Me 
                                            <a href="#">Forget Password?</a>
                                        </label>
                                    </div>
                                    <div class="buttons-container">
                                        <button class="btn-primary">Login</button>
                                        <p class="sign-up-label">
                                            Don't have an account? <a href="register.jsp" class="register-link">Register</a>
                                        </p>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
