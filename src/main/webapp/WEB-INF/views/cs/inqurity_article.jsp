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
        <div class="cs-sidebar-title">고객센터</div>
        <ul class="cs-menu">
            <li><a href="${pageContext.request.contextPath}/cs/notice">공지사항</a></li>
            <li><a href="${pageContext.request.contextPath}/cs/faq">자주 묻는 질문</a></li>
            <li><a href="${pageContext.request.contextPath}/cs/list" class="active">1:1 문의</a></li>
            <li><a href="#">이용안내</a></li>
        </ul>
    </div>
    <div class="cs-content">
        <table class="view-table">
            <tr><th colspan="2">${dto.subject}</th></tr>
            <tr>
                <td width="50%">작성자 : ${dto.userName}</td>
                <td width="50%" align="right">등록일 : ${dto.reg_date}</td>
            </tr>
            <c:if test="${not empty dto.saveFilename}">
            <tr>
                <td colspan="2">
                    첨부파일 : <a href="${pageContext.request.contextPath}/cs/download?num=${dto.num}">${dto.originalFilename}</a>
                </td>
             </tr>
            </c:if>
        </table>
        
        <div class="view-content">${dto.content}</div>

        <c:if test="${not empty dto.replyContent}">
            <div class="reply-box">
                <div class="reply-header">
                    <span class="reply-title">CS MANAGER 답변</span>
                    <span class="reply-date">${dto.replyDate}</span>
                </div>
                <div class="reply-content">
                    ${dto.replyContent}
                </div>
            </div>
        </c:if>

        <div class="btn-area">
            <a href="${pageContext.request.contextPath}/cs/list?${query}" class="btn">목록</a>
            
            <c:if test="${sessionScope.member.userId == dto.userId}">
                <a href="javascript:deleteBoard('${dto.num}', '${query}')" class="btn btn-delete">삭제</a>
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