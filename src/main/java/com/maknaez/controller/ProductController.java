package com.maknaez.controller;

import java.io.IOException;

import com.maknaez.model.ProductDTO;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.view.ModelAndView;
import com.maknaez.service.ProductService;
import com.maknaez.service.ProductServiceImpl;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class ProductController {

    private ProductService productService;

    public ProductController() {
        this.productService = new ProductServiceImpl();
    }
    
    @GetMapping("/product/detail") 
    public ModelAndView detail(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        
        String prodIdStr = req.getParameter("prod_id");
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

        ModelAndView mav = new ModelAndView("product/detail");
        mav.addObject("dto", dto); 

        return mav;
    }
}