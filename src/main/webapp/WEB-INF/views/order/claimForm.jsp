<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>MAKNAEZ | CANCEL / EXCHANGE</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/mypage.css">

<style>
.claim-wrapper {
	max-width: 700px;
	margin: 60px auto;
	color: #000;
	font-family: 'Noto Sans KR', sans-serif;
}

.claim-header {
	border-bottom: 2px solid #000;
	padding-bottom: 15px;
	margin-bottom: 40px;
}

.claim-header h2 {
	font-size: 28px;
	font-weight: 800;
	letter-spacing: -1px;
	text-transform: uppercase;
}

/* Product Summary Card */
.product-card {
	display: flex;
	align-items: center;
	padding: 20px;
	background: #f9f9f9;
	margin-bottom: 40px;
	border: 1px solid #eee;
}

.product-card img {
	width: 100px;
	height: 100px;
	object-fit: cover;
	background: #fff;
	border: 1px solid #e5e5e5;
}

.product-info {
	margin-left: 20px;
}

.product-info .order-num {
	font-size: 12px;
	color: #888;
	text-transform: uppercase;
	margin-bottom: 5px;
}

.product-info .product-name {
	font-size: 16px;
	font-weight: 700;
}

/* Form Styles */
.form-section {
	margin-bottom: 30px;
}

.form-label {
	display: block;
	font-size: 13px;
	font-weight: 700;
	text-transform: uppercase;
	margin-bottom: 10px;
	letter-spacing: 0.5px;
}

.form-control {
	width: 100%;
	border: 1px solid #e5e5e5;
	padding: 15px;
	font-size: 14px;
	border-radius: 0;
	appearance: none;
	-webkit-appearance: none;
}

.form-control:focus {
	border-color: #000;
	outline: none;
}

.form-textarea {
	resize: none;
	height: 150px;
	line-height: 1.6;
}

/* Custom Select Arrow */
.select-wrapper {
	position: relative;
}

.select-wrapper::after {
	content: '↓';
	position: absolute;
	right: 15px;
	top: 50%;
	transform: translateY(-50%);
	font-size: 12px;
	pointer-events: none;
}

/* Buttons */
.btn-group {
	display: flex;
	gap: 10px;
	margin-top: 50px;
}

.btn-salomon {
	flex: 1;
	padding: 20px;
	font-size: 15px;
	font-weight: 700;
	text-transform: uppercase;
	border: 1px solid #000;
	cursor: pointer;
	transition: 0.3s;
}

.btn-black {
	background: #000;
	color: #fff;
}

.btn-white {
	background: #fff;
	color: #000;
}

.btn-black:hover {
	background: #333;
}

.btn-white:hover {
	background: #f0f0f0;
}

.required-star {
	color: #ff4d4d;
	margin-left: 3px;
}
</style>
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
			<div class="claim-wrapper">
				<header class="claim-header">
					<h2>MAKNAEZ | Cancel / Exchange</h2>
				</header>

				<div class="product-card">
					<img
						src="${pageContext.request.contextPath}/uploads/product/${dto.thumbNail}"
						onerror="this.src='${pageContext.request.contextPath}/dist/images/no-image.png'">
					<div class="product-info">
						<p class="order-num">No. ${dto.orderNum}</p>
						<p class="product-name">${dto.productName}</p>
						<p style="font-size: 13px; color: #666;">[옵션] ${dto.pdSize} /
							${dto.qty}개</p>
					</div>
				</div>

				<form id="claimForm"
					action="${pageContext.request.contextPath}/order/claimRequest"
					method="post">
					<input type="hidden" name="order_id" value="${param.order_id}">

					<div class="form-section">
						<label class="form-label">Request Type <span
							class="required-star">*</span></label>
						<div class="select-wrapper">
							<select name="type" class="form-control" id="claimType" required>
								<option value="CANCEL">주문 취소 (배송 전)</option>
								<option value="EXCH">교환 신청 (배송 완료 후)</option>
							</select>
						</div>
					</div>

					<div class="form-section">
						<label class="form-label">Reason Category <span
							class="required-star">*</span></label>
						<div class="select-wrapper">
							<select name="reason_category" class="form-control"
								id="reasonCategory" required>
								<option value="">사유를 선택해 주세요</option>
								<option value="단순 변심">단순 변심 (Size/Color)</option>
								<option value="상품 불량">상품 불량 및 파손</option>
								<option value="배송 지연">배송 지연</option>
								<option value="오배송">오배송 (상품 오발송)</option>
								<option value="etc">기타 직접 입력</option>
							</select>
						</div>
					</div>

					<div class="form-section">
						<label class="form-label">Detailed Reason</label>
						<textarea name="reason" class="form-control form-textarea"
							id="reasonDetail"
							placeholder="상세 사유를 입력해 주세요. 교환의 경우 원하시는 옵션(사이즈 등)을 반드시 입력해 주셔야 재고 확인이 가능합니다."></textarea>
					</div>

					<div class="btn-group">
						<button type="button" class="btn-salomon btn-white"
							onclick="history.back()">Back</button>
						<button type="submit" class="btn-salomon btn-black">Submit
							Request</button>
					</div>
				</form>
			</div>
		</main>
	</div>

	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

	<script>
		document
				.addEventListener(
						"DOMContentLoaded",
						function() {
							const claimForm = document
									.getElementById("claimForm");

							claimForm
									.addEventListener(
											"submit",
											function(e) {
												const type = document
														.getElementById("claimType").value;
												const category = document
														.getElementById("reasonCategory").value;
												const detail = document
														.getElementById("reasonDetail").value
														.trim();

												// 1. 필수 선택 값 확인
												if (!category) {
													alert("신청 사유를 선택해 주세요.");
													e.preventDefault();
													return;
												}

												// 2. 교환 시 상세 사유 입력 권장 (재고 연동 때문)
												if (type === "EXCH"
														&& detail.length < 5) {
													alert("교환 신청 시 교환을 원하시는 [사이즈/컬러] 정보를 상세 사유에 입력해 주세요.");
													e.preventDefault();
													return;
												}

												// 3. 최종 확인
												const confirmMsg = type === "CANCEL" ? "주문 취소를 신청하시겠습니까?\n취소 완료 시 사용된 포인트는 환불되며 재고가 복구됩니다."
														: "교환을 신청하시겠습니까?\n관리자 확인 후 진행됩니다.";

												if (!confirm(confirmMsg)) {
													e.preventDefault();
												}
											});

							// 신청 유형 변경 시 문구 가이드 변경
							document
									.getElementById("claimType")
									.addEventListener(
											"change",
											function() {
												const detailArea = document
														.getElementById("reasonDetail");
												if (this.value === "EXCH") {
													detailArea.placeholder = "교환을 원하시는 옵션(사이즈, 컬러 등)을 입력해 주세요. (재고 부족 시 처리가 지연될 수 있습니다.)";
												} else {
													detailArea.placeholder = "상세한 취소 사유를 입력하시면 빠른 처리에 도움이 됩니다.";
												}
											});
						});
	</script>

</body>
</html>