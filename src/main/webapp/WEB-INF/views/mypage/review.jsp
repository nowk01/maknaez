<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>상품 리뷰 | 쇼핑몰</title>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage.css">
</head>
<body>

	<jsp:include page="/WEB-INF/views/layout/header.jsp" />

	<div class="mypage-container">
		
		<div class="sm-salomon__accountSidebar">
			<h1 class="h2 feature-header" data-cc-animate>마이페이지</h1>
			<div class="sm-salomon__accountSidebarList" data-cc-animate>

				<div class="sm-salomon__accountCard">
					<h3 class="sm-salomon__accountCardHeading">구매내역</h3>
					<a href="${pageContext.request.contextPath}/member/mypage/orderList" class="sm-salomon__accountCardLink">주문/배송조회</a>
					<a href="${pageContext.request.contextPath}/member/mypage/cancelList" class="sm-salomon__accountCardLink">취소/반품조회</a>
				</div>

				<div class="sm-salomon__accountCard">
					<h3 class="sm-salomon__accountCardHeading">혜택내역</h3>
					<a href="${pageContext.request.contextPath}/member/mypage/review" class="sm-salomon__accountCardLink" style="font-weight: 700;">상품 리뷰</a>
					<a href="#" class="sm-salomon__accountCardLink">포인트/쿠폰</a>
				</div>

				<div class="sm-salomon__accountCard">
					<h3 class="sm-salomon__accountCardHeading">상품내역</h3>
					<a href="#" class="sm-salomon__accountCardLink">최근 본 상품</a>
					<a href="#" class="sm-salomon__accountCardLink">관심 상품</a>
				</div>

				<div class="sm-salomon__accountCard">
					<h3 class="sm-salomon__accountCardHeading">회원정보</h3>
					<a href="#" class="sm-salomon__accountCardLink">내 정보 관리</a>
					<a href="#" class="sm-salomon__accountCardLink">배송지 관리</a>
					<a href="#" class="sm-salomon__accountCardLink">회원등급</a>
					<a href="#" class="sm-salomon__accountCardLink">문의하기</a>
				</div>

				<a href="${pageContext.request.contextPath}/member/logout" class="sm-salomon__accountCardLink">로그아웃</a>
			</div>
		</div>

		<main class="main-content">
			<h2 class="page-title" style="text-align: left; margin-bottom: 30px;">상품 리뷰</h2>

			<div class="review-tabs">
				<button type="button" class="tab-btn active" onclick="showTab('writable')">작성 가능한 리뷰 (0)</button>
				<button type="button" class="tab-btn" onclick="showTab('written')">작성한 리뷰 (0)</button>
			</div>

			<div id="tab-writable" class="review-tab-content active">
				
				<div class="PendingReviews__header">
					<div class="PendingReviews__order_dropdown">
						<div style="height: 100%;">
							<button type="button" class="AppButton__button AppButton__button--style-plain" onclick="toggleSortMenu()">
								<div class="AppDropdown__label" id="currentSortLabel" style="--label-font-size: 14px;">
									과거 구매순
								</div>
								<svg xmlns="http://www.w3.org/2000/svg" class="AppSvgIcon AppDropdown__icon" style="width: 9px; height: 8px;" viewBox="0 0 12 12">
									<path d="M2 4l4 4 4-4" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
								</svg>
							</button>
						</div>

						<div id="sortMenu" class="sm-salomon__dropdown-menu">
							<div class="sm-salomon__dropdown-item" onclick="selectSort('과거 구매순')">과거 구매순</div>
							<div class="sm-salomon__dropdown-item" onclick="selectSort('최근 구매순')">최근 구매순</div>
							<div class="sm-salomon__dropdown-item" onclick="selectSort('작성기한 임박순')">작성기한 임박순</div>
						</div>
					</div>
					
					<div class="PendingReviews__max-mileage-divider"></div>
				</div>
				<div class="no-data-msg" style="padding: 60px 0;">
					작성 가능한 리뷰가 없습니다.
				</div>
			</div>

			<div id="tab-written" class="review-tab-content">
				<div class="PendingReviews__header">
					<div class="PendingReviews__order_dropdown">
						<button type="button" class="AppButton__button AppButton__button--style-plain">
							<div class="AppDropdown__label">최신순</div>
							<svg xmlns="http://www.w3.org/2000/svg" class="AppSvgIcon AppDropdown__icon" style="width: 9px; height: 8px;" viewBox="0 0 12 12">
								<path d="M2 4l4 4 4-4" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
							</svg>
						</button>
					</div>
				</div>

				<div class="no-data-msg" style="padding: 60px 0;">
					작성한 리뷰 내역이 없습니다.
				</div>
			</div>

			<div class="notice-container">
				<h3>리뷰 작성 시 유의사항</h3>
				<ul>
					<li>리뷰는 최소 20자 이상 작성해야 등록 가능합니다.</li>
					<li>텍스트 리뷰 작성 시 1,000 포인트 / 포토·동영상 리뷰 작성 시 3,000 포인트가 지급됩니다.</li>
					<li>작성하신 리뷰의 노출 및 포인트 지급에는 일정 시간이 소요될 수 있습니다.</li>
					<li>적립된 포인트는 작성일로부터 1년간 유효합니다.</li>
					<li>배송 완료일 기준 90일 이내 작성 가능하며, 중복 작성은 불가합니다.</li>
					<li>리뷰 등록 후에는 수정·삭제가 불가합니다.</li>
					<li>상품과 무관한 내용, 악의적 비방, 개인정보 노출 등은 사전 안내 없이 삭제되거나 등록이 제한될 수 있고, 포인트는 지급되지 않거나 회수될 수 있습니다.</li>
					<li>리뷰 정책은 당사 사정에 따라 변경되거나 종료될 수 있습니다.</li>
				</ul>
			</div>

		</main>
	</div>

	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
	<jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />
	
	<script>
		// 1. 탭 전환
		function showTab(tabName) {
			document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
			document.querySelectorAll('.review-tab-content').forEach(content => content.classList.remove('active'));
			
			if(tabName === 'writable') {
				document.querySelectorAll('.tab-btn')[0].classList.add('active');
				document.getElementById('tab-writable').classList.add('active');
			} else {
				document.querySelectorAll('.tab-btn')[1].classList.add('active');
				document.getElementById('tab-written').classList.add('active');
			}
		}

		// 2. 드롭다운 토글
		function toggleSortMenu() {
			const menu = document.getElementById('sortMenu');
			const dropdown = document.querySelector('.PendingReviews__order_dropdown');
			
			menu.classList.toggle('active');
			dropdown.classList.toggle('open'); // 화살표 회전용 클래스 추가
		}

		// 3. 정렬 선택
		function selectSort(sortName) {
			document.getElementById('currentSortLabel').innerText = sortName;
			
			const menu = document.getElementById('sortMenu');
			const dropdown = document.querySelector('.PendingReviews__order_dropdown');
			
			menu.classList.remove('active');
			dropdown.classList.remove('open');
			
			console.log("정렬 변경됨: " + sortName);
		}

		// 4. 외부 클릭 시 닫기
		document.addEventListener('click', function(event) {
			const dropdown = document.querySelector('.PendingReviews__order_dropdown');
			const menu = document.getElementById('sortMenu');
			
			// 버튼 내부 클릭이 아니면 닫기
			if (dropdown && !dropdown.contains(event.target)) {
				if(menu) menu.classList.remove('active');
				if(dropdown) dropdown.classList.remove('open');
			}
		});
	</script>

</body>
</html>