package com.maknaez.mybatis.support;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

// Mapper 객체 저장
public class MapperContainer {
	// ConcurrentHashMap
	//  : 멀티스레드 환경에서 안전하게 데이터를 관리할 수 있도록 설계된 고성능 Map 구현체
	private static final Map<Class<?>, Object> mapperMap = new ConcurrentHashMap<>();

	public static <T> void register(Class<T> clazz) {
		// Mapper Proxy는 1개만 생성
		mapperMap.put(clazz, MapperProxyFactory.create(clazz));
	}

	@SuppressWarnings("unchecked")
	public static <T> T get(Class<T> clazz) {
		return (T) mapperMap.get(clazz);
	}
}
