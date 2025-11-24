package com.sportsshop.model;

import java.util.Date;

public class Order {
    private int maDon;
    private int maUser;
    private User user;
    private Date ngayDat;
    private double tongTien;
    private String diaChiGiao;
    private String trangThai;
    private String sdt;
    private String tenNguoiNhan;
    
    // ⭐ THÊM 2 THUỘC TÍNH NÀY
    private String phuongThucThanhToan;
    private String anhChuyenKhoan;
    
    // Getters and Setters cũ (giữ nguyên)
    public int getMaDon() { return maDon; }
    public void setMaDon(int maDon) { this.maDon = maDon; }
    
    public int getMaUser() { return maUser; }
    public void setMaUser(int maUser) { this.maUser = maUser; }
    
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    
    public Date getNgayDat() { return ngayDat; }
    public void setNgayDat(Date ngayDat) { this.ngayDat = ngayDat; }
    
    public double getTongTien() { return tongTien; }
    public void setTongTien(double tongTien) { this.tongTien = tongTien; }
    
    public String getDiaChiGiao() { return diaChiGiao; }
    public void setDiaChiGiao(String diaChiGiao) { this.diaChiGiao = diaChiGiao; }
    
    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }
    
    public String getSdt() { return sdt; }
    public void setSdt(String sdt) { this.sdt = sdt; }
    
    public String getTenNguoiNhan() { return tenNguoiNhan; }
    public void setTenNguoiNhan(String tenNguoiNhan) { this.tenNguoiNhan = tenNguoiNhan; }
    
    public String getEmail() {
        return user != null ? user.getEmail() : "";
    }
    
    // ⭐ THÊM GETTER/SETTER CHO 2 THUỘC TÍNH MỚI
    public String getPhuongThucThanhToan() {
        return phuongThucThanhToan;
    }
    
    public void setPhuongThucThanhToan(String phuongThucThanhToan) {
        this.phuongThucThanhToan = phuongThucThanhToan;
    }
    
    public String getAnhChuyenKhoan() {
        return anhChuyenKhoan;
    }
    
    public void setAnhChuyenKhoan(String anhChuyenKhoan) {
        this.anhChuyenKhoan = anhChuyenKhoan;
    }
}