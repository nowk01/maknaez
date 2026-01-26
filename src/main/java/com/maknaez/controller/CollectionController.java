package com.maknaez.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.maknaez.model.ProductDTO;
import com.maknaez.model.SessionInfo; // 추가됨
import com.maknaez.model.WishlistDTO; // 추가됨
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.PostMapping; // 추가됨
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.annotation.ResponseBody; // 추가됨
import com.maknaez.mvc.view.ModelAndView;
import com.maknaez.service.ProductService;
import com.maknaez.service.ProductServiceImpl;
import com.maknaez.service.WishlistService;
import com.maknaez.service.WishlistServiceImpl;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/collections") 
public class CollectionController {

    private ProductService productService;
    private WishlistService wishlistService; 

    public CollectionController() {
        this.productService = new ProductServiceImpl();
        this.wishlistService = new WishlistServiceImpl(); 
    }

    @RequestMapping("/list") 
    public ModelAndView list(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        ModelAndView mav = new ModelAndView("collections/list");

        Map<String, Object> map = getSearchMap(req);
        map.put("offset", 0);
        map.put("size", 9);

        String category = (String) map.get("category");

        List<ProductDTO> list = null;
        int dataCount = 0;
        int totalPage = 0;
        
        List<String> dynamicSportList = new ArrayList<>();
        try {
            if ("sale".equalsIgnoreCase(category)) {
                 dynamicSportList = productService.listCategoryNames(category); 
            } else {
                dynamicSportList = productService.listCategoryNames(category);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            list = productService.listProduct(map);
            
            HttpSession session = req.getSession();
            SessionInfo info = (SessionInfo) session.getAttribute("member");
            
            if (info != null && list != null && !list.isEmpty()) {
                List<Long> likedIds = wishlistService.listLikedProductIds(info.getMemberIdx());
                
                if (likedIds != null) {
                    for (ProductDTO dto : list) {
                        if (likedIds.contains(dto.getProdId())) {
                            dto.setLiked(true);
                        }
                    }
                }
            }
            
            dataCount = productService.dataCount(map);
            
            int size = (int)map.get("size");
            if(dataCount > 0) {
                totalPage = (int) Math.ceil((double)dataCount / size);
            } else {
                totalPage = 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
            list = new ArrayList<>();
        }

        mav.addObject("list", list);
        mav.addObject("dataCount", dataCount);
        mav.addObject("totalPage", totalPage);
        
        mav.addObject("category", category);
        mav.addObject("categoryCode", category);
        mav.addObject("categoryName", getCategoryName(category));
   
        mav.addObject("sportList", dynamicSportList);
        
        mav.addObject("genderList", getGenderList());
        mav.addObject("colorList", getColorList());
        
        mav.addObject("paramValues", req.getParameterMap()); 
        mav.addObject("minPrice", req.getParameter("minPrice"));
        mav.addObject("maxPrice", req.getParameter("maxPrice"));
        mav.addObject("paramSort", req.getParameter("sort"));

        return mav;
    }
    
    // 무한스크롤 
    @RequestMapping("/listMore")
    public ModelAndView listMore(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        ModelAndView mav = new ModelAndView("collections/list_more");
        
        String pageStr = req.getParameter("page");
        int currentPage = 1;
        try { currentPage = Integer.parseInt(pageStr); } catch (Exception e) {}
        
        int size = 9;
        int offset = (currentPage - 1) * size;

        Map<String, Object> map = getSearchMap(req);
        map.put("offset", offset);
        map.put("size", size);

        try {
            List<ProductDTO> list = productService.listProduct(map);
            
            HttpSession session = req.getSession();
            SessionInfo info = (SessionInfo) session.getAttribute("member");
            
            if (info != null && list != null && !list.isEmpty()) {
                List<Long> likedIds = wishlistService.listLikedProductIds(info.getMemberIdx());
                if (likedIds != null) {
                    for (ProductDTO dto : list) {
                        if (likedIds.contains(dto.getProdId())) {
                            dto.setLiked(true);
                        }
                    }
                }
            }
            
            mav.addObject("list", list);
        } catch (Exception e) { e.printStackTrace(); }
        
        return mav;
    }

    // 하트 클릭 시 찜 등록/해제 처리 (AJAX)
    @ResponseBody
    @PostMapping("/wishlist/toggle")
    public Map<String, Object> toggleWish(HttpServletRequest req, HttpServletResponse resp) {
        Map<String, Object> result = new HashMap<>();
        HttpSession session = req.getSession();
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        
        if (info == null) {
            result.put("status", "login_required");
            return result;
        }
        
        try {
            long prodId = Long.parseLong(req.getParameter("prodId"));
            
            boolean isLiked = wishlistService.isLiked(info.getMemberIdx(), prodId);
            
            if (isLiked) {
                Map<String, Object> param = new HashMap<>();
                param.put("memberIdx", info.getMemberIdx());
                param.put("prodId", prodId);
                wishlistService.deleteWish(param);
                result.put("liked", false);
            } else {
                WishlistDTO dto = new WishlistDTO();
                dto.setMemberIdx(info.getMemberIdx());
                dto.setProdId(prodId);
                wishlistService.insertWish(dto);
                result.put("liked", true);
            }
            result.put("status", "success");
            
        } catch (Exception e) {
            e.printStackTrace();
            result.put("status", "error");
        }
        
        return result;
    }
    
    private Map<String, Object> getSearchMap(HttpServletRequest req) {
        Map<String, Object> map = new HashMap<>();
        
        String category = req.getParameter("category");
        if (category == null || category.isEmpty()) category = "men";
        map.put("category", category);
        
        String[] sports = req.getParameterValues("sports");
        if(sports != null) map.put("sports", sports);
        
        String[] genders = req.getParameterValues("genders");
        if(genders != null) map.put("genders", genders);
        
        String[] colors = req.getParameterValues("colors");
        if(colors != null) map.put("colors", colors);

        String sub = req.getParameter("sub");
        if(sub != null && !sub.isEmpty()) map.put("subCategory", sub);

        String minPrice = req.getParameter("minPrice");
        String maxPrice = req.getParameter("maxPrice");
        if(minPrice != null && !minPrice.isEmpty()) map.put("minPrice", minPrice);
        if(maxPrice != null && !maxPrice.isEmpty()) map.put("maxPrice", maxPrice);
        
        String sort = req.getParameter("sort");
        if(sort != null && !sort.isEmpty()) map.put("sort", sort);
        
        String filter = req.getParameter("filter");
        if(filter != null && !filter.isEmpty()) map.put("filter", filter);
        
        String excludeSoldOut = req.getParameter("excludeSoldOut");
        if(excludeSoldOut != null && !excludeSoldOut.isEmpty()) {
            map.put("excludeSoldOut", excludeSoldOut);
        }

        return map;
    }

    private List<Map<String, String>> getGenderList() {
        List<Map<String, String>> list = new ArrayList<>();
        Map<String, String> m = new HashMap<>(); m.put("code", "M"); m.put("name", "남성"); list.add(m);
        Map<String, String> f = new HashMap<>(); f.put("code", "F"); f.put("name", "여성"); list.add(f);
        Map<String, String> u = new HashMap<>(); u.put("code", "U"); u.put("name", "Unisex"); list.add(u);
        return list;
    }
    
    private List<Map<String, String>> getColorList() {
        List<Map<String, String>> list = new ArrayList<>();
        String[] codes = {"BK", "WH", "GY", "NV", "SV", "GR", "BE", "OR", "PK", "RD"};
        String[] names = {"블랙", "화이트", "그레이", "네이비", "실버", "그린", "베이지", "오렌지", "핑크", "레드"};
        String[] hexes = {"#000000", "#FFFFFF", "#808080", "#000080", "#C0C0C0", "#008000", "#F5F5DC", "#FFA500", "#FFC0CB", "#ff0000"};
        
        for(int i=0; i<codes.length; i++) {
            Map<String, String> m = new HashMap<>();
            m.put("code", codes[i]);
            m.put("name", names[i]);
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