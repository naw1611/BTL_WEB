/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Connection;

import org.mindrot.jbcrypt.BCrypt;

public class HashPassword {
    public static void main(String[] args) {
        String password = "admin@123";
        String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
        
        System.out.println("Password gốc: " + password);
        System.out.println("Hash BCrypt: " + hashed);
    }
}
