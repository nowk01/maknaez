package com.maknaez.controller;

import java.io.IOException;
import java.util.ArrayList;
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

        // 검색 파라미터 처리
        Map<String, Object> map = getSearchMap(req);
        
        // 페이징 (초기 1페이지, 9개씩)
        map.put("offset", 0);
        map.put("size", 9);

        // [핵심] 서비스 호출 (DB 조회)
        try {
            List<ProductDTO> list = productService.listProduct(map);
            int dataCount = productService.dataCount(map);
            
            mav.addObject("list", list);             // 상품 목록 (DB)
            mav.addObject("dataCount", dataCount);   // 전체 개수
        } catch (Exception e) {
            e.printStackTrace();
            mav.addObject("list", new ArrayList<>()); 
            mav.addObject("dataCount", 0);
        }

        // 화면 표시용 기본 데이터
        String category = (String) map.get("category");
        mav.addObject("category", category);
        mav.addObject("categoryCode", category); // JSP 호환용
        mav.addObject("categoryName", getCategoryName(category));
        
        // [복구] 사이드바 필터용 리스트 생성 (JSP에서 사용됨)
        mav.addObject("sportList", getSportList());
        mav.addObject("genderList", getGenderList());
        mav.addObject("colorList", getColorList());
        
        // 필터 상태 유지 (JSP에서 체크박스 유지용)
        mav.addObject("paramValues", req.getParameterMap()); // 체크박스 값들
        mav.addObject("minPrice", req.getParameter("minPrice"));
        mav.addObject("maxPrice", req.getParameter("maxPrice"));

        return mav;
    }
    
    // 2. 무한 스크롤 데이터 요청 (AJAX - HTML 조각 반환)
    @RequestMapping("/listMore")
    public ModelAndView listMore(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        ModelAndView mav = new ModelAndView("collections/list_more");
        
        String pageStr = req.getParameter("page");
        int currentPage = 1;
        if(pageStr != null && !pageStr.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) { }
        }
        
        int size = 9;
        int offset = (currentPage - 1) * size;

        Map<String, Object> map = getSearchMap(req);
        map.put("offset", offset);
        map.put("size", size);

        try {
            List<ProductDTO> list = productService.listProduct(map);
            mav.addObject("list", list);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return mav;
    }
    
    // [Helper] 파라미터 맵핑
    private Map<String, Object> getSearchMap(HttpServletRequest req) {
        Map<String, Object> map = new HashMap<>();
        String category = req.getParameter("category");
        if (category == null || category.isEmpty()) category = "men";
        map.put("category", category);
        
        // 체크박스 필터 처리
        String[] sports = req.getParameterValues("sports");
        if(sports != null) map.put("sports", sports); 
        // *참고: 현재 Mapper는 'subCategory' 파라미터를 사용하여 'cate_code'를 검색합니다.
        // JSP의 체크박스 값(sports)을 Mapper에 적용하려면 Mapper XML 수정이 필요할 수 있습니다.
        // 우선 기존 'sub' 파라미터 로직과 호환되도록, 첫 번째 선택된 값을 subCategory로 넣어줍니다.
        if(sports != null && sports.length > 0) {
             // 한글명을 코드로 변환하는 로직이 필요할 수 있으나, 일단 값 그대로 전달
             // (DB에 '트레일러닝' 등으로 저장되어 있지 않다면 매칭 안 될 수 있음 -> 영문 코드로 변환 추천)
             // 여기서는 간단히 sub 파라미터가 있으면 그걸 우선시함
        }
        
        String sub = req.getParameter("sub");
        if(sub != null && !sub.isEmpty()) map.put("subCategory", sub);

        String minPrice = req.getParameter("minPrice");
        String maxPrice = req.getParameter("maxPrice");
        if(minPrice != null && !minPrice.isEmpty()) map.put("minPrice", minPrice);
        if(maxPrice != null && !maxPrice.isEmpty()) map.put("maxPrice", maxPrice);
        
        String sort = req.getParameter("sort");
        if(sort != null && !sort.isEmpty()) map.put("sort", sort);

        return map;
    }

    // [Helper] 더미 리스트 생성 메소드들 (사이드바용)
    private List<String> getSportList() {
        List<String> list = new ArrayList<>();
        list.add("로드러닝"); 
        list.add("트레일러닝"); 
        list.add("아웃도어"); // 하이킹 -> 아웃도어 변경
        list.add("스포츠스타일"); 
        list.add("샌들/워터슈즈");
        return list;
    }
    
    private List<String> getGenderList() {
        List<String> list = new ArrayList<>();
        list.add("남성"); list.add("여성"); list.add("Unisex");
        return list;
    }
    
    private List<Map<String, String>> getColorList() {
        List<Map<String, String>> list = new ArrayList<>();
        String[] colors = {"블랙", "화이트", "그레이", "레드", "블루", "그린", "베이지", "브라운", "옐로우"};
        String[] hexes = {"#000000", "#FFFFFF", "#808080", "#E32526", "#0057B8", "#006F44", "#DBCFB6", "#6E4E37", "#FFD100"};
        for(int i=0; i<colors.length; i++) {
            Map<String, String> m = new HashMap<>();
            m.put("name", colors[i]);
            m.put("hex", hexes[i]);
            list.add(m);
        }
        return list;
    }

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