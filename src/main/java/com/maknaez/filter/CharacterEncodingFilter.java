package com.maknaez.filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.http.HttpServletRequest;

@WebFilter(
		urlPatterns = "/*",
		initParams = @WebInitParam(name="charset", value = "utf-8")
)
public class CharacterEncodingFilter implements Filter {
	private String charset;
	
	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		charset = filterConfig.getInitParameter("charset");
		if(charset == null || charset.length() == 0) {
			charset = "utf-8";
		}
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		
		if(request instanceof HttpServletRequest) {
			HttpServletRequest req = (HttpServletRequest)request;
			if(req.getMethod().equalsIgnoreCase("POST")) {
				req.setCharacterEncoding("utf-8");
			}
		}
		
		chain.doFilter(request, response);
	}

	@Override
	public void destroy() {
	}
}
