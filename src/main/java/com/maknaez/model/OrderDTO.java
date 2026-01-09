package com.maknaez.model;

public class OrderDTO {
    // DB 컬럼 매핑
    private String orderNum;      // 주문번호 (order_id)
    private long memberIdx;       // 회원번호
    private String orderDate;     // 주문일자
    private String orderState;    // 주문상태 (status)
    private String productName;   // 상품명 (prod_name)
    private String thumbNail;     // 썸네일
    
    // [중요] 숫자형은 null 처리를 위해 Integer로 선언
    private Integer totalAmount;  // 결제금액
    private Integer qty;          // 수량
    private Integer price;        // 단가

    // Getter & Setter
    public String getOrderNum() { return orderNum; }
    public void setOrderNum(String orderNum) { this.orderNum = orderNum; }
    
    public long getMemberIdx() { return memberIdx; }
    public void setMemberIdx(long memberIdx) { this.memberIdx = memberIdx; }
    
    public String getOrderDate() { return orderDate; }
    public void setOrderDate(String orderDate) { this.orderDate = orderDate; }
    
    public String getOrderState() { return orderState; }
    public void setOrderState(String orderState) { this.orderState = orderState; }
    
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    
    public String getThumbNail() { return thumbNail; }
    public void setThumbNail(String thumbNail) { this.thumbNail = thumbNail; }
    
    public Integer getTotalAmount() { return totalAmount; }
    public void setTotalAmount(Integer totalAmount) { this.totalAmount = totalAmount; }
    
    public Integer getQty() { return qty; }
    public void setQty(Integer qty) { this.qty = qty; }
    
    public Integer getPrice() { return price; }
    public void setPrice(Integer price) { this.price = price; }
}