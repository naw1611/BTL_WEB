package com.sportsshop.model;

public class CartItem {
    private int maCart;
    private int maUser;
    private Product product;
    private int soLuong;

    // Getters and Setters
    public int getMaCart() { return maCart; }
    public void setMaCart(int maCart) { this.maCart = maCart; }
    public int getMaUser() { return maUser; }
    public void setMaUser(int maUser) { this.maUser = maUser; }
    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
    public int getSoLuong() { return soLuong; }
    public void setSoLuong(int soLuong) { this.soLuong = soLuong; }
}