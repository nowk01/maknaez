package com.maknaez.mapper;

import java.util.List;
import java.util.Map;
import com.maknaez.model.ProductDTO;
import com.maknaez.model.CategoryDTO;

public interface ProductMapper {
    
    public List<ProductDTO> listProduct(Map<String, Object> map); // 상품 리스트 조회
    public int dataCount(Map<String, Object> map); // 전체 상품 개수 조회
    public List<String> listCategoryNames(String categoryCode); // 사이드바 필터용 카테고리명 조회
    public List<String> listSaleCategoryNames(); // 세일 카태고리

    // (기존 관리자용 메소드 유지)
    public List<CategoryDTO> listCategory();
    public void insertCategory(CategoryDTO dto) throws Exception;
    public void updateCategory(CategoryDTO dto) throws Exception;
    public void deleteCategory(String cateCode) throws Exception;
}