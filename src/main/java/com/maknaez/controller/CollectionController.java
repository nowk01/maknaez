package com.maknaez.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

        // 1. 스포츠 카테고리 리스트 생성 (추가됨)
        List<String> sportList = new ArrayList<>();
        sportList.add("로드러닝");
        sportList.add("트레일러닝");
        sportList.add("하이킹");
        sportList.add("스포츠스타일");
        sportList.add("샌들/워터슈즈");

        // 2. 성별 리스트 생성 (추가됨)
        List<String> genderList = new ArrayList<>();
        genderList.add("남성");
        genderList.add("여성");
        genderList.add("Unisex");

        // 3. 색상 리스트 생성
        List<Map<String, String>> colorList = new ArrayList<>();
        String[] colors = {"블랙", "화이트", "그레이", "레드", "블루", "그린", "베이지", "브라운", "옐로우"};
        String[] hexes = {"#000000", "#FFFFFF", "#808080", "#E32526", "#0057B8", "#006F44", "#DBCFB6", "#6E4E37", "#FFD100"};
        
        for (int i = 0; i < colors.length; i++) {
            Map<String, String> map = new HashMap<>();
            map.put("name", colors[i]);
            map.put("hex", hexes[i]);
            colorList.add(map);
        }

        String viewName = "collections/list"; 
        
        ModelAndView mav = new ModelAndView(viewName);
        
        mav.addObject("categoryCode", category.toLowerCase()); 
        mav.addObject("categoryName", categoryName);
        
        // 모델에 리스트 추가
        mav.addObject("sportList", sportList);   // JSP로 스포츠 리스트 전달
        mav.addObject("genderList", genderList); // JSP로 성별 리스트 전달
        mav.addObject("colorList", colorList);   // JSP로 색상 리스트 전달
        
        return mav;
    }
}