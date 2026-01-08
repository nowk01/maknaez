<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지 | 쇼핑몰</title>
    <link rel="icon" href="data:;base64,iVBORw0KGgo=">
    
    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="mypage-container">
    <aside class="sidebar">
        <h2>마이페이지</h2>
        
        <div class="menu-group">
            <span class="menu-title">구매내역</span>
            <ul>
                <li><a href="#">주문/배송조회</a></li>
                <li><a href="#">취소/반품조회</a></li>
            </ul>
        </div>
        
        <div class="menu-group">
            <span class="menu-title">혜택내역</span>
            <ul>
                <li><a href="#">상품 리뷰</a></li>
                <li><a href="#">포인트/쿠폰</a></li>
            </ul>
        </div>

        <div class="menu-group">
            <span class="menu-title">상품내역</span>
            <ul>
                <li><a href="#">최근 본 상품</a></li>
                <li><a href="#">관심 상품</a></li>
            </ul>
        </div>

        <div class="menu-group">
            <span class="menu-title">회원정보</span>
            <ul>
                <li><a href="#">내 정보 관리</a></li>
                <li><a href="#">배송지 관리</a></li>
                <li><a href="#">회원등급</a></li>
                <li><a href="#">문의하기</a></li>
            </ul>
        </div>
    </aside>

    <main class="main-content">
        <h1 class="page-title">마이페이지</h1>
        
        <div class="profile-card dashboard-area">
            <div class="user-profile">
                <div class="profile-circle">B</div>
                <div class="user-detail">
                    <p class="user-name">
                        ${not empty sessionScope.member.userName ? sessionScope.member.userName : '최하늘'} 님
                    </p>
                    <div class="grade-box">
                        <p class="user-grade">BRONZE <span>등급</span></p>
                    </div>
                    <div class="user-actions">
                        <a href="#">등급혜택 &gt;</a>
                        <a href="${pageContext.request.contextPath}/member/logout">로그아웃</a>
                    </div>
                </div>
            </div>
            
            <div class="order-status">
                <div class="status-label">주문/배송</div>
                <div class="status-count">0</div>
            </div>
            
            <div style="width: 150px;"></div>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
<jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />

</body>
</html>