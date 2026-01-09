<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/cs.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<div class="cs-wrap">
    <div class="cs-sidebar">
        <div class="cs-sidebar-title">고객센터</div>
        <ul class="cs-menu">
            <li><a href="${pageContext.request.contextPath}/cs/notice" class="active">공지사항</a></li>
            <li><a href="${pageContext.request.contextPath}/cs/faq">자주 묻는 질문</a></li>
            <li><a href="${pageContext.request.contextPath}/cs/list">1:1 문의</a></li>
            <li><a href="#">이용안내</a></li>
        </ul>
    </div>

    <div class="cs-content">
        <div class="content-header">
            <h2 class="content-title">공지사항</h2>
        </div>

        <table class="notice-table">
            <colgroup>
                <col width="60">
                <col width="*">
                <col width="100">
                <col width="80">
            </colgroup>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>제목</th>
                    <th>작성일</th>
                    <th>조회수</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty list}">
                        <tr><td colspan="4" class="no-data">등록된 공지사항이 없습니다.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="dto" items="${list}">
                            <tr class="${dto.isNotice == 1 ? 'notice-fixed' : ''}">
                                <td>
                                    <c:choose>
                                        <c:when test="${dto.isNotice == 1}">
                                            <span class="notice-badge">공지</span>
                                        </c:when>
                                        <c:otherwise>${dto.num}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="subject" onclick="location.href='${pageContext.request.contextPath}/cs/notice/article?num=${dto.num}&page=${page}'">
                                    ${dto.subject}
                                    <c:if test="${dto.isNotice == 1}">
                                        <span class="notice-icon">●</span>
                                    </c:if>
                                </td>
                                <td>${dto.reg_date.substring(0, 10)}</td>
                                <td>${dto.hitCount}</td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <div class="page-navigation">
            <c:if test="${dataCount > 0}">
                <c:forEach var="i" begin="1" end="${total_page}">
                    <a href="${pageContext.request.contextPath}/cs/notice?page=${i}" class="page-link ${page==i?'active':''}">${i}</a>
                </c:forEach>
            </c:if>
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