package com.maknaez.controller.admin;

import java.io.IOException;

import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.view.ModelAndView;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/admin/order/*")
public class orderManageController {
	
	@GetMapping("order_list")
	public ModelAndView orderList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/order/order_list");
		
		return mav;
	}
	
	@GetMapping("claim_list")
	public ModelAndView claimList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/order/claim_list");
		
		return mav;
	}
	
	@GetMapping("estimate_list")
	public ModelAndView estimateList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/order/estimate_list");
		
		return mav;
	}
}
