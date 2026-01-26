package com.maknaez.listener;

import java.util.Calendar;
import java.util.Timer;
import java.util.TimerTask;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;

// @WebListener // 이벤트 등록
public class CountManager implements HttpSessionListener {
	private static int currentCount;
	private static long todayCount = 1523;
	
	public static void init(long today) {
		todayCount = today;
	}
	
	public CountManager() {
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
		
		timer.schedule(task, cal.getTime(), 1000 * 60 * 60 * 24);
	}

	@Override
	public void sessionCreated(HttpSessionEvent se) {
		HttpSession session = se.getSession();
		
		ServletContext context = session.getServletContext();
		
		synchronized(se) {
			currentCount++;
			todayCount++;
			
			context.setAttribute("currentCount", currentCount);
			context.setAttribute("todayCount", todayCount);;
		}
		
	}
	
	@Override
	public void sessionDestroyed(HttpSessionEvent se) {
		
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
