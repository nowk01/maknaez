package com.maknaez.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.maknaez.mail.Mail;
import com.maknaez.mail.MailSender;
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
        try {
            dto = mapper.readProduct(prodId);
            
            if (dto != null) {
                List<ProductDTO> sizeList = mapper.listProductSize(prodId);
                
                List<String> sizes = new ArrayList<>();
                List<Integer> stocks = new ArrayList<>();
                
                if(sizeList != null) {
                    for(ProductDTO s : sizeList) {
                        sizes.add(s.getProdSize());   // 사이즈 명
                        stocks.add(s.getStockQty());  // 재고 수량
                    }
                }
                dto.setSizes(sizes);
                dto.setStocks(stocks);

                String name = dto.getProdName();
                if (name != null) {
                     List<ProductDTO> colors = this.listProductColors(name);
                     dto.setColorOptions(colors);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dto;
    }
    
    @Override
    public List<ProductDTO> listProductColors(String prodName) {
        List<ProductDTO> list = null;
        
        try {
            String baseName = prodName;
            int lastUnderscore = prodName.lastIndexOf("_");
            if (lastUnderscore > 0) {
                baseName = prodName.substring(0, lastUnderscore);
            }
            
            list = mapper.listProductColors(baseName);
            
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
	
	@Override
	public void deleteProductImg(long fileId, String pathname) throws Exception {
	    try {
	        
	        mapper.deleteProductImg(fileId);
	        
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
	        // 1. 썸네일 이미지 파일명 처리
	        if (dto.getThumbnailImg() != null) {
	            String saveFilename = dto.getThumbnailImg().getSaveFilename();
	            dto.setThumbnail(saveFilename);
	        }

	        // 2. 기본 정보 업데이트 (PRODUCTS 테이블)
	        mapper.updateProduct(dto);

	        // 3. 추가 이미지 등록 (수정 시 새로 업로드한 파일만 INSERT)
	        List<MyMultipartFile> listFile = dto.getListFile();
	        if (listFile != null && !listFile.isEmpty()) {
	            for (MyMultipartFile mf : listFile) {
	                String saveImg = mf.getSaveFilename();
	                Map<String, Object> imgMap = new HashMap<>();
	                imgMap.put("prodId", dto.getProdId());
	                imgMap.put("filename", saveImg);
	                mapper.insertProductImg(imgMap);
	            }
	        }
	        
	        List<String> sizes = dto.getSizes();
	        List<Integer> stocks = dto.getStocks();

	        if (sizes != null && stocks != null) {
	            for (int i = 0; i < sizes.size(); i++) {
	                try {
	                    ProductDTO optDto = new ProductDTO();
	                    optDto.setProdId(dto.getProdId());
	                    optDto.setPdSize(sizes.get(i));
	                    
	                    mapper.insertPdSize(optDto); 
	                    
	                    // 재고 로그 추가
	                    Map<String, Object> stockMap = new HashMap<>();
	                    stockMap.put("prodId", dto.getProdId());
	                    stockMap.put("optId", optDto.getOptId()); // 방금 생성된 optId
	                    stockMap.put("qty", stocks.get(i));
	                    mapper.insertStockLog(stockMap);
	                    
	                } catch (Exception e) {
	                }
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        throw e;
	    }
	}
	
	@Override
    public List<ProductDTO> listProductByIds(List<String> ids) {
        // 1. null 체크
        if (ids == null || ids.isEmpty()) {
            return new ArrayList<>();
        }

        List<ProductDTO> list = null;
        try {
            // 2. DB에서 상품 목록 조회
            list = mapper.listProductByIds(ids);
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (list == null) {
            return new ArrayList<>();
        }

        // 3. 쿠키에 저장된 순서(최신순)대로 정렬
        List<ProductDTO> sortedList = new ArrayList<>();
        for (String id : ids) {
            for (ProductDTO dto : list) {
                // dto.getProdId()는 long 타입이므로 문자열로 변환하여 비교
                if (String.valueOf(dto.getProdId()).equals(id)) {
                    sortedList.add(dto);
                    break;
                }
            }
        }
        return sortedList;
    }
	
	@Override
	public List<ProductDTO> listProductImg(long prodId) {
	    List<ProductDTO> list = null;
	    try {
	        // Mapper에 정의된 listProductImg 쿼리 호출
	        list = mapper.listProductImg(prodId);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
	@Override
    public List<ProductDTO> listStock(Map<String, Object> map) {
		List<ProductDTO> dto = null;
        try {
			dto = mapper.listStock(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
        return dto;
    }
	
	@Override
    public int dataCountStock(Map<String, Object> map) {
        try {
        	return mapper.dataCountStock(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
        
        return 0;
    }
	
	public void updateStock(long[] optIds, int qty, String reason) throws Exception {
	    try {
	        for (long optId : optIds) {
	            // 1. 현재 재고 조회
	            Integer currentStock = mapper.getLastStock(optId);
	            if (currentStock == null) currentStock = 0;

	            // 2. 최종 재고 계산
	            int finalStock = currentStock + qty;
	            if (finalStock < 0) finalStock = 0;

	            // 3. 로그 기록 (신규 메서드 호출!)
	            Map<String, Object> map = new HashMap<>();
	            map.put("optId", optId);
	            map.put("qty", qty);
	            map.put("finalStock", finalStock); // 계산된 잔고
	            map.put("reason", reason);

	            mapper.insertStockUpdateLog(map); // <-- 이걸 호출합니다
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        throw e;
	    }
	}
	
	
	// [추가 구현] 재고 입고 알림 메일 발송
    @Override
    public void sendRestockAlarm(long optId) throws Exception {
        try {
            // 1. 옵션 ID로 상품명과 사이즈 정보 조회
            ProductDTO productInfo = mapper.getOptionInfoForAlarm(optId);
            if (productInfo == null) return;

            long prodId = productInfo.getProdId();
            String prodName = productInfo.getProdName();
            String sizeName = productInfo.getProdSize();

            // 2. 해당 상품(prodId)을 위시리스트에 담은 회원들의 이메일 리스트 조회
            // (SQL에서 DISTINCT 처리됨)
            List<String> emailList = mapper.listWishListUserEmails(prodId);
            
            if (emailList == null || emailList.isEmpty()) {
                return; // 발송 대상 없음
            }

            // 3. 메일 발송 준비
            MailSender sender = new MailSender();
            Mail mail = new Mail();
            mail.setSenderEmail("admin@maknaez.com");
            mail.setSenderName("Maknaez 관리자");
            mail.setSubject("[Maknaez] 재입고 알림 : " + prodName + " (" + sizeName + ")");

            // 4. 메일 내용 (HTML)
            StringBuilder sb = new StringBuilder();
            sb.append("<div style='border:1px solid #ddd; padding:20px; max-width:600px;'>");
            sb.append("<h2 style='color:#111;'>재입고 알림</h2>");
            sb.append("<p>고객님께서 기다리시던 상품의 재고가 추가되었습니다.</p>");
            sb.append("<hr style='border:0; border-top:1px solid #eee; margin:20px 0;'>");
            sb.append("<p><strong>상품명 : </strong> " + prodName + "</p>");
            sb.append("<p><strong>입고 사이즈 : </strong> <span style='color:#e74c3c; font-weight:bold;'>" + sizeName + "</span></p>");
            sb.append("<p style='margin-top:20px; color:#888; font-size:12px;'>본 메일은 발신 전용입니다.</p>");
            sb.append("</div>");
            
            mail.setContent(sb.toString());

            for (String email : emailList) {
                if(email.contains("@")) {
                    mail.setReceiverEmail(email);
                    sender.mailSend(mail);
                    try { Thread.sleep(100); } catch(Exception e) {}
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            // 메일 발송 실패가 전체 트랜잭션을 롤백시키지 않도록 예외를 로그만 남기고 넘길 수도 있음
            System.out.println("메일 발송 중 오류 발생: " + e.getMessage());
        }
    }
	
}