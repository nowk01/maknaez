package com.maknaez.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.maknaez.model.SessionInfo;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.annotation.RequestMethod;
import com.maknaez.mvc.view.ModelAndView;

@Controller
@RequestMapping("/order") 
public class CartController {

    @RequestMapping(value = "/cart", method = RequestMethod.GET)
    public ModelAndView cartList(HttpServletRequest req, HttpServletResponse resp) {
        HttpSession session = req.getSession();
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) {
            return new ModelAndView("redirect:/member/login");
        }
        ModelAndView mav = new ModelAndView("order/cart");
        
        // 추후 DB에서 장바구니 리스트를 가져와서 담을 때: 구현중 
        // mav.addObject("list", cartList); 

        return mav;
    }
}