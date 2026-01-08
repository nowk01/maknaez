<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <%-- JSTL 추가 --%>

<header>
    <a href="${pageContext.request.contextPath}/" class="header-logo font-brand">MAKNAEZ</a>
    <nav>
        <ul class="nav-menu">
            <li><a href="#">MEN</a></li>
            <li><a href="#">WOMEN</a></li>
            <li><a href="#">SPORTSTYLE</a></li>
            <li><a href="#">SALE</a></li>
        </ul>
    </nav>
    <div class="nav-icons">
        <i class="ph ph-magnifying-glass"></i>
        
        <%-- [수정] 하트 아이콘 삭제 후 사람 아이콘 + 링크 추가 --%>
        <c:choose>
            <c:when test="${not empty sessionScope.member}">
                <%-- 로그인 상태: 마이페이지로 이동 --%>
                <a href="${pageContext.request.contextPath}/mypage/main.do" style="color: inherit; text-decoration: none; display: flex; align-items: center;">
                    <i class="ph ph-user"></i>
                </a>
            </c:when>
            <c:otherwise>
                <%-- 비로그인 상태: 로그인 페이지로 이동 --%>
                <a href="${pageContext.request.contextPath}/member/login" style="color: inherit; text-decoration: none; display: flex; align-items: center;">
                    <i class="ph ph-user"></i>
                </a>
            </c:otherwise>
        </c:choose>

        <i class="ph ph-shopping-bag"></i>
    </div>
</header>