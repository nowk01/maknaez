package com.maknaez.controller;

import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.RequestMapping;
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

}