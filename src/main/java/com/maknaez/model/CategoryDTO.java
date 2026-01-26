package com.maknaez.model;

/**
 * 테이블명: CATEGORY
 * 설명: 상품 카테고리 정보 (대분류, 중분류 계층 구조)
 */
public class CategoryDTO {
    private String cateCode;   
    private String cateName;   
    private String cateParent; 
    private int depth;        
    private int status;        // 1: 노출, 0: 숨김
    private int orderNo;       
    private String originCateCode;

    public String getOriginCateCode() {
		return originCateCode;
	}

	public void setOriginCateCode(String originCateCode) {
		this.originCateCode = originCateCode;
	}

	public CategoryDTO() {
    }

    public CategoryDTO(String cateCode, String cateName, String cateParent, int depth) {
        this.cateCode = cateCode;
        this.cateName = cateName;
        this.cateParent = cateParent;
        this.depth = depth;
    }

    public String getCateCode() {
        return cateCode;
    }

    public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public int getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(int orderNo) {
		this.orderNo = orderNo;
	}

	public void setCateCode(String cateCode) {
        this.cateCode = cateCode;
    }

    public String getCateName() {
        return cateName;
    }

    public void setCateName(String cateName) {
        this.cateName = cateName;
    }

    public String getCateParent() {
        return cateParent;
    }

    public void setCateParent(String cateParent) {
        this.cateParent = cateParent;
    }

    public int getDepth() {
        return depth;
    }

    public void setDepth(int depth) {
        this.depth = depth;
    }

    @Override
    public String toString() {
        return "CategoryDTO [cateCode=" + cateCode + ", cateName=" + cateName + ", cateParent=" + cateParent + ", depth="
                + depth + "]";
    }
}