package servlets;

import java.io.IOException;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.mysql.jdbc.Connection;
import com.mysql.jdbc.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


public class RemoveItemServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve product_id from the request parameter
        String productIdStr = request.getParameter("product_id");
        int productId = Integer.parseInt(productIdStr);

        // Calculate the new total after removing the item
        double total = removeItemFromCart(productId); // Remove the item and calculate the new total

        // Send the updated total as plain text
        response.setContentType("text/plain");
        response.getWriter().write("total=" + total);
    }

    private double removeItemFromCart(int productId) {
        // This method should remove the product from the user's cart and return the updated total price for the cart

        double total = 0;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        String dbURL = "jdbc:mysql://localhost:3306/phone_shop";
        String dbUsername = "root";
        String dbPassword = "12345678";

        try {
            // Connect to the database
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = (Connection) DriverManager.getConnection(dbURL, dbUsername, dbPassword);

            // SQL query to delete the item from the cart
            String deleteSql = "DELETE FROM cart WHERE product_id = ?";
            stmt = (PreparedStatement) conn.prepareStatement(deleteSql);
            stmt.setInt(1, productId);
            stmt.executeUpdate();

            // Calculate the new total for the cart after removal
            String totalSql = "SELECT SUM(p.price * c.quantity) AS total FROM cart c " +
                              "JOIN products p ON c.product_id = p.id";
            stmt = (PreparedStatement) conn.prepareStatement(totalSql);
            rs = stmt.executeQuery();

            if (rs.next()) {
                total = rs.getDouble("total");
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return total;
    }
}
