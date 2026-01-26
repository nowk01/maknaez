package com.maknaez.model;

public class CartDTO {
    private long cartId;        
    private long memberIdx;     
    private long prodId;     
    private long optId;         
    private int quantity;       
    private String regDate;     
    
    private String prodName;    
    private int prodPrice;      
    private String prodImg;    
    private String sizeValue;   

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