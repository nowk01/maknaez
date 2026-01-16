<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
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
                <li><a href="${pageContext.request.contextPath}/member/mypage/orderList">주문/배송조회</a></li>
                <li><a href="${pageContext.request.contextPath}/member/mypage/cancelList">취소상품조회</a></li>
            </ul>
        </div>

        <div class="menu-group">
            <span class="menu-title">혜택내역</span>
            <ul>
                <li><a href="${pageContext.request.contextPath}/member/mypage/review">상품 리뷰</a></li>
                <li><a href="${pageContext.request.contextPath}/member/mypage/membership">포인트/쿠폰</a></li>
            </ul>
        </div>

        <div class="menu-group">
            <span class="menu-title">상품내역</span>
            <ul>
            	<li><a href="${pageContext.request.contextPath}/member/mypage/recent">최근 본 상품</a></li>
                <li><a href="${pageContext.request.contextPath}/member/mypage/wishList">관심 상품</a></li>
            </ul>
        </div>

        <div class="menu-group">
            <span class="menu-title">회원정보</span>
            <ul>
                <li><a href="${pageContext.request.contextPath}/member/mypage/myInfo">내 정보 관리</a></li>
                <li><a href="${pageContext.request.contextPath}/member/mypage/addr">배송지 관리</a></li>
                <li><a href="${pageContext.request.contextPath}/member/mypage/level_benefit">회원등급</a></li>
            </ul>
        </div>
        
        <div class="menu-group">
             <ul>
                <li><a href="${pageContext.request.contextPath}/member/logout" style="color:#999;">로그아웃</a></li>
             </ul>
        </div>
    </aside>

    <main class="main-content">
        <h1 class="page-title">마이페이지</h1>

        <div class="sm-salomon__detailsCustomersTag">
            <div class="sm-salomon__detailsCustomersCard sm-salomon__detailsCustomersTier--tier">
                <div class="sm-salomon__detailsCustomersTierImage">
                    <c:choose>
                        <c:when test="${sessionScope.member.userLevel >= 4}">
                            <img src="//salomon.co.kr/cdn/shop/files/ic_VIP_100.png?v=8418633967200043728" class="sm-salomon__detailsImage" alt="VIP">
                        </c:when>
                        <c:when test="${sessionScope.member.userLevel == 3}">
                            <img src="//salomon.co.kr/cdn/shop/files/ic_gold_100.png?v=14757858475559429681" class="sm-salomon__detailsImage" alt="GOLD">
                        </c:when>
                        <c:when test="${sessionScope.member.userLevel == 2}">
                            <img src="//salomon.co.kr/cdn/shop/files/ic_silver_100.png?v=17895277962029434101" class="sm-salomon__detailsImage" alt="SILVER">
                        </c:when>
                        <c:otherwise>
                            <img src="//salomon.co.kr/cdn/shop/files/ic_bronze_100.png?v=17792475310696573771" class="sm-salomon__detailsImage" alt="BRONZE">
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <div class="sm-salomon__detailsCustomersTierDetails">
                    <div class="sm-salomon__detailsCustomerName">
                        <strong>${not empty sessionScope.member.userName ? sessionScope.member.userName : 'GUEST'}</strong> 님
                    </div>
                    
                    <div class="sm-salomon__detailsCustomersTierName">
                        <c:choose>
                            <c:when test="${sessionScope.member.userLevel >= 4}">VIP</c:when>
                            <c:when test="${sessionScope.member.userLevel == 3}">GOLD</c:when>
                            <c:when test="${sessionScope.member.userLevel == 2}">SILVER</c:when>
                            <c:otherwise>BRONZE</c:otherwise>
                        </c:choose>
                        <span class="sm-salomon__detailsCustomersTierNameRating">등급</span>
                    </div>
                    
                    <div style="margin-top: 12px; display: flex; gap: 10px; font-size: 13px;">
                        <a href="#" class="sm-salomon__detailsCustomersTierLink">등급혜택 보기</a>
                    </div>
                </div>
            </div>

            <div class="sm-salomon__detailsCustomersCard sm-salomon__detailsCustomersTier--orderCount" style="flex: 1; justify-content: center; text-align: center;">
                <div>
                    <div class="sm-salomon__detailsCustomersCardCount" style="margin-bottom: 5px;">
                        <a href="${pageContext.request.contextPath}/member/mypage/orderList" style="text-decoration:none; color:inherit;">주문/배송</a>
                    </div>
                    <div class="sm-salomon__detailsCustomersCardCounter">
                        ${not empty orderCount ? orderCount : 0}
                    </div>
                </div>
            </div>
        </div>
        
    </main>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
<jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />

</body>
</html>