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
@RequestMapping("/admin/cs/*")
public class CsManageController {
	@GetMapping("inquiry_list")
	public ModelAndView inquiryList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/cs/inquiry_list");
		
		return mav;
	}
	
	@GetMapping("notice_list")
	public ModelAndView noticeList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/cs/notice_list");
		
		return mav;
	}
	
	@GetMapping("qna_list")
	public ModelAndView qnaList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/cs/qna_list");
		
		return mav;
	}
	
	@GetMapping("review_list")
	public ModelAndView reviewList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/cs/review_list");
		
		return mav;
	}
}
