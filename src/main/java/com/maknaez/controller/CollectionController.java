package com.maknaez.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.maknaez.model.ProductDTO;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.view.ModelAndView;
import com.maknaez.service.ProductService;
import com.maknaez.service.ProductServiceImpl;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/collections") 
public class CollectionController {

    private ProductService productService;

    public CollectionController() {
        this.productService = new ProductServiceImpl();
    }

    // 1. 초기 리스트 화면 (1페이지 데이터 포함)
    @RequestMapping("/list") 
    public ModelAndView list(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        ModelAndView mav = new ModelAndView("collections/list");

        // 검색 파라미터 처리 (Helper 메소드 이용)
        Map<String, Object> map = getSearchMap(req);
        
        // 페이징 (초기 1페이지, 9개씩)
        map.put("offset", 0);
        map.put("size", 9);

        // 서비스 호출 (DB 조회)
        List<ProductDTO> list = productService.listProduct(map);
        int dataCount = productService.dataCount(map);

        // View 데이터 전달
        mav.addObject("list", list);             // 상품 목록
        mav.addObject("dataCount", dataCount);   // 전체 개수
        
        // 화면 표시용 데이터
        String category = (String) map.get("category");
        mav.addObject("category", category);
        mav.addObject("categoryName", getCategoryName(category));
        
        // 필터 상태 유지를 위한 값 전달 (JSP에서 활성화 표시용)
        mav.addObject("paramSub", req.getParameter("sub"));
        mav.addObject("paramFilter", req.getParameter("filter"));
        mav.addObject("paramSort", req.getParameter("sort"));
        mav.addObject("minPrice", req.getParameter("minPrice"));
        mav.addObject("maxPrice", req.getParameter("maxPrice"));

        return mav;
    }
    
    // 2. 무한 스크롤 데이터 요청 (AJAX - HTML 조각 반환)
    @RequestMapping("/listMore")
    public ModelAndView listMore(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // [핵심] list_more.jsp는 <html> 태그 없이 <div> 반복문만 있는 파일이어야 함
        ModelAndView mav = new ModelAndView("collections/list_more");
        
        String pageStr = req.getParameter("page");
        int currentPage = 1;
        if(pageStr != null && !pageStr.isEmpty()) {
            currentPage = Integer.parseInt(pageStr);
        }
        
        int size = 9;
        int offset = (currentPage - 1) * size;

        Map<String, Object> map = getSearchMap(req);
        map.put("offset", offset);
        map.put("size", size);

        List<ProductDTO> list = productService.listProduct(map);
        mav.addObject("list", list);
        
        return mav;
    }
    
    // [Helper] 요청 파라미터를 Map으로 변환하는 메소드
    private Map<String, Object> getSearchMap(HttpServletRequest req) {
        Map<String, Object> map = new HashMap<>();
        
        String category = req.getParameter("category");
        if (category == null || category.isEmpty()) category = "men";
        map.put("category", category);
        
        String[] params = {"sub", "filter", "price", "discount", "sort", "minPrice", "maxPrice"};
        for(String p : params) {
            String val = req.getParameter(p);
            if(val != null && !val.isEmpty()) {
                if("sub".equals(p)) map.put("subCategory", val);
                else if("price".equals(p)) map.put("priceRange", val);
                else if("discount".equals(p)) map.put("discountRate", val);
                else map.put(p, val);
            }
        }
        return map;
    }

    // [Helper] 카테고리 한글명 변환
    private String getCategoryName(String category) {
        if(category == null) return "전체 상품";
        switch (category.toLowerCase()) {
            case "men": return "남성";
            case "women": return "여성";
            case "sportstyle": return "스포츠 스타일";
            case "sale": return "세일";
            default: return "전체 상품";
        }
    }
}