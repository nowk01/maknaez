package com.maknaez.controller.admin;

import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.maknaez.model.CategoryDTO;
import com.maknaez.model.ProductDTO;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.PostMapping;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.view.JsonView;
import com.maknaez.mvc.view.ModelAndView;
import com.maknaez.service.ProductService;
import com.maknaez.service.ProductServiceImpl;
import com.maknaez.util.FileManager;
import com.maknaez.util.MyMultipartFile;
import com.maknaez.util.MyUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@Controller
@RequestMapping("/admin/product/*")
public class ProductManageController {
	
	private ProductService service = new ProductServiceImpl();
	private FileManager fileManager = new FileManager();
	private MyUtil util = new MyUtil();

	@GetMapping("category_manage")
    public ModelAndView categoryManage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        return new ModelAndView("admin/product/category_manage");
    }

	@GetMapping("category_list")
    public ModelAndView listCategoryApi(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        List<CategoryDTO> list = service.listCategory();

        // JSON으로 데이터 반환
        ModelAndView mav = new ModelAndView(new JsonView());
        mav.addObject("list", list);

        return mav;
    }
	
	@PostMapping("category_insert")
    public ModelAndView insertCategoryApi(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        CategoryDTO dto = new CategoryDTO();
        dto.setCateName(req.getParameter("cateName"));
        dto.setDepth(Integer.parseInt(req.getParameter("depth")));
        dto.setStatus(Integer.parseInt(req.getParameter("status")));
        dto.setOrderNo(Integer.parseInt(req.getParameter("orderNo")));
        
        String parent = req.getParameter("cateParent");
        if(parent != null && !parent.isEmpty() && !parent.equals("null")) {
            dto.setCateParent(parent);
        }

        service.insertCategory(dto);
        
        // 수정: 생성자 대신 addObject 사용
        ModelAndView mav = new ModelAndView(new JsonView());
        mav.addObject("state", "true");
        
        return mav;
    }
	
	@PostMapping("category_update")
    public ModelAndView updateCategoryApi(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        CategoryDTO dto = new CategoryDTO();
        dto.setOriginCateCode(req.getParameter("originCateCode"));
        dto.setCateCode(req.getParameter("cateCode"));
        dto.setCateName(req.getParameter("cateName"));
        dto.setStatus(Integer.parseInt(req.getParameter("status")));
        dto.setOrderNo(Integer.parseInt(req.getParameter("orderNo")));

        service.updateCategory(dto);

        // 수정: 생성자 대신 addObject 사용
        ModelAndView mav = new ModelAndView(new JsonView());
        mav.addObject("state", "true");
        
        return mav;
    }
	
	@PostMapping("category_delete")
    public ModelAndView deleteCategoryApi(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String cateCode = req.getParameter("cateCode");
        
        ModelAndView mav = new ModelAndView(new JsonView());
        try {
            service.deleteCategory(cateCode);
            mav.addObject("state", "true");
        } catch (Exception e) {
            mav.addObject("state", "false");
            mav.addObject("message", "하위 카테고리가 있거나 삭제할 수 없는 상태입니다.");
        }
        return mav;
    }
	
	@GetMapping("stock_list")
	public ModelAndView stockList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/product/stock_list");
		
		return mav;
	}
	
	@GetMapping("product_list")
    public ModelAndView productList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ModelAndView mav = new ModelAndView("admin/product/product_list");
        
        // 1. 페이징 및 검색 파라미터 처리
        String page = req.getParameter("page");
        int current_page = 1;
        if(page != null && page.length() != 0) {
            try {
                current_page = Integer.parseInt(page);
            } catch (NumberFormatException e) { }
        }
        
        String searchKey = req.getParameter("searchKey");
        String searchValue = req.getParameter("searchValue");
        if(searchValue == null) {
            searchKey = "prodName";
            searchValue = "";
        }
        
        if(req.getMethod().equalsIgnoreCase("GET")) {
            searchValue = URLDecoder.decode(searchValue, "UTF-8"); // Import 추가로 에러 해결
        }
        
        // 2. 데이터 가져오기
        int rows = 10;
        Map<String, Object> map = new HashMap<>();
        map.put("searchKey", searchKey);
        map.put("searchValue", searchValue);
        
        int dataCount = service.dataCountManage(map); // Service에 해당 메소드가 있어야 함
        int total_page = util.pageCount(rows, dataCount);
        if(current_page > total_page) current_page = total_page;
        
        int start = (current_page - 1) * rows + 1;
        int end = current_page * rows;
        map.put("start", start);
        map.put("end", end);
        
        List<ProductDTO> list = service.listProductManage(map); // Service에 해당 메소드가 있어야 함
        
        // 3. 카테고리 트리 구조 생성
        List<CategoryDTO> allCats = service.listCategoryAll(); // Service에 해당 메소드가 있어야 함
        List<CategoryDTO> parentCats = new ArrayList<>();
        Map<String, List<CategoryDTO>> childCatsMap = new HashMap<>();
        
        if(allCats != null) {
            for(CategoryDTO dto : allCats) {
                if(dto.getDepth() == 1 || dto.getCateParent() == null) {
                    parentCats.add(dto);
                } else {
                    String pCode = dto.getCateParent();
                    List<CategoryDTO> children = childCatsMap.getOrDefault(pCode, new ArrayList<>());
                    children.add(dto);
                    childCatsMap.put(pCode, children);
                }
            }
        }
        
        // 4. 페이징 URL 처리
        String cp = req.getContextPath();
        String listUrl = cp + "/admin/product/product_list";
        
        String query = "rows=" + rows;
        if(searchValue.length() != 0) {
            query += "&searchKey=prodName&searchValue=" + URLEncoder.encode(searchValue, "UTF-8"); // Import 추가로 에러 해결
        }
        listUrl += "?" + query;
        
        String paging = util.paging(current_page, total_page, listUrl);
        
        // 5. 모델 전송
        mav.addObject("list", list);
        mav.addObject("parentCats", parentCats);
        mav.addObject("childCatsMap", childCatsMap);
        mav.addObject("page", current_page);
        mav.addObject("total_page", total_page);
        mav.addObject("dataCount", dataCount);
        mav.addObject("paging", paging);
        mav.addObject("searchValue", searchValue);
        
        return mav;
    }
	    
	   
	
	@PostMapping("writeSubmit")
	public String writeSubmit(HttpServletRequest req, HttpServletResponse resp) { // 인자를 2개로 수정
	    try {
	        HttpSession session = req.getSession(); // 세션은 req에서 꺼냅니다.
	        ProductDTO dto = new ProductDTO();

	        // [1] 파라미터 수동 매핑 (프레임워크가 안 해주므로 직접 해야 함)
	        dto.setCateCode(req.getParameter("cateCode"));
	        dto.setProdName(req.getParameter("prodName"));
	        dto.setColorCode(req.getParameter("colorCode"));
	        dto.setDescription(req.getParameter("description")); // 스마트에디터 내용
	        
	        // 숫자형 변환 처리
	        String priceStr = req.getParameter("price");
	        if(priceStr != null && !priceStr.isEmpty()) {
	            dto.setPrice(Integer.parseInt(priceStr));
	        }

	        // 옵션(사이즈/재고) 배열 처리
	        String[] sizes = req.getParameterValues("sizes");
	        String[] stocks = req.getParameterValues("stocks");
	        
	        List<String> sizeList = new ArrayList<>();
	        List<Integer> stockList = new ArrayList<>();

	        if(sizes != null && stocks != null) {
	            for(int i=0; i<sizes.length; i++) {
	                sizeList.add(sizes[i]);
	                try {
	                    stockList.add(Integer.parseInt(stocks[i]));
	                } catch (NumberFormatException e) {
	                    stockList.add(0);
	                }
	            }
	            dto.setSizes(sizeList);
	            dto.setStocks(stockList);
	        }
	        
	        // isDisplayed(status) 등 필요한 기본값 설정 (필요시)
	        dto.setIsDisplayed(1); // 예: 기본 1(표시)

	        // [2] 파일 저장 경로 설정
	        String root = session.getServletContext().getRealPath("/");
	        String pathname = root + "uploads" + File.separator + "product";

	        // [3] 썸네일 이미지 처리
	        Part thumbPart = req.getPart("thumbnailFile");
	        if (thumbPart != null && thumbPart.getSize() > 0) {
	            MyMultipartFile mf = fileManager.doFileUpload(thumbPart, pathname);
	            dto.setThumbnailImg(mf);
	        }

	        // [4] 추가 이미지 처리
	        Collection<Part> parts = req.getParts();
	        List<Part> imgParts = new ArrayList<>();
	        for(Part p : parts) {
	            if("imgs".equals(p.getName()) && p.getSize() > 0) {
	                imgParts.add(p);
	            }
	        }
	        
	        if(!imgParts.isEmpty()) {
	            List<MyMultipartFile> uploadedFiles = fileManager.doFileUpload(imgParts, pathname);
	            dto.setListFile(uploadedFiles);
	        }

	        // [5] 제품명 완성 (상품명 + 색상코드)
	        String fullName = dto.getProdName() + " " + dto.getColorCode(); // 공백이나 구분자 추가 권장
	        dto.setProdName(fullName);

	        // [6] Service 호출
	        service.insertProduct(dto);
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	        return "redirect:/admin/product/product_write"; // write_ok가 아니라 product_write로 가야 함 (매핑 확인 필요)
	    }
	    return "redirect:/admin/product/product_list";
	}
	
	@PostMapping("delete")
	public void deleteProduct(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	    try {
	        String[] sParams = req.getParameterValues("prodIds");
	        if(sParams != null) {
	            long[] prodIds = new long[sParams.length];
	            for(int i=0; i<sParams.length; i++) {
	                prodIds[i] = Long.parseLong(sParams[i]);
	            }
	            service.deleteProductList(prodIds);
	        }
	        resp.setStatus(200); // 성공
	    } catch (Exception e) {
	        e.printStackTrace();
	        resp.sendError(500);
	    }
	}
}
