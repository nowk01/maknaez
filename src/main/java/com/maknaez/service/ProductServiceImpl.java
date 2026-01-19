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
	                String sizeName = sizes.get(i);
	                int newStockQty = stocks.get(i);

	                // 파라미터 맵 생성
	                Map<String, Object> paramMap = new HashMap<>();
	                paramMap.put("prodId", dto.getProdId());
	                paramMap.put("pdSize", sizeName);

	                // [핵심] 이미 존재하는 사이즈인지 확인
	                Long existingOptId = mapper.getOptId(paramMap);
	                long optId;

	                if (existingOptId == null) {
	                    // (1) 존재하지 않으면 -> INSERT (새 옵션 생성)
	                    ProductDTO optDto = new ProductDTO();
	                    optDto.setProdId(dto.getProdId());
	                    optDto.setPdSize(sizeName);
	                    
	                    mapper.insertPdSize(optDto);
	                    optId = optDto.getOptId(); // 새로 생성된 키값
	                } else {
	                    // (2) 존재하면 -> 기존 opt_id 사용 (pd_size 테이블은 건드리지 않음)
	                    optId = existingOptId;
	                }

	                // 3. 재고 로그 업데이트 (값이 변경되었거나 새로 등록된 경우)
	                // 현재 재고 조회
	                Integer currentStock = mapper.getLastStock(optId);
	                if (currentStock == null) currentStock = 0;

	                // 재고 수량에 차이가 있을 때만 로그 insert (선택 사항, 모든 변경 시 기록하려면 조건문 제거)
	                if (existingOptId == null || currentStock != newStockQty) {
	                    Map<String, Object> stockMap = new HashMap<>();
	                    stockMap.put("prodId", dto.getProdId());
	                    stockMap.put("optId", optId);
	                    
	                    // 현재 작성된 insertStockLog 쿼리는 'qty'를 prod_stock(잔여량)으로 바로 세팅하므로
	                    // 관리자가 입력한 최종 수량(newStockQty)을 그대로 넘겨주면 됩니다.
	                    stockMap.put("qty", newStockQty); 
	                    
	                    mapper.insertStockLog(stockMap);
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
	
	public void updateStock(long[] prodIds, long[] optIds, int qty, String reason) throws Exception {
	    try {
	        for (int i=0; i<optIds.length; i++) {	        	
	            // 1. 현재 재고 조회
	            Integer currentStock = mapper.getLastStock(optIds[i]);
	            if (currentStock == null) currentStock = 0;

	            // 2. 최종 재고 계산
	            int finalStock = currentStock + qty;
	            if (finalStock < 0) finalStock = 0;

	            // 3. 로그 기록 (신규 메서드 호출!)
	            Map<String, Object> map = new HashMap<>();
	            map.put("prodId", prodIds[i]);
	            map.put("optId", optIds[i]);
	            map.put("qty", qty);
	            map.put("finalStock", finalStock); // 계산된 잔고
	            map.put("reason", reason);

	            mapper.insertStockUpdateLog(map); // <-- 이걸 호출합니다
	            

                if (currentStock <= 0 && finalStock > 0 && qty > 0) {
                    sendRestockNotification(prodIds[i], optIds[i]);
                }          
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        throw e;
	    }
	}
	
	public void sendRestockNotification(long prodId, long optId) {
		try {
			// 1. 상품 및 사이즈 정보 조회 (요청하신 메서드 사용)
			ProductDTO pDto = mapper.getOptionInfoForAlarm(optId);
			if (pDto == null) {
				return;
			}
			
			String prodName = pDto.getProdName();
			// DTO에 prodSize 필드가 있어야 합니다. (없다면 DTO 수정 필요)
			String sizeName = pDto.getProdSize(); 

			// 2. 대상자 이메일 조회 (위시리스트 기준)
			List<String> emailList = mapper.listWishListUserEmails(prodId);
			
			if (emailList == null || emailList.isEmpty()) {
				return;
			}

			// 3. 메일 발송
			MailSender sender = new MailSender();
			Mail mail = new Mail();
			
			// [중요] MailSender.java에 설정된 구글 계정과 일치시킴
			mail.setSenderEmail("ssangyoungyuwon@gmail.com");
			mail.setSenderName("막내즈");
			
			mail.setSubject("[Maknaez] 재입고 알림 : " + prodName);
			
			StringBuilder sb = new StringBuilder();
			sb.append("<div style='padding:20px; border:1px solid #ddd; background-color:#fff;'>");
			sb.append("<h2 style='color:#111;'>재입고 알림</h2>");
			sb.append("<p>고객님께서 기다리시던 상품의 재고가 추가되었습니다.</p>");
			sb.append("<hr style='border:0; border-top:1px solid #eee; margin:20px 0;'>");
			sb.append("<p><strong>상품명 : </strong> " + prodName + "</p>");
			sb.append("<p><strong>입고 사이즈 : </strong> <span style='color:#e74c3c; font-weight:bold;'>" + sizeName + "</span></p>");
			sb.append("<br>");
			sb.append("<a href='http://localhost:9090/maknaez/product/detail?prod_id=" + prodId + "' style='padding:10px 20px; background:#333; color:#fff; text-decoration:none; border-radius:4px;'>상품 바로가기</a>");
			sb.append("<p style='margin-top:20px; color:#888; font-size:12px;'>본 메일은 발신 전용입니다.</p>");
			sb.append("</div>");
			
			mail.setContent(sb.toString());

			int successCount = 0;
			for (String email : emailList) {
				if(email != null && email.contains("@")) {
					mail.setReceiverEmail(email);
					boolean isSent = sender.mailSend(mail);
					if(isSent) successCount++;
					
					// 메일 서버 부하 방지용 딜레이 (선택사항)
					try { Thread.sleep(100); } catch(Exception e) {}
				}
			}
			System.out.println("[알림완료] " + prodName + "(" + sizeName + ") - " + successCount + "명에게 발송.");

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("메일 발송 중 오류 발생: " + e.getMessage());
		}
	}
    
    @Override
	public List<ProductDTO> listRelatedProducts(long prodId, String cateCode) {
		List<ProductDTO> list = null;
		try {
			Map<String, Object> map = new HashMap<>();
			map.put("prodId", prodId);
			map.put("cateCode", cateCode);
			
			list = mapper.listRelatedProducts(map);
			if(list != null) {
				for(ProductDTO dto : list) {
					dto.setOriginalPrice(dto.getPrice());
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}



	
}