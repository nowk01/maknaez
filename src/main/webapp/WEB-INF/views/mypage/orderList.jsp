<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>주문/배송조회 | MAKNAEZ</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/mypage.css">

<style>
@import
	url('https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800&family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap')
	;

body {
	font-family: 'Montserrat', 'Noto Sans KR', sans-serif;
	letter-spacing: -0.5px;
	color: #000;
}

/* 1. 상단 상태 대시보드 */
.status-dashboard-container {
	display: flex;
	justify-content: space-between;
	align-items: center;
	border: 1px solid #e5e5e5;
	padding: 40px 0;
	margin-bottom: 50px;
	background: #fff;
	border-radius: 10px;
}

.status-item {
	flex: 1;
	text-align: center;
	display: flex;
	flex-direction: column;
	align-items: center;
}

.status-item .title {
	font-size: 14px;
	color: #888;
	margin-bottom: 12px;
	font-weight: 500;
}

.status-item .count {
	font-size: 32px;
	font-weight: 700;
	color: #000;
	font-family: 'Montserrat', sans-serif;
}

.status-item .count.point-red {
	color: #ff4e00;
}

.status-item-divider {
	width: 1px;
	height: 50px;
	background-color: #eee;
}

/* 2. 필터 영역 */
.filter-section-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 25px;
}

.pill-button-group {
	display: flex;
	gap: 10px;
}

/* 기간 버튼 애니메이션 */
.custom-pill-btn {
	border: 1px solid #e0e0e0;
	background: #fff;
	color: #888;
	font-weight: 600;
	padding: 0 24px;
	height: 42px;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	font-size: 14px;
	cursor: pointer;
	transition: all 0.3s ease;
	border-radius: 21px !important;
}

.custom-pill-btn:hover {
	border-color: #000;
	color: #000;
}

/* ★ 기간 버튼 '선택됨' 상태: 검정 배경 ★ */
.custom-pill-btn[data-selected], .custom-pill-btn.active {
	background: #000 !important;
	color: #fff !important;
	border-color: #000 !important;
}

.ipt-cal-field {
	height: 42px;
	border: 1px solid #e0e0e0;
	padding: 0 15px;
	font-size: 14px;
	color: #333;
	width: 140px;
	border-radius: 5px;
}

.btn-submit-search {
	height: 42px;
	padding: 0 35px;
	background: #000;
	color: #fff;
	border: none;
	font-size: 14px;
	font-weight: 700;
	cursor: pointer;
	border-radius: 5px;
	transition: opacity 0.2s;
}

/* 3. 게시판 UI */
.order-list-board {
	border-top: 2.5px solid #000;
	margin-top: 10px;
}

.board-thead {
	display: flex;
	padding: 18px 0;
	text-align: center;
	border-bottom: 2.5px solid #000;
}

.board-thead>div {
	font-weight: 700;
	font-size: 15px;
	color: #000;
}

.th-info {
	flex: 5.5;
}

.th-stat {
	flex: 2;
}

.th-price {
	flex: 2.5;
}

.order-item-group {
	border-bottom: 1px solid #ddd;
}

.order-meta-line {
	background-color: #fff;
	border-bottom: 1px solid #f0f0f0;
	padding: 15px 0 15px 10px;
	display: flex;
	align-items: center;
	font-size: 14px;
	font-weight: 700;
	color: #000;
	position: relative;
}

.order-meta-line::after {
	content: '>';
	position: absolute;
	right: 20px;
	color: #ccc;
	font-size: 16px;
}

.order-meta-line .ord-no {
	font-weight: 400;
	color: #999;
	margin-left: 12px;
	font-family: 'Montserrat', sans-serif;
}

.board-tbody-row {
	display: flex;
	align-items: center;
	padding: 30px 0;
	text-align: center;
}

.td-item-info {
	flex: 5.5;
	display: flex;
	align-items: flex-start;
	text-align: left;
	padding-left: 20px;
}

.td-item-info .thumb {
	width: 110px;
	height: 110px;
	border: 1px solid #f0f0f0;
	margin-right: 25px;
	flex-shrink: 0;
}

.td-item-info .thumb img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.td-item-info .details {
	display: flex;
	flex-direction: column;
	justify-content: center;
	min-height: 110px;
}

.td-item-info .name {
	font-size: 17px;
	font-weight: 700;
	color: #000;
	margin-bottom: 8px;
	line-height: 1.4;
}

.td-item-info .option-qty {
	font-size: 14px;
	color: #777;
	line-height: 1.8;
	font-weight: 400;
}

.td-item-stat {
	flex: 2;
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	gap: 8px;
}

.td-item-stat .status-badge {
	font-size: 15px;
	font-weight: 400;
	color: #333;
}

.btn-action-mini {
	display: inline-block;
	padding: 6px 14px;
	font-size: 12px;
	font-weight: 600;
	border: 1px solid #ddd;
	background: #fff;
	color: #666;
	cursor: pointer;
}

.td-item-price {
	flex: 2.5;
	display: flex;
	align-items: center;
	justify-content: center;
}

.td-item-price .price-val {
	font-size: 18px;
	font-weight: 700;
	color: #000;
	font-family: 'Montserrat', sans-serif;
}

.order-summary-footer {
	padding: 15px 25px;
	display: flex;
	justify-content: flex-end;
	align-items: center;
	border-top: 1px solid #f0f0f0;
	gap: 20px;
}

.order-summary-footer .summary-label {
	font-size: 13px;
	color: #888;
	font-weight: 500;
	font-family: 'Montserrat', sans-serif;
}

.order-summary-footer .summary-content {
	font-size: 15px;
	color: #000;
	font-weight: 600;
	font-family: 'Montserrat', sans-serif;
}

.order-summary-footer .summary-content strong {
	font-weight: 700;
	color: #000;
	font-family: 'Montserrat', sans-serif;
	margin-left: 5px;
}

/* ★ 페이징 디자인 (호버 시 테두리, 선택 시 검정 배경) ★ */
.page-navigation-wrap {
	margin: 60px 0;
	text-align: center;
	display: flex;
	justify-content: center;
	align-items: center;
	gap: 8px;
}

.page-navigation-wrap a, .page-navigation-wrap span,
	.page-navigation-wrap b {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	width: 36px;
	height: 36px;
	font-size: 14px;
	font-family: 'Montserrat', sans-serif;
	color: #888;
	text-decoration: none;
	border: 1px solid transparent;
	transition: all 0.2s;
	cursor: pointer;
	border-radius: 50%;
}

.page-navigation-wrap a:hover {
	color: #000;
	border: 1px solid #000 !important;
}

/* ★ 페이징 '현재 페이지' 강조: 검정 배경 + 흰색 글씨 ★ */
.page-navigation-wrap span.current, .page-navigation-wrap b {
	background-color: #000 !important;
	color: #fff !important;
	font-weight: 700 !important;
	border: 1px solid #000 !important;
}
</style>
</head>
<body>
	<form name="searchForm"
		action="${pageContext.request.contextPath}/member/mypage/orderList"
		method="get">
		<input type="hidden" name="page" value="${page}"> <input
			type="hidden" name="historyStartDate" value="${historyStartDate}">
		<input type="hidden" name="historyEndDate" value="${historyEndDate}">
	</form>

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
				<p>· 같은 제품의 동일 사이즈는 2개 이상 구매하신 경우, 주문 취소 시 해당 제품의 전체 수량이 취소됩니다.</p>
			</div>

			<div class="status-dashboard-container">
				<div class="status-item">
					<span class="title">전체</span><span class="count point-red"><c:out
							value="${dataCount}" default="0" /></span>
				</div>
				<div class="status-item-divider"></div>
				<div class="status-item">
					<span class="title">결제완료</span><span class="count"><c:out
							value="${paymentCount}" default="0" /></span>
				</div>
				<div class="status-item-divider"></div>
				<div class="status-item">
					<span class="title">배송중</span><span class="count"><c:out
							value="${shippingCount}" default="0" /></span>
				</div>
				<div class="status-item-divider"></div>
				<div class="status-item">
					<span class="title">배송완료</span><span class="count"><c:out
							value="${completeCount}" default="0" /></span>
				</div>
			</div>

			<div class="filter-section-row">
				<div class="pill-button-group">
					<div
						class="custom-pill-btn ${empty param.historyStartDate ? 'active' : ''}"
						data-period="1">1개월</div>
					<div class="custom-pill-btn" data-period="3">3개월</div>
					<div class="custom-pill-btn" data-period="6">6개월</div>
					<div class="custom-pill-btn" data-period="12">1년</div>
				</div>
				<div class="date-search-group">
					<input type="date" class="ipt-cal-field" id="sDate"
						value="${historyStartDate}"> <span>~</span> <input
						type="date" class="ipt-cal-field" id="eDate"
						value="${historyEndDate}">
					<button type="button" class="btn-submit-search"
						onclick="searchList()">조회</button>
				</div>
			</div>

			<div class="order-list-board">
				<div class="board-thead">
					<div class="th-info">상품 정보</div>
					<div class="th-stat">주문상태</div>
					<div class="th-price">주문금액</div>
				</div>

				<c:choose>
					<c:when test="${not empty list}">
						<c:forEach var="dto" items="${list}">
							<div class="order-item-group">
								<div class="order-meta-line"
									onclick="location.href='${pageContext.request.contextPath}/member/mypage/orderDetail?orderNum=${dto.orderNum}'"
									style="cursor: pointer;">
									${dto.orderDate} <span class="ord-no">| ${dto.orderNum}</span>
								</div>
								<div class="board-tbody-row">
									<div class="td-item-info">
										<div class="thumb">
											<img
												src="${pageContext.request.contextPath}/uploads/product/${dto.thumbNail}"
												onerror="this.src='${pageContext.request.contextPath}/dist/images/no-image.png'">
										</div>
										<div class="details">
											<div class="name">${dto.productName}</div>
											<div class="option-qty">사이즈: ${not empty dto.pdSize ? dto.pdSize : '-'}
												/ 수량: ${dto.qty}개</div>
										</div>
									</div>
									<div class="td-item-stat">
										<span class="status-badge">${dto.orderState}</span>
										<c:choose>
											<c:when test="${dto.orderState == '결제완료'}">
												<button type="button" class="btn-action-mini"
													onclick="openCancelModal('${dto.orderNum}')">주문취소</button>
											</c:when>
											<c:when test="${dto.orderState == '배송완료'}">
												<button type="button" class="btn-action-mini"
													onclick="confirmOrder('${dto.orderNum}')">구매확정</button>
											</c:when>
										</c:choose>
									</div>
									<div class="td-item-price">
										<span class="price-val"><fmt:formatNumber
												value="${dto.totalAmount}" pattern="#,###" />원</span>
									</div>
								</div>
								<div class="order-summary-footer">
									<span class="summary-label">결제 요약</span> <span
										class="summary-content">총 수량 ${dto.qty}개 / 총 결제금액 <strong><fmt:formatNumber
												value="${dto.totalAmount}" pattern="#,###" />원</strong></span>
								</div>
							</div>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<div style="text-align: center; padding: 100px 0; color: #888;">주문
							내역이 없습니다.</div>
					</c:otherwise>
				</c:choose>
				<div class="page-navigation-wrap">${paging}</div>
			</div>
		</main>
	</div>

	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

	<script>
        document.addEventListener("DOMContentLoaded", function() {
            const pills = document.querySelectorAll('.custom-pill-btn');
            pills.forEach(pill => {
                pill.addEventListener('click', function(e) {
                    pills.forEach(p => {
                        p.removeAttribute('data-selected');
                        p.classList.remove('active');
                    });
                    this.setAttribute('data-selected', '');
                    setPeriod(this.getAttribute("data-period"));
                });
            });
            const f = document.searchForm;
            if(f.historyStartDate.value) document.getElementById("sDate").value = f.historyStartDate.value;
            if(f.historyEndDate.value) document.getElementById("eDate").value = f.historyEndDate.value;
        });

        function setPeriod(months) {
            let now = new Date();
            let past = new Date();
            past.setMonth(now.getMonth() - parseInt(months));
            const formatDate = (d) => d.toISOString().split('T')[0];
            const f = document.searchForm;
            f.historyStartDate.value = formatDate(past);
            f.historyEndDate.value = formatDate(now);
            f.page.value = "1";
            f.submit();
        }

        function searchList() {
            const f = document.searchForm;
            let start = document.getElementById("sDate").value;
            let end = document.getElementById("eDate").value;
            if(!start || !end) { alert("날짜를 모두 선택해주세요."); return; }
            f.historyStartDate.value = start; f.historyEndDate.value = end;
            f.page.value = "1";
            f.submit();
        }

        function listPage(page) {
            const f = document.searchForm;
            f.page.value = page;
            f.submit();
        }

        function openCancelModal(orderNum) { if(confirm("주문을 취소하시겠습니까?")) location.href = "${pageContext.request.contextPath}/member/mypage/claimForm?order_id=" + orderNum + "&type=CANCEL"; }
        function confirmOrder(orderNum) { if(confirm("상품을 잘 받으셨나요? 구매확정 시 포인트가 적립되며 반품이 불가능합니다.")) { location.href = "${pageContext.request.contextPath}/member/mypage/confirmOrder?orderNum=" + orderNum; } }
    </script>
</body>
</html>