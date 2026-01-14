package com.maknaez.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.maknaez.model.CategoryDTO;
import com.maknaez.model.ProductDTO;

public interface ProductMapper {
    // ��ǰ ����Ʈ ��ȸ (ī�װ� ������ ���͸� �����ϵ��� Map ����)
    public List<ProductDTO> listProduct(Map<String, Object> map) throws SQLException;
    
    // ��ǰ ���� ��ȸ
    public int dataCount(Map<String, Object> map) throws SQLException;
    
    public List<CategoryDTO> listCategory() throws SQLException;
    public void insertCategory(CategoryDTO dto) throws SQLException;
    public void updateCategory(CategoryDTO dto) throws SQLException;
    public void deleteCategory(String cateCode) throws SQLException;
}