package com.maknaez.model;

public class ProductDTO {
	private long productNo;      // prod_id (PK)
    private int categoryNo;     // cate_code (FK)
    private String productName; // prod_name
    private int price;          // base_price
    private String content;     // prod_desc (CLOB)
    private int isDisplayed;    // is_displayed (1:진열, 0:진열안함)
    private String imageFile;   // thumb_nail
    private String regDate;     // prod_date
    private String shippedDate; // shipped_date
	
	public ProductDTO() {
		
	}
	
	public ProductDTO(long l, String string, String string2, int i, Object object, boolean b, int j) {
	}

	public long getProductNo() {
		return productNo;
	}

	public void setProductNo(long productNo) {
		this.productNo = productNo;
	}

	public int getCategoryNo() {
		return categoryNo;
	}

	public void setCategoryNo(int categoryNo) {
		this.categoryNo = categoryNo;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public int getIsDisplayed() {
		return isDisplayed;
	}

	public void setIsDisplayed(int isDisplayed) {
		this.isDisplayed = isDisplayed;
	}

	public String getImageFile() {
		return imageFile;
	}

	public void setImageFile(String imageFile) {
		this.imageFile = imageFile;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public String getShippedDate() {
		return shippedDate;
	}

	public void setShippedDate(String shippedDate) {
		this.shippedDate = shippedDate;
	}

	
	
}
