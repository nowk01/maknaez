package com.maknaez.model;

public class PointDTO {
    private long pm_id;     
    private long memberIdx;   
    private String order_id;   
    private String reason;    
    private int point_amount;  
    private int rem_point;      
    private String reg_date;    

    public long getPm_id() { return pm_id; }
    public void setPm_id(long pm_id) { this.pm_id = pm_id; }
    public long getMemberIdx() { return memberIdx; }
    public void setMemberIdx(long memberIdx) { this.memberIdx = memberIdx; }
    public String getOrder_id() { return order_id; }
    public void setOrder_id(String order_id) { this.order_id = order_id; }
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
    public int getPoint_amount() { return point_amount; }
    public void setPoint_amount(int point_amount) { this.point_amount = point_amount; }
    public int getRem_point() { return rem_point; }
    public void setRem_point(int rem_point) { this.rem_point = rem_point; }
    public String getReg_date() { return reg_date; }
    public void setReg_date(String reg_date) { this.reg_date = reg_date; }
}