package com.maknaez.controller;

import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.maknaez.model.CartDTO;
import com.maknaez.model.SessionInfo;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.annotation.RequestMethod;
import com.maknaez.mvc.annotation.PostMapping;
import com.maknaez.mvc.annotation.ResponseBody;
import com.maknaez.mvc.view.ModelAndView;
import com.maknaez.service.ProductService;
import com.maknaez.service.ProductServiceImpl;
import com.maknaez.mybatis.support.SqlSessionManager;

@Controller
@RequestMapping("/order") 
public class CartController {

    private ProductService productService = new ProductServiceImpl();

    // 1. 장바구니 페이지 이동
    @RequestMapping(value = "/cart", method = RequestMethod.GET)
    public ModelAndView cartList(HttpServletRequest req, HttpServletResponse resp) {
        HttpSession session = req.getSession();
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) {
            return new ModelAndView("redirect:/member/login");
        }
        return new ModelAndView("order/cart");
    }

    // 2. 장바구니 담기 Ajax 처리 (재고 체크 및 중복 확인 로직 통합)
    @PostMapping("/cart/insert")
    @ResponseBody
    public Map<String, Object> insertCart(CartDTO dto, HttpSession session) {
        Map<String, Object> model = new HashMap<>();
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        
        if (info == null) {
            model.put("state", "login_required");
            return model;
        }

        try {
            // [데이터 세팅] 세션에서 로그인한 사용자의 고유 번호(memberIdx)를 가져옴
            dto.setMemberIdx(info.getMemberIdx());

            // 1. 실시간 재고 확인 (productService에 getOptionStock 메서드가 구현되어 있어야 함)
            // optId를 기준으로 stock_logs의 합계를 가져옵니다.
            int currentStock = productService.getOptionStock(dto.getOptId());
            if (currentStock < dto.getQuantity()) {
                model.put("state", "false");
                model.put("message", "재고가 부족합니다. (현재 재고: " + currentStock + "개)");
                return model;
            }

            // 2. 장바구니 중복 체크 (Canvas에 있는 CartMapper.xml의 checkExistingCart 호출)
            Integer existingCount = SqlSessionManager.getSession().selectOne("com.maknaez.mapper.CartMapper.checkExistingCart", dto);
            
            if (existingCount != null && existingCount > 0) {
                // 이미 존재하면 수량 업데이트
                SqlSessionManager.getSession().update("com.maknaez.mapper.CartMapper.updateCartQuantity", dto);
            } else {
                // 존재하지 않으면 신규 추가
                SqlSessionManager.getSession().insert("com.maknaez.mapper.CartMapper.insertCart", dto);
            }

            model.put("state", "true");
        } catch (Exception e) {
            e.printStackTrace();
            model.put("state", "error");
            model.put("message", "장바구니 담기 중 시스템 오류가 발생했습니다.");
        }
        
        return model;
    }
}