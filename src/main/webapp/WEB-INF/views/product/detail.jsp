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
  
<!-- Bootstrap Icons -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main>
	<div class="container product-detail-container">
		
		<form name="buyForm" method="post">
			<input type="hidden" name="productNum" value="${dto.productNo}">
			<input type="hidden" name="detailNum" id="selectedDetailNum" value="">
			<input type="hidden" name="qty" id="selectedQty" value="1">
		</form>

		<div class="row">
			<!-- ================= LEFT COLUMN (상세 정보) ================= -->
			<div class="col-lg-8 detail-left-section">
				
				<!-- 좌-상: 제품 이미지 그리드 (2-2-1 배치) -->
				<div class="product-image-grid">
					<!-- 1행: 이미지 2개 -->
					<img src="https://via.placeholder.com/800x600?text=Product+Image+1" alt="Product Image 1">
					<img src="https://via.placeholder.com/800x600?text=Product+Image+2" alt="Product Image 2">
					
                    <!-- 2행: 이미지 2개 -->
					<img src="https://via.placeholder.com/800x600?text=Product+Image+3" alt="Product Image 3">
                    <img src="https://via.placeholder.com/800x600?text=Product+Image+4" alt="Product Detail Cut">
                    
                    <!-- 3행: 이미지 1개 (가운데 배치, 크기는 1개 컬럼만큼) -->
                    <img src="https://via.placeholder.com/800x600?text=Product+Image+5+(Center)" alt="Product Feature">
				</div>

				<!-- 좌-중1: 탭 -->
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

				<!-- 좌-중2: 제품 정보 -->
				<div class="tab-content" id="myTabContent">
					<div class="tab-pane fade show active" id="info-pane" role="tabpanel">
						<div class="product-info-scrollable">
							${dto.content}
							
							<c:if test="${empty dto.content}">
								<p>상세 정보가 없습니다.</p>
                                <br><br>
                                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
                                <p>Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
                                <img src="https://via.placeholder.com/700x500?text=Detail+Description+Image" class="img-fluid my-3">
                                <p>스크롤 테스트용 텍스트입니다. 높이 제한은 800px입니다.</p>
                                <br><br>
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
				<div id="stickySidebar" class="sticky-sidebar">
					
					<div class="product-name">${dto.productName}</div>
					<div class="product-price"><fmt:formatNumber value="${dto.price}" pattern="#,###"/> 원</div>

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

					<div class="color-options">
						<div class="color-label">컬러 : Black / Silver</div>
						<div class="color-thumbs">
							<div class="color-thumb active">
								<img src="https://via.placeholder.com/60/000000/FFFFFF?text=BK" alt="Black">
							</div>
							<div class="color-thumb" onclick="location.href='#'">
								<img src="https://via.placeholder.com/60/FFFFFF/000000?text=WH" alt="White">
							</div>
							<div class="color-thumb" onclick="location.href='#'">
								<img src="https://via.placeholder.com/60/FF0000/FFFFFF?text=RD" alt="Red">
							</div>
						</div>
					</div>

					<div class="size-options">
						<div class="d-flex justify-content-between mb-2">
							<span class="fw-bold">사이즈</span>
							<a href="#" class="text-decoration-underline text-muted" style="font-size:0.8rem;">사이즈 가이드</a>
						</div>
						
						<div class="size-grid">
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

					<div class="restock-alert d-flex justify-content-between align-items-center mb-4">
                        <span class="restock-text-left">원하시는 옵션이 없으신가요?</span>
						<button type="button" class="restock-btn" data-bs-toggle="modal" data-bs-target="#restockModal">
							<i class="bi bi-bell"></i> 입고알림신청하기
						</button>
					</div>

					<div class="purchase-area-custom">
						<div class="purchase-row-top">
                            <div class="qty-control-custom">
                                <button type="button" class="minus">-</button>
                                <input type="text" class="qty-input" id="displayQty" value="1" readonly>
                                <button type="button" class="plus">+</button>
                            </div>
							<button type="button" class="btn btn-cart-custom" onclick="addToCart()">장바구니</button>
						</div>
						
						<div class="purchase-row-bottom">
							<button type="button" class="btn btn-buy-custom" onclick="buyNow()">구매하기</button>
						</div>
					</div>

				</div> <!-- End Sticky Sidebar -->
			</div> <!-- End Right Column -->
		</div> <!-- End Row -->

		<div id="sentinelNode" class="sentinel-point"></div>

		<div id="reviewSection" class="review-section">
			<h3>Reviews <span class="text-muted">(120)</span></h3>
			<div class="alert alert-secondary text-center mt-4">
				리뷰 영역입니다. (추후 구현)
			</div>
		</div>

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
				</div>
			</div>
		</div>

	</div>
</main>

<footer>
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>

<script>
$(document).ready(function() {
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

	$('input[name="optionDetailNum"]').change(function() {
		let size = $(this).val();
		$('#selectedDetailNum').val(size); 
		
		if($(this).is(':disabled')) {
			alert("품절된 상품입니다.");
			return;
		}
	});

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

	window.addToCart = function() {
		if(!checkSelection()) return;
		let data = $('form[name="buyForm"]').serialize();
		alert("장바구니에 담았습니다 (기능 미구현)");
	};

	window.buyNow = function() {
		if(!checkSelection()) return;
		let f = document.buyForm;
		f.action = "${pageContext.request.contextPath}/order/payment"; 
		alert("구매 페이지로 이동합니다 (기능 미구현)");
	};

	function checkSelection() {
		let size = $('input[name="optionDetailNum"]:checked').val();
		if(!size) {
			alert("사이즈를 선택해주세요.");
			return false;
		}
		return true;
	}
	
	$('#wishBtn').click(function() {
		$(this).toggleClass('bi-heart bi-heart-fill text-danger');
	});
});

function scrollToReview() {
	document.getElementById('reviewSection').scrollIntoView({ behavior: 'smooth' });
}
function scrollToRecommend() {
	document.getElementById('recommendSection').scrollIntoView({ behavior: 'smooth' });
}
</script>

<div class="modal fade" id="restockModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">입고 알림 신청</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <p>원하시는 사이즈가 품절인가요?<br>입고 시 알림톡을 보내드립니다.</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-dark w-100">신청하기</button>
      </div>
    </div>
  </div>
</div>

</body>
</html>