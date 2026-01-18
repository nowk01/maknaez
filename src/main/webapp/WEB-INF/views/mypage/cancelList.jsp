<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>취소/반품 조회 | MAKNAEZ</title>
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
}

/* 3. 게시판 UI (상세 목록형 5컬럼) */
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

.col-date-no {
	flex: 2;
}

.col-product-info {
	flex: 5;
}

.col-proc-status {
	flex: 1.5;
}

.col-refund-amt {
	flex: 1.5;
}

.order-item-row {
	display: flex;
	align-items: center;
	padding: 30px 0;
	text-align: center;
	border-bottom: 1px solid #eee;
}

.ord-no-link {
	font-size: 13px;
	font-weight: 600;
	color: #666;
	text-decoration: underline;
	cursor: pointer;
	font-family: 'Montserrat', sans-serif;
	margin-top: 5px;
	display: block;
}

.td-product-wrap {
	display: flex;
	align-items: center;
	text-align: left;
	padding-left: 20px;
}

.td-product-wrap .thumb {
	width: 90px;
	height: 90px;
	border: 1px solid #f0f0f0;
	margin-right: 25px;
	flex-shrink: 0;
}

.td-product-wrap .thumb img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.td-product-wrap .name {
	font-size: 16px;
	font-weight: 700;
	color: #000;
	margin-bottom: 6px;
	line-height: 1.4;
}

.td-product-wrap .opt {
	font-size: 14px;
	color: #777;
	font-weight: 400;
}

.status-badge-text {
	font-size: 15px;
	color: #333;
	font-weight: 400;
}

.price-bold-text {
	font-size: 17px;
	font-weight: 700;
	font-family: 'Montserrat', sans-serif;
	color: #000;
}

/* 4. 페이징 디자인 */
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

.page-navigation-wrap span.current, .page-navigation-wrap b {
	background-color: #000 !important;
	color: #fff !important;
	font-weight: 700 !important;
	border: 1px solid #000 !important;
}
</style>
</head>
<body>
	<form name="searchForm" id="searchForm"
		action="${pageContext.request.contextPath}/member/mypage/cancelList"
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
						href="${pageContext.request.contextPath}/member/mypage/orderList">주문/배송조회</a></li>
					<li><a
						href="${pageContext.request.contextPath}/member/mypage/cancelList"
						class="active">취소상품조회</a></li>
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
			<h1 class="page-title">취소/반품 조회</h1>
			<div class="notice-box">
				<p>· 취소/반품 신청 내역 및 처리 상태를 확인하실 수 있습니다.</p>
			</div>

			<div class="status-dashboard-container">
				<div class="status-item">
					<span class="title">전체</span> <span class="count point-red"><c:out
							value="${dataCount}" default="0" /></span>
				</div>
				<div class="status-item-divider"></div>
				<div class="status-item">
					<span class="title">취소완료</span> <span class="count"><c:out
							value="${cancelCount}" default="0" /></span>
				</div>
				<div class="status-item-divider"></div>
				<div class="status-item">
					<span class="title">반품신청</span> <span class="count"><c:out
							value="${returnCheckCount}" default="0" /></span>
				</div>
				<div class="status-item-divider"></div>
				<div class="status-item">
					<span class="title">반품완료</span> <span class="count"><c:out
							value="${returnDoneCount}" default="0" /></span>
				</div>
			</div>

			<div class="filter-section-row">
				<div class="pill-button-group">
					<div
						class="custom-pill-btn ${empty historyStartDate ? 'active' : ''}"
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
					<div class="col-date-no">신청일자/번호</div>
					<div class="col-product-info">상품정보</div>
					<div class="col-proc-status">처리상태</div>
					<div class="col-refund-amt">환불금액</div>
				</div>

				<c:choose>
					<c:when test="${not empty list}">
						<c:forEach var="dto" items="${list}">
							<div class="order-item-row">
								<div class="col-date-no">
									<div style="font-size: 14px; font-weight: 500;">${dto.orderDate}</div>
									<a class="ord-no-link"
										onclick="location.href='${pageContext.request.contextPath}/member/mypage/orderDetail?orderNum=${dto.orderNum}'">${dto.orderNum}</a>
								</div>
								<div class="col-product-info td-product-wrap">
									<div class="thumb">
										<img
											src="${pageContext.request.contextPath}/uploads/product/${dto.thumbNail}"
											onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/dist/images/no-image.png';">
									</div>
									<div>
										<div class="name">${dto.productName}</div>
										<div class="opt">옵션: ${not empty dto.pdSize ? dto.pdSize : '-'}
											/ ${dto.qty}개</div>
									</div>
								</div>
								<div class="col-proc-status status-badge-text">${dto.orderState}</div>
								<div class="col-refund-amt price-bold-text">
									<fmt:formatNumber value="${dto.totalAmount}" pattern="#,###" />
									원
								</div>
							</div>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<div style="text-align: center; padding: 100px 0; color: #888;">내역이
							없습니다.</div>
					</c:otherwise>
				</c:choose>
				<div class="page-navigation-wrap">${paging}</div>
			</div>
		</main>
	</div>

	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

	<script>
        document.addEventListener("DOMContentLoaded", function() {
            // 기간 알약 버튼 이벤트 연결
            document.querySelectorAll('.custom-pill-btn').forEach(pill => {
                pill.addEventListener('click', function() {
                    setPeriod(this.getAttribute("data-period"));
                });
            });
            // 달력 초기값 세팅
            const f = document.searchForm;
            if(f.historyStartDate.value) document.getElementById("sDate").value = f.historyStartDate.value;
            if(f.historyEndDate.value) document.getElementById("eDate").value = f.historyEndDate.value;
        });
            
        function setPeriod(months) {
            const now = new Date();
            const past = new Date();
            past.setMonth(now.getMonth() - parseInt(months));
            const formatDate = (d) => {
                let y = d.getFullYear();
                let m = ('0' + (d.getMonth() + 1)).slice(-2);
                let day = ('0' + d.getDate()).slice(-2);
                return y + '-' + m + '-' + day;
            };
            const f = document.searchForm;
            f.historyStartDate.value = formatDate(past);
            f.historyEndDate.value = formatDate(now);
            f.page.value = "1";
            f.submit();
        }
        
        function searchList() {
            const f = document.searchForm;
            const start = document.getElementById("sDate").value;
            const end = document.getElementById("eDate").value;
            if(!start || !end) { alert("날짜를 모두 선택해주세요."); return; }
            f.historyStartDate.value = start; 
            f.historyEndDate.value = end;
            f.page.value = "1"; 
            f.submit();
        }

        function listPage(page) {
            const f = document.searchForm;
            f.page.value = page;
            f.submit();
        }
    </script>
</body>
</html>