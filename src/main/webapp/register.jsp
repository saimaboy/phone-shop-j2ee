<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*,java.net.URLEncoder" %>
<%@ page import="servlets.RegisterServlet" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Registration</title>
        <%@include file="./components/common.jsp" %>
        <link rel="stylesheet" type="text/css" href="./css/register.css">
        <link rel="stylesheet" type="text/css" href="./css/root.css">
    </head>
    <body>

        <div class="main-wrapper">
            <div class="container">
                <div class="img">
                    <img src="images/Registration/Regi.svg">
                </div>
                
                <div id="individualFields" style="display: block;">
                    <div class="form-box">
                        <div id="message"></div> <!-- Div to display error/success messages -->
                        <form action="RegisterServlet" method="post" class="form" id="registrationForm">
                            <h1>Create an account</h1>

                            <br>
                            <div class="flex-column">
                                <label>First Name</label>
                            </div>
                            <div class="inputForm mb-3">
                                <input type="text" placeholder="Enter your First Name" class="input" name="user_name" required>
                            </div>

                            <div class="flex-column">
                                <label>Last Name</label>
                            </div>
                            <div class="inputForm mb-3">
                                <input type="text" placeholder="Enter Your Last Name" class="input" name="lname" required>
                            </div>

                            <div class="flex-column">
                                <label>Email</label>
                            </div>
                            <div class="inputForm mb-3">
                                <input type="text" placeholder="Enter Your Email" class="input" name="user_email" required>
                            </div>

                            <div class="flex-column">
                                <label>Password</label>
                            </div>
                            <div class="inputForm mb-3">
                                <input type="password" placeholder="Enter Your Password" class="input" name="user_password" required>
                            </div>

                            <div class="flex-column">
                                <label>Confirm Password</label>
                            </div>
                            <div class="inputForm mb-3">
                                <input type="password" placeholder="Confirm Your Password" class="input" name="user_seepassword" required>
                            </div>

                            <div class="flex-column">
                                <label>Phone Number</label>
                            </div>
                            <div class="inputForm mb-3">
                                <input type="text" placeholder="Enter your Phone Number" class="input" name="user_phone" required>
                            </div>

                            <div class="flex-column">
                                <label>Address</label>
                            </div>
                            <div class="inputForm mb-3">
                                <input type="text" placeholder="Enter your Address" class="input" name="user_address" required>
                            </div>

                            <div class="flex-row">
                               <label>Already Have an Account <a href="login.jsp">Login</a></label>
                            </div>

                            <input type="submit" class="btn btn-primary" value="Submit">
                            <br>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const form = document.getElementById('registrationForm');

                form.addEventListener('submit', function(event) {
                    let isValid = true;
                    const userEmail = document.querySelector('input[name="user_email"]');
                    const userPassword = document.querySelector('input[name="user_password"]');
                    const userConfirmPassword = document.querySelector('input[name="user_seepassword"]');
                    const userPhone = document.querySelector('input[name="user_phone"]');
                    const userAddress = document.querySelector('input[name="user_address"]');
                    
                    // Check if passwords match
                    if (userPassword.value !== userConfirmPassword.value) {
                        isValid = false;
                        alert("Passwords do not match!");
                    }

                    // Check if email is valid
                    const emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
                    if (!emailPattern.test(userEmail.value)) {
                        isValid = false;
                        alert("Invalid email format!");
                    }

                    // Check if phone number is valid (10 digits)
                    const phonePattern = /^[0-9]{10}$/;
                    if (!phonePattern.test(userPhone.value)) {
                        isValid = false;
                        alert("Phone number should be 10 digits!");
                    }

                    // Check if all fields are filled
                    if (userEmail.value === '' || userPassword.value === '' || userConfirmPassword.value === '' || userPhone.value === '' || userAddress.value === '') {
                        isValid = false;
                        alert("All fields are required!");
                    }

                    // If validation fails, prevent form submission
                    if (!isValid) {
                        event.preventDefault(); // Prevent form submission if validation fails
                    }
                });

                // Show alert based on server-side registration status
                <% if (request.getAttribute("message") != null) { %>
                    <% if ("success".equals(request.getAttribute("message"))) { %>
                        alert("Registration Successful.");
                    <% } else if ("failure".equals(request.getAttribute("message"))) { %>
                        alert("Registration Failed. Please try again.");
                    <% } %>
                <% } %>
            });
        </script>
    </body>
</html>
