package com.maknaez.model;

public class OrderDTO {
    // DB 컬럼 매핑
    private String orderNum;      // 주문번호 (order_id)
    private long memberIdx;       // 회원번호
    private String orderDate;     // 주문일자
    private String orderState;    // 주문상태 (status)
    private String productName;   // 상품명 (prod_name)
    private String thumbNail;     // 썸네일
    private Integer totalAmount;  // 결제금액
    private Integer qty;          // 수량
    private Integer price;        // 단가
    private String pdSize;
    private String userName;
    private String tel;
    private String email;
    private String zip;
    private String addr1;
    private String addr2;

    public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getZip() {
		return zip;
	}
	public void setZip(String zip) {
		this.zip = zip;
	}
	public String getAddr1() {
		return addr1;
	}
	public void setAddr1(String addr1) {
		this.addr1 = addr1;
	}
	public String getAddr2() {
		return addr2;
	}
	public void setAddr2(String addr2) {
		this.addr2 = addr2;
	}
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
    
    public String getPdSize() { return pdSize; }
    public void setPdSize(String pdSize) { this.pdSize = pdSize; }
}