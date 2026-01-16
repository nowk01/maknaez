<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>주문/배송조회 | 쇼핑몰</title>
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
					<li><a
						href="${pageContext.request.contextPath}/member/mypage/orderList"
						class="active">주문/배송조회</a></li>
					<li><a
						href="${pageContext.request.contextPath}/member/mypage/cancelList">취소상품조회</a></li>
				</ul>
			</div>

			<div class="menu-group">
				<span class="menu-title">혜택내역</span>
				<ul>
					<li><a
						href="${pageContext.request.contextPath}/member/mypage/review">상품
							리뷰</a></li>
					<li><a href="#">포인트/쿠폰</a></li>
				</ul>
			</div>

			<div class="menu-group">
				<span class="menu-title">상품내역</span>
				<ul>
					<li><a href="#">최근 본 상품</a></li>
					<li><a
						href="${pageContext.request.contextPath}/member/mypage/wishList">관심
							상품</a></li>
				</ul>
			</div>

			<div class="menu-group">
				<span class="menu-title">회원정보</span>
				<ul>
					<li><a
						href="${pageContext.request.contextPath}/member/mypage/myImfo">내
							정보 관리</a></li>
					<li><a
						href="${pageContext.request.contextPath}/member/mypage/addr">배송지
							관리</a></li>
					<li><a
						href="${pageContext.request.contextPath}/member/mypage/level_benefit">회원등급</a></li>
				</ul>
			</div>
		</aside>

		<main class="main-content">
			<h1 class="page-title">주문/배송조회</h1>

			<div class="notice-box">
				<p>같은 제품의 동일 사이즈는 2개 이상 구매하신 경우, 주문 취소 시 해당 제품의 전체 수량이 취소됩니다.</p>
				<p>전체 취소 후 재구매 부탁드립니다.</p>
			</div>


			<div class="sm-salomon__statusBar">

				<div class="sm-salomon__statusBarItem" data-status-bar-item="">
					<span class="sm-salomon__statusBarItemTitle">전체</span> <span
						class="sm-salomon__statusBarItemValue" data-status-total="">
						<c:out value="${dataCount}" default="0" />
					</span>
				</div>

				<div class="sm-salomon__statusBarBorder">
					<svg xmlns="http://www.w3.org/2000/svg" width="1" height="76"
						viewBox="0 0 1 76" fill="none">
            			<line x1="0.5" y1="0" x2="0.5" y2="76" stroke="#E7E7E7"></line>
        			</svg>
				</div>

				<div class="sm-salomon__statusBarItem" data-status-bar-item="">
					<span class="sm-salomon__statusBarItemTitle">결제완료</span> <span
						class="sm-salomon__statusBarItemValue" data-status-paid="">
						<c:out value="${paymentCount}" default="0" />
					</span>
				</div>

				<div class="sm-salomon__statusBarBorder">
					<svg xmlns="http://www.w3.org/2000/svg" width="1" height="76"
						viewBox="0 0 1 76" fill="none">
            			<line x1="0.5" y1="0" x2="0.5" y2="76" stroke="#E7E7E7"></line>
        			</svg>
				</div>

				<div class="sm-salomon__statusBarItem" data-status-bar-item="">
					<span class="sm-salomon__statusBarItemTitle">배송중</span> <span
						class="sm-salomon__statusBarItemValue" data-status-in-transit="">
						<c:out value="${shippingCount}" default="0" />
					</span>
				</div>

				<div class="sm-salomon__statusBarBorder">
					<svg xmlns="http://www.w3.org/2000/svg" width="1" height="76"
						viewBox="0 0 1 76" fill="none">
            			<line x1="0.5" y1="0" x2="0.5" y2="76" stroke="#E7E7E7"></line>
        			</svg>
				</div>

				<div class="sm-salomon__statusBarItem" data-status-bar-item="">
					<span class="sm-salomon__statusBarItemTitle">배송완료</span> <span
						class="sm-salomon__statusBarItemValue" data-status-delivered="">
						<c:out value="${completeCount}" default="0" />
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
											src="${pageContext.request.contextPath}/uploads/product/${dto.thumbNail}"
											onerror="this.src='${pageContext.request.contextPath}/dist/images/no-image.png'">
									</div>

									<div class="info">
										<div class="state-text">${dto.orderState}</div>
										<div class="prod-name">${dto.productName}</div>
										<div class="options">[옵션] ${not empty dto.pdSize ? dto.pdSize : '-'}</div>
										<div class="price-qty">
											<strong> <fmt:formatNumber
													value="${dto.totalAmount}" pattern="#,###" />원
											</strong> <span>· ${dto.qty}개</span>
										</div>
									</div>


									<div class="buttons">
										<c:choose>
											<%-- 1. 결제완료 상태: 주문취소만 가능 --%>
											<c:when test="${dto.orderState == '결제완료'}">
												<button type="button" class="btn-sm btn-outline"
													onclick="openCancelModal('${dto.orderNum}')">주문취소</button>
											</c:when>

											<%-- 2. 배송중 상태: 배송조회 필수 --%>
											<c:when test="${dto.orderState == '배송중'}">
												<button type="button" class="btn-sm btn-black"
													onclick="openDeliveryTracking('${dto.orderNum}')">배송조회</button>
											</c:when>

											<%-- 3. 배송완료 상태: 배송조회 + 교환/반품 신청 --%>
											<c:when test="${dto.orderState == '배송완료'}">
												<button type="button" class="btn-sm btn-black"
													onclick="openDeliveryTracking('${dto.orderNum}')">배송조회</button>
												<button type="button" class="btn-sm btn-outline"
													onclick="location.href='${pageContext.request.contextPath}/order/claimForm?order_id=${dto.orderNum}'">
													교환/반품 신청</button>
											</c:when>

											<%-- 4. 취소완료/반품완료 등: 버튼 미노출 또는 상세기능 --%>
											<c:otherwise>
												<button type="button" class="btn-sm btn-outline"
													onclick="location.href='${pageContext.request.contextPath}/member/mypage/orderDetail?orderNum=${dto.orderNum}'">
													주문상세</button>
											</c:otherwise>
										</c:choose>
									</div>
								</div>
							</div>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<div class="no-data-msg">아직 주문한 내역이 없습니다.</div>
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
		
		function openCancelModal(orderId) {
		    const reason = prompt("취소 사유를 입력해주세요.");
		    if(reason) {
		        location.href = "/order/claimRequest?order_id=" + orderId + "&reason=" + reason;
		    }
		}
		
		function openCancelModal(orderId) {
		    if(confirm("주문을 취소하시겠습니까?")) {
		        location.href = "${pageContext.request.contextPath}/order/cancelRequest?orderNum=" + orderId;
		    }
		}

		function openDeliveryTracking(orderNum) {
		    window.open("${pageContext.request.contextPath}/member/mypage/deliveryInfo?orderNum=" + orderNum, 
		                "deliveryPop", "width=550,height=700");
		}
		
	</script>

</body>
</html>