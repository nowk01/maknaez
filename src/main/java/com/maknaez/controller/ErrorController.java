package com.maknaez.controller;

import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.view.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class ErrorController {
    @GetMapping("/error/404")
    public ModelAndView error404(HttpServletRequest req, HttpServletResponse resp) {
        return new ModelAndView("common/error404");
    }
}