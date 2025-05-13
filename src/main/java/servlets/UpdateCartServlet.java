package servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;


public class UpdateCartServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve the user_id from the session
        Integer userId = (Integer) request.getSession().getAttribute("user_id");

        if (userId == null) {
            // If the user is not logged in, redirect to login
            response.sendRedirect("login.jsp");
            return;
        }

        String[] productIds = request.getParameterValues("product_id");
        String[] quantities = request.getParameterValues("quantity");
        double total = 0;

        if (productIds != null && quantities != null && productIds.length == quantities.length) {
            Connection conn = null;
            PreparedStatement stmt = null;

            try {
                String dbURL = "jdbc:mysql://localhost:3306/phone_shop";
                String dbUsername = "root";
                String dbPassword = "12345678";

                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUsername, dbPassword);

                // Update cart items in the database
                for (int i = 0; i < productIds.length; i++) {
                    int productId = Integer.parseInt(productIds[i]);
                    int quantity = Integer.parseInt(quantities[i]);

                    // Update the cart table with the new quantity
                    String sql = "UPDATE cart SET cart_quantity = ? WHERE product_id = ? AND user_id = ?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, quantity);
                    stmt.setInt(2, productId);
                    stmt.setInt(3, userId); // Use the userId from session
                    stmt.executeUpdate();

                    // Get updated subtotal for the product
                    String priceSql = "SELECT price FROM products WHERE id = ?";
                    PreparedStatement priceStmt = conn.prepareStatement(priceSql);
                    priceStmt.setInt(1, productId);
                    ResultSet rs = priceStmt.executeQuery();
                    if (rs.next()) {
                        double price = rs.getDouble("price");
                        total += price * quantity;
                    }
                }

                // Send the updated total back to the client
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true, \"total\": " + total + "}");
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false}");
            } finally {
                try {
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false}");
        }
    }
}