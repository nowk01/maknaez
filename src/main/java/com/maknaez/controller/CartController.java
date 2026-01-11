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
        // 디버깅: 컨트롤러 진입 확인
        System.out.println("[CartController] /order/cart 진입");

        HttpSession session = req.getSession();
        SessionInfo info = (SessionInfo) session.getAttribute("member");

        // 1. 로그인 여부 확인
        if (info == null) {
            System.out.println("[CartController] 비로그인 상태 -> 로그인 이동");
            // setViewName 대신 생성자를 사용하여 리다이렉트 주소 설정
            return new ModelAndView("redirect:/member/login");
        }

        // 2. 로그인 된 경우: 장바구니 화면으로 이동
        System.out.println("[CartController] 로그인 유저: " + info.getUserId());
        
        // setViewName 대신 생성자에 뷰 경로("order/cart")를 바로 주입해야 합니다.
        ModelAndView mav = new ModelAndView("order/cart");
        
        // 추후 DB에서 장바구니 리스트를 가져와서 담을 때:
        // mav.addObject("list", cartList); 

        return mav;
    }
}