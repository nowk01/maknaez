<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
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
            <a href="${pageContext.request.contextPath}/cs/write" class="btn-black">문의하기</a>
        </div>

        <table class="cs-table">
            <colgroup>
                <col width="60"> 
                <col width="100"> 
                <col width="*">
                <col width="100">
                <col width="120">
            </colgroup>
            <thead>
                <tr>
                    <th>NO</th>
                    <th>STATUS</th>
                    <th>SUBJECT</th>
                    <th>AUTHOR</th>
                    <th>DATE</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty list}">
                         <tr><td colspan="5" class="no-data">등록된 문의 내역이 없습니다.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="dto" items="${list}">
                            <tr>
                                <td>${dto.num}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty dto.replyDate}">
                                            <span class="status-badge status-done">Answered</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge">Waiting</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="subject" onclick="location.href='${pageContext.request.contextPath}/cs/article?num=${dto.num}&page=${page}'">
                                    ${dto.subject}
                                </td>
                                <td>${dto.userName}</td>
                                <td>${dto.reg_date.substring(0,10)}</td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
        
        <div class="page-navigation">
            <c:if test="${dataCount > 0}">
                <c:forEach var="i" begin="1" end="${total_page}">
                    <a href="${pageContext.request.contextPath}/cs/list?page=${i}" class="page-link ${page==i?'active':''}">${i}</a>
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