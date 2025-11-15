package com.sportsshop.model;

public class Product {
    private int maSP;
    private String tenSP;
    private String codeSP;
    private double gia;
    private String hinhAnh;
    private String moTa;
    private int maDanhMuc;
    private int soLuong;
    private int maKM;

    public int getMaKM() {
        return maKM;
    }

    public void setMaKM(int maKM) {
        this.maKM = maKM;
    }

    // === THÊM 2 FIELD MỚI CHO KHUYẾN MÃI ===
    private int phanTramGiam = 0;        // % giảm giá (0 = không khuyến mại)
    private double giaKhuyenMai = 0;     // Giá sau khi giảm (tính sẵn)

    // Getters and Setters
    public int getMaSP() { return maSP; }
    public void setMaSP(int maSP) { this.maSP = maSP; }
    public String getTenSP() { return tenSP; }
    public void setTenSP(String tenSP) { this.tenSP = tenSP; }
    public String getCodeSP() { return codeSP; }
    public void setCodeSP(String codeSP) { this.codeSP = codeSP; }
    public double getGia() { return gia; }
    public void setGia(double gia) { this.gia = gia; }
    public String getHinhAnh() { return hinhAnh; }
    public void setHinhAnh(String hinhAnh) { this.hinhAnh = hinhAnh; }
    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }
    public int getMaDanhMuc() { return maDanhMuc; }
    public void setMaDanhMuc(int maDanhMuc) { this.maDanhMuc = maDanhMuc; }
    public int getSoLuong() { return soLuong; }
    public void setSoLuong(int soLuong) { this.soLuong = soLuong; }

    // === GETTER & SETTER MỚI ===
    public int getPhanTramGiam() {
        return phanTramGiam;
    }
    public void setPhanTramGiam(int phanTramGiam) {
        this.phanTramGiam = phanTramGiam;
    }

    public double getGiaKhuyenMai() {
        return giaKhuyenMai;
    }
    public void setGiaKhuyenMai(double giaKhuyenMai) {
        this.giaKhuyenMai = giaKhuyenMai;
    }
}