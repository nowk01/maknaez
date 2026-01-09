<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${dto.productName} - Maknaez Style</title>

<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>

<!-- Custom CSS for Detail Page -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/product-detail.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/header.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/footer.css">
  
<!-- Bootstrap Icons (만약 headerResources에 없다면 추가) -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

<style>
    /* 추가 요청 사항에 따른 CSS 오버라이딩 */
    
    /* 1. 이미지 세로 나열 */
    .product-image-stack img {
        width: 100%;
        height: auto;
        margin-bottom: 20px; /* 이미지 간 간격 */
        display: block;
    }

    /* 2. 상세 정보 스크롤 영역 */
    .product-info-scrollable {
        max-height: 800px; /* 높이를 높게 설정 */
        overflow-y: auto;  /* 내용이 넘치면 스크롤 생성 */
        padding-right: 15px; /* 스크롤바 공간 확보 */
        margin-bottom: 30px;
        border-bottom: 1px solid #eee;
    }
    
    /* 스크롤바 스타일 커스텀 (선택사항) */
    .product-info-scrollable::-webkit-scrollbar {
        width: 8px;
    }
    .product-info-scrollable::-webkit-scrollbar-thumb {
        background-color: #ccc;
        border-radius: 4px;
    }

    /* 3. 구매 영역 버튼 배치 수정 */
    .purchase-area-custom {
        margin-top: 30px;
        padding-top: 20px;
        border-top: 1px solid #eee;
    }
    
    .purchase-row-top {
        display: flex;
        gap: 10px;
        margin-bottom: 10px;
        align-items: stretch; /* 높이 맞춤 */
    }
    
    /* 수량 조절 버튼 스타일 조정 */
    .qty-control-custom {
        display: flex;
        border: 1px solid #ddd;
    }
    .qty-control-custom button {
        width: 40px;
        background: #fff;
        border: none;
        font-size: 1.2rem;
        cursor: pointer;
    }
    .qty-control-custom input {
        width: 50px;
        text-align: center;
        border: none;
        border-left: 1px solid #eee;
        border-right: 1px solid #eee;
        font-weight: bold;
    }

    /* 장바구니 버튼 (같은 레벨) */
    .btn-cart-custom {
        flex: 1; /* 남은 공간 차지 */
        background: #fff;
        border: 1px solid #000;
        color: #000;
        font-weight: 600;
        padding: 12px 0;
        transition: all 0.2s;
    }
    .btn-cart-custom:hover {
        background: #f5f5f5;
    }

    /* 구매하기 버튼 (크게, 아래 배치) */
    .btn-buy-custom {
        width: 100%;
        background: #000;
        color: #fff;
        border: 1px solid #000;
        font-size: 1.1rem;
        font-weight: 700;
        padding: 18px 0; /* 높게 잡기 */
        transition: all 0.3s;
    }
    .btn-buy-custom:hover {
        background: #fff;
        color: #000; /* 색상 반전 */
    }

    /* 입고 알림 텍스트 */
    .restock-text-left {
        font-size: 0.9rem;
        color: #666;
        font-weight: normal; /* 일반 글씨 */
        text-align: left;
    }
</style>

</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main>
	<div class="container product-detail-container">
		
		<form name="buyForm" method="post">
			<!-- [수정] DTO 필드명 불일치 해결: productNum -> productNo -->
			<input type="hidden" name="productNum" value="${dto.productNo}">
			<input type="hidden" name="detailNum" id="selectedDetailNum" value="">
			<input type="hidden" name="qty" id="selectedQty" value="1">
		</form>

		<div class="row">
			<!-- ================= LEFT COLUMN (상세 정보) ================= -->
			<div class="col-lg-8 detail-left-section">
				
				<!-- [수정] 좌-상: 제품 스틸컷 (캐러셀 제거 -> 세로 나열) -->
				<div class="product-image-stack mb-5">
					<!-- 실제 이미지 경로가 있다면 ${dto.imageFile} 등으로 교체 -->
					<img src="https://via.placeholder.com/800x600?text=Product+Image+1" alt="Product Image 1">
					<img src="https://via.placeholder.com/800x600?text=Product+Image+2" alt="Product Image 2">
					<img src="https://via.placeholder.com/800x600?text=Product+Image+3" alt="Product Image 3">
                    <img src="https://via.placeholder.com/800x600?text=Product+Detail+Cut" alt="Product Detail Cut">
				</div>

				<!-- 좌-중1: 탭 (정보, 리뷰, 추천) -->
				<ul class="nav nav-tabs product-tabs mb-4" id="myTab" role="tablist">
					<li class="nav-item" role="presentation">
						<button class="nav-link active" id="info-tab" data-bs-toggle="tab" data-bs-target="#info-pane" type="button" role="tab">제품 정보</button>
					</li>
					<li class="nav-item" role="presentation">
						<button class="nav-link" id="review-tab" type="button" onclick="scrollToReview()">리뷰</button>
					</li>
					<li class="nav-item" role="presentation">
						<button class="nav-link" id="recommend-tab" type="button" onclick="scrollToRecommend()">추천</button>
					</li>
				</ul>

				<!-- [수정] 좌-중2: 제품 정보 (Editor CLOB Content) - 스크롤 적용 -->
				<div class="tab-content" id="myTabContent">
					<div class="tab-pane fade show active" id="info-pane" role="tabpanel">
						<div class="product-info-scrollable">
							<!-- 관리자가 작성한 내용 출력 -->
							${dto.content}
							
							<!-- 내용이 없을 경우 예시 출력 (개발용) -->
							<c:if test="${empty dto.content}">
								<p>상세 정보가 없습니다.</p>
                                <!-- 스크롤 테스트를 위한 더미 텍스트 -->
                                <br><br>
                                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
                                <p>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
                                <img src="https://via.placeholder.com/700x500?text=Detail+Description+Image" class="img-fluid my-3">
                                <p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
                                <p>Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
                                <br><br>
                                <p>스크롤이 생기도록 내용을 길게 배치합니다. 높이 제한은 800px입니다.</p>
							</c:if>
						</div>
					</div>
				</div>

				<!-- 좌-하1: 제품 특징 -->
				<div class="product-features">
					<h4>제품 특징</h4>
					<p>
						<strong>쿠셔닝:</strong> 맥시멀<br>
						<strong>신발 너비:</strong> 기본<br>
						<strong>지형:</strong> 로드, 혼합<br>
						<br>
						이 제품은 최상의 퍼포먼스를 위해 설계되었으며 어쩌구 저쩌구...
					</p>
				</div>

				<!-- 좌-하2: 고시 정보 -->
				<div class="product-notice">
					<h4>상품 제공 고시 정보</h4>
					<table class="notice-table">
						<tr><th>소재</th><td>폴리에스테르 100%</td></tr>
						<tr><th>제조국</th><td>베트남</td></tr>
						<tr><th>제조년월</th><td>2024.01</td></tr>
						<tr><th>수입원</th><td>(주)살로몬 코리아</td></tr>
						<tr><th>A/S 책임자</th><td>1588-0000</td></tr>
						<tr><th>품질보증기준</th><td>관련 법 및 소비자 분쟁해결 규정에 따름</td></tr>
					</table>
				</div>

			</div> <!-- End Left Column -->

			<!-- ================= RIGHT COLUMN (옵션 & 결제) ================= -->
			<div class="col-lg-4 detail-right-section">
				<!-- Sticky Sidebar Wrapper -->
				<div id="stickySidebar" class="sticky-sidebar">
					
					<!-- 우1: 제품명 -->
					<div class="product-name">
						${dto.productName}
					</div>

					<!-- 우2: 가격 -->
					<div class="product-price">
						<fmt:formatNumber value="${dto.price}" pattern="#,###"/> 원
					</div>

					<!-- 우3: 별점, 공유, 찜 -->
					<div class="product-actions-top">
						<div class="star-rating">
							<i class="bi bi-star-fill"></i>
							<i class="bi bi-star-fill"></i>
							<i class="bi bi-star-fill"></i>
							<i class="bi bi-star-fill"></i>
							<i class="bi bi-star-half"></i>
							<span class="text-dark ms-1">(4.8)</span>
						</div>
						<div class="action-icons">
							<i class="bi bi-share" title="공유하기"></i>
							<i class="bi bi-heart" id="wishBtn" title="찜하기"></i>
						</div>
					</div>

					<!-- 우4: 컬러 정보 -->
					<div class="color-options">
						<div class="color-label">컬러 : Black / Silver</div>
						<div class="color-thumbs">
							<!-- 현재 보고 있는 컬러 -->
							<div class="color-thumb active">
								<img src="https://via.placeholder.com/60/000000/FFFFFF?text=BK" alt="Black">
							</div>
							<!-- 다른 컬러 링크 -->
							<div class="color-thumb" onclick="location.href='#'">
								<img src="https://via.placeholder.com/60/FFFFFF/000000?text=WH" alt="White">
							</div>
							<div class="color-thumb" onclick="location.href='#'">
								<img src="https://via.placeholder.com/60/FF0000/FFFFFF?text=RD" alt="Red">
							</div>
						</div>
					</div>

					<!-- 우5: 사이즈 정보 -->
					<div class="size-options">
						<div class="d-flex justify-content-between mb-2">
							<span class="fw-bold">사이즈</span>
							<a href="#" class="text-decoration-underline text-muted" style="font-size:0.8rem;">사이즈 가이드</a>
						</div>
						
						<div class="size-grid">
							<!-- 220 ~ 310, 5단위 반복 -->
							<c:set var="sizes" value="220,225,230,235,240,245,250,255,260,265,270,275,280,285,290,295,300,305,310"/>
							<c:forTokens items="${sizes}" delims="," var="size" varStatus="st">
								<div class="size-item">
									<c:choose>
										<c:when test="${size eq '235' or size eq '260'}">
											<input type="radio" name="optionDetailNum" id="size_${size}" value="${size}" disabled>
											<label for="size_${size}" class="size-btn">${size}</label>
										</c:when>
										<c:otherwise>
											<input type="radio" name="optionDetailNum" id="size_${size}" value="${size}">
											<label for="size_${size}" class="size-btn">${size}</label>
										</c:otherwise>
									</c:choose>
								</div>
							</c:forTokens>
						</div>
					</div>

					<!-- [수정] 우6: 입고 알림 신청 (Flexbox로 좌우 배치 수정) -->
					<div class="restock-alert d-flex justify-content-between align-items-center mb-4">
                        <span class="restock-text-left">원하시는 옵션이 없으신가요?</span>
						<button type="button" class="restock-btn" data-bs-toggle="modal" data-bs-target="#restockModal">
							<i class="bi bi-bell"></i> 입고알림신청하기
						</button>
					</div>

					<!-- [수정] 우7: 수량 및 구매 버튼 (배치 변경) -->
					<div class="purchase-area-custom">
                        <!-- 윗줄: 수량조절 + 장바구니 -->
						<div class="purchase-row-top">
                            <div class="qty-control-custom">
                                <button type="button" class="minus">-</button>
                                <input type="text" class="qty-input" id="displayQty" value="1" readonly>
                                <button type="button" class="plus">+</button>
                            </div>
							<button type="button" class="btn btn-cart-custom" onclick="addToCart()">장바구니</button>
						</div>
						
                        <!-- 아랫줄: 구매하기 (크게) -->
						<div class="purchase-row-bottom">
							<button type="button" class="btn btn-buy-custom" onclick="buyNow()">구매하기</button>
						</div>
					</div>

				</div> <!-- End Sticky Sidebar -->
			</div> <!-- End Right Column -->
		</div> <!-- End Row -->

		<!-- Sentinel Node -->
		<div id="sentinelNode" class="sentinel-point"></div>

		<!-- ================= REVIEW SECTION ================= -->
		<div id="reviewSection" class="review-section">
			<h3>Reviews <span class="text-muted">(120)</span></h3>
			<div class="alert alert-secondary text-center mt-4">
				리뷰 영역입니다. (추후 구현)
			</div>
		</div>

		<!-- ================= RECOMMEND SECTION ================= -->
		<div id="recommendSection" class="recommend-section">
			<h3>추천 상품</h3>
			<div class="recommend-carousel mt-4">
				<div class="row">
					<div class="col-3">
						<div class="card border-0">
							<img src="https://via.placeholder.com/300x300" class="card-img-top" alt="...">
							<div class="card-body px-0">
								<h6 class="card-title">SPEEDCROSS 6</h6>
								<p class="card-text text-muted">198,000 원</p>
							</div>
						</div>
					</div>
					<div class="col-3">
						<div class="card border-0">
							<img src="https://via.placeholder.com/300x300" class="card-img-top" alt="...">
							<div class="card-body px-0">
								<h6 class="card-title">XT-WINGS 2</h6>
								<p class="card-text text-muted">210,000 원</p>
							</div>
						</div>
					</div>
					<!-- 더미 데이터 -->
				</div>
			</div>
		</div>

	</div>
</main>

<footer>
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>

<!-- JavaScript Logic -->
<script>
$(document).ready(function() {
	
	// --- 1. Sticky Sidebar Logic with Sentinel ---
	const sidebar = document.getElementById('stickySidebar');
	const sentinel = document.getElementById('sentinelNode');
	
	const observer = new IntersectionObserver((entries) => {
		entries.forEach(entry => {
			if (entry.isIntersecting) {
				console.log("Review section reached");
			}
		});
	});
	
	if(sentinel) observer.observe(sentinel);


	// --- 2. Size Selection Logic ---
	$('input[name="optionDetailNum"]').change(function() {
		// 모든 사이즈 버튼 초기화 (CSS로 처리되지만 JS로 값 갱신)
		let size = $(this).val();
		$('#selectedDetailNum').val(size); // 실제로는 DB PK값을 넣어야 함
		
		// 재고가 없는 경우
		if($(this).is(':disabled')) {
			alert("품절된 상품입니다.");
			return;
		}
		
		console.log("Selected Size: " + size);
	});


	// --- 3. Quantity Logic ---
	$('.plus').click(function() {
		let q = parseInt($('.qty-input').val());
		if(q < 10) {
            $('.qty-input').val(q + 1);
            $('#selectedQty').val(q + 1);
        }
	});
	
	$('.minus').click(function() {
		let q = parseInt($('.qty-input').val());
		if(q > 1) {
            $('.qty-input').val(q - 1);
            $('#selectedQty').val(q - 1);
        }
	});


	// --- 4. Buy & Cart Action ---
	window.addToCart = function() {
		if(!checkSelection()) return;
		
		// Ajax로 장바구니 담기 구현
		let data = $('form[name="buyForm"]').serialize();
		// $.post ...
		alert("장바구니에 담았습니다 (기능 미구현)");
	};

	window.buyNow = function() {
		if(!checkSelection()) return;
		
		// 구매 페이지 이동
		let f = document.buyForm;
		f.action = "${pageContext.request.contextPath}/order/payment"; // 예시 URL
		// f.submit();
		alert("구매 페이지로 이동합니다 (기능 미구현)");
	};

	function checkSelection() {
		let size = $('input[name="optionDetailNum"]:checked').val();
		if(!size) {
			alert("사이즈를 선택해주세요.");
			// 사이즈 영역으로 스크롤 이동 or 흔들기 효과
			return false;
		}
		return true;
	}
	
	// --- 5. Wishlist Toggle ---
	$('#wishBtn').click(function() {
		$(this).toggleClass('bi-heart bi-heart-fill text-danger');
		// Ajax 찜 등록/해제 로직
	});

});

// 스크롤 이동 함수
function scrollToReview() {
	document.getElementById('reviewSection').scrollIntoView({ behavior: 'smooth' });
}
function scrollToRecommend() {
	document.getElementById('recommendSection').scrollIntoView({ behavior: 'smooth' });
}
</script>

<!-- Restock Modal (Example) -->
<div class="modal fade" id="restockModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">입고 알림 신청</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <p>원하시는 사이즈가 품절인가요?<br>입고 시 알림톡을 보내드립니다.</p>
        <!-- 폼 구현 예정 -->
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-dark w-100">신청하기</button>
      </div>
    </div>
  </div>
</div>

</body>
</html>