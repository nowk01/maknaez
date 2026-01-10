<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>취소/반품조회 | 쇼핑몰</title>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/mypage.css">
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
					<li><a href="${pageContext.request.contextPath}/member/mypage/cancelList" class="active">취소/반품조회</a></li>
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
			<h1 class="page-title">취소/반품조회</h1>

			<div class="notice-box">
				<p>취소/반품 신청 내역을 확인하실 수 있습니다.</p>
				<p>반품이 완료된 후 결제 취소가 진행됩니다.</p>
			</div>

			<div class="sm-salomon__statusBar">

				<div class="sm-salomon__statusBarItem" data-status-bar-item="">
					<span class="sm-salomon__statusBarItemTitle">전체</span> 
					<span class="sm-salomon__statusBarItemValue" data-status-total="">
						<c:out value="${dataCount}" default="0" />
					</span>
				</div>

				<div class="sm-salomon__statusBarBorder">
					<svg xmlns="http://www.w3.org/2000/svg" width="1" height="76" viewBox="0 0 1 76" fill="none">
            			<line x1="0.5" y1="0" x2="0.5" y2="76" stroke="#E7E7E7"></line>
        			</svg>
				</div>

				<div class="sm-salomon__statusBarItem" data-status-bar-item="">
					<span class="sm-salomon__statusBarItemTitle">취소</span> 
					<span class="sm-salomon__statusBarItemValue" data-status-cancel="">
						<c:out value="${cancelCount}" default="0" />
					</span>
				</div>

				<div class="sm-salomon__statusBarBorder">
					<svg xmlns="http://www.w3.org/2000/svg" width="1" height="76" viewBox="0 0 1 76" fill="none">
            			<line x1="0.5" y1="0" x2="0.5" y2="76" stroke="#E7E7E7"></line>
        			</svg>
				</div>

				<div class="sm-salomon__statusBarItem" data-status-bar-item="">
					<span class="sm-salomon__statusBarItemTitle">반품중</span> 
					<span class="sm-salomon__statusBarItemValue" data-status-return-ing="">
						<c:out value="${returnIngCount}" default="0" />
					</span>
				</div>

				<div class="sm-salomon__statusBarBorder">
					<svg xmlns="http://www.w3.org/2000/svg" width="1" height="76" viewBox="0 0 1 76" fill="none">
            			<line x1="0.5" y1="0" x2="0.5" y2="76" stroke="#E7E7E7"></line>
        			</svg>
				</div>

				<div class="sm-salomon__statusBarItem" data-status-bar-item="">
					<span class="sm-salomon__statusBarItemTitle">반품완료</span> 
					<span class="sm-salomon__statusBarItemValue" data-status-return-done="">
						<c:out value="${returnDoneCount}" default="0" />
					</span>
				</div>
			</div>

			<div class="filter-wrapper">
				<div class="period-buttons">
					<div class="sm-salomon__filterPill" data-period="1" data-selected>1개월</div>
					<div class="sm-salomon__filterPill" data-period="3">3개월</div>
					<div class="sm-salomon__filterPill" data-period="6">6개월</div>
					<div class="sm-salomon__filterPill" data-period="12">1년</div>
				</div>

				<div class="date-inputs">
					<input type="date" class="input-date"> <span class="tilde">~</span>
					<input type="date" class="input-date">
					<button type="button" class="btn-search">조회</button>
				</div>
			</div>

			<div class="order-list-area">
				<c:choose>
					<c:when test="${not empty list}">
						<c:forEach var="dto" items="${list}">
							<div class="order-item-card">
								<div class="card-head">
									<strong class="date">${dto.orderDate}</strong> <span
										class="order-no">주문번호 ${dto.orderNum}</span>
								</div>

								<div class="card-content">
									<div class="thumb">
										<img
											src="${pageContext.request.contextPath}/uploads/product/${dto.imageFilename}"
											onerror="this.src='${pageContext.request.contextPath}/dist/images/no-image.png'">
									</div>

									<div class="info">
										<div class="state-text">${dto.orderState}</div>
										<div class="prod-name">${dto.productName}</div>
										<div class="options">[옵션] ${not empty dto.colorName ? dto.colorName : '-'}
											/ ${not empty dto.sizeName ? dto.sizeName : '-'}</div>
										<div class="price-qty">
											<strong> <fmt:formatNumber
													value="${dto.totalAmount}" pattern="#,###" />원
											</strong> <span>· ${dto.qty}개</span>
										</div>
									</div>

									<div class="buttons">
										<button type="button" class="btn-basic">상세보기</button>
									</div>
								</div>
							</div>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<div class="no-data-msg">취소/반품 내역이 없습니다.</div>
					</c:otherwise>
				</c:choose>

				<div class="page-navigation">${paging}</div>
			</div>
		</main>
	</div>
	
	
	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
	<jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />

	<script>
		document.addEventListener("DOMContentLoaded", function() {
			const pills = document.querySelectorAll('.sm-salomon__filterPill');
	
			pills.forEach(pill => {
				pill.addEventListener('click', () => {
					pills.forEach(p => p.removeAttribute('data-selected'));
					pill.setAttribute('data-selected', '');
				});
			});
		});
	</script>

</body>
</html>