package com.maknaez.model;

public class OrderItemDTO {
    private long item_id;      // ITEM_ID (PK)
    private String order_id;   // ORDER_ID (FK)
    private long opt_id;       // OPT_ID (FK) - PD_SIZE 테이블 참조
    private int count;         // COUNT (수량)
    private long price;        // PRICE (가격)

    private long prod_id;      // 상품 ID
    private String prod_name;  // 상품명
    private String prod_image; // 상품 이미지
    private String option_value; // 옵션 값 (예: 사이즈, 색상 등)

    private Long delivery_number;    // 배송 번호
    private String receiver_name;    // 수령인
    private String receiver_tel;     // 연락처
    private String zip_code;         // 우편번호
    private String addr1;            // 기본주소
    private String addr2;            // 상세주소
    private String memo;             // 배송 메모
    private String delivery_status;  // 배송 상태 (STATUS)
    private String tracking_no;      // 운송장 번호
    private String delivery_company; // 택배사

    // Getters and Setters
    public long getItem_id() { return item_id; }
    public void setItem_id(long item_id) { this.item_id = item_id; }

    public String getOrder_id() { return order_id; }
    public void setOrder_id(String order_id) { this.order_id = order_id; }

    public long getOpt_id() { return opt_id; }
    public void setOpt_id(long opt_id) { this.opt_id = opt_id; }

    public int getCount() { return count; }
    public void setCount(int count) { this.count = count; }

    public long getPrice() { return price; }
    public void setPrice(long price) { this.price = price; }

    // Join Data Getters/Setters
    public long getProd_id() { return prod_id; }
    public void setProd_id(long prod_id) { this.prod_id = prod_id; }

    public String getProd_name() { return prod_name; }
    public void setProd_name(String prod_name) { this.prod_name = prod_name; }

    public String getProd_image() { return prod_image; }
    public void setProd_image(String prod_image) { this.prod_image = prod_image; }

    public String getOption_value() { return option_value; }
    public void setOption_value(String option_value) { this.option_value = option_value; }

    // Shipment Data Getters/Setters
    public Long getDelivery_number() { return delivery_number; }
    public void setDelivery_number(Long delivery_number) { this.delivery_number = delivery_number; }

    public String getReceiver_name() { return receiver_name; }
    public void setReceiver_name(String receiver_name) { this.receiver_name = receiver_name; }

    public String getReceiver_tel() { return receiver_tel; }
    public void setReceiver_tel(String receiver_tel) { this.receiver_tel = receiver_tel; }

    public String getZip_code() { return zip_code; }
    public void setZip_code(String zip_code) { this.zip_code = zip_code; }

    public String getAddr1() { return addr1; }
    public void setAddr1(String addr1) { this.addr1 = addr1; }

    public String getAddr2() { return addr2; }
    public void setAddr2(String addr2) { this.addr2 = addr2; }

    public String getMemo() { return memo; }
    public void setMemo(String memo) { this.memo = memo; }

    public String getDelivery_status() { return delivery_status; }
    public void setDelivery_status(String delivery_status) { this.delivery_status = delivery_status; }

    public String getTracking_no() { return tracking_no; }
    public void setTracking_no(String tracking_no) { this.tracking_no = tracking_no; }

    public String getDelivery_company() { return delivery_company; }
    public void setDelivery_company(String delivery_company) { this.delivery_company = delivery_company; }
}