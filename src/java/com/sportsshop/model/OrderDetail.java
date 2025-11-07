package com.sportsshop.model;

public class OrderDetail {
    private int maChiTiet;
    private int maDon;
    private Product product;
    private int soLuong;
    private double donGia;

    // Getters and Setters
    public int getMaChiTiet() { return maChiTiet; }
    public void setMaChiTiet(int maChiTiet) { this.maChiTiet = maChiTiet; }
    public int getMaDon() { return maDon; }
    public void setMaDon(int maDon) { this.maDon = maDon; }
    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
    public int getSoLuong() { return soLuong; }
    public void setSoLuong(int soLuong) { this.soLuong = soLuong; }
    public double getDonGia() { return donGia; }
    public void setDonGia(double donGia) { this.donGia = donGia; }
}