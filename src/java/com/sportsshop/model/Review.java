package com.sportsshop.model;

import java.sql.Timestamp;

public class Review {
    private int maReview;
    private int maSP;
    private int maUser;
    private int soSao;
    private String noiDung;
    private String fullName;
    private Timestamp ngayDanhGia;
    
    // ✅ THÊM MỚI
    private String adminReply;
    private Timestamp adminReplyDate;
    
    // Getters & Setters
    public int getMaReview() { return maReview; }
    public void setMaReview(int maReview) { this.maReview = maReview; }
    
    public int getMaSP() { return maSP; }
    public void setMaSP(int maSP) { this.maSP = maSP; }
    
    public int getMaUser() { return maUser; }
    public void setMaUser(int maUser) { this.maUser = maUser; }
    
    public int getSoSao() { return soSao; }
    public void setSoSao(int soSao) { this.soSao = soSao; }
    
    public String getNoiDung() { return noiDung; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }
    
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    
    public Timestamp getNgayDanhGia() { return ngayDanhGia; }
    public void setNgayDanhGia(Timestamp ngayDanhGia) { this.ngayDanhGia = ngayDanhGia; }
    
    // ✅ THÊM GETTERS/SETTERS
    public String getAdminReply() { return adminReply; }
    public void setAdminReply(String adminReply) { this.adminReply = adminReply; }
    
    public Timestamp getAdminReplyDate() { return adminReplyDate; }
    public void setAdminReplyDate(Timestamp adminReplyDate) { this.adminReplyDate = adminReplyDate; }
}