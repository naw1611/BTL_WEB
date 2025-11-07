package com.sportsshop.model;

public class User {
    private int maUser;
    private String fullName;
    private String username;
    private String email;
    private String soDienThoai;
    private String diaChi;
    private String role;

    // Getters and Setters
    public int getMaUser() { return maUser; }
    public void setMaUser(int maUser) { this.maUser = maUser; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getSoDienThoai() { return soDienThoai; }
    public void setSoDienThoai(String soDienThoai) { this.soDienThoai = soDienThoai; }
    public String getDiaChi() { return diaChi; }
    public void setDiaChi(String diaChi) { this.diaChi = diaChi; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
}