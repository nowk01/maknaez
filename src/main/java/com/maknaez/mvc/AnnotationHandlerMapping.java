package com.maknaez.mvc;

import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import com.maknaez.mvc.annotation.DeleteMapping;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.PostMapping;
import com.maknaez.mvc.annotation.PutMapping;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.annotation.RequestMethod;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;

public class AnnotationHandlerMapping implements HandlerMapping {

	private final String[] basePackages;
	private final Map<HandlerKey, HandlerExecution> handlerExecutions;

	public AnnotationHandlerMapping(final String... basePackages) {
		this.basePackages = basePackages;
		this.handlerExecutions = new HashMap<>();
	}

	@Override
	public void initialize() throws ServletException {
		initHandlerExecution(basePackages);
	}

	@Override
	public HandlerExecution getHandler(final HttpServletRequest req) {
		HandlerKey handlerKey = new HandlerKey(req);
		return handlerExecutions.get(handlerKey);
	}

	private void initHandlerExecution(final String[] basePackages) throws ServletException {

		ControllerScanner controllerScanner = new ControllerScanner();
		Map<Class<?>, Object> controllers = controllerScanner.getControllers(basePackages);

		for (Map.Entry<Class<?>, Object> entry : controllers.entrySet()) {
			Class<?> controller = entry.getKey();
			Object handler = entry.getValue();

			String classUrl = resolveClassUrl(controller);

			List<Method> methods = getMappingMethods(controller);

			long emptyMethodUrlCount = methods.stream().filter(m -> getMethodUrl(m).isEmpty()).count();

			for (Method method : methods) {
				putHandlerExecution(classUrl, method, handler, emptyMethodUrlCount);
			}
		}
	}

	private List<Method> getMappingMethods(Class<?> clazz) {
		return Arrays.stream(clazz.getDeclaredMethods()).filter(this::isRequestMappingMethod)
				.collect(Collectors.toList());
	}

	private boolean isRequestMappingMethod(Method method) {
		return method.isAnnotationPresent(RequestMapping.class) || method.isAnnotationPresent(GetMapping.class)
				|| method.isAnnotationPresent(PostMapping.class) || method.isAnnotationPresent(PutMapping.class) 
				|| method.isAnnotationPresent(DeleteMapping.class);
	}

	/**
	 * 클래스 레벨 URL 처리
	 */
	private String resolveClassUrl(Class<?> controller) {
		if (!controller.isAnnotationPresent(RequestMapping.class)) {
			return "";
		}

		String url = controller.getAnnotation(RequestMapping.class).value();

		if (url.endsWith("/*")) {
			url = url.substring(0, url.length() - 2);
		}

		return url;
	}

	private void putHandlerExecution(String classUrl, Method method, Object handler, long emptyMethodUrlCount)
			throws ServletException {

		MappingInfo mappingInfo = extractMappingInfo(method);
		String methodUrl = mappingInfo.url;

		String finalUrl;

		// 메서드 절대경로
		if (!methodUrl.isEmpty() && methodUrl.startsWith("/")) {
			finalUrl = methodUrl;

			// 메서드 URL 없음
		} else if (methodUrl.isEmpty()) {

			if (classUrl.isEmpty()) {
				throw new ServletException("클래스 URL과 메서드 URL이 모두 없습니다: " + method.getName());
			}

			if (emptyMethodUrlCount > 1) {
				throw new ServletException("클래스 URL [" + classUrl + "] 에 매핑된 메서드가 둘 이상 존재합니다.");
			}

			finalUrl = classUrl;

			// 클래스 + 상대경로
		} else {
			finalUrl = classUrl.endsWith("/") ? classUrl + methodUrl : classUrl + "/" + methodUrl;
		}

		for (RequestMethod requestMethod : mappingInfo.methods) {
			HandlerKey key = new HandlerKey(finalUrl, requestMethod);

			if (handlerExecutions.containsKey(key)) {
				throw new ServletException(key + " : URI 가 중복되었습니다.");
			}

			handlerExecutions.put(key, new HandlerExecution(handler, method));
		}
	}

	/**
	 * 메서드의 매핑 정보를 RequestMapping / GetMapping / PostMapping / PutMapping / DeleteMapping 에서 추출
	 */
	private MappingInfo extractMappingInfo(Method method) {

		if (method.isAnnotationPresent(GetMapping.class)) {
			GetMapping gm = method.getAnnotation(GetMapping.class);
			return new MappingInfo(gm.value(), new RequestMethod[] { RequestMethod.GET });
		}

		if (method.isAnnotationPresent(PostMapping.class)) {
			PostMapping pm = method.getAnnotation(PostMapping.class);
			return new MappingInfo(pm.value(), new RequestMethod[] { RequestMethod.POST });
		}

		if (method.isAnnotationPresent(PutMapping.class)) {
			PutMapping pm = method.getAnnotation(PutMapping.class);
			return new MappingInfo(pm.value(), new RequestMethod[] { RequestMethod.PUT });
		}
		
		if (method.isAnnotationPresent(DeleteMapping.class)) {
			DeleteMapping dm = method.getAnnotation(DeleteMapping.class);
			return new MappingInfo(dm.value(), new RequestMethod[] { RequestMethod.DELETE });
		}
		
		RequestMapping rm = method.getAnnotation(RequestMapping.class);

		RequestMethod[] methods = rm.method().length == 0
				? new RequestMethod[] { RequestMethod.GET, RequestMethod.POST }
				: rm.method();

		return new MappingInfo(rm.value(), methods);
	}

	private String getMethodUrl(Method method) {
		if (method.isAnnotationPresent(GetMapping.class)) {
			return method.getAnnotation(GetMapping.class).value();
		}
		if (method.isAnnotationPresent(PostMapping.class)) {
			return method.getAnnotation(PostMapping.class).value();
		}
		if (method.isAnnotationPresent(PutMapping.class)) {
			return method.getAnnotation(PutMapping.class).value();
		}
		if (method.isAnnotationPresent(DeleteMapping.class)) {
			return method.getAnnotation(DeleteMapping.class).value();
		}
		
		return method.getAnnotation(RequestMapping.class).value();
	}

	private static class MappingInfo {
		String url;
		RequestMethod[] methods;

		MappingInfo(String url, RequestMethod[] methods) {
			this.url = url;
			this.methods = methods;
		}
	}
}
