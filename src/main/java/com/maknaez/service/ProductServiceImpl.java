package com.maknaez.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.maknaez.mapper.ProductMapper;
import com.maknaez.model.CategoryDTO;
import com.maknaez.model.ProductDTO;
import com.maknaez.mybatis.support.MapperContainer;
import com.maknaez.util.MyMultipartFile;

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
    
    @Override
    public List<String> listSaleCategoryNames() {
        List<String> list = new ArrayList<>();
        try {
            list = mapper.listSaleCategoryNames();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    @Override
    public ProductDTO readProduct(long prodId) {
        ProductDTO dto = null;
        try  {
            dto = mapper.readProduct(prodId);
        } catch (Exception e) { e.printStackTrace(); }
        return dto;
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

	@Override
    public void insertProduct(ProductDTO dto) throws Exception { // pathname 파라미터 제거됨
        try {
            // 1. 썸네일 파일명 추출 및 DB 세팅
            // GuestServiceImpl 처럼 DTO에 있는 파일 객체 확인
            if (dto.getThumbnailImg() != null) {
                // 저장된 파일명을 꺼내서 DB 컬럼용 필드에 세팅
                String saveFilename = dto.getThumbnailImg().getSaveFilename();
                dto.setThumbnail(saveFilename); 
            }

            // 2. 상품 정보 DB 저장 (먼저 실행하여 prodId 생성)
            mapper.insertProduct(dto);
            long prodId = dto.getProdId();

            // 3. 추가 이미지 파일명 추출 및 DB 저장
            // GuestServiceImpl의 listFile 처리 방식과 동일
            List<MyMultipartFile> listFile = dto.getListFile();
            if (listFile != null && !listFile.isEmpty()) {
                for (MyMultipartFile mf : listFile) {
                    // 저장된 파일명만 꺼내옴 (이미지 이름이 중요!)
                    String saveImg = mf.getSaveFilename();
                    
                    Map<String, Object> imgMap = new HashMap<>();
                    imgMap.put("prodId", prodId);
                    imgMap.put("filename", saveImg);
                    
                    mapper.insertProductImg(imgMap);
                }
            }

            // 4. 옵션(사이즈) 및 재고 저장 (기존 로직 유지)
            List<String> sizes = dto.getSizes();
            List<Integer> stocks = dto.getStocks();

            if (sizes != null && stocks != null) {
                for (int i = 0; i < sizes.size(); i++) {
                    ProductDTO optDto = new ProductDTO();
                    optDto.setProdId(prodId);
                    optDto.setPdSize(sizes.get(i));
                    
                    mapper.insertPdSize(optDto);
                    
                    Map<String, Object> stockMap = new HashMap<>();
                    stockMap.put("prodId", prodId);
                    stockMap.put("optId", optDto.getOptId());
                    stockMap.put("qty", stocks.get(i));
                    mapper.insertStockLog(stockMap);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }
	
	@Override
	public List<CategoryDTO> listCategorySelect() {
	    try {
	        return mapper.listCategorySelect(); // 새로 만든 쿼리 호출
	    } catch (Exception e) {
	        e.printStackTrace();
	        return null;
	    }
	}
	
	@Override
	public int dataCountManage(Map<String, Object> map) {
	    int result = 0;
	    try {
	        result = mapper.countProductManage(map);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return result;
	}

	@Override
	public List<ProductDTO> listProductManage(Map<String, Object> map) {
	    List<ProductDTO> list = null;
	    try {
	        list = mapper.listProductManage(map);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	@Override
	public List<CategoryDTO> listCategoryAll() {
	    List<CategoryDTO> list = null;
	    try {
	        list = mapper.listCategoryAll();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	@Override
	public void deleteProductList(long[] prodIds) throws Exception {
	    try {
	        for(long prodId : prodIds) {
	            mapper.deleteProduct(prodId);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        throw e;
	    }
	}
	
	// 장바구니
	@Override
    public ProductDTO findById(long prod_id) {
        return mapper.findById(prod_id);
    }

    @Override
    public List<ProductDTO> listProductSizes(long prod_id) {
        try {
            return mapper.listProductSize(prod_id);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }


    @Override
    public int getOptionStock(long optId) {
        return mapper.getOptionStock(optId);
    }
    

    @Override
    public void reserveStock(long optId, int quantity) throws Exception {
        Map<String, Object> map = new HashMap<>();
        map.put("opt_id", optId);
        map.put("quantity", -quantity); // 차감을 위해 음수 전달
        map.put("remarks", "BUY_NOW_RESERVATION");
        
        mapper.insertStockLog(map);
    }

	@Override
	public void insertStockLog(Map<String, Object> map) throws Exception {
		mapper.insertStockLog(map);
	}
	
	@Override
    public void updateProduct(ProductDTO dto) throws Exception {
        try {
            mapper.updateProduct(dto);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

}