package com.maknaez.model;

public class OrderItemDTO {
    private long item_id;      // 상세 ID (PK)
    private long order_id;     // 주문 ID (FK)
    private long prod_id;      // 상품 ID (FK)
    private int quantity;      // 수량
    private long price;        // 가격
    
    // [추가] 배송지 관련 정보
    private Long addressId;       // 배송지 번호 (기존 배송지 선택 시)
    private String receiverName;  // 수령인
    private String receiverTel;   // 연락처
    private String zipCode;       // 우편번호
    private String addr1;         // 기본주소
    private String addr2;         // 상세주소
    private String memo;          // 배송 메모

    // 조인용 상품 정보 (화면 표시용)
    private String prod_name;
    private String prod_image;

    // Getters and Setters
    public long getItem_id() { return item_id; }
    public void setItem_id(long item_id) { this.item_id = item_id; }
    
    public long getOrder_id() { return order_id; }
    public void setOrder_id(long order_id) { this.order_id = order_id; }
    
    public long getProd_id() { return prod_id; }
    public void setProd_id(long prod_id) { this.prod_id = prod_id; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public long getPrice() { return price; }
    public void setPrice(long price) { this.price = price; }
    
    public String getProd_name() { return prod_name; }
    public void setProd_name(String prod_name) { this.prod_name = prod_name; }
    
    public String getProd_image() { return prod_image; }
    public void setProd_image(String prod_image) { this.prod_image = prod_image; }

    // 배송지 정보 Getters/Setters
    public Long getAddressId() { return addressId; }
    public void setAddressId(Long addressId) { this.addressId = addressId; }
    
    public String getReceiverName() { return receiverName; }
    public void setReceiverName(String receiverName) { this.receiverName = receiverName; }
    
    public String getReceiverTel() { return receiverTel; }
    public void setReceiverTel(String receiverTel) { this.receiverTel = receiverTel; }
    
    public String getZipCode() { return zipCode; }
    public void setZipCode(String zipCode) { this.zipCode = zipCode; }
    
    public String getAddr1() { return addr1; }
    public void setAddr1(String addr1) { this.addr1 = addr1; }
    
    public String getAddr2() { return addr2; }
    public void setAddr2(String addr2) { this.addr2 = addr2; }
    
    public String getMemo() { return memo; }
    public void setMemo(String memo) { this.memo = memo; }
}