<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>주문/배송조회 | 쇼핑몰</title>
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
                <li><a href="${pageContext.request.contextPath}/member/mypage/orderList" class="active">주문/배송조회</a></li>
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
        <h1 class="page-title">주문/배송조회</h1>
        
        <div class="order-list-wrap">
            <p class="list-info">총 <b>${dataCount}</b>건의 주문 내역이 있습니다.</p>
            
            <table class="order-table">
                <thead>
                    <tr>
                        <th width="150">주문일자<br>(주문번호)</th>
                        <th>상품정보</th>
                        <th width="100">결제금액</th>
                        <th width="100">상태</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty list}">
                            <c:forEach var="dto" items="${list}">
                                <tr>
                                    <td class="td-date">
                                        <span class="order-date">${dto.orderDate}</span>
                                        <span class="order-num">
                                            <a href="#">(${dto.orderNum})</a>
                                        </span>
                                    </td>
                                    <td class="td-product left">
                                        <div class="product-info">
                                            <div class="p-name">${dto.productName}</div>
                                            <div class="p-opt">수량: ${dto.qty}개</div>
                                        </div>
                                    </td>
                                    <td class="td-price">
                                        <fmt:formatNumber value="${dto.totalAmount}" pattern="#,###" />원
                                    </td>
                                    <td class="td-status">
                                        <span class="status-badge ${dto.orderState == '배송중' ? 'shipping' : ''}">${dto.orderState}</span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="4" class="no-data">주문 내역이 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
            
            <div class="page-navigation">
                ${paging}
            </div>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
<jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />

</body>
</html>