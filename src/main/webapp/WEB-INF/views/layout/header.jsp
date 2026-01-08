<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<header>
    <div class="top-bar">
        <div class="container d-flex justify-content-end">
            <div id="auth-links">
                <c:choose>
                	<c:when test="${empty sessionScope.member}">
                		<a href="${pageContext.request.contextPath}/member/login" class="me-3">로그인</a>
                		<a href="${pageContext.request.contextPath}/member/account" class="me-3">회원가입</a>
                		<a href="#">고객센터</a>
                	</c:when>
                	<c:otherwise>
                		<a href="${pageContext.request.contextPath}/member/logout" title="로그아웃">로그아웃</a>
                		<a href="${pageContext.request.contextPath}/cs/list">고객센터</a>
                		<c:if test="${sessionScope.member.userLevel>50}">
                			<a href="${pageContext.request.contextPath}/admin" title="관리자"><i class="bi bi-gear"></i></a>
                		</c:if>
                	</c:otherwise>
                </c:choose>
                
            </div>
        </div>
    </div>

    <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom py-3">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/main">Maknaez</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="mainNav">
                <ul class="navbar-nav mx-auto mb-2 mb-lg-0">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/collections/list?category=men">Men</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Women</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">kids</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Sports</a></li>
                </ul>
                <div class="d-flex align-items-center">
                    <div class="search-box me-3 d-none d-lg-block">
                        <form action="search.do" method="get">
                            <input type="text" class="form-control form-control-sm" placeholder="상품 검색" name="keyword">
                            <button type="submit"><i class="fas fa-search"></i></button>
                        </form>
                    </div>
                    <a href="${pageContext.request.contextPath}/mypage/main.do" class="nav-icon">
    				<i class="bi bi-person-check-fill" style="font-size: 1.5rem; color: black;"></i>
					</a>
                    <a href="#" class="text-dark fs-5 position-relative">
                        <i class="fas fa-shopping-bag"></i>
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size:0.5rem;">2</span>
                    </a>
                </div>
            </div>
        </div>
    </nav>
</header>