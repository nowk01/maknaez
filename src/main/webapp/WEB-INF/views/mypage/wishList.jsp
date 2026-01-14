<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관심 상품 | 쇼핑몰</title>
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
                <li><a href="${pageContext.request.contextPath}/member/mypage/cancelList">취소/반품조회</a></li>
            </ul>
        </div>

        <div class="menu-group">
            <span class="menu-title">혜택내역</span>
            <ul>
                <li><a href="${pageContext.request.contextPath}/member/mypage/review">상품 리뷰</a></li>
                <li><a href="#">포인트/쿠폰</a></li>
            </ul>
        </div>

        <div class="menu-group">
            <span class="menu-title">상품내역</span>
            <ul>
                <li><a href="#">최근 본 상품</a></li>
                <li><a href="${pageContext.request.contextPath}/member/mypage/wishList" class="active">관심 상품</a></li>
            </ul>
        </div>

        <div class="menu-group">
            <span class="menu-title">회원정보</span>
            <ul>
                <li><a href="${pageContext.request.contextPath}/member/mypage/muInfo" class="active">내 정보 관리</a></li>
                <li><a href="${pageContext.request.contextPath}/member/mypage/addr" class="active">배송지 관리</a></li>
                <li><a href="#">회원등급</a></li>
            </ul>
        </div>
        
        <div class="menu-group">
             <ul>
                <li><a href="${pageContext.request.contextPath}/member/logout" style="color:#999;">로그아웃</a></li>
             </ul>
        </div>
    </aside>
    
    <main class="main-content">
        <div class="as-wishlist__contentWrap">
            
            <h1 class="page-title">관심 상품</h1> 
            
            <div class="as-wishlist__productList">
                
                <div class="as-wishlist__productCount">
                    <span style="font-weight:700;">${dataCount}</span>개 제품
                </div>

                <c:if test="${empty list}">
                    <div class="as-wishlist__productError">
                        <p class="as-wishlist__errorText">관심 제품이 없습니다.</p>
                        <p class="as-wishlist__errorText">지금 바로 제품들을 만나보세요.</p>
                        <a href="${pageContext.request.contextPath}/" class="as-wishlist__button">상품 보러가기</a>
                    </div>
                </c:if>

                <c:if test="${not empty list}">
                    <div class="as-wishlist__products">
                        <c:forEach var="dto" items="${list}">
                            <div class="as-wishlist__productItem">
                                <div class="as-wishlist__productImageWrap">
                                    <div class="as-wishlist__productImageInnerWrap">
                                        <a href="${pageContext.request.contextPath}/product/detail?productNo=${dto.productNo}" class="as-wishlist__productLink">
                                            <img class="as-wishlist__productImage" 
                                                 src="${not empty dto.imageFile ? dto.imageFile : 'https://placehold.co/500x500?text=No+Image'}" 
                                                 alt="${dto.productName}">
                                        </a>

                                        <div class="as-wishlist__iconContainer" onclick="deleteWish('${dto.productNo}')">
                                            <div class="as-wishlist__icons">
                                                <div class="as-wishlist__icon">
                                                    <svg class="as-icon as-icon--fill-heart" width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                                        <path d="M20.8382 4.60999C20.3274 4.099 19.721 3.69364 19.0535 3.41708C18.3861 3.14052 17.6707 2.99817 16.9482 2.99817C16.2257 2.99817 15.5103 3.14052 14.8428 3.41708C14.1754 3.69364 13.5689 4.099 13.0582 4.60999L11.9982 5.66999L10.9382 4.60999C9.90647 3.5783 8.5072 2.9987 7.04817 2.9987C5.58913 2.9987 4.18986 3.5783 3.15817 4.60999C2.12647 5.64169 1.54688 7.04096 1.54688 8.49999C1.54687 9.95903 2.12647 11.3583 3.15817 12.39L4.21817 13.45L11.9982 21.23L19.7782 13.45L20.8382 12.39C21.3492 11.8792 21.7545 11.2728 22.0311 10.6053C22.3076 9.93789 22.45 9.22248 22.45 8.49999C22.45 7.77751 22.3076 7.0621 22.0311 6.39464C21.7545 5.72718 21.3492 5.12075 20.8382 4.60999Z" fill="#FD6464" stroke="#FD6464" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                                                    </svg>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <a href="${pageContext.request.contextPath}/product/detail?productNo=${dto.productNo}" class="as-wishlist__productLink" style="text-decoration:none;">
                                    <h3 class="as-wishlist__productTitle">${dto.productName}</h3>
                                </a>
                                <p class="as-wishlist__productType">CATEGORY</p>
                                <p class="as-wishlist__productPrice">₩<fmt:formatNumber value="${dto.price}" pattern="#,###" /></p>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>

                <div class="as-wishlist__pagination" style="text-align:center; margin-top:30px;">
                    ${paging}
                </div>

            </div>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
<jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />

<script>
    function deleteWish(productNo) {
        if(!confirm("관심 상품에서 삭제하시겠습니까?")) return;
        
        // 실제 백엔드 연동 시 아래 주석 해제하여 사용
        /*
        $.ajax({
            type: "POST",
            url: "${pageContext.request.contextPath}/member/mypage/deleteWish",
            data: { productNo: productNo },
            dataType: "json",
            success: function(data) {
                location.reload();
            },
            error: function(e) {
                console.log(e);
            }
        });
        */
        alert("삭제 기능은 백엔드 구현이 필요합니다. (상품번호: " + productNo + ")");
    }
</script>

</body>
</html>