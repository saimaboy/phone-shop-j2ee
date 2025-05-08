<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="javax.servlet.http.HttpSession"%> 
<%@page import="javax.servlet.http.*, javax.servlet.*"%>
<%@page import="java.sql.*, java.util.*, java.net.URLEncoder" %>

<%
    // Retrieve the existing session
    HttpSession session = request.getSession(false); // false ensures we don't create a new session

    // If the session exists, invalidate it to log out the user
    if (session != null) {
        session.invalidate(); // Log out the user by invalidating the session
    }

    // Redirect to the login page
    response.sendRedirect("login.jsp");
%>
