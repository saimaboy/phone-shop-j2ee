<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*"%>
<%@ page import="java.sql.*, java.util.*,java.net.URLEncoder" %>
<nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top">
    <div class="container-fluid">
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarTogglerDemo01" aria-controls="navbarTogglerDemo01" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="container">
            <div class="collapse navbar-collapse mx-lg-5" id="navbarTogglerDemo01">
                <img src="images/trade hub.png" width="170">

                <ul class="navbar-nav nav-dark justify-content-center flex-grow-1 pe-3">
                    <li class="nav-item">
                        <a class="nav-link active mx-lg-3" aria-current="page" href="admin-dashboard.jsp?user_id=<%= session.getAttribute("userIdStr") != null ? session.getAttribute("userIdStr") : "" %>">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link mx-lg-3" aria-current="page" href="admin-order.jsp">Orders</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link mx-lg-3" aria-current="page" href="admin-user.jsp">Users</a>
                    </li>
                
                </ul> 

                <div class="nav-item">
                    <!-- User Profile Icon (conditionally show based on user login status) -->
                    <a href="admin-profile.jsp?user_id=<%= session.getAttribute("userIdStr") != null ? session.getAttribute("userIdStr") : "" %>" class="btn btn-primary pb-0 mx-2" style="border:none;">
                        <i class="fa-solid fa-user" style="font-size: 1.5rem;"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</nav>
