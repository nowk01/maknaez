package com.maknaez.listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.ServletRegistration;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class WebAppInit implements ServletContextListener {
	@Override
	public void contextInitialized(ServletContextEvent sce) {
		// 서버가 시작되는 시점에 호출
		
		/*
		  - DefaultServlet 위임 설정
		    : *.css, *.js, 이미지 파일 등 정적인 리소스는 
		      개발자가 만든 FrontController(서블릿)를 거치지 않고 
		      톰캣의 기본 서블릿('default')이 바로 처리하도록 매핑을 추가합니다.
		 */
		
		// 1. 정적 리소스 경로 및 확장자 설정
		String[] uris = {
			"/dist/*", "/uploads/*", "/resources/*", 
			"*.css", "*.js", "*.html", "*.htm",
			"*.png", "*.jpg", "*.jpeg", "*.gif", "*.ico", "*.svg", // 이미지 파일
			"*.woff", "*.woff2", "*.ttf", "*.eot" // 폰트 파일
		};
		
		ServletRegistration registration = sce.getServletContext().getServletRegistration("default");
		if (registration != null) {
			registration.addMapping(uris);
		}
	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		// 서버가 종료되기 직전에 호출
	}
}