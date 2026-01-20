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
			// 1. 상품 및 사이즈 정보 조회
			ProductDTO pDto = mapper.getOptionInfoForAlarm(optId);
			if (pDto == null) {
				return;
			}
			
			String prodName = pDto.getProdName();
			String sizeName = pDto.getProdSize(); 

            // 2. 썸네일 이미지 URL 생성
            // [중요] localhost 주소는 Gmail, Naver 등 외부 메일 서비스에서 접근할 수 없습니다.
            // 로컬 테스트 시에는 이미지가 깨져 보이는(엑스박스) 것이 정상 동작입니다.
            // 실제 서비스 배포 시에는 외부에서 접속 가능한 도메인 주소로 변경해야 합니다.
            String imgBaseUrl = "http://localhost:9090/maknaez/uploads/product/"; 
            String thumbnail = pDto.getThumbnail(); 
            
            String prodImgUrl = "";
            if (thumbnail != null && !thumbnail.isEmpty()) {
            	prodImgUrl = imgBaseUrl + thumbnail;
            }
            
            // [디버깅] 콘솔에서 생성된 URL이 올바른지 확인 (복사해서 브라우저 주소창에 넣어보세요)
            System.out.println(">> [재입고알림] 생성된 썸네일 URL: " + prodImgUrl);

			// 3. 대상자 이메일 조회 (위시리스트 기준)
			List<String> emailList = mapper.listWishListUserEmails(prodId);
			
			if (emailList == null || emailList.isEmpty()) {
				return;
			}

			// 4. 메일 발송 설정
			MailSender sender = new MailSender();
			Mail mail = new Mail();
			
			mail.setSenderEmail("ssangyoungyuwon@gmail.com");
			mail.setSenderName("막내즈");
			mail.setSubject("[Maknaez] 재입고 알림 : " + prodName);
			
            // [수정] 내부 헬퍼 메서드를 호출하여 HTML 본문 생성
			String htmlContent = generateRestockEmail(prodName, sizeName, String.valueOf(prodId), prodImgUrl);
			mail.setContent(htmlContent);

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
    
    /**
     * 재입고 알림 이메일 HTML 생성 헬퍼 메서드
     */
    private String generateRestockEmail(String prodName, String sizeName, String prodId, String prodImgUrl) {
        StringBuilder sb = new StringBuilder();
        sb.append("<div style='font-family: \"Apple SD Gothic Neo\", \"Malgun Gothic\", sans-serif; background-color: #f4f4f4; padding: 40px 20px; color: #333333;'>");
        
        // 2. 카드 컨테이너
        sb.append("  <div style='max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.05);'>");
        
        // 3. 헤더
        sb.append("    <div style='background-color: #111111; padding: 25px 0; text-align: center;'>");
        sb.append("      <h2 style='margin: 0; color: #ffffff; font-size: 20px; font-weight: 500; letter-spacing: 1px;'>MAKNAEZ</h2>");
        sb.append("    </div>");

        // 4. 본문 내용
        sb.append("    <div style='padding: 40px 30px;'>");
        sb.append("      <h2 style='margin: 0 0 10px 0; font-size: 24px; font-weight: bold; color: #111;'>재입고 알림</h2>");
        sb.append("      <p style='margin: 0 0 30px 0; font-size: 14px; color: #666; line-height: 1.6;'>");
        sb.append("        고객님께서 오랫동안 기다리셨던 상품이 드디어 재입고되었습니다.<br>");
        sb.append("        품절되기 전에 빠르게 확인해보세요!");
        sb.append("      </p>");

        // 5. 상품 정보 박스
        sb.append("      <div style='background-color: #f9f9f9; padding: 20px; border-radius: 6px; border: 1px solid #eeeeee; text-align: left;'>");
        
        // 썸네일 이미지 (이미지 URL이 유효할 때만 표시)
        if (prodImgUrl != null && !prodImgUrl.isEmpty()) {
            sb.append("        <div style='text-align: center; margin-bottom: 15px; background-color: #fff; padding: 10px; border-radius: 4px; border: 1px solid #eee;'>");
            sb.append("          <img src='" + prodImgUrl + "' alt='상품 이미지' style='max-width: 100%; height: auto; max-height: 150px; display: block; margin: 0 auto; border-radius: 2px;'>");
            sb.append("        </div>");
        }

        sb.append("        <div style='margin-bottom: 10px;'>");
        sb.append("          <span style='font-size: 12px; color: #888; display: block; margin-bottom: 4px;'>상품명</span>");
        sb.append("          <span style='font-size: 16px; font-weight: bold; color: #333; display: block;'>" + prodName + "</span>");
        sb.append("        </div>");
        sb.append("        <div>");
        sb.append("          <span style='font-size: 12px; color: #888; display: block; margin-bottom: 4px;'>입고 사이즈</span>");
        sb.append("          <span style='font-size: 16px; font-weight: bold; color: #e74c3c; display: block;'>" + sizeName + "</span>");
        sb.append("        </div>");
        sb.append("      </div>");

        // 6. 버튼
        sb.append("      <div style='margin-top: 35px; text-align: center;'>");
        sb.append("        <a href='http://localhost:9090/maknaez/product/detail?prod_id=" + prodId + "' style='display: block; width: 100%; padding: 16px 0; background-color: #111111; color: #ffffff; text-decoration: none; font-weight: bold; font-size: 16px; border-radius: 6px; box-sizing: border-box;'>상품 바로가기</a>");
        sb.append("      </div>");
        sb.append("    </div>");

        // 7. 푸터
        sb.append("    <div style='background-color: #f9f9f9; padding: 20px; text-align: center; border-top: 1px solid #eeeeee;'>");
        sb.append("      <p style='margin: 0; font-size: 11px; color: #999; line-height: 1.5;'>");
        sb.append("        본 메일은 발신 전용이며 회신되지 않습니다.<br>");
        sb.append("        © MAKNAEZ Corp. All rights reserved.");
        sb.append("      </p>");
        sb.append("    </div>");

        sb.append("  </div>");
        sb.append("</div>");

        return sb.toString();
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