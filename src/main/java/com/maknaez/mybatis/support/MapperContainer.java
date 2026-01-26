package com.maknaez.mybatis.support;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class MapperContainer {
	private static final Map<Class<?>, Object> mapperMap = new ConcurrentHashMap<>();

	public static <T> void register(Class<T> clazz) {
		mapperMap.put(clazz, MapperProxyFactory.create(clazz));
	}

	@SuppressWarnings("unchecked")
	public static <T> T get(Class<T> clazz) {
		return (T) mapperMap.get(clazz);
	}
}
