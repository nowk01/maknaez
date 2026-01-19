package com.maknaez.model;

public class ReviewDTO {
    private long reviewId;
    private long prodId;
    private long memberIdx;
    private String content;
    private int starRating;
    private String reviewImg;
    private String optionValue;
    private String regDate;
    private String writerId;
    private String writerName;
    private String orderNum;
    
    private String productName;
    private String thumbNail;

    public ReviewDTO() {}

    public long getReviewId() { return reviewId; }
    public void setReviewId(long reviewId) { this.reviewId = reviewId; }

    public long getProdId() { return prodId; }
    public void setProdId(long prodId) { this.prodId = prodId; }

    public long getMemberIdx() { return memberIdx; }
    public void setMemberIdx(long memberIdx) { this.memberIdx = memberIdx; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public int getStarRating() { return starRating; }
    public void setStarRating(int starRating) { this.starRating = starRating; }

    public String getReviewImg() { return reviewImg; }
    public void setReviewImg(String reviewImg) { this.reviewImg = reviewImg; }
   
    public String getOptionValue() { return optionValue; }
    public void setOptionValue(String optionValue) { this.optionValue = optionValue; }

    public String getRegDate() { return regDate; }
    public void setRegDate(String regDate) { this.regDate = regDate; }

    public String getWriterId() { return writerId; }
    public void setWriterId(String writerId) { this.writerId = writerId; }

    public String getWriterName() { return writerName; }
    public void setWriterName(String writerName) { this.writerName = writerName; }
    
    public String getOrderNum() { return orderNum; }
    public void setOrderNum(String orderNum) { this.orderNum = orderNum; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getThumbNail() { return thumbNail; }
    public void setThumbNail(String thumbNail) { this.thumbNail = thumbNail; }
    
    private int enabled;
    public int getEnabled() { return enabled; }
    public void setEnabled(int enabled) { this.enabled = enabled; }
}