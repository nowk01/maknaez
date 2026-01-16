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
import com.maknaez.service.WishlistService;
import com.maknaez.service.WishlistServiceImpl;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class ProductController {

    private ProductService productService;
    private WishlistService wishlistService;

    public ProductController() {
        this.productService = new ProductServiceImpl();
        this.wishlistService = new WishlistServiceImpl();
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
        
        List<ProductDTO> sizeList = productService.listProductSizes(prodId);

        ModelAndView mav = new ModelAndView("product/detail");
        mav.addObject("dto", dto); 
        mav.addObject("sizeList", sizeList); 
        
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
}