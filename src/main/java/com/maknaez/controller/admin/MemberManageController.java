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
@RequestMapping("/admin/member/*")
public class MemberManageController {
	
	@GetMapping("member_list")
	public ModelAndView memberList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/member/member_list");
		
		return mav;
	}
	
	@GetMapping("point_manage")
	public ModelAndView pointManage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/member/point_manage");
		
		return mav;
	}
	
	@GetMapping("dormant_manage")
	public ModelAndView dormantManage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/member/dormant_manage");
		
		return mav;
	}
}
