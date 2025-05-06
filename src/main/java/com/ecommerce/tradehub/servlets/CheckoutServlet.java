/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.ecommerce.tradehub.servlets;

import com.ecommerce.tradehub.dao.CartDao;
import com.ecommerce.tradehub.entities.Cart;
import com.ecommerce.tradehub.entities.User;
import com.stripe.Stripe;
import com.stripe.exception.StripeException;
import com.stripe.model.checkout.Session;
import com.stripe.param.checkout.SessionCreateParams;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Shadow
 */
public class CheckoutServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private static final String STRIPE_SECRET_KEY = "";
    
    @Override
    public void init() {
        // Initialize Stripe API with your secret key
        Stripe.apiKey = STRIPE_SECRET_KEY;
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user_type");
        
        if (user == null) {
            session.setAttribute("message", "Please log in to complete your purchase");
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            // Get all cart items for the user
            CartDao cartDao = new CartDao();
            List<Cart> cartItems = cartDao.getItemsById(user.getUserId());
            
            if (cartItems.isEmpty()) {
                session.setAttribute("message", "Your cart is empty");
                response.sendRedirect("cart.jsp");
                return;
            }
            
            // Build line items for Stripe checkout
            List<SessionCreateParams.LineItem> lineItems = new ArrayList<>();
            
            for (Cart item : cartItems) {
                lineItems.add(
                    SessionCreateParams.LineItem.builder()
                        .setPriceData(
                            SessionCreateParams.LineItem.PriceData.builder()
                                .setCurrency("LKR")
                                .setUnitAmount((long) (item.getProduct().getpPrice() * 100)) // Stripe uses cents/paise
                                .setProductData(
                                    SessionCreateParams.LineItem.PriceData.ProductData.builder()
                                        .setName(item.getProduct().getpName())
                                        .setDescription(item.getProduct().getpDesc())
                                        .build()
                                )
                                .build()
                        )
                        .setQuantity((long) item.getQuantity())
                        .build()
                );
            }
            SessionCreateParams params = SessionCreateParams.builder()
                .setMode(SessionCreateParams.Mode.PAYMENT)
                .setSuccessUrl(request.getScheme() + "://" + request.getServerName() + ":" + 
                               request.getServerPort() + request.getContextPath() + "/payment-success.jsp")
                .setCancelUrl(request.getScheme() + "://" + request.getServerName() + ":" + 
                              request.getServerPort() + request.getContextPath() + "/cart.jsp")
                .addAllLineItem(lineItems)
                .build();
            
            Session checkoutSession = Session.create(params);
            
            // Store checkout session ID in session for later use
            session.setAttribute("stripe_session_id", checkoutSession.getId());
            
            // Redirect to Stripe checkout page
            response.sendRedirect(checkoutSession.getUrl());
            
        } catch (StripeException e) {
            session.setAttribute("message", "Error creating checkout session: " + e.getMessage());
            response.sendRedirect("cart.jsp");
        }
        
        
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
