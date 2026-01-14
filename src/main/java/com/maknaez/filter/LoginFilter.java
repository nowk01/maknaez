package com.maknaez.filter;

import java.io.IOException;

import com.maknaez.model.SessionInfo;

import jakarta.servlet.DispatcherType;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebFilter(urlPatterns = "/*", dispatcherTypes = {DispatcherType.REQUEST})
public class LoginFilter implements Filter {
	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse resp = (HttpServletResponse) response;
		HttpSession session = req.getSession();

		if (isResourceUrl(req)) {
			chain.doFilter(request, response);
			return;
		}

		String uri = req.getRequestURI();
		String cp = req.getContextPath();
		
		if (uri.endsWith("/index2.jsp")) {
			resp.sendRedirect(cp + "/admin");
			return;
		}

		String path = uri;
		if (path.startsWith(cp)) {
			path = path.substring(cp.length());
		}

		SessionInfo info = (SessionInfo) session.getAttribute("member");

		// 1. 로그인이 필요한 페이지인데 로그인을 안 한 경우
		if (info == null && !isExcludeUri(req)) {
			if (isAjaxRequest(req)) {
				resp.sendError(403);
			} else {
				if (!path.equals("/admin/login") && !path.equals("/member/login")) {
					String returnUri = "redirect:" + path;
					String queryString = req.getQueryString();
					if (queryString != null) {
						returnUri += "?" + queryString;
					}
					session.setAttribute("preLoginURI", returnUri);
				}

				// 관리자 페이지(/admin) 접근 시도였다면 관리자 로그인으로 이동
				if (path.startsWith("/admin")) {
					resp.sendRedirect(cp + "/admin/login");
				} else {
					resp.sendRedirect(cp + "/member/login");
				}
			}
			return;
		}

		// 2. 로그인은 했으나 관리자 페이지(/admin)에 권한 없이 접근하는 경우
		else if (info != null && path.startsWith("/admin")) {
			// 관리자 로그인 페이지나 로그아웃은 통과
			if (path.equals("/admin/login") || path.equals("/member/logout")) {
				chain.doFilter(request, response);
				return;
			}

			// 권한 체크 (레벨 51 미만은 접근 불가)
			if (info.getUserLevel() < 51) {
				resp.sendRedirect(cp + "/member/noAuthorized");
				return;
			}
		}

		chain.doFilter(request, response);
	}

	@Override
	public void destroy() {
	}

	private boolean isAjaxRequest(HttpServletRequest req) {
		String h = req.getHeader("AJAX");
		return h != null && "true".equals(h);
	}

	private boolean isResourceUrl(HttpServletRequest req) {
		String uri = req.getRequestURI().toLowerCase();
		return uri.endsWith(".css") || uri.endsWith(".js") || 
			   uri.endsWith(".png") || uri.endsWith(".jpg") || uri.endsWith(".jpeg") || 
			   uri.endsWith(".gif") || uri.endsWith(".ico") || uri.endsWith(".svg") ||
			   uri.endsWith(".woff") || uri.endsWith(".ttf");
	}

	private boolean isExcludeUri(HttpServletRequest req) {
		String uri = req.getRequestURI();
		String cp = req.getContextPath();
		String path = uri.substring(cp.length());

		if (path.contains("/admin/login") || path.contains("/dist/") || path.contains("/uploads/")) {
			return true;
		}

		String[] excludeUrls = {
			"/index.jsp", "/main", "/index2.jsp",
			"/member/login", "/member/logout",
			"/member/account", "/member/userIdCheck", "/member/complete",
			"/member/nickNameCheck", 
			"/member/consent",
			"/about/intro",
			"/about/store",
			"/about/terms",
			"/about/privacy",
			"/collections/**", 
			"/product/**"
		};

		if (path.length() <= 1) { 
			return true;
		}

		for (String s : excludeUrls) {
			if (s.endsWith("**")) {
				String prefix = s.substring(0, s.length() - 2);
				if (path.startsWith(prefix)) {
					return true;
				}
			} else {
				if (path.equals(s)) {
					return true;
				}
			}
		}
		return false;
	}
}