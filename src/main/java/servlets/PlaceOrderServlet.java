package servlets;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.*;

public class PlaceOrderServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Parse the JSON body
        StringBuilder stringBuilder = new StringBuilder();
        String line;
        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                stringBuilder.append(line);
            }
        }
        String orderDataJson = stringBuilder.toString();

        // Convert JSON data to a Map (use a JSON library like Gson or Jackson to parse)
        // For simplicity, assume the data is already parsed here
        Map<String, Object> orderData = parseJson(orderDataJson); // Assume a function that parses JSON into a map

        int userId = (int) orderData.get("user_id");
        String firstName = (String) orderData.get("shipping_first_name");
        String lastName = (String) orderData.get("shipping_last_name");
        String email = (String) orderData.get("email");
        String address = (String) orderData.get("shipping_address");
        List<Map<String, Object>> cartItems = (List<Map<String, Object>>) orderData.get("cart_items");

        // Save the order to the database
        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/your_database", "root", "password")) {
            // Insert into orders table
            String insertOrderSQL = "INSERT INTO orders (user_id, shipping_first_name, shipping_last_name, email, shipping_address, order_date) VALUES (?, ?, ?, ?, ?, NOW())";
            try (PreparedStatement stmt = conn.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, userId);
                stmt.setString(2, firstName);
                stmt.setString(3, lastName);
                stmt.setString(4, email);
                stmt.setString(5, address);
                stmt.executeUpdate();

                // Get the generated order ID
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    int orderId = rs.getInt(1);

                    // Insert each order item into the order_items table
                    String insertItemSQL = "INSERT INTO order_items (order_id, product_id, quantity) VALUES (?, ?, ?)";
                    try (PreparedStatement itemStmt = conn.prepareStatement(insertItemSQL)) {
                        for (Map<String, Object> item : cartItems) {
                            int productId = (int) item.get("productId");
                            int quantity = (int) item.get("quantity");

                            itemStmt.setInt(1, orderId);
                            itemStmt.setInt(2, productId);
                            itemStmt.setInt(3, quantity);
                            itemStmt.addBatch();
                        }
                        itemStmt.executeBatch();
                    }
                }

                // Send order confirmation email
                sendEmail(email, "Order Confirmation", "Thank you for your order!");

                // Respond to the client
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true, \"userEmail\": \"" + email + "\"}");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"An error occurred while processing the order.\"}");
        }
    }

    private void sendEmail(String to, String subject, String body) {
        try {
        
        	
            String from = "	tharushika1517@gmail.com";
            String password = "rsgw nsrj iohy bwxe";
            Properties properties = new Properties();
            properties.put("mail.smtp.host", "smtp.gmail.com");
            properties.put("mail.smtp.port", "587");
            properties.put("mail.smtp.auth", "true");
            properties.put("mail.smtp.starttls.enable", "true");

            Session session = Session.getInstance(properties, new jakarta.mail.Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(from, password);
                }
            });

            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
            message.setSubject(subject);
            message.setText(body);

            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    private Map<String, Object> parseJson(String json) {
        // Use a JSON parsing library like Gson or Jackson to parse the JSON string into a map
        return new HashMap<>();
    }
}
