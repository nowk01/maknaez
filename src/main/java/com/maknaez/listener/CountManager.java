package com.maknaez.listener;

import java.util.Calendar;
import java.util.Timer;
import java.util.TimerTask;

import jakarta.servlet.ServletContext;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;

/*
  - HttpSessionListener
    : 세션이 생성되거나 소멸될때 발생하는 세션 이벤트를 처리하는 리스너
*/

@WebListener // 이벤트 등록
public class CountManager implements HttpSessionListener {
	private static int currentCount;
	private static long todayCount = 1523;
	
	public static void init(long today) {
		todayCount = today;
	}
	
	public CountManager() {
		// 자정이 되면 오늘인원은 어제 인원으로 변경하고, 오늘 인원은 0으로 설정
		TimerTask task = new TimerTask() {
			
			@Override
			public void run() {
				todayCount = 0;
			}
		};
		
		Timer timer = new Timer();
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, 1);
		
		cal.set(Calendar.HOUR, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		
		// 밤 12시마다 1번씩 실행
		timer.schedule(task, cal.getTime(), 1000 * 60 * 60 * 24);
	}

	@Override
	public void sessionCreated(HttpSessionEvent se) {
		// 세션이 생성될때 호출
		/*
 			- session.invalidate(); 를 호출하면 세션이 무효화 되고
 			  다시 세션이 생성되므로 로그아웃할때 마다 호출됨
		*/
		
		HttpSession session = se.getSession();
		
		// 웹서버의 설정 정보를 가지고 있는 객체
		ServletContext context = session.getServletContext();
		
		// 접속자 인원수 증가
		synchronized(se) {
			currentCount++;
			todayCount++;
			
			context.setAttribute("currentCount", currentCount);
			context.setAttribute("todayCount", todayCount);;
		}
		
	}
	
	@Override
	public void sessionDestroyed(HttpSessionEvent se) {
		// 세션이 소멸될때 호출
		
		HttpSession session = se.getSession();
		ServletContext context = session.getServletContext();
		
		synchronized (se) {
			currentCount--;
			if(currentCount < 0) {
				currentCount = 0;
			}
			
			context.setAttribute("currentCount", currentCount);
			context.setAttribute("todayCount", todayCount);		
		}
		
	}

	public static int getCurrentCount() {
		return currentCount;
	}

	public static long getTodayCount() {
		return todayCount;
	}
	
}
