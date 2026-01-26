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
		
		// 정적 리소스 경로 및 확장자 설정
		String[] uris = {
			"/dist/*", "/uploads/*", "/resources/*", 
			"*.css", "*.js", "*.html", "*.htm",
			"*.png", "*.jpg", "*.jpeg", "*.gif", "*.ico", "*.svg", 
			"*.woff", "*.woff2", "*.ttf", "*.eot" 
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