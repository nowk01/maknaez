<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/cs.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/layout/header.jsp" />

	<div class="cs-wrap">
		<div class="cs-sidebar">
			<div class="cs-sidebar-title">고객센터</div>
			<ul class="cs-menu">
				<li><a href="${pageContext.request.contextPath}/cs/notice"
					class="active">공지사항</a></li>
				<li><a href="${pageContext.request.contextPath}/cs/faq">자주
						묻는 질문</a></li>
				<li><a href="${pageContext.request.contextPath}/cs/list">1:1
						문의</a></li>
				<li><a href="#">이용안내</a></li>
			</ul>
		</div>
		<div class="cs-content">
			<table class="view-table">
				<tr>
					<th colspan="2">${dto.subject}</th>
				</tr>
				<tr>
					<td width="50%"><c:choose>
							<c:when test="${not empty dto.userName}">${dto.userName}</c:when>
							<c:otherwise>관리자</c:otherwise>
						</c:choose></td>
					<td width="50%" align="right">${dto.reg_date.substring(0, 10)}
						| 조회 ${dto.hitCount}</td>
				</tr>
				<c:if test="${not empty dto.saveFilename}">
					<tr>
						<td colspan="2">첨부파일 : <a
							href="${pageContext.request.contextPath}/cs/download?num=${dto.num}">${dto.originalFilename}</a>
						</td>
					</tr>
				</c:if>
			</table>

			<div class="view-content">${dto.content}</div>

			<div class="btn-area">
				<a href="${pageContext.request.contextPath}/cs/notice?${query}"
					class="btn">목록</a>
			</div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
	<script>
    const contextPath = "${pageContext.request.contextPath}";
</script>
	<script src="${pageContext.request.contextPath}/dist/js/cs.js"></script>
</body>
</html>