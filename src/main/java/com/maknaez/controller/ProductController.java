package com.maknaez.controller;

import java.util.ArrayList;
import java.util.List;

import com.maknaez.model.ProductDTO;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.view.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/product")
public class ProductController {

    @GetMapping("/detail")
    public ModelAndView detail(HttpServletRequest req, HttpServletResponse resp) {
        // [View 경로] /WEB-INF/views/product/detail.jsp 로 이동
        // DispatcherServlet 내부의 ViewResolver(혹은 JspView) 설정에 따라 
        // prefix(/WEB-INF/views/)와 suffix(.jsp)가 결합됩니다.
        ModelAndView mav = new ModelAndView("product/detail");

        // 1. 파라미터 수신 (productNo)
        String productNoStr = req.getParameter("productNo");
        
        // [디버깅 로그] 요청이 들어왔는지 콘솔에서 확인
        System.out.println("[ProductController] detail 요청 진입 - productNo: " + productNoStr);
        
        long productNo = 0;
        
        try {
            if(productNoStr != null && !productNoStr.isEmpty()) {
                productNo = Long.parseLong(productNoStr);
            }
        } catch (NumberFormatException e) {
            System.out.println("[ProductController] productNo 파싱 에러: " + e.getMessage());
            e.printStackTrace();
        }

        // 2. [가상 데이터] DB 연동 전, DTO 필드에 맞춘 Mock Data 생성
        ProductDTO dto = new ProductDTO();
        
        // 파라미터가 없으면 1001번을 기본값으로 사용
        long currentId = (productNo != 0) ? productNo : 1001;
        
        dto.setProductNo(currentId);
        dto.setProductName("XT-6 Gore-Tex (상품번호: " + currentId + ")");
        dto.setPrice(280000);
        dto.setCategoryNo(10); // 카테고리 코드 (10: 스포츠스타일 가정)
        dto.setIsDisplayed(1); // 1: 진열함
        dto.setImageFile("xt6_black.jpg"); // 이미지 파일명 예시
        dto.setRegDate("2024-01-01");
        
        // 상세 설명 (HTML 태그 포함)
        String desc = "<b>상품 번호 " + currentId + "번</b>에 대한 상세 페이지입니다.<br>"
                    + "이 제품은 살로몬의 트레일 유산이 담긴 기술력에 방수 기능을 더한 제품입니다.<br>"
                    + "어떠한 지형에서도 최상의 퍼포먼스를 제공합니다.";
        dto.setContent(desc);
        
        // [중요] ProductDTO에는 categoryName 필드가 없으므로, 별도로 전달합니다.
        // 추후 JOIN 쿼리를 통해 DTO에 필드를 추가하거나 Map으로 처리할 수 있습니다.
        String categoryName = "스포츠스타일"; 

        // 3. [추천 상품] 하단 캐러셀용 리스트 구성 (Mock Data)
        List<ProductDTO> recommendList = new ArrayList<>();
        for(int i=1; i<=8; i++) {
            ProductDTO p = new ProductDTO();
            p.setProductNo(i + 100);
            p.setProductName("추천 모델 0" + i);
            p.setPrice(200000 + (i * 5000));
            p.setImageFile("thumb_" + i + ".jpg"); // 실제 이미지가 없다면 jsp에서 onerror 처리 필요
            recommendList.add(p);
        }

        // 4. View로 데이터 전달
        // JSP에서는 ${dto.productName}, ${categoryName}, ${recommendList} 등으로 접근 가능
        mav.addObject("dto", dto);
        mav.addObject("categoryName", categoryName);
        mav.addObject("recommendList", recommendList);
        
        System.out.println("[ProductController] 데이터 바인딩 완료 -> View 이동");
        
        return mav;
    }
}