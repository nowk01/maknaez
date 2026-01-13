package com.maknaez.model;

public class ProductDTO {
    // PRODUCTS 테이블 컬럼
    private long prodId;         // prod_id (PK)
    private String cateCode;     // cate_code (FK) -
    private String prodName;     // prod_name
    private String description;  // prod_desc (CLOB)
    private int price;           // base_price (정가)
    private int isDisplayed;     // is_displayed
    private String thumbnail;    // thumb_nail
    private String regDate;      // prod_date
    private String shippedDate;  // shipped_date

    // JOIN 데이터 (CATEGORY, DISCOUNTS)
    private String cateName;     // 카테고리명
    private String cateParent;   // 대분류 코드 (MEN, WOMEN...)
    private int depth;           // 카테고리 깊이
    private int discountRate;    // 할인율 (없으면 0)
    
    // 편의성 필드 (화면 표시용)
    private int originalPrice;   // 정가 (price와 동일, 표기용)
    private String techLine;     // 필터링용 태그 (DB컬럼 없으면 이름에서 추출)

    public ProductDTO() {
    	
    }


    public long getProdId() { return prodId; }
    public void setProdId(long prodId) { this.prodId = prodId; }

    public String getCateCode() { return cateCode; }
    public void setCateCode(String cateCode) { this.cateCode = cateCode; }

    public String getProdName() { return prodName; }
    public void setProdName(String prodName) { this.prodName = prodName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getPrice() { return price; }
    public void setPrice(int price) { this.price = price; }

    public int getIsDisplayed() { return isDisplayed; }
    public void setIsDisplayed(int isDisplayed) { this.isDisplayed = isDisplayed; }

    public String getThumbnail() { return thumbnail; }
    public void setThumbnail(String thumbnail) { this.thumbnail = thumbnail; }

    public String getRegDate() { return regDate; }
    public void setRegDate(String regDate) { this.regDate = regDate; }

    public String getShippedDate() { return shippedDate; }
    public void setShippedDate(String shippedDate) { this.shippedDate = shippedDate; }

    public String getCateName() { return cateName; }
    public void setCateName(String cateName) { this.cateName = cateName; }

    public String getCateParent() { return cateParent; }
    public void setCateParent(String cateParent) { this.cateParent = cateParent; }

    public int getDepth() { return depth; }
    public void setDepth(int depth) { this.depth = depth; }

    public int getDiscountRate() { return discountRate; }
    public void setDiscountRate(int discountRate) { this.discountRate = discountRate; }

    public int getOriginalPrice() { return originalPrice; }
    public void setOriginalPrice(int originalPrice) { this.originalPrice = originalPrice; }

    public String getTechLine() { return techLine; }
    public void setTechLine(String techLine) { this.techLine = techLine; }
    
    // 할인가 계산 로직 (JSP에서 사용 가능)
    public int getSalePrice() {
        if (discountRate > 0) {
            return price - (int)(price * (discountRate / 100.0));
        }
        return price;
    }
}