package com.maknaez.mvc;

import java.lang.reflect.Method;
import java.util.Map;

import com.maknaez.mvc.annotation.ResponseBody;
import com.maknaez.mvc.view.JsonView;
import com.maknaez.mvc.view.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class HandlerExecution {
	private final Object handler;
	private final Method method;

	public HandlerExecution(final Object handler, final Method method) {
		this.handler = handler;
		this.method = method;
	}

	public void handle(final HttpServletRequest req, final HttpServletResponse resp) throws Exception {
		Class<?> cls = method.getReturnType();

		if (cls.getSimpleName().equals("void")) {
			method.invoke(handler, req, resp);
		} else if (cls.getSimpleName().equals("Map")) {
			@SuppressWarnings("unchecked")
			Map<String, Object> model = (Map<String, Object>) method.invoke(handler, req, resp);

			if (method.isAnnotationPresent(ResponseBody.class)) {
				JsonView jsonView = new JsonView();
				jsonView.render(model, req, resp);
			} else {
				String uri = req.getRequestURI();
				String cp = req.getContextPath();
				String viewName = uri.substring(cp.length() + 1);

				if (viewName.lastIndexOf(".") != -1) {
					viewName = viewName.substring(0, viewName.lastIndexOf("."));
				}
				ModelAndView modelAndView = new ModelAndView(viewName, model);
				modelAndView.renderView(req, resp);
			}
		} else if (cls.getSimpleName().equals("String")) {
			String viewName = (String) method.invoke(handler, req, resp);
			ModelAndView modelAndView = new ModelAndView(viewName);
			modelAndView.renderView(req, resp);
		} else {
			ModelAndView modelAndView = (ModelAndView) method.invoke(handler, req, resp);
			modelAndView.renderView(req, resp);
		}
	}
}
