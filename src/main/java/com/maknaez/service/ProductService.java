package com.maknaez.service;

import java.util.List;
import java.util.Map;
import com.maknaez.model.CategoryDTO;
import com.maknaez.model.ProductDTO;

public interface ProductService {
    
    public List<ProductDTO> listProduct(Map<String, Object> map); // 상품 목록 조회
    public int dataCount(Map<String, Object> map); // 상품 개수 조회(페이징을 위햐)
    public List<String> listCategoryNames(String categoryCode); // 사이드바 필터용 카테고리 이름 목록 조회
    public List<String> listSaleCategoryNames(); // 세일 카태고리
    public ProductDTO readProduct(long prodId); // 제품 조회 detail
    
    // (기존 관리자용 메소드 유지)
    public List<CategoryDTO> listCategory();
    public void insertCategory(CategoryDTO dto) throws Exception;
    public void updateCategory(CategoryDTO dto) throws Exception;
    public void deleteCategory(String cateCode) throws Exception;
}