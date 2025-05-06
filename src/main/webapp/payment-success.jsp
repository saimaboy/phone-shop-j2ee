<%-- 
    Document   : payment-success
    Created on : May 5, 2025, 4:25:30 AM
    Author     : Shadow
--%>
<%@page import="org.hibernate.Query"%>
<%@page import="com.ecommerce.tradehub.helper.FactoryProvider"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="org.hibernate.Session"%>
<%@page import="com.ecommerce.tradehub.dao.CartDao"%>
<%@page import="com.ecommerce.tradehub.entities.User"%>
<%
    User user = (User) session.getAttribute("user_type");
    String sessionId = (String) session.getAttribute("stripe_session_id");
    
    if (user == null || sessionId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    boolean cartCleared = false;
    String errorMessage = null;
    
    // Process the order and clear the cart
    try {
        // Create a new OrderDao to handle saving order information
        // OrderDao orderDao = new OrderDao();
        // orderDao.createOrder(user.getUserId(), sessionId);
        
        // Clear the user's cart after successful payment
        
        Session hibernateSession = null;
        Transaction tx = null;
//        CartDao cartDao = new CartDao();
//        cartDao.clearCart(user.getUserId());
        try {
            hibernateSession = FactoryProvider.getFactory().openSession();
            tx = hibernateSession.beginTransaction();
            
            // SQL Delete approach - more reliable than HQL in some cases
            Query query = hibernateSession.createNativeQuery("DELETE FROM cart WHERE user_id = :userId");
            query.setParameter("userId", user.getUserId());
            
            int deletedRows = query.executeUpdate();
            
            tx.commit();
            cartCleared = true;
            
            // For debugging
            out.println("<!-- DEBUG: " + deletedRows + " rows deleted from cart -->");
            
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            errorMessage = e.getMessage();
            e.printStackTrace();
        } finally {
            if (hibernateSession != null) {
                hibernateSession.close();
            }
        }
        
        // Remove session ID
        session.removeAttribute("stripe_session_id");
        
        session.setAttribute("message", "Payment successful! Your order has been placed.");
    } catch (Exception e) {
        session.setAttribute("message", "Error processing your order: " + e.getMessage());
    }
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Payment Success</title>
        <%@include file="components/common.jsp" %>
    </head>
    <body>
        <%@include file="components/nav.jsp" %>
        <div class="main-wrapper">
            <div class="container">
                <div class="row">
                    <div class="col-md-12 text-center mt-5">
                        <i class="fa-solid fa-circle-check text-success" style="font-size: 5rem;"></i>
                        <h1 class="mt-3">Payment Successful!</h1>
                        <p>Your order has been placed successfully.</p>
                        <% if (errorMessage != null) { %>
                        <div class="alert alert-warning mt-3">
                            There was an issue clearing your cart: <%= errorMessage %>
                        </div>
                        <% } %>
                        
                        <div class="mt-4">
                            <a href="index.jsp" class="btn btn-primary me-2">Continue Shopping</a>
                            <% if (!cartCleared) { %>
                            <form action="ClearCartServlet" method="post" class="d-inline">
                                <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                                <button type="submit" class="btn btn-warning">Clear Cart</button>
                            </form>
                            <% } %>
                       
                    </div>
                </div>
            </div>
        </div>
        <%@include file="components/footer.jsp" %>
    </body>
</html>
