package com.maknaez.controller;

import java.util.ArrayList;
import java.util.List;

import com.maknaez.model.ProductDTO;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.annotation.ResponseBody;
import com.maknaez.mvc.view.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/collections")
public class CollectionController {

    public CollectionController() {
    }

    @GetMapping("/collections/list")
    public ModelAndView list(HttpServletRequest req, HttpServletResponse resp) {
        String category = req.getParameter("category");
        
        if (category == null || category.isEmpty()) {
            category = "men";
        }

        String categoryName = category.equalsIgnoreCase("women") ? "여성" : category.equalsIgnoreCase("kids") ? "아동":"남성";
        String viewName = "collections/list"; 
        
        ModelAndView mav = new ModelAndView(viewName);
        mav.addObject("categoryCode", category.toLowerCase());
        mav.addObject("categoryName", categoryName);
        
        return mav;
    }

 
        @GetMapping("/api/list")
        @ResponseBody
        public List<ProductDTO> listData(HttpServletRequest request, HttpServletResponse response) {
            String category = request.getParameter("category");
            
            // 더미 데이터 생성 (DB 연동 전 테스트용)
            List<ProductDTO> dummyList = new ArrayList<>();
            
            // 더미 데이터 1
//            ProductDTO p1 = new ProductDTO();
//            p1.setId(1);
//            p1.setName("XT-6");
//            p1.setPrice(280000);
//            p1.setCategory("Sportstyle");
//            p1.setNew(true);
//            p1.setImageUrl("/uploads/product/shoes1-1.jpg"); 
//            
//            dummyList.add(p1);

            return dummyList; // 프레임워크가 자동으로 JSON으로 변환하여 반환
    }
    
    

}