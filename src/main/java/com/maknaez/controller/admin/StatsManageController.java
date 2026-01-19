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
@RequestMapping("/admin/stats/*")
public class StatsManageController {
	
	
	@GetMapping("sales_stats")
	public ModelAndView salesStats(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/stats/sales_stats");
		
		return mav;
	}
	
	@GetMapping("product_stats")
	public ModelAndView productStats(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/stats/product_stats");
		
		return mav;
	}
	
	@GetMapping("customer_stats")
	public ModelAndView customerStats(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/stats/customer_stats");
		
		return mav;
	}
	
	@GetMapping("visitor_stats")
	public ModelAndView visitorStats(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/stats/visitor_stats");
		
		return mav;
	}
}
