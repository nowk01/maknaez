package com.maknaez.service;

import java.util.List;
import java.util.Map;

import com.maknaez.model.CategoryDTO;
import com.maknaez.model.ProductDTO;

public interface ProductService {
    public List<ProductDTO> listProduct(Map<String, Object> map); // 상품목록 조회 
    public int dataCount(Map<String, Object> map); // 페이징 처리를 위해
    
    public List<CategoryDTO> listCategory();
    public void insertCategory(CategoryDTO dto) throws Exception;
    public void updateCategory(CategoryDTO dto) throws Exception;
    public void deleteCategory(String cateCode) throws Exception;
}