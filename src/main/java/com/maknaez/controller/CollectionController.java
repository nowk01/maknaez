package com.maknaez.controller;

import java.io.IOException;
import java.sql.SQLException;

import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.view.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/collections") 
public class CollectionController {

    public CollectionController() {
    }

    @RequestMapping("/list") 
    public ModelAndView list(HttpServletRequest req, HttpServletResponse resp) throws SQLException, IOException {
        String category = req.getParameter("category");
        String sub = req.getParameter("sub");
        
        // 카테고리가 없으면 기본값 설정
        if (category == null || category.isEmpty()) {
            category = "men";
        }

        String categoryName = "전체 상품";
        
        switch (category.toLowerCase()) {
            case "men":
                categoryName = "남성";
                break;
            case "women":
                categoryName = "여성";
                break;
            case "sports":
                categoryName = "스포츠 스타일";
                break;
            case "sale":
                categoryName = "세일";
                break;
            default:
                categoryName = "남성";
                category = "men";
                break;
        }

        String viewName = "collections/list"; 
        
        ModelAndView mav = new ModelAndView(viewName);
        
        mav.addObject("categoryCode", category.toLowerCase()); 
        mav.addObject("categoryName", categoryName);           
        
        return mav;
    }
}