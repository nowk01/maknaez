package com.maknaez.model;
/**
 * 테이블: PAYMENTS
 * 설명: 결제 정보를 담는 객체
 */
public class PaymentDTO {
    private long payId;   	     // PAY_ID (PK)
    private String orderId;      // ORDER_ID (FK -> ORDERS.ITEMS_ID)
    private String payMethod;    // PAY_METHOD (카드, 무통장 등)
    private long payAmount;      // PAY_AMOUNT (결제 금액)
    private String pgTid; 		 // PG_TID (PG사 거래 번호, 테스트용 임의값)
    private String payStatus;    // PAY_STATUS (결제완료, 취소 등)
    private String cardName;     // CARD_NAME
    private String cardNum;      // CARD_NUM

    public PaymentDTO() {}

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