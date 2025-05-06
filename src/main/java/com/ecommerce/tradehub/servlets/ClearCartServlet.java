/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.ecommerce.tradehub.servlets;

import com.ecommerce.tradehub.entities.User;
import com.ecommerce.tradehub.helper.FactoryProvider;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author Shadow
 */
public class ClearCartServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    

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
        
         HttpSession httpSession = request.getSession();
        User user = (User) httpSession.getAttribute("user_type");
        
        
        int userId = user.getUserId();
        boolean cleared = false;
        
        // Direct database approach to clear cart
        Session hibernateSession = null;
        Transaction tx = null;
        
        try {
            hibernateSession = FactoryProvider.getFactory().openSession();
            tx = hibernateSession.beginTransaction();
            
            // Try both approaches to ensure cart is cleared
            
            // Approach 1: Using native SQL
            Query sqlQuery = hibernateSession.createNativeQuery("DELETE FROM cart WHERE user_id = :uid");
            sqlQuery.setParameter("uid", userId);
            int sqlResult = sqlQuery.executeUpdate();
            
            // Approach 2: Using HQL (as backup)
//            Query hqlQuery = hibernateSession.createQuery("delete from Cart where userId = :uid");
//            hqlQuery.setParameter("uid", userId);
//            int hqlResult = hqlQuery.executeUpdate();
            
            tx.commit();
            
            cleared = true;
            httpSession.setAttribute("message", "Cart cleared successfully");
            
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            e.printStackTrace();
            httpSession.setAttribute("message", "Failed to clear cart: " + e.getMessage());
        } finally {
            if (hibernateSession != null) {
                hibernateSession.close();
            }
        }
        
        // Redirect back to cart page (or success page)
        response.sendRedirect("cart.jsp");
    
       
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
