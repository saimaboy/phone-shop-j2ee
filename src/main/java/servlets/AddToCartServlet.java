package servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import utils.DBConnection; // Assuming you have this class to handle DB connection

public class AddToCartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the product ID and user ID from the URL parameters
        String productId = request.getParameter("product_id");
        String userId = request.getParameter("user_id"); // You should ensure the user is logged in

        if (productId == null || userId == null) {
            // If either the product_id or user_id is not provided, send an error
            request.setAttribute("errorMessage", "Invalid product or user information.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Get database connection
            conn = DBConnection.getConnection();

            // Check if the product is already in the cart (if the user has the product in the cart, just increase the quantity)
            String checkCartSql = "SELECT * FROM cart WHERE user_id = ? AND product_id = ?";
            stmt = conn.prepareStatement(checkCartSql);
            stmt.setInt(1, Integer.parseInt(userId));
            stmt.setInt(2, Integer.parseInt(productId));
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Product already in cart, so update the quantity
                int cartId = rs.getInt("cart_id");
                int quantity = rs.getInt("quantity");
                String updateCartSql = "UPDATE cart SET quantity = ? WHERE cart_id = ?";
                stmt = conn.prepareStatement(updateCartSql);
                stmt.setInt(1, quantity + 1); // Increase quantity by 1
                stmt.setInt(2, cartId);
                stmt.executeUpdate();
            } else {
                // Product not in cart, so add it
                String addCartSql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
                stmt = conn.prepareStatement(addCartSql);
                stmt.setInt(1, Integer.parseInt(userId));
                stmt.setInt(2, Integer.parseInt(productId));
                stmt.setInt(3, 1); // Set initial quantity to 1
                stmt.executeUpdate();
            }

            // Redirect back to the cart page (or any other page you want)
            response.sendRedirect("cart.jsp?user_id=" + userId); // Assuming you have a cart.jsp that displays the user's cart
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle any database errors
            request.setAttribute("errorMessage", "Error adding product to cart: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
