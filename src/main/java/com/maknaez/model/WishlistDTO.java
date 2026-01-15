package com.maknaez.model;

public class WishlistDTO {
    // 1. wishlist 테이블 데이터
    private long wishId;      // 찜 고유 번호 (삭제할 때 필요: WHERE wish_id = ?)
    private long memberIdx;   // 회원 번호
    private long prodId;      // 상품 번호 (상품 페이지로 이동할 때 필요)
    
    // 2. products 테이블 데이터 (화면 출력용)
    private String prodName;  // 상품 이름
    private int price;        // 가격
    private String thumbnail; // 썸네일 이미지

    // Getter & Setter
    public long getWishId() { return wishId; }
    public void setWishId(long wishId) { this.wishId = wishId; }
    public long getMemberIdx() { return memberIdx; }
    public void setMemberIdx(long memberIdx) { this.memberIdx = memberIdx; }
    public long getProdId() { return prodId; }
    public void setProdId(long prodId) { this.prodId = prodId; }
    
    public String getProdName() { return prodName; }
    public void setProdName(String prodName) { this.prodName = prodName; }
    public int getPrice() { return price; }
    public void setPrice(int price) { this.price = price; }
    public String getThumbnail() { return thumbnail; }
    public void setThumbnail(String thumbnail) { this.thumbnail = thumbnail; }
}