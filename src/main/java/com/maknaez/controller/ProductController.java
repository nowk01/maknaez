package com.maknaez.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.maknaez.model.ProductDTO;
import com.maknaez.model.SessionInfo;
import com.maknaez.model.WishlistDTO;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.PostMapping;
import com.maknaez.mvc.annotation.ResponseBody;
import com.maknaez.mvc.view.ModelAndView;
import com.maknaez.service.ProductService;
import com.maknaez.service.ProductServiceImpl;
import com.maknaez.service.ReviewService;
import com.maknaez.service.ReviewServiceImpl;
import com.maknaez.service.WishlistService;
import com.maknaez.service.WishlistServiceImpl;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class ProductController {

    private ProductService productService;
    private WishlistService wishlistService;
    private ReviewService reviewService;

    public ProductController() {
        this.productService = new ProductServiceImpl();
        this.wishlistService = new WishlistServiceImpl();
        this.reviewService = new ReviewServiceImpl();
    }
    

    @GetMapping("/product/detail") 
    public ModelAndView detail(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String prodIdStr = req.getParameter("prod_id");
        if(prodIdStr == null) {
            prodIdStr = req.getParameter("productNo");
        }

        long prodId = 0;
        try {
            if (prodIdStr != null && !prodIdStr.isEmpty()) {
                prodId = Long.parseLong(prodIdStr);
            }
        } catch (NumberFormatException e) {
            return new ModelAndView("redirect:/collections/list");
        }

        ProductDTO dto = productService.readProduct(prodId);
        if (dto == null) {
            return new ModelAndView("redirect:/collections/list");
        }
        
        String recentCookieName = "recent_products";
        String recentProducts = "";
        jakarta.servlet.http.Cookie[] cookies = req.getCookies();
        
        if (cookies != null) {
            for (jakarta.servlet.http.Cookie c : cookies) {
                if (c.getName().equals(recentCookieName)) {
                    try {
                        recentProducts = java.net.URLDecoder.decode(c.getValue(), "UTF-8");
                    } catch (Exception e) {}
                    break;
                }
            }
        }

        java.util.LinkedList<String> idList = new java.util.LinkedList<>();
        if (!recentProducts.isEmpty()) {
            String[] ids = recentProducts.split(",");
            for (String id : ids) {
                if(!id.trim().isEmpty()) idList.add(id.trim());
            }
        }

        String currentId = String.valueOf(prodId);
        
        idList.remove(currentId);
        idList.addFirst(currentId);

        if (idList.size() > 5) {
            idList.removeLast();
        }

        String newValue = String.join(",", idList);
        try {
            jakarta.servlet.http.Cookie newCookie = new jakarta.servlet.http.Cookie(recentCookieName, java.net.URLEncoder.encode(newValue, "UTF-8"));
            newCookie.setPath("/");       
            newCookie.setMaxAge(60 * 60 * 24); // 1일
            resp.addCookie(newCookie);
        } catch (Exception e) {
        }
        List<ProductDTO> relatedProducts = productService.listRelatedProducts(prodId, dto.getCateCode());
        List<ProductDTO> sizeList 		 = productService.listProductSizes(prodId);
        Map<String, Object> reviewStats  = reviewService.readReviewStats(prodId);
        List<ProductDTO> listImg 		 = productService.listProductImg(prodId);

        ModelAndView mav = new ModelAndView("product/detail");
        mav.addObject("dto", dto); 
        mav.addObject("sizeList", sizeList); 
        mav.addObject("recentProductIds", idList);
        mav.addObject("relatedProducts", relatedProducts);
        mav.addObject("reviewStats", reviewStats);
        mav.addObject("listImg", listImg);

        HttpSession session = req.getSession();
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        boolean isUserLiked = false;
        
        if (info != null) {
            isUserLiked = wishlistService.isLiked(info.getMemberIdx(), prodId);
        }
        mav.addObject("isUserLiked", isUserLiked);

        return mav;
    }

    @PostMapping("/product/insertWish")
    @ResponseBody
    public Map<String, Object> insertWish(HttpServletRequest req, HttpServletResponse resp) {
        
        Map<String, Object> model = new HashMap<>();
        HttpSession session = req.getSession();
        SessionInfo info = (SessionInfo) session.getAttribute("member");

        if (info == null) {
            model.put("state", "login_required");
            return model;
        }

        try {
            long prod_id = Long.parseLong(req.getParameter("prod_id"));
            boolean isLiked = wishlistService.isLiked(info.getMemberIdx(), prod_id);
            
            if (isLiked) {
                // 위시리스트 삭제 로직
                Map<String, Object> param = new HashMap<>();
                param.put("memberIdx", info.getMemberIdx());
                param.put("prodId", prod_id);
                wishlistService.deleteWish(param);
                model.put("state", "false"); 
            } else {
                // 위시리스트 추가 로직
                WishlistDTO dto = new WishlistDTO();
                dto.setMemberIdx(info.getMemberIdx());
                dto.setProdId(prod_id);
                wishlistService.insertWish(dto);
                model.put("state", "true"); 
            }
        } catch (Exception e) {
            model.put("state", "error");
            e.printStackTrace();
        }
        
        return model;
    }
    
    @PostMapping("/product/restockSubmit")
    @ResponseBody
    public Map<String, Object> restockSubmit(HttpServletRequest req, HttpServletResponse resp) {
        
        Map<String, Object> model = new HashMap<>();
        HttpSession session = req.getSession();
        SessionInfo info = (SessionInfo) session.getAttribute("member");

        if (info == null) {
            model.put("state", "login_required");
            return model;
        }

        try {
            long prodId = Long.parseLong(req.getParameter("prodId"));
            
            WishlistDTO dto = new WishlistDTO();
            dto.setMemberIdx(info.getMemberIdx());
            dto.setProdId(prodId);
            
            boolean isLiked = wishlistService.isLiked(info.getMemberIdx(), prodId);
            if (!isLiked) {
                wishlistService.insertWish(dto);
                model.put("state", "true");
                model.put("message", "입고 알림 신청이 완료되었습니다.\n(관심 상품 목록에 추가되었으며, 재입고 시 메일로 알려드립니다.)");
            } else {
                model.put("state", "true"); 
                model.put("message", "이미 입고 알림(관심 상품)에 등록된 상품입니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            model.put("state", "false");
            model.put("message", "신청 중 오류가 발생했습니다.");
        }

        return model;
    }
        
    
}