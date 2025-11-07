/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Connection;
import java.sql.*;
public class TestDB {
    public static void main(String[] args) {
        Connection conn = DatabaseConnection.getConnection();
        if (conn != null) {
            try {
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM SanPham LIMIT 5");
                while (rs.next()) {
                    System.out.println(rs.getString("TenSP") + " - " + rs.getDouble("Gia"));
                }
            } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
