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
			<div class="cs-sidebar-title">SUPPORT</div>
			<ul class="cs-menu">
				<li><a href="${pageContext.request.contextPath}/cs/notice">Notice</a></li>
				<li><a href="${pageContext.request.contextPath}/cs/faq">FAQ</a></li>
				<li><a href="${pageContext.request.contextPath}/cs/list"
					class="active">1:1 Inquiry</a></li>
			</ul>
		</div>

		<div class="cs-content">
			<div class="chat-container">
				<div class="chat-header-modern">
					<div>
						<div class="chat-title-lg">${dto.subject}</div>
						<div class="chat-meta-info">NO. ${dto.num} &nbsp;|&nbsp;
							${dto.reg_date}</div>
					</div>
					<div>
						<c:choose>
							<c:when test="${not empty dto.replyContent}">
								<span class="status-tag complete">Answered</span>
							</c:when>
							<c:otherwise>
								<span class="status-tag">Waiting</span>
							</c:otherwise>
						</c:choose>
					</div>
				</div>

				<div class="chat-body-modern">
					<div class="chat-msg me">
						<div class="msg-bubble">
							${dto.content}

							<c:if test="${not empty dto.saveFilename}">
								<div style="margin-top: 15px;">
									<div class="file-attach">
										<i class="bi bi-paperclip"></i> <a
											href="${pageContext.request.contextPath}/cs/download?num=${dto.num}">${dto.originalFilename}</a>
									</div>
								</div>
							</c:if>
						</div>
						<div class="msg-time">Read</div>
					</div>

					<c:if test="${not empty dto.replyContent}">
						<div class="chat-msg admin">
							<div class="msg-profile">
								<span class="admin-badge">CS TEAM</span> <span
									class="admin-name">Salomon Support</span>
							</div>
							<div class="msg-bubble">${dto.replyContent}</div>
							<div class="msg-time">${dto.replyDate}</div>
						</div>
					</c:if>

					<c:if test="${empty dto.replyContent}">
						<div
							style="text-align: center; color: #aaa; font-size: 13px; margin-top: 30px;">
							담당자가 확인 후 순차적으로 답변을 드립니다.</div>
					</c:if>
				</div>

				<div class="chat-actions">
					<button type="button" class="btn-back"
						onclick="location.href='${pageContext.request.contextPath}/cs/list?${query}'">LIST</button>

					<c:if test="${sessionScope.member.userId == dto.userId}">
						<button type="button" class="btn-del"
							onclick="deleteBoard('${dto.num}', '${query}')">DELETE</button>
					</c:if>
				</div>
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