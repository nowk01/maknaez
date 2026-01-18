package com.maknaez.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.maknaez.model.CategoryDTO;
import com.maknaez.model.ProductDTO;

public interface ProductMapper {
    
    public List<ProductDTO> listProduct(Map<String, Object> map); // 상품 리스트 조회
    public int dataCount(Map<String, Object> map); // 전체 상품 개수 조회
    public List<String> listCategoryNames(String categoryCode); // 사이드바 필터용 카테고리명 조회
    public List<String> listSaleCategoryNames(); // 세일 카태고리
    public ProductDTO readProduct(long prodId); // 제품 조회 detail
    public List<ProductDTO> listProductColors(String baseName) throws SQLException; // 색상 변형 상품 리스트 조회

    // (기존 관리자용 메소드 유지)
    public List<CategoryDTO> listCategory();
    public void insertCategory(CategoryDTO dto) throws Exception;
    public void updateCategory(CategoryDTO dto) throws Exception;
    public void deleteCategory(String cateCode) throws Exception;
    
    public void insertProduct(ProductDTO dto) throws Exception;
    public void insertPdSize(ProductDTO dto) throws Exception;
    public void insertProductImg(Map<String, Object> map) throws Exception;
    public void insertStockLog(Map<String, Object> map) throws Exception;
    public List<CategoryDTO> listCategorySelect();
    
    public int countProductManage(Map<String, Object> map);
    public List<ProductDTO> listProductManage(Map<String, Object> map);
    public List<ProductDTO> listProductImg(long prodId);
    public List<CategoryDTO> listCategoryAll();
    public void deleteProduct(long prodId) throws Exception;
    public void deleteProductImg(long imgId) throws Exception;
    
    public List<ProductDTO> listStock(Map<String, Object> map); // 재고 현황 목록 조회
    public int dataCountStock(Map<String, Object> map); // 재고 목록 개수 (페이징용)
    public Integer getLastStock(long optId);
    public void insertStockUpdateLog(Map<String, Object> map) throws Exception; 
    
    ProductDTO findById(long prod_id); // 상품 상세 정보 조회
    List<ProductDTO> listProductSize(long prod_id); // 상품별 사이즈 및 실시간 재고 리스트 조회
    void insertCart(Map<String, Object> map); // 장바구니 담기
    public List<ProductDTO> listProductSizes(long prodId);  // 상품별 사이즈 및 합산 재고 리스트 조회
    public Integer getOptionStock(long optId); // 특정 옵션의 현재 실시간 재고량 조회
    
    public void updateProduct(ProductDTO dto) throws Exception;
    
    public List<ProductDTO> listProductByIds(List<String> ids);
    
    public ProductDTO getOptionInfoForAlarm(long optId); // 입고알람용
    public List<String> listWishListUserEmails(long prodId); // 입고알람용
    
    
    
}