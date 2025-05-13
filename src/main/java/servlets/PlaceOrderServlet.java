package servlets;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import utils.DBConnection;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.*;

public class PlaceOrderServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("user_id");
        String firstName = request.getParameter("shipping_first_name");
        String lastName = request.getParameter("shipping_last_name");
        String email = request.getParameter("email");
        String address = request.getParameter("shipping_address");
        String paymentMethod = request.getParameter("payment_method");

        // Validate inputs to avoid null pointer exceptions
        if (firstName == null || firstName.trim().isEmpty()) {
            response.getWriter().write("First name is required.");
            return;
        }
        if (lastName == null || lastName.trim().isEmpty()) {
            response.getWriter().write("Last name is required.");
            return;
        }
        if (email == null || email.trim().isEmpty()) {
            response.getWriter().write("Email is required.");
            return;
        }
        if (address == null || address.trim().isEmpty()) {
            response.getWriter().write("Shipping address is required.");
            return;
        }

        // Fetch cart data from request parameters (cart data passed as a hidden field)
        String cartData = request.getParameter("cart"); // Expecting a JSON string of cart items
        if (cartData == null || cartData.isEmpty()) {
            response.getWriter().write("Cart data is missing.");
            return;
        }

        // Parse the cart JSON into a list of items
        List<Map<String, Object>> cartItems = parseCartData(cartData);

        // Calculate total price
        double totalPrice = calculateTotal(cartItems);

        // Start a database connection
        Connection conn = null;
        PreparedStatement stmt = null, itemStmt = null;
        ResultSet rs = null;
        int orderId = 0; // To store the generated order ID

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start a transaction

            // Insert the order into the 'orders' table
            String insertOrderQuery = "INSERT INTO orders (user_id, order_status, total, order_date) VALUES (?, ?, ?, NOW())";
            stmt = conn.prepareStatement(insertOrderQuery, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, userId);
            stmt.setString(2, "Pending"); // Initial order status
            stmt.setDouble(3, totalPrice);
            stmt.executeUpdate();

            // Retrieve the generated order ID
            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                orderId = rs.getInt(1); // Get the auto-generated order ID
            }

            // Insert the items into the 'order_items' table
            String insertOrderItemQuery = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
            itemStmt = conn.prepareStatement(insertOrderItemQuery);

            for (Map<String, Object> item : cartItems) {
                Integer productId = (Integer) item.get("productId");
                Integer quantity = (Integer) item.get("quantity");
                Object priceObj = item.get("productPrice");
                Double price = null;

                if (priceObj instanceof Integer) {
                    price = ((Integer) priceObj).doubleValue();
                } else if (priceObj instanceof Double) {
                    price = (Double) priceObj;
                }

                // Null check for price and quantity
                if (price == null || quantity == null) {
                    continue; // Skip items with null price or quantity
                }

                itemStmt.setInt(1, orderId);
                itemStmt.setInt(2, productId);
                itemStmt.setInt(3, quantity);
                itemStmt.setDouble(4, price);
                itemStmt.addBatch(); // Add to batch for efficiency
            }

            itemStmt.executeBatch(); // Execute all insert statements

            conn.commit(); // Commit the transaction

            response.getWriter().write("Order placed successfully. Order ID: " + orderId);

        } catch (SQLException e) {
            try {
                if (conn != null) {
                    conn.rollback(); // Rollback transaction if there's an error
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            response.getWriter().write("Error occurred while placing the order.");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (itemStmt != null) itemStmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Helper method to calculate the total price from the cart items
    private double calculateTotal(List<Map<String, Object>> cartItems) {
        double total = 0.0;
        for (Map<String, Object> item : cartItems) {
            Object priceObj = item.get("productPrice");
            Object quantityObj = item.get("quantity");
            Double price = null;
            Integer quantity = null;

            if (priceObj instanceof Integer) {
                price = ((Integer) priceObj).doubleValue();
            } else if (priceObj instanceof Double) {
                price = (Double) priceObj;
            }

            if (quantityObj instanceof Integer) {
                quantity = (Integer) quantityObj;
            } else if (quantityObj instanceof Double) {
                quantity = ((Double) quantityObj).intValue();
            }

            if (price != null && quantity != null) {
                total += price * quantity;
            }
        }
        return total;
    }

    // Helper method to parse cart data from JSON
    private List<Map<String, Object>> parseCartData(String cartData) {
        ObjectMapper objectMapper = new ObjectMapper();
        List<Map<String, Object>> cartItems = new ArrayList<>();
        try {
            cartItems = objectMapper.readValue(cartData, List.class);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return cartItems;
    }
}