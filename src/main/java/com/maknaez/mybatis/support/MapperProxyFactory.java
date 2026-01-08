package com.maknaez.mybatis.support;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Proxy;
import java.sql.SQLException;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;

/*
  - 프록시(Proxy)
    : 프록시는 '대리인'이라는 뜻한다.
    : 클라이언트가 실제 대상 객체(Target)를 직접 호출하는 대신, 
      프록시 객체를 거쳐 호출하게 함으로써 부가적인 기능(로깅, 트랜잭션, 권한 체크 등)을 수행할 수 있도록 한다.
    : 프록시는 인터페이스 기반으로 생성된다.
  - java.lang.reflect.Proxy
    :런타임에 동적으로 프록시 객체를 생성할 수 있게 해주는 도구
*/

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

						// MyBatis 예외
	                    if (target instanceof PersistenceException pe) {
	                        Throwable cause = pe.getCause();

	                        // SQLException 하위면 그대로 던짐
	                        if (cause instanceof SQLException) {
	                            throw cause;
	                        }

	                        // 그 외 MyBatis 예외는 유지
	                        throw pe;
	                    }
	                    
						// SQLException 그대로 던짐
						if (target instanceof SQLException) {
							throw target;
						}

						// RuntimeException 유지
						if (target instanceof RuntimeException) {
							throw target;
						}

						// 기타 예외
						throw new RuntimeException(target);
					}
				}

		);
	}
}
