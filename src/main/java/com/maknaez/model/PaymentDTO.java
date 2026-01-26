package com.maknaez.model;
/**
 * 테이블: PAYMENTS
 * 설명: 결제 정보를 담는 객체
 */
public class PaymentDTO {
    private long payId;   	     
    private String orderId;      
    private String payMethod;    
    private long payAmount;     
    private String pgTid; 		
    private String payStatus;    
    private String cardName;     
    private String cardNum;     

    public long getPayId() { return payId; }
    public void setPayId(long payId) { this.payId = payId; }
    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }
    public String getPayMethod() { return payMethod; }
    public void setPayMethod(String payMethod) { this.payMethod = payMethod; }
    public long getPayAmount() { return payAmount; }
    public void setPayAmount(long payAmount) { this.payAmount = payAmount; }
    public String getPgTid() { return pgTid; }
    public void setPgTid(String pgTid) { this.pgTid = pgTid; }
    public String getPayStatus() { return payStatus; }
    public void setPayStatus(String payStatus) { this.payStatus = payStatus; }
    public String getCardName() { return cardName; }
    public void setCardName(String cardName) { this.cardName = cardName; }
    public String getCardNum() { return cardNum; }
    public void setCardNum(String cardNum) { this.cardNum = cardNum; }

    @Override
    public String toString() {
    	return "PaymentDTO [payId=" + payId + ", orderId=" + orderId + ", payMethod=" + payMethod + ", payAmount="
  + payAmount + ", payStatus=" + payStatus + "]";
    }
}