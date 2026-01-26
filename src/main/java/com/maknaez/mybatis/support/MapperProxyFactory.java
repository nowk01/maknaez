package com.maknaez.mybatis.support;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Proxy;
import java.sql.SQLException;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;

public class MapperProxyFactory {
	@SuppressWarnings("unchecked")
	public static <T> T create(Class<T> mapperClass) {

		return (T) Proxy.newProxyInstance(
				mapperClass.getClassLoader(), 
				new Class[] { mapperClass },
				(proxy, method, args) -> {
					SqlSession session = SqlSessionManager.getSession();

					Object mapper = session.getMapper(mapperClass);
					try {
						return method.invoke(mapper, args);
					} catch (InvocationTargetException e) {
						Throwable target = e.getTargetException();

	                    if (target instanceof PersistenceException pe) {
	                        Throwable cause = pe.getCause();

	                        if (cause instanceof SQLException) {
	                            throw cause;
	                        }

	                        throw pe;
	                    }
	                    
						if (target instanceof SQLException) {
							throw target;
						}

						if (target instanceof RuntimeException) {
							throw target;
						}

						throw new RuntimeException(target);
					}
				}

		);
	}
}
