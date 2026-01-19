package com.maknaez.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.maknaez.model.CartDTO;
import com.maknaez.model.SessionInfo;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.annotation.RequestMethod;
import com.maknaez.mvc.annotation.ResponseBody;
import com.maknaez.mvc.view.ModelAndView;
import com.maknaez.service.CartService;
import com.maknaez.service.CartServiceImpl;

@Controller
public class CartController {
    
    private CartService service = new CartServiceImpl();

    // 1. 장바구니 담기 (Ajax)
    @ResponseBody
    @RequestMapping(value = "/cart/insert", method = RequestMethod.POST)
    public Map<String, Object> insert(HttpServletRequest req, HttpServletResponse resp) {
        Map<String, Object> model = new HashMap<>();
        HttpSession session = req.getSession();
        SessionInfo info = (SessionInfo) session.getAttribute("member");

        if (info == null) {
            model.put("status", "login_required");
            return model;
        }

        try {
            long prodId = Long.parseLong(req.getParameter("prodId"));
            // optId 파라미터 처리 (옵션이 없는 경우 0 또는 예외처리)
            String optIdStr = req.getParameter("optId");
            long optId = (optIdStr != null && !optIdStr.isEmpty()) ? Long.parseLong(optIdStr) : 0; 
            
            int quantity = Integer.parseInt(req.getParameter("quantity"));

            CartDTO dto = new CartDTO();
            dto.setMemberIdx(info.getMemberIdx());
            dto.setProdId(prodId);
            dto.setOptId(optId);
            dto.setQuantity(quantity);

            service.insertCart(dto);

            model.put("status", "success");
        } catch (Exception e) {
            e.printStackTrace();
            model.put("status", "fail");
            model.put("message", e.getMessage());
        }

        return model;
    }

    // 2. 장바구니 목록 페이지 (URL 수정: /cart/list -> /order/cart)
    // 에러 원인 해결: 사용자가 접근하는 URL(/order/cart)과 매핑을 일치시킴
    @RequestMapping(value = "/order/cart", method = RequestMethod.GET)
    public ModelAndView list(HttpServletRequest req, HttpServletResponse resp) {
        // View 경로: /WEB-INF/views/order/cart.jsp
        ModelAndView mav = new ModelAndView("order/cart");
        
        HttpSession session = req.getSession();
        SessionInfo info = (SessionInfo) session.getAttribute("member");

        // 비로그인 상태면 로그인 페이지로 리다이렉트
        if (info == null) {
            return new ModelAndView("redirect:/member/login");
        }

        // 서비스 호출
        List<CartDTO> list = service.listCart(info.getMemberIdx());
        
        // 총 금액 계산
        int totalProdPrice = 0;
        if(list != null) {
            for(CartDTO dto : list) {
                totalProdPrice += (dto.getProdPrice() * dto.getQuantity());
            }
        }

        // JSP로 데이터 전달
        mav.addObject("list", list);
        mav.addObject("count", list != null ? list.size() : 0);
        mav.addObject("totalProdPrice", totalProdPrice);
        mav.addObject("deliveryFee", 0); // 무료배송

        return mav;
    }
    
 // 3. 장바구니 삭제 (Ajax)
    @ResponseBody
    @RequestMapping(value = "/cart/delete", method = RequestMethod.POST)
    public Map<String, Object> delete(HttpServletRequest req, HttpServletResponse resp) {
        Map<String, Object> model = new HashMap<>();
        
        HttpSession session = req.getSession();
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) {
            model.put("status", "login_required");
            return model;
        }
        
        try {
            // [수정] JS에서 traditional: true로 보낼 경우 "cartIds"로 받음
            String[] ids = req.getParameterValues("cartIds");
            
            // 만약 JS에서 traditional 옵션 없이 보냈다면 "cartIds[]"로 받아야 함 (호환성 유지)
            if (ids == null) {
                ids = req.getParameterValues("cartIds[]");
            }
            
            // 단일 삭제의 경우 (deleteItem 함수는 cartId 파라미터를 보냄)
            if(ids == null) {
                String id = req.getParameter("cartId"); // 단일 값
                if(id != null) ids = new String[]{id};
            }
            
            if(ids != null && ids.length > 0) {
                List<Long> list = new ArrayList<>();
                for(String s : ids) {
                    list.add(Long.parseLong(s));
                }
                service.deleteCart(list);
            }
            
            model.put("status", "success");
        } catch (Exception e) {
            e.printStackTrace();
            model.put("status", "fail");
        }
        
        return model;
    }
    
    // 4. 수량 변경 (Ajax)
    @ResponseBody
    @RequestMapping(value = "/cart/updateQty", method = RequestMethod.POST)
    public Map<String, Object> updateQty(HttpServletRequest req, HttpServletResponse resp) {
        Map<String, Object> model = new HashMap<>();
        
        try {
            long cartId = Long.parseLong(req.getParameter("cartId"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));
            
            service.updateQuantity(cartId, quantity);
            model.put("status", "success");
        } catch (Exception e) {
            e.printStackTrace();
            model.put("status", "fail");
        }
        
        return model;
    }
}