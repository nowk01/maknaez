<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>1:1 문의 관리 | MAKNAEZ ADMIN</title>
<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/admin_inquiry.css">
</head>
<body>
	<div id="wrapper">
		<jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
		<div id="page-content-wrapper">
			<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

			<div class="content-container">
				<div class="page-header">
					<h3 class="page-title">1:1 문의 관리</h3>
					<p class="page-desc">Customer Support Real-time Protocol</p>
				</div>

				<div class="chat-main-grid">
					<div class="chat-sidebar">
						<div class="inquiry-list-header">
							<form name="searchForm"
								action="${pageContext.request.contextPath}/admin/cs/inquiry_list"
								method="get">
								<select name="status" onchange="searchList()"
									class="status-select">
									<option value="all" ${status == 'all' ? 'selected' : ''}>전체
										상태</option>
									<option value="wait" ${status == 'wait' ? 'selected' : ''}>답변
										대기</option>
									<option value="done" ${status == 'done' ? 'selected' : ''}>답변
										완료</option>
								</select>
								<div class="search-bar-wrap">
									<input type="text" name="keyword" value="${keyword}"
										placeholder="검색어...">
									<button type="button" onclick="searchList()">
										<i class="fa fa-search"></i>
									</button>
								</div>
							</form>
						</div>
						<div class="inquiry-list-wrapper">
							<c:forEach var="dto" items="${list}">
								<div class="inquiry-item" onclick="openChat('${dto.num}', this)">
									<div class="inquiry-info">
										<span>${dto.userName}</span> <span>${dto.reg_date}</span>
									</div>
									<div class="inquiry-subject">
										<c:choose>
											<c:when test="${empty dto.replyContent}">
												<span class="badge badge-wait">대기</span>
											</c:when>
											<c:otherwise>
												<span class="badge badge-done">완료</span>
											</c:otherwise>
										</c:choose>
										${dto.subject}
									</div>
								</div>
							</c:forEach>
						</div>
					</div>

					<div class="chat-window">
						<div class="empty-state" id="emptyState">
							<i class="far fa-comments"
								style="font-size: 50px; margin-bottom: 20px;"></i>
							<p>상담할 문의 내역을 좌측에서 선택해 주세요.</p>
						</div>
						<div class="d-none flex-column h-100" id="chatView">
							<div class="chat-header">
								<h5 id="chatTitle">제목</h5>
								<small id="chatUser" class="text-muted">사용자 정보</small>
							</div>
							<div class="chat-body" id="chatBody"></div>
							<div class="chat-footer">
								<div class="reply-input-wrap">
									<textarea id="replyContent" placeholder="답변을 입력하세요..."></textarea>
									<button type="button" class="btn-send" onclick="sendReply()">SEND</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
	<script
		src="${pageContext.request.contextPath}/dist/js/admin_inquiry.js"></script>
</body>
</html>