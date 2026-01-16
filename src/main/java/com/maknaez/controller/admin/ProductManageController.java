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
	public String list(HttpServletRequest req, HttpServletResponse resp) throws Exception {
	    MyUtil myUtil = new MyUtil();
	    String cp = req.getContextPath();
	    
	    String page = req.getParameter("page");
	    int current_page = 1;
	    if(page != null) current_page = Integer.parseInt(page);

	    String schType = req.getParameter("schType");
	    String kwd = req.getParameter("kwd");
	    String category = req.getParameter("category");

	    if(schType == null) schType = "all";
	    if(kwd == null) kwd = "";
	    if(category == null) category = "";

	    if(req.getMethod().equalsIgnoreCase("GET")) {
	        kwd = URLDecoder.decode(kwd, "UTF-8");
	    }

	    Map<String, Object> map = new HashMap<>();
	    map.put("schType", schType);
	    map.put("kwd", kwd);
	    map.put("category", category);

	    // 1. 전체 데이터 개수 가져오기
	    int dataCount = service.dataCountManage(map);

	    int rows = 10;
	    
	    // [수정 포인트 1] 파라미터 순서 변경: (총데이터수, 한페이지개수)
	    int total_page = myUtil.pageCount(dataCount, rows);
	    
	    if(current_page > total_page) current_page = total_page;

	    // 데이터가 없는 경우 1페이지로 설정 안하면 에러 날 수 있음
	    if(current_page < 1) current_page = 1;

	    int start = (current_page - 1) * rows + 1;
	    int end = current_page * rows;
	    map.put("start", start);
	    map.put("end", end);

	    // 리스트 조회
	    List<ProductDTO> list = service.listProductManage(map);
	    List<CategoryDTO> categoryList = service.listCategory();

	    // 2. 페이징 URL 생성
	    String query = "schType=" + schType + "&kwd=" + URLEncoder.encode(kwd, "UTF-8") + "&category=" + category;
	    String listUrl = cp + "/admin/product/product_list";
	    
	    if(!query.equals("")) {
	        listUrl += "?" + query;
	    }
	    
	    // [수정 포인트 2] MyUtil paging 호출
	    String paging = myUtil.paging(current_page, total_page, listUrl);

	    req.setAttribute("list", list);
	    req.setAttribute("categoryList", categoryList);
	    req.setAttribute("page", current_page);
	    req.setAttribute("dataCount", dataCount);
	    req.setAttribute("total_page", total_page);
	    req.setAttribute("paging", paging); // JSP에서 ${paging}으로 사용
	    req.setAttribute("schType", schType);
	    req.setAttribute("kwd", kwd);
	    req.setAttribute("category", category);

	    return "admin/product/product_list";
	}
	    
	   
	@GetMapping("product_write")
    public String writeForm(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        List<CategoryDTO> categoryList = service.listCategory();
        req.setAttribute("categoryList", categoryList);
        req.setAttribute("mode", "write");
        return "admin/product/product_write";
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
	        
	        String gender = req.getParameter("gender");
            if(gender == null) gender = "M"; // 기본값

	        // [5] 제품명 완성 (상품명 + 색상코드)
	        String fullName = gender + "_" + dto.getProdName() + "_" + dto.getColorCode(); // 공백이나 구분자 추가 권장
	        dto.setProdName(fullName);

	        // [6] Service 호출
	        service.insertProduct(dto);
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	        return "redirect:/admin/product/product_write"; 
	    }
	    return "redirect:/admin/product/product_list";
	}
	
	@GetMapping("update")
    public String updateForm(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        try {
            long prodId = Long.parseLong(req.getParameter("prodId"));
            String page = req.getParameter("page");

            ProductDTO dto = service.readProduct(prodId);
            if(dto == null) {
                return "redirect:/admin/product/product_list?page=" + page;
            }

            List<CategoryDTO> categoryList = service.listCategory();

            req.setAttribute("mode", "update"); // 모드 설정
            req.setAttribute("dto", dto);
            req.setAttribute("categoryList", categoryList);
            req.setAttribute("page", page);

            return "admin/product/product_write"; // 등록 폼 재사용

        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/admin/product/product_list";
        }
    }
	
	@PostMapping("updateSubmit")
    public String updateSubmit(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        try {
            HttpSession session = req.getSession(); // 세션 가져오기
            ProductDTO dto = new ProductDTO();
            
            dto.setProdId(Long.parseLong(req.getParameter("prodId")));
            dto.setCateCode(req.getParameter("cateCode"));
            dto.setProdName(req.getParameter("prodName"));
            dto.setPrice(Integer.parseInt(req.getParameter("base_price")));
            dto.setDescription(req.getParameter("prodDesc")); // prodDesc 이름 확인
            dto.setIsDisplayed(Integer.parseInt(req.getParameter("isDisplayed")));
            
            // [추가] 파일 업로드 경로 설정
            String root = session.getServletContext().getRealPath("/");
            String pathname = root + "uploads" + File.separator + "product";

            // [추가] 썸네일 이미지 수정 처리
            Part thumbPart = req.getPart("thumbnailFile");
            if (thumbPart != null && thumbPart.getSize() > 0) {
                MyMultipartFile mf = fileManager.doFileUpload(thumbPart, pathname);
                dto.setThumbnailImg(mf);
            }

            // [추가] 추가 이미지 수정(추가) 처리
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

            // 서비스 호출
            service.updateProduct(dto);
            
            String page = req.getParameter("page");
            return "redirect:/admin/product/product_list?page=" + page;
            
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/admin/product/product_list";
        }
    }
	
	
	
	@PostMapping("delete")
    public void delete(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        try {
            String[] sParams = req.getParameterValues("prodIds");
            
            if(sParams != null && sParams.length > 0) {
                long[] prodIds = new long[sParams.length];
                for(int i=0; i<sParams.length; i++) {
                    prodIds[i] = Long.parseLong(sParams[i]);
                }
                
                service.deleteProductList(prodIds);
            }
            
            resp.sendError(200); 
            
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500);
        }
    }
}
