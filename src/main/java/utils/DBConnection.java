package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // Database URL, username, and password
    private static final String DB_URL = "jdbc:mysql://localhost:3306/phone_shop";  // Change with your DB URL
    private static final String USER = "root";                                      // Change with your DB username
    private static final String PASSWORD = "12345678";                              // Change with your DB password

    // Method to establish and return the database connection
    public static Connection getConnection() throws SQLException {
        try {
            // Load the MySQL JDBC driver (you may not need this in newer versions of JDBC)
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Create and return a connection
            return DriverManager.getConnection(DB_URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC driver not found.", e);
        }
    }
}
