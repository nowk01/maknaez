package com.maknaez.controller;

import java.io.IOException;
import java.sql.SQLException;

import com.maknaez.model.ProductDTO;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.view.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
// @RequestMapping("/product")  <-- [테스트] 잠시 주석 처리 (매핑 결합 문제 배제)
public class ProductController {

    public ProductController() {
        System.out.println("=================================================");
        System.out.println(">>> [ProductController] 생성자 호출됨 (Bean 등록 성공)");
        System.out.println("=================================================");
    }

    // [중요] 전체 경로를 직접 지정해서 테스트
    @GetMapping("/product/detail") 
    public ModelAndView detail(HttpServletRequest req, HttpServletResponse resp) throws SQLException, IOException {
        System.out.println(">>> [ProductController] detail 메서드 진입 성공!");
        
        String productNoStr = req.getParameter("productNo");
        System.out.println(">>> 요청 파라미터: " + productNoStr);
        
        long productNo = 0;
        try {
            if (productNoStr != null && !productNoStr.isEmpty()) {
                productNo = Long.parseLong(productNoStr);
            } else {
                productNo = 1;
            }
        } catch (NumberFormatException e) {
            productNo = 1;
        }

        ProductDTO dto = new ProductDTO();
        dto.setProductNo(productNo); 
        dto.setProductName("나이키 에어 포스 1 '07 (" + productNo + "번 모델)");
        dto.setPrice((int)(139000 + (productNo * 1000))); 
        dto.setCategoryNo(1);
        
        ModelAndView mav = new ModelAndView("product/detail");
        mav.addObject("dto", dto);
        
        return mav;
    }
}