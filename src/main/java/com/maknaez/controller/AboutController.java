package com.maknaez.controller;

import java.io.IOException;

import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.view.ModelAndView;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/about")
public class AboutController {

	@GetMapping("intro")
	public ModelAndView intro(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		return new ModelAndView("about/intro");
	}

	@GetMapping("store")
	public ModelAndView store(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		return new ModelAndView("about/store");
	}
	
	@GetMapping("terms")
	public ModelAndView termsForm(HttpServletRequest req, HttpServletResponse resp) {
		return new ModelAndView("about/terms");
	}

	@GetMapping("privacy")
	public ModelAndView privacyForm(HttpServletRequest req, HttpServletResponse resp) {
	    return new ModelAndView("about/privacy");
	}
}