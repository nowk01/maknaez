package com.maknaez.filter;

import java.io.IOException;

import com.maknaez.mybatis.support.SqlSessionManager;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;

// 트랜잭션 필터
@WebFilter(urlPatterns = "/*")
public class MyBatisTransactionFilter implements Filter {

	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {

		try {
			chain.doFilter(req, res);
			SqlSessionManager.commit();
		} catch (Exception e) {
			SqlSessionManager.rollback();
			throw e;
		} finally {
			SqlSessionManager.close();
		}
	}

}
