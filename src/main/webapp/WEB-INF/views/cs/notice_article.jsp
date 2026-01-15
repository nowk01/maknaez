<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<title>NOTICE | MAKNAEZ</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/cs.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<div class="cs-wrap">
    <div class="cs-sidebar">
        <div class="cs-sidebar-title">SUPPORT</div>
        <ul class="cs-menu">
            <li><a href="${pageContext.request.contextPath}/cs/notice" class="active">Notice</a></li>
            <li><a href="${pageContext.request.contextPath}/cs/faq">FAQ</a></li>
            <li><a href="${pageContext.request.contextPath}/cs/list">1:1 Inquiry</a></li>
        </ul>
    </div>

    <div class="cs-content">
        <div class="notice-view-container">
            <div class="view-header content-header">
                <div class="view-subject-group">
                    <c:if test="${dto.isNotice == 1}">
                        <span class="view-badge">NOTICE</span>
                    </c:if>
                    <h1 class="view-subject">${dto.subject}</h1>
                </div>
            </div>

            <div class="view-meta">
                <div class="view-meta-left">
                    <span><b>AUTHOR</b> ${not empty dto.userName ? dto.userName : 'ADMIN'}</span>
                    <span><b>DATE</b> ${dto.reg_date.substring(0, 10)}</span>
                </div>
                <div class="view-meta-right">
                    <span><b>VIEWS</b> ${dto.hitCount}</span>
                </div>
            </div>

            <c:if test="${not empty dto.saveFilename}">
                <div class="view-attachment">
                    <span class="file-tag">FILES</span>
                    <a href="${pageContext.request.contextPath}/cs/download?num=${dto.num}" class="file-name">
                        ${dto.originalFilename}
                    </a>
                </div>
            </c:if>
            
            <div class="view-body">
                ${dto.content}
            </div>

            <div class="view-footer">
                <button type="button" class="btn-list-back" 
                        onclick="location.href='${pageContext.request.contextPath}/cs/notice?${query}'">
                    BACK TO LIST
                </button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
<script src="${pageContext.request.contextPath}/dist/js/cs.js"></script>
</body>
</html>