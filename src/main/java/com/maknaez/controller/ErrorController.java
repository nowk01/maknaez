package com.maknaez.controller;

import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.view.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class ErrorController {
    @RequestMapping("/error/404") 
    public ModelAndView error404(HttpServletRequest req, HttpServletResponse resp) {
        return new ModelAndView("common/error404");
    }
}