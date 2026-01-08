package com.maknaez.filter;

import java.io.IOException;

import com.maknaez.model.SessionInfo;

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

/*
  - Filter
    : 요청(request)과 응답(response)를 가로채어 전후처리를 할수 있는 
      재사용가능한 컴포넌트
    : 주로 공통기능을 처리하기 위해 사용
    : 요청(request) 전 - 인증, 권한검사, 인코딩, 로깅등
    : 응답(response) 전 - 응답압축, 응답내용변경, 보안해더추가등
 */

@WebFilter("/*")
public class LoginFilter implements Filter {
	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
	
		// request 필터
		
		// 로그인 체크
		HttpServletRequest req = (HttpServletRequest)request;
		HttpServletResponse resp = (HttpServletResponse)response;
		HttpSession session = req.getSession();
		
		String uri = req.getRequestURI();
		String cp = req.getContextPath();
		
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		
		if(info == null && isExcludeUri(req) == false) {
			if(isAjaxRequest(req)) {
				resp.sendError(403);
			} else {
				// 로그인 전 주소가 존재하는 경우 로그인 전 주소로 가기 위해 세션에 로그인 전주소 저장
				// 로그인 주소로 돌아가는 코드는 login 에서 처리
				
				// uri에서 ContextPath 제거
				if(uri.indexOf(req.getContextPath()) == 0) {
					uri = uri.substring(req.getContextPath().length());
				}
				uri = "redirect:" + uri;
				
				String queryString = req.getQueryString();
				if(queryString != null) {
					uri += "?" + queryString;
				}
				session.setAttribute("preLoginURI", uri);
				
				resp.sendRedirect(cp + "/member/login");
			}

			return;
		} else if(info != null && uri.indexOf("admin") != -1) {
			if(info.getUserLevel() < 51) {
				resp.sendRedirect(cp + "/member/noAuthorized");
				return;
			}
		}
		
		// 다음 필터 또는 필터의 마지막이면 end-pointer(서블릿, jsp 등)를 실행
		chain.doFilter(request, response);
		
		// response 필터
	}

	@Override
	public void destroy() {
	}
	
	// 요청이 AJAX 인지를 확인하는 메소드
	private boolean isAjaxRequest(HttpServletRequest req) {
		String h = req.getHeader("AJAX");
		
		return h != null && h.equals("true");
	}
	
	// 로그인 체크가 필요하지 않는지의 여부 판단
	private boolean isExcludeUri(HttpServletRequest req) {
		String uri = req.getRequestURI();
		String cp = req.getContextPath();
		uri = uri.substring(cp.length());
		
		String []uris = {
				"/index.jsp", "/main", 
				"/member/login", "/member/logout",
				"/member/account", "/member/userIdCheck", "/member/complete",
				"/member/consent", // [추가됨] 약관 동의 페이지는 로그인 없이 접근 가능해야 함
				"/uploads/product/**",
				"/dist/**",
				"/collections/**", 
				"/product/**"
		};
		
		if(uri.length() <= 1) {
			return true;
		}
		
		for(String s : uris) {
			if(s.lastIndexOf("**") != -1) {
                s = s.substring(0, s.lastIndexOf("**"));
                if(uri.indexOf(s) == 0) {
					return true;
				}
			} else if(uri.equals(s)) {
				return true;
			}
		}
		
		return false;
	}

}