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
                        sizes.add(s.getProdSize());   
                        stocks.add(s.getStockQty());  
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
    public void insertProduct(ProductDTO dto) throws Exception {
        try {
            if (dto.getThumbnailImg() != null) {
                String saveFilename = dto.getThumbnailImg().getSaveFilename();
                dto.setThumbnail(saveFilename); 
            }

            mapper.insertProduct(dto);
            long prodId = dto.getProdId();

            List<MyMultipartFile> listFile = dto.getListFile();
            if (listFile != null && !listFile.isEmpty()) {
                for (MyMultipartFile mf : listFile) {
                    String saveImg = mf.getSaveFilename();
                    
                    Map<String, Object> imgMap = new HashMap<>();
                    imgMap.put("prodId", prodId);
                    imgMap.put("filename", saveImg);
                    
                    mapper.insertProductImg(imgMap);
                }
            }

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
	        return mapper.listCategorySelect(); 
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
        map.put("quantity", -quantity); 
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
	        if (dto.getThumbnailImg() != null) {
	            String saveFilename = dto.getThumbnailImg().getSaveFilename();
	            dto.setThumbnail(saveFilename);
	        }

	        mapper.updateProduct(dto);

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

	                Map<String, Object> paramMap = new HashMap<>();
	                paramMap.put("prodId", dto.getProdId());
	                paramMap.put("pdSize", sizeName);

	                Long existingOptId = mapper.getOptId(paramMap);
	                long optId;

	                if (existingOptId == null) {
	                    ProductDTO optDto = new ProductDTO();
	                    optDto.setProdId(dto.getProdId());
	                    optDto.setPdSize(sizeName);
	                    
	                    mapper.insertPdSize(optDto);
	                    optId = optDto.getOptId(); 
	                } else {
	                    optId = existingOptId;
	                }

	                Integer currentStock = mapper.getLastStock(optId);
	                if (currentStock == null) currentStock = 0;

	                if (existingOptId == null || currentStock != newStockQty) {
	                    Map<String, Object> stockMap = new HashMap<>();
	                    stockMap.put("prodId", dto.getProdId());
	                    stockMap.put("optId", optId);
	                    
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
        if (ids == null || ids.isEmpty()) {
            return new ArrayList<>();
        }

        List<ProductDTO> list = null;
        try {
            list = mapper.listProductByIds(ids);
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (list == null) {
            return new ArrayList<>();
        }

        List<ProductDTO> sortedList = new ArrayList<>();
        for (String id : ids) {
            for (ProductDTO dto : list) {
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
	            Integer currentStock = mapper.getLastStock(optIds[i]);
	            if (currentStock == null) currentStock = 0;

	            int finalStock = currentStock + qty;
	            if (finalStock < 0) finalStock = 0;

	            Map<String, Object> map = new HashMap<>();
	            map.put("prodId", prodIds[i]);
	            map.put("optId", optIds[i]);
	            map.put("qty", qty);
	            map.put("finalStock", finalStock);
	            map.put("reason", reason);

	            mapper.insertStockUpdateLog(map);
	            

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
			ProductDTO pDto = mapper.getOptionInfoForAlarm(optId);
			if (pDto == null) {
				return;
			}
			
			String prodName = pDto.getProdName();
			String sizeName = pDto.getProdSize(); 

            String imgBaseUrl = "http://61.73.115.26:9090/maknaez/uploads/product/"; 
            String thumbnail = pDto.getThumbnail(); 
            
            String prodImgUrl = "";
            if (thumbnail != null && !thumbnail.isEmpty()) {
            	prodImgUrl = imgBaseUrl + thumbnail;
            }
            
            System.out.println(">> [재입고알림] 생성된 썸네일 URL: " + prodImgUrl);

			List<String> emailList = mapper.listWishListUserEmails(prodId);
			
			if (emailList == null || emailList.isEmpty()) {
				return;
			}

			MailSender sender = new MailSender();
			Mail mail = new Mail();
			
			mail.setSenderEmail("ssangyoungyuwon@gmail.com");
			mail.setSenderName("막내즈");
			mail.setSubject("[Maknaez] 재입고 알림 : " + prodName);
			
			String htmlContent = generateRestockEmail(prodName, sizeName, String.valueOf(prodId), prodImgUrl);
			mail.setContent(htmlContent);

			int successCount = 0;
			for (String email : emailList) {
				if(email != null && email.contains("@")) {
					mail.setReceiverEmail(email);
					boolean isSent = sender.mailSend(mail);
					if(isSent) successCount++;
					
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