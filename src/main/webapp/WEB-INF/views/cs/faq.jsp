<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/cs.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <div class="cs-wrap">
        <div class="cs-sidebar">
            <div class="cs-sidebar-title">SUPPORT</div>
            <ul class="cs-menu">
                <li><a href="${pageContext.request.contextPath}/cs/notice">Notice</a></li>
                <li><a href="${pageContext.request.contextPath}/cs/faq" class="active">FAQ</a></li>
                <li><a href="${pageContext.request.contextPath}/cs/list">1:1 Inquiry</a></li>
                <li><a href="#">Guide</a></li>
            </ul>
        </div>

        <div class="cs-content">
            <div class="content-header">
                <h2 class="content-title">FAQ</h2>
            </div>

            <div class="faq-tabs">
                <button class="tab-btn ${category=='all'?'active':''}" onclick="filterFaq('all')">ALL</button>
                <button class="tab-btn ${category=='배송'?'active':''}" onclick="filterFaq('배송')">DELIVERY</button>
                <button class="tab-btn ${category=='상품'?'active':''}" onclick="filterFaq('상품')">PRODUCT</button>
                <button class="tab-btn ${category=='교환/반품'?'active':''}" onclick="filterFaq('교환/반품')">RETURN</button>
                <button class="tab-btn ${category=='회원'?'active':''}" onclick="filterFaq('회원')">MEMBER</button>
            </div>

            <div class="faq-list">
                <c:choose>
                    <c:when test="${empty list}">
                        <div class="no-data">등록된 질문이 없습니다.</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="dto" items="${list}">
                            <div class="faq-item">
                                <div class="faq-question" onclick="toggleFaq(this)">
                                    <span class="category">${dto.category}</span> 
                                    <span class="subject">${dto.subject}</span> 
                                    <span class="icon">+</span>
                                </div>
                                <div class="faq-answer">${dto.content}</div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
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