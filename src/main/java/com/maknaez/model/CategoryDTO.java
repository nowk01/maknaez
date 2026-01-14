package com.maknaez.model;

/**
 * 테이블명: CATEGORY
 * 설명: 상품 카테고리 정보 (대분류, 중분류 계층 구조)
 */
public class CategoryDTO {
    private String cateCode;   // 카테고리 고유 코드 (예: MEN, MEN_TRAIL)
    private String cateName;   // 카테고리 표시 이름 (예: 남성, 트레일러닝)
    private String cateParent; // 상위 카테고리 코드 (대분류는 null)
    private int depth;         // 계층 깊이 (1:대분류, 2:중분류 .. )
    private int status;        // 1: 노출, 0: 숨김
    private int orderNo;       // 정렬 순서

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

    // 항상 toString을 제정의할것 > this. 디버깅용도 
    @Override
    public String toString() {
        return "CategoryDTO [cateCode=" + cateCode + ", cateName=" + cateName + ", cateParent=" + cateParent + ", depth="
                + depth + "]";
    }
}