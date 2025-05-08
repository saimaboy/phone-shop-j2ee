package servlets;

import utils.DBConnection;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.util.ArrayList;
import java.util.List;

public class AdminDashboardServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();

            // Get total users
            rs = stmt.executeQuery("SELECT COUNT(*) AS total_users FROM users");
            if (rs.next()) {
                request.setAttribute("totalUsers", rs.getInt("total_users"));
            }

            // Get total products
            rs = stmt.executeQuery("SELECT COUNT(*) AS total_products FROM products");
            if (rs.next()) {
                request.setAttribute("totalProducts", rs.getInt("total_products"));
            }

            // Get total categories
            rs = stmt.executeQuery("SELECT COUNT(DISTINCT category) AS total_categories FROM products");
            if (rs.next()) {
                request.setAttribute("totalCategories", rs.getInt("total_categories"));
            }

            // Get all users for the 'Manage Users' table
            List<User> users = new ArrayList<>();
            rs = stmt.executeQuery("SELECT user_id, user_name, user_email, user_type FROM users");
            while (rs.next()) {
                User user = new User(rs.getInt("user_id"), rs.getString("user_name"), rs.getString("user_email"), rs.getString("user_type"));
                users.add(user);
            }
            request.setAttribute("users", users);

            // Get all products for the 'Manage Products' table
            List<Product> products = new ArrayList<>();
            rs = stmt.executeQuery("SELECT id, product_name, price, stock_quantity FROM products");
            while (rs.next()) {
                Product product = new Product(rs.getInt("id"), rs.getString("product_name"), rs.getBigDecimal("price"), rs.getInt("stock_quantity"));
                products.add(product);
            }
            request.setAttribute("products", products);

            // Get all orders for the 'Manage Orders' table
            List<Order> orders = new ArrayList<>();
            rs = stmt.executeQuery("SELECT order_id, user_id, order_date, order_status FROM orders");
            while (rs.next()) {
                Order order = new Order(rs.getInt("order_id"), rs.getInt("user_id"), rs.getTimestamp("order_date"), rs.getString("order_status"));
                orders.add(order);
            }
            request.setAttribute("orders", orders);

            // Forward to JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("admin_dashboard.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException e) {
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
    }

    // Model classes to hold user, product, and order data
    class User {
        int id;
        String name;
        String email;
        String role;

        User(int id, String name, String email, String role) {
            this.id = id;
            this.name = name;
            this.email = email;
            this.role = role;
        }

		public void setUserName(int i) {
			// TODO Auto-generated method stub
			
		}
    }

    class Product {
        int id;
        String name;
        BigDecimal price;
        int stock;

        Product(int id, String name, BigDecimal price, int stock) {
            this.id = id;
            this.name = name;
            this.price = price;
            this.stock = stock;
        }
    }

    class Order {
        int id;
        int userId;
        Timestamp date;
        String status;

        Order(int id, int userId, Timestamp date, String status) {
            this.id = id;
            this.userId = userId;
            this.date = date;
            this.status = status;
        }
    }
}
