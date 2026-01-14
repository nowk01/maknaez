package com.maknaez.service;

import java.util.List;
import java.util.Map;

import com.maknaez.mapper.ProductMapper;
import com.maknaez.model.CategoryDTO;
import com.maknaez.model.ProductDTO;
import com.maknaez.mybatis.support.SqlSessionManager;

public class ProductServiceImpl implements ProductService {
    
    @Override
    public List<ProductDTO> listProduct(Map<String, Object> map) {
        List<ProductDTO> list = null;
        try {
            var sqlSession = SqlSessionManager.getSession();
            ProductMapper mapper = sqlSession.getMapper(ProductMapper.class);
            list = mapper.listProduct(map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int dataCount(Map<String, Object> map) {
        int result = 0;
        try {
            var sqlSession = SqlSessionManager.getSession();
            ProductMapper mapper = sqlSession.getMapper(ProductMapper.class);
            result = mapper.dataCount(map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

	@Override
	public List<CategoryDTO> listCategory() {
		List<CategoryDTO> list = null;
        try (var sqlSession = SqlSessionManager.getSession()) {
            ProductMapper mapper = sqlSession.getMapper(ProductMapper.class);
            list = mapper.listCategory();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
	}

	@Override
	public void insertCategory(CategoryDTO dto) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateCategory(CategoryDTO dto) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteCategory(String cateCode) throws Exception {
		// TODO Auto-generated method stub
		
	}
}