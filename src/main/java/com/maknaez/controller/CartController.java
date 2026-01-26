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

    // 장바구니 담기 (Ajax)
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

    // 장바구니 목록 페이지
    @RequestMapping(value = "/order/cart", method = RequestMethod.GET)
    public ModelAndView list(HttpServletRequest req, HttpServletResponse resp) {
        ModelAndView mav = new ModelAndView("order/cart");
        
        HttpSession session = req.getSession();
        SessionInfo info = (SessionInfo) session.getAttribute("member");

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
        mav.addObject("deliveryFee", 0);

        return mav;
    }
    
    // 장바구니 삭제 (Ajax)
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
            String[] ids = req.getParameterValues("cartIds");
            
            if (ids == null) {
                ids = req.getParameterValues("cartIds[]");
            }
            
            if(ids == null) {
                String id = req.getParameter("cartId"); 
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
    
    // 수량 변경 (Ajax)
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