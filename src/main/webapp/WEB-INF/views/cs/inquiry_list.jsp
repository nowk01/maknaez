<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/cs.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<div class="cs-wrap">
    <div class="cs-sidebar">
        <div class="cs-sidebar-title">SUPPORT</div>
        <ul class="cs-menu">
            <li><a href="${pageContext.request.contextPath}/cs/notice">Notice</a></li>
            <li><a href="${pageContext.request.contextPath}/cs/faq">FAQ</a></li>
            <li><a href="${pageContext.request.contextPath}/cs/list" class="active">1:1 Inquiry</a></li>
            <li><a href="#">Guide</a></li>
        </ul>
    </div>

    <div class="cs-content">
        <div class="content-header">
            <h3 class="content-title">1:1 Inquiry</h3>
            <a href="${pageContext.request.contextPath}/cs/write" class="btn-new-chat">
                <i class="bi bi-pencil-fill"></i> 문의하기
            </a>
        </div>

        <div class="chat-list-container">
            <c:choose>
                <%-- 문의 내역이 없는 경우 처리 --%>
                <c:when test="${empty list or dataCount == 0}">
                    <div class="no-data">
                        <i class="bi bi-chat-square-dots" style="font-size: 40px; color: #e0e0e0; margin-bottom: 15px; display:block;"></i>
                        문의 내역이 없습니다.
                    </div>
                </c:when>
                <c:otherwise>
                    <%-- 문의 리스트 반복 출력 --%>
                    <c:forEach var="dto" items="${list}">
                        <%-- 클릭 시 상세 페이지(article)로 이동하며 번호와 페이지 번호 전달 --%>
                        <div class="chat-list-item" onclick="location.href='${pageContext.request.contextPath}/cs/article?num=${dto.num}&page=${empty page ? 1 : page}'">
                            
                            <div class="chat-item-icon">
                                <c:choose>
                                    <%-- 관리자가 답변을 등록한 경우(replyDate 존재 여부로 확인) 체크 아이콘 표시 --%>
                                    <c:when test="${not empty dto.replyDate}">
                                        <i class="bi bi-check-lg" style="color:#0ca678; font-weight:bold;"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bi bi-chat-dots"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <div class="chat-item-info">
                                <div class="chat-item-top">
                                    <span class="chat-item-subject">${dto.subject}</span>
                                    <%-- 등록일 출력 (날짜 부분만 잘라서 표시) --%>
                                    <span class="chat-item-date">${dto.reg_date.substring(0,10)}</span>
                                </div>
                                <div class="chat-item-bottom">
                                    <span class="chat-item-preview">${dto.content}</span>
                                    
                                    <c:choose>
                                        <%-- 답변 상태에 따른 뱃지 출력 --%>
                                        <c:when test="${not empty dto.replyDate}">
                                            <span class="badge-status complete">답변완료</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-status waiting">답변대기</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
<script>
    const contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/dist/js/cs.js"></script>
</body>
</html>