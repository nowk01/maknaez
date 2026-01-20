package com.maknaez.model;

import java.util.List;
import com.maknaez.util.MyMultipartFile;

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
    
    private MyMultipartFile thumbnailImg;      // 썸네일 업로드 결과 객체
    private List<MyMultipartFile> listFile;    // 추가 이미지들 업로드 결과 리스트
    
    private long optId;      // pd_size 테이블의 PK (시퀀스로 생성됨)
    private String pdSize;   // 리스트(sizes)에서 하나씩 꺼낸 단일 사이즈 값
    
    private List<ProductDTO> colorOptions;
    
    public List<ProductDTO> getColorOptions() { return colorOptions; }
    public void setColorOptions(List<ProductDTO> colorOptions) { this.colorOptions = colorOptions; }
    
    
    public long getOptId() {
		return optId;
	}


	public void setOptId(long optId) {
		this.optId = optId;
	}


	public String getPdSize() {
		return pdSize;
	}


	public void setPdSize(String pdSize) {
		this.pdSize = pdSize;
	}

	private List<String> sizes;
    private List<Integer> stocks;
    private String colorCode;
    
    public MyMultipartFile getThumbnailImg() {
		return thumbnailImg;
	}


	public void setThumbnailImg(MyMultipartFile thumbnailImg) {
		this.thumbnailImg = thumbnailImg;
	}


	public List<MyMultipartFile> getListFile() {
		return listFile;
	}


	public void setListFile(List<MyMultipartFile> listFile) {
		this.listFile = listFile;
	}


	public List<String> getSizes() {
		return sizes;
	}


	public void setSizes(List<String> sizes) {
		this.sizes = sizes;
	}


	public List<Integer> getStocks() {
		return stocks;
	}


	public void setStocks(List<Integer> stocks) {
		this.stocks = stocks;
	}


	public String getColorCode() {
		return colorCode;
	}


	public void setColorCode(String colorCode) {
		this.colorCode = colorCode;
	}


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
    

    // 
    private long opt_id;       // 사이즈 옵션 고유 번호
    private String size_name;  // 사이즈 명칭 (S, M, L 등)
    private int stock_count;   // stock_logs를 통해 계산된 실시간 재고량

    public long getOpt_id() { return opt_id; }
    public void setOpt_id(long opt_id) { this.opt_id = opt_id; }

    public String getSize_name() { return size_name; }
    public void setSize_name(String size_name) { this.size_name = size_name; }

    public int getStock_count() { return stock_count; }
    public void setStock_count(int stock_count) { this.stock_count = stock_count; }
    
    

	private int status;       // 삭제 여부 (1:활성, 0:삭제)
  
    public int getStatus() {
		return status;
	}


	public void setStatus(int status) {
		this.status = status;
	}
	
    private String prodSize;   // 사이즈 명칭 (220, 230 ...)
    private int stockQty;      // 재고 수량

    public String getProdSize() { return prodSize; }
    public void setProdSize(String prodSize) { this.prodSize = prodSize; }

    public int getStockQty() { return stockQty; }
    public void setStockQty(int stockQty) { this.stockQty = stockQty; }
    
    
    private long fileId;      // 이미지 고유 번호 (img_id)
    private String fileName;  // 이미지 파일명 (img)

	public long getFileId() {
		return fileId;
	}
	public void setFileId(long fileId) {
		this.fileId = fileId;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	
	private boolean liked;

	public boolean isLiked() {
	    return liked;
	}
	public void setLiked(boolean liked) {
	    this.liked = liked;
	}
}