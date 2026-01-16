<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>최근 본 상품 | 마이페이지</title>
    <link rel="icon" href="data:;base64,iVBORw0KGgo=">
    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage.css">
    
    <style>
        /* 최근 본 상품 전용 간단 스타일 (mypage.css에 병합하셔도 됩니다) */
        .recent-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid #222;
            margin-bottom: 20px;
            padding-bottom: 10px;
        }
        .btn-delete-all {
            border: 1px solid #ddd;
            background: #fff;
            padding: 5px 12px;
            font-size: 13px;
            cursor: pointer;
            border-radius: 4px;
        }
        .btn-delete-all:hover { background: #f9f9f9; }

        .recent-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr); /* 한 줄에 4개 */
            gap: 20px;
            list-style: none;
            padding: 0; margin: 0;
        }
        .recent-item { position: relative; }
        .recent-item a { text-decoration: none; color: inherit; }
        
        .thumb-box {
            width: 100%;
            aspect-ratio: 1/1;
            background: #f5f5f5;
            overflow: hidden;
            margin-bottom: 10px;
            border-radius: 4px;
        }
        .thumb-box img {
            width: 100%; height: 100%; object-fit: cover;
            transition: transform 0.3s;
        }
        .recent-item:hover .thumb-box img { transform: scale(1.05); }

        .info-box .brand { font-weight: bold; font-size: 12px; display: block; margin-bottom: 4px;}
        .info-box .name { font-size: 14px; margin-bottom: 6px; display: block; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .info-box .price { font-weight: bold; font-size: 15px; }
        .info-box .discount { color: #ff4000; margin-right: 5px; }

        .empty-recent { text-align: center; padding: 80px 0; color: #999; font-size: 16px; }
    </style>

    <script>
        function clearRecent() {
            if(!confirm("최근 본 상품 기록을 모두 삭제하시겠습니까?")) return;
            
            // 쿠키 삭제 (Max-Age=0)
            document.cookie = "recent_products=; path=/; max-age=0";
            
            alert("삭제되었습니다.");
            location.reload();
        }
    </script>
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
                <li><a href="${pageContext.request.contextPath}/member/mypage/recent" style="font-weight:bold; color:#222;">최근 본 상품</a></li>
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
        <div class="recent-header">
            <h1 class="page-title" style="margin:0; border:none;">최근 본 상품</h1>
            <c:if test="${not empty list}">
                <button type="button" class="btn-delete-all" onclick="clearRecent()">전체 삭제</button>
            </c:if>
        </div>

        <c:choose>
            <c:when test="${empty list}">
                <div class="empty-recent">최근 본 상품이 없습니다.</div>
            </c:when>
            
            <c:otherwise>
                <ul class="recent-grid">
                    <c:forEach var="dto" items="${list}">
                        <li class="recent-item">
                            <a href="${pageContext.request.contextPath}/product/detail?prod_id=${dto.prodId}">
                                <div class="thumb-box">
                                    <img src="${pageContext.request.contextPath}/uploads/product/${dto.thumbnail}" alt="${dto.prodName}">
                                </div>
                                <div class="info-box">
                                    <span class="brand">SALOMON</span> <span class="name">${dto.prodName}</span>
                                    <div class="price">
                                        <c:if test="${dto.discountRate > 0}">
                                            <span class="discount">${dto.discountRate}%</span>
                                        </c:if>
                                        <fmt:formatNumber value="${dto.price}" pattern="#,###"/>원
                                    </div>
                                </div>
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </c:otherwise>
        </c:choose>
        
    </main>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
<jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />

</body>
</html>