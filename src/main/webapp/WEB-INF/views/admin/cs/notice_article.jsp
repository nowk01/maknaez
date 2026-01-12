<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항 상세 | MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_notice_article.css">
</head>
<body>
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                <div class="page-header">
                    <h3 class="page-title">공지사항 상세</h3>
                </div>

                <div class="article-box">
                    <div class="article-header">
                        <div class="article-title">
                            <c:if test="${dto.isNotice == 1}">
                                <span class="badge-pin">NOTICE</span>
                            </c:if>
                            ${dto.subject}
                        </div>
                        <div class="article-info">
                            <span><b>WRITER</b> ${dto.userName}</span>
                            <span><b>DATE</b> ${dto.reg_date}</span>
                            <span><b>VIEWS</b> ${dto.hitCount}</span>
                        </div>
                    </div>

                    <div class="article-content">
                        ${dto.content}
                    </div>

                    <c:if test="${not empty dto.saveFilename}">
                        <div class="file-box">
                            <strong>Attached File</strong> 
                            <a href="${pageContext.request.contextPath}/admin/cs/download?num=${dto.num}">
                                ${dto.originalFilename}
                            </a>
                        </div>
                    </c:if>

                    <div class="article-footer">
                        <button type="button" class="btn-list" 
                                onclick="location.href='${pageContext.request.contextPath}/admin/cs/notice_list?${query}'">
                            BACK TO LIST
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <script src="${pageContext.request.contextPath}/dist/js/admin_notice_article.js"></script>
</body>
</html>