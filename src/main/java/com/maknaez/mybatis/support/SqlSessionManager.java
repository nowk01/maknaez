package com.maknaez.mybatis.support;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

public class SqlSessionManager {
	private static SqlSessionFactory factory;
	private static final ThreadLocal<SqlSession> local = new ThreadLocal<>();
	private static final ThreadLocal<Boolean> rollbackOnly = new ThreadLocal<>();

	public static void init(SqlSessionFactory f) {
		factory = f;
	}

	public static SqlSession getSession() {
		SqlSession session = local.get();
		if (session == null) {
			session = factory.openSession(false);
			local.set(session);
			rollbackOnly.set(false); 
		}

		return session;
	}

	public static void setRollbackOnly() {
		rollbackOnly.set(true);
	}

	public static boolean isRollbackOnly() {
		Boolean flag = rollbackOnly.get();
		return flag != null && flag;
	}

	public static void commit() {
		SqlSession session = local.get();
		if (session != null) {
			if (isRollbackOnly()) {
				session.rollback();
			} else {
				session.commit();
			}
		}
	}

	public static void rollback() {
		SqlSession session = local.get();
		if (session != null) {
			session.rollback();
		}
	}

	public static void close() {
		SqlSession session = local.get();
		if (session != null) {
			session.close();
		}
		local.remove();
		rollbackOnly.remove();
	}
}
