package com.maknaez.model;

public class CartDTO {
    private long cartId;        // CART_ID (PK)
    private long memberIdx;     // MEMBERIDX (FK)
    private long prodId;        // PROD_ID (FK)
    private long optId;         // OPT_ID (FK, 사이즈 옵션 고유 번호)
    private int quantity;       // QUANTITY (수량)
    private String regDate;     // REG_DATE
    
    private String prodName;    // 상품명
    private int prodPrice;      // 상품 가격
    private String prodImg;     // 대표 이미지
    private String sizeValue;   // 

    // 기본 생성자
    public CartDTO() {}

    // Getters & Setters
    public long getCartId() { return cartId; }
    public void setCartId(long cartId) { this.cartId = cartId; }

    public long getMemberIdx() { return memberIdx; }
    public void setMemberIdx(long memberIdx) { this.memberIdx = memberIdx; }

    public long getProdId() { return prodId; }
    public void setProdId(long prodId) { this.prodId = prodId; }

    public long getOptId() { return optId; }
    public void setOptId(long optId) { this.optId = optId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getRegDate() { return regDate; }
    public void setRegDate(String regDate) { this.regDate = regDate; }

    public String getProdName() { return prodName; }
    public void setProdName(String prodName) { this.prodName = prodName; }

    public int getProdPrice() { return prodPrice; }
    public void setProdPrice(int prodPrice) { this.prodPrice = prodPrice; }

    public String getProdImg() { return prodImg; }
    public void setProdImg(String prodImg) { this.prodImg = prodImg; }

    public String getSizeValue() { return sizeValue; }
    public void setSizeValue(String sizeValue) { this.sizeValue = sizeValue; }
}