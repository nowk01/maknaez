package com.maknaez.controller.admin;

import java.io.IOException;

import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.view.ModelAndView;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class HomeManageController {
	@RequestMapping("/admin")
	public ModelAndView adminMain(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/home/main");
		
		return mav;
	}
}
