package servlets;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;

public class CheckoutServlet extends HttpServlet {

    // Handle GET request (for displaying the checkout page)
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Assuming user_id is passed as a parameter in the URL
        String userId = request.getParameter("user_id");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        String dbURL = "jdbc:mysql://localhost:3306/phone_shop";
        String dbUsername = "root";
        String dbPassword = "12345678";

        try {
            // Connect to the database
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUsername, dbPassword);

            // Fetch user data from the database using user_id
            String userQuery = "SELECT first_name, last_name, email, shipping_address FROM users WHERE user_id = ?";
            stmt = conn.prepareStatement(userQuery);
            stmt.setInt(1, Integer.parseInt(userId));
            rs = stmt.executeQuery();

            if (rs.next()) {
                // Set user data as request attributes to populate the checkout form
                request.setAttribute("firstName", rs.getString("first_name"));
                request.setAttribute("lastName", rs.getString("last_name"));
                request.setAttribute("email", rs.getString("email"));
                request.setAttribute("shippingAddress", rs.getString("shipping_address"));
            }

            // Fetch cart items for the user
            String cartQuery = "SELECT p.product_name, p.price, c.quantity, c.product_id FROM cart c " +
                               "JOIN products p ON c.product_id = p.id WHERE c.user_id = ?";
            stmt = conn.prepareStatement(cartQuery);
            stmt.setInt(1, Integer.parseInt(userId));
            rs = stmt.executeQuery();

            // Create a list to hold the cart items and order total
            StringBuilder orderDetails = new StringBuilder();
            double totalAmount = 0.0;
            StringBuilder productIds = new StringBuilder();
            StringBuilder quantities = new StringBuilder();

            while (rs.next()) {
                String productName = rs.getString("product_name");
                double price = rs.getDouble("price");
                int quantity = rs.getInt("quantity");
                double subtotal = price * quantity;
                totalAmount += subtotal;

                // Append the product details to the order details
                orderDetails.append("Product: ").append(productName)
                            .append(", Quantity: ").append(quantity)
                            .append(", Price: Rs.").append(price)
                            .append(", Subtotal: Rs.").append(subtotal)
                            .append("\n");

                // Add productId and quantity to the lists for hidden form fields
                productIds.append(rs.getInt("product_id")).append(",");
                quantities.append(quantity).append(",");
            }

            // Remove trailing commas from productIds and quantities
            if (productIds.length() > 0) productIds.deleteCharAt(productIds.length() - 1);
            if (quantities.length() > 0) quantities.deleteCharAt(quantities.length() - 1);

            // Set order details, total amount, and cart items as request attributes
            request.setAttribute("orderDetails", orderDetails.toString());
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("productIds", productIds.toString().split(","));
            request.setAttribute("quantities", quantities.toString().split(","));

            // Forward the request to the checkout page
            RequestDispatcher dispatcher = request.getRequestDispatcher("heckout.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error fetching user data or cart items.");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Handle POST request (for processing the order)
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String[] productIds = request.getParameterValues("productId");
        String[] quantities = request.getParameterValues("quantity");

        Connection conn = null;
        PreparedStatement stmt = null;
        String dbURL = "jdbc:mysql://localhost:3306/phone_shop";
        String dbUsername = "root";
        String dbPassword = "12345678";

        try {
            // Connect to the database
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUsername, dbPassword);

            // Remove items from cart after checkout
            String deleteSQL = "DELETE FROM cart WHERE product_id = ? AND user_id = ?";
            stmt = conn.prepareStatement(deleteSQL);

            String userId = request.getParameter("user_id");

            // Check for null or empty productIds and quantities
            if (productIds != null && quantities != null && productIds.length == quantities.length) {
                for (int i = 0; i < productIds.length; i++) {
                    stmt.setInt(1, Integer.parseInt(productIds[i]));
                    stmt.setInt(2, Integer.parseInt(userId));
                    stmt.executeUpdate();
                }
            } else {
                throw new SQLException("Invalid cart data.");
            }

            // After clearing cart, redirect to order confirmation page
            response.sendRedirect("OrderConfirmation.jsp");

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing checkout");
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
