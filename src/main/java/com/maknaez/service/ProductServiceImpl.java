package com.maknaez.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.maknaez.mapper.ProductMapper;
import com.maknaez.model.CategoryDTO;
import com.maknaez.model.ProductDTO;
import com.maknaez.mybatis.support.MapperContainer;

public class ProductServiceImpl implements ProductService {
    
	private ProductMapper mapper = MapperContainer.get(ProductMapper.class);
	
    @Override
    public List<ProductDTO> listProduct(Map<String, Object> map) {
        List<ProductDTO> list = null;
        try {
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
            result = mapper.dataCount(map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }


    @Override
    public List<String> listCategoryNames(String categoryCode) {
        List<String> list = new ArrayList<>();
        try {
            list = mapper.listCategoryNames(categoryCode);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    
    // 관리자 사용
	@Override
	public List<CategoryDTO> listCategory() {
		List<CategoryDTO> list = null;
        try {
            list = mapper.listCategory();
            return list;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
	}

	@Override
	public void insertCategory(CategoryDTO dto) throws Exception {
		try {
			mapper.insertCategory(dto);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void updateCategory(CategoryDTO dto) throws Exception {
		try {
			mapper.updateCategory(dto);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void deleteCategory(String cateCode) throws Exception {
		try {
			mapper.deleteCategory(cateCode);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}