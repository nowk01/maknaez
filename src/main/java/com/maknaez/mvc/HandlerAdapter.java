package com.maknaez.mvc;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public interface HandlerAdapter {
	public boolean supports(Object handler);
	public void handle(HttpServletRequest req, HttpServletResponse resp, Object handler) throws Exception;
}
