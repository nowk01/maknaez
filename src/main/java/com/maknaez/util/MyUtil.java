package com.maknaez.util;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.regex.Pattern;

public class MyUtil {
	/**
	 * 전체 페이지 수 구하기
	 * 
	 * @param dataCount 총 데이터 개수
	 * @param size      한화면에 출력할 목록 수
	 * @return 전체 페이지 수
	 */
	public int pageCount(int dataCount, int size) {
		if (dataCount <= 0 || size <= 0) {
			return 0;
		}

		return dataCount / size + (dataCount % size > 0 ? 1 : 0);
	}

	/**
	 * 페이징(paging) 처리(GET 방식)
	 * 
	 * @param current_page 현재 표시되는 페이지 번호
	 * @param total_page   전체 페이지 수
	 * @param list_url     링크를 설정할 주소
	 * @return 페이징 처리 결과
	 */
	public String paging(int current_page, int total_page, String list_url) {
		StringBuilder sb = new StringBuilder();

		int numPerBlock = 10;
		int currentPageSetup;
		int n, page;

		if (current_page < 1 || total_page < current_page || list_url == null) {
			return "";
		}

		list_url += list_url.contains("?") ? "&" : "?";

		currentPageSetup = (current_page / numPerBlock) * numPerBlock;
		if (current_page % numPerBlock == 0) {
			currentPageSetup = currentPageSetup - numPerBlock;
		}

		sb.append("<div class='paginate'>");
		n = current_page - numPerBlock;
		if (total_page > numPerBlock && currentPageSetup > 0) {
			sb.append(createLinkUrl(list_url, 1, "&#x226A"));
			sb.append(createLinkUrl(list_url, n, "&#x003C"));
		}

		page = currentPageSetup + 1;
		while (page <= total_page && page <= (currentPageSetup + numPerBlock)) {
			if (page == current_page) {
				sb.append("<span>" + page + "</span>");
			} else {
				sb.append(createLinkUrl(list_url, page, String.valueOf(page)));
			}
			page++;
		}

		n = current_page + numPerBlock;
		if (n > total_page) {
			n = total_page;
		}
		if (total_page - currentPageSetup > numPerBlock) {
			sb.append(createLinkUrl(list_url, n, "&#x003E"));
			sb.append(createLinkUrl(list_url, total_page, "&#x226B"));
		}
		sb.append("</div>");

		return sb.toString();
	}

	/**
	 * javascript로 페이징(paging) 처리 : javascript 지정 함수 호출
	 * 
	 * @param current_page 현재 표시되는 페이지 번호
	 * @param total_page   전체 페이지 수
	 * @param methodName   호출할 자바 스크립트 함수명
	 * @return 페이징 처리 결과
	 */
	public String pagingMethod(int current_page, int total_page, String methodName) {
		StringBuilder sb = new StringBuilder();

		int numPerBlock = 10; 
		int currentPageSetUp;
		int n, page;

		if (current_page < 1 || total_page < current_page) {
			return "";
		}

		currentPageSetUp = (current_page / numPerBlock) * numPerBlock;
		if (current_page % numPerBlock == 0) {
			currentPageSetUp = currentPageSetUp - numPerBlock;
		}

		sb.append("<div class='paginate'>");

		n = current_page - numPerBlock;
		if ((total_page > numPerBlock) && (currentPageSetUp > 0)) {
			sb.append(createLinkClick(methodName, 1, "&#x226A"));
			sb.append(createLinkClick(methodName, n, "&#x003C"));
		}

		page = currentPageSetUp + 1;
		while ((page <= total_page) && (page <= currentPageSetUp + numPerBlock)) {
			if (page == current_page) {
				sb.append("<span>" + page + "</span>");
			} else {
				sb.append(createLinkClick(methodName, page, String.valueOf(page)));
			}
			page++;
		}

		n = current_page + numPerBlock;
		if (n > total_page)
			n = total_page;
		if (total_page - currentPageSetUp > numPerBlock) {
			sb.append(createLinkClick(methodName, n, "&#x003E"));
			sb.append(createLinkClick(methodName, total_page, "&#x226B"));
		}
		sb.append("</div>");

		return sb.toString();
	}

	public String pagingUrl(int current_page, int total_page, String list_url) {
		StringBuilder sb = new StringBuilder();

		int numPerBlock = 10;
		int n, page;

		if (current_page < 1 || total_page < current_page || list_url == null) {
			return "";
		}

		list_url += list_url.contains("?") ? "&" : "?";

		page = 1; 
		if (current_page > (numPerBlock / 2) + 1) {
			page = current_page - (numPerBlock / 2);

			n = total_page - page;
			if (n < numPerBlock) {
				page = total_page - numPerBlock + 1;
			}

			if (page < 1)
				page = 1;
		}

		sb.append("<div class='paginate'>");

		if (page > 1) {
			sb.append(createLinkUrl(list_url, 1, "&#x226A"));
		}

		n = current_page - 1;
		if (current_page > 1) {
			sb.append(createLinkUrl(list_url, n, "&#x003C"));
		}

		n = page;
		while (page <= total_page && page < n + numPerBlock) {
			if (page == current_page) {
				sb.append("<span>" + page + "</span>");
			} else {
				sb.append(createLinkUrl(list_url, page, String.valueOf(page)));
			}
			page++;
		}

		n = current_page + 1;
		if (current_page < total_page) {
			sb.append(createLinkUrl(list_url, n, "&#x003E"));
		}

		if (page <= total_page) {
			sb.append(createLinkUrl(list_url, total_page, "&#x226B"));
		}

		sb.append("</div>");

		return sb.toString();
	}

	public String pagingFunc(int current_page, int total_page, String methodName) {
		StringBuilder sb = new StringBuilder();

		int numPerBlock = 10;
		int n, page;

		if (current_page < 1 || total_page < current_page) {
			return "";
		}

		page = 1; 
		if (current_page > (numPerBlock / 2) + 1) {
			page = current_page - (numPerBlock / 2);

			n = total_page - page;
			if (n < numPerBlock) {
				page = total_page - numPerBlock + 1;
			}

			if (page < 1)
				page = 1;
		}

		sb.append("<div class='paginate'>");

		if (page > 1) {
			sb.append(createLinkClick(methodName, 1, "&#x226A"));
		}

		n = current_page - 1;
		if (current_page > 1) {
			sb.append(createLinkClick(methodName, n, "&#x003C"));
		}

		n = page;
		while (page <= total_page && page < n + numPerBlock) {
			if (page == current_page) {
				sb.append("<span>" + page + "</span>");
			} else {
				sb.append(createLinkClick(methodName, page, String.valueOf(page)));
			}
			
			page++;
		}

		n = current_page + 1;
		if (current_page < total_page) {
			sb.append(createLinkClick(methodName, n, "&#x003E"));
		}

		if (page <= total_page) {
			sb.append(createLinkClick(methodName, total_page, "&#x226B"));
		}

		sb.append("</div>");

		return sb.toString();
	}
	
    protected String createLinkUrl(String url, int page, String label) {
        return "<a href='" + url + "page=" + page + "'>" + label + "</a>";
    }

    protected String createLinkClick(String methodName, int page, String label) {
        return "<a onclick='" + methodName + "(" + page + ");'>" + label + "</a>";
    }
    
	/**
	 * 문자열을 주소형식으로 인코딩
	 * @param str 인코딩할 문자열
	 * @return 주소형식으로 인코딩된 문자열
	 */
	public String encodeUrl(String str) {
		 if (str == null) {
			 return null;
		 }
		 
		 try {
			str = URLEncoder.encode(str, StandardCharsets.UTF_8.name());
		} catch (UnsupportedEncodingException e) {
		}
		
		return str;
	}

	/**
	 * 주소 형식의 문자열을 디코딩
	 * @param str 디코딩할 인코딩된 문자열
	 * @return 디코딩된 문자열
	 */
	public String decodeUrl(String str) {
		Pattern pattern = Pattern.compile(".*%[0-9a-fA-F]{2}.*");
		
		 if (str == null) {
			 return null;
		 }
		 
		 try {
			  if (! str.contains("%")) {
				  return str;
			  }
			  
			  if (pattern.matcher(str).matches()) {
				  return URLDecoder.decode(str, StandardCharsets.UTF_8.name());
			  }
		} catch (IllegalArgumentException e) {
		} catch (UnsupportedEncodingException e) {
		}
		
		return str;
	}
    
	/**
	 * 특수문자를 HTML 문자로 변경 및 엔터를 <br> 로 변경
	 * 
	 * @param str 변경할 문자열
	 * @return HTML 문자로 변경된 문자열
	 */
	public String htmlSymbols(String str) {
		if (str == null || str.length() == 0) {
			return "";
		}

		str = str.replaceAll("&", "&amp;");
		str = str.replaceAll("\"", "&quot;");
		str = str.replaceAll(">", "&gt;");
		str = str.replaceAll("<", "&lt;");

		str = str.replaceAll("\n", "<br>");
		str = str.replaceAll("\\s", "&nbsp;"); 

		return str;
	}

	/**
	 * E-Mail 검사
	 * 
	 * @param email 검사 할 E-Mail
	 * @return E-Mail 검사 결과
	 */
	public boolean isValidEmail(String email) {
		if (email == null) {
			return false;
		}

		return Pattern.matches("[\\w\\~\\-\\.]+@[\\w\\~\\-]+(\\.[\\w\\~\\-]+)+", email.trim());
	}
	

	public String pagingCustom(int current_page, int total_page, String list_url) {
		StringBuilder sb = new StringBuilder();

		if (current_page < 1 || total_page <= 1 || list_url == null) {
			return "";
		}

		list_url += list_url.contains("?") ? "&" : "?";
		
		sb.append("<div class='as-wishlist__pagination' style='display: flex; justify-content: center; align-items: center; gap: 20px; margin-top: 40px;'>");

		if (current_page > 1) {
			sb.append("<a href='" + list_url + "page=" + (current_page - 1) + "' class='as-wishlist__paginationButton' title='Prev' style='cursor: pointer;'>");
			sb.append("<svg width='7' height='11' viewBox='0 0 7 11' fill='none' xmlns='http://www.w3.org/2000/svg'><path d='M6 1L1 5.5L6 10' stroke='#777780' stroke-linecap='round'></path></svg>");
			sb.append("</a>");
		} else {
			sb.append("<span class='as-wishlist__paginationButton' style='opacity: 0.3; cursor: default;'>");
			sb.append("<svg width='7' height='11' viewBox='0 0 7 11' fill='none' xmlns='http://www.w3.org/2000/svg'><path d='M6 1L1 5.5L6 10' stroke='#777780' stroke-linecap='round'></path></svg>");
			sb.append("</span>");
		}

		if (current_page < total_page) {
			sb.append("<a href='" + list_url + "page=" + (current_page + 1) + "' class='as-wishlist__paginationButton' title='Next' style='cursor: pointer;'>");
			sb.append("<svg width='7' height='11' viewBox='0 0 7 11' fill='none' xmlns='http://www.w3.org/2000/svg'><path d='M1 1L6 5.5L1 10' stroke='#777780' stroke-linecap='round'></path></svg>");
			sb.append("</a>");
		} else {
			sb.append("<span class='as-wishlist__paginationButton' style='opacity: 0.3; cursor: default;'>");
			sb.append("<svg width='7' height='11' viewBox='0 0 7 11' fill='none' xmlns='http://www.w3.org/2000/svg'><path d='M1 1L6 5.5L1 10' stroke='#777780' stroke-linecap='round'></path></svg>");
			sb.append("</span>");
		}

		sb.append("</div>");

		return sb.toString();
	}
}
