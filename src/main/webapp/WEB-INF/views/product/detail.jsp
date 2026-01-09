<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- DTO의 productName 사용 -->
<title>${dto.productName} - Maknaez</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/product-detail.css" type="text/css">
</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main>
	<div class="container product-detail-container">
		
		<!-- 데이터 확인용 (개발 시에만 사용, 실제 배포 시 삭제) -->
		<c:if test="${empty dto}">
			<div class="alert alert-danger">
				데이터 로드 실패: Controller에서 dto가 넘어오지 않았습니다.
			</div>
		</c:if>

		<div class="row">
			<!-- 왼쪽: 상품 상세 컨텐츠 -->
			<div class="col-lg-8 detail-left-section">
				
				<!-- 메인 이미지 영역 -->
				<div class="main-image-area mb-4">
					<div class="main-image-placeholder">
						<c:choose>
							<c:when test="${not empty dto.imageFile}">
								<!-- 실제 이미지가 있다면 img 태그 사용 (경로는 환경에 맞게 조정 필요) -->
								<img src="${pageContext.request.contextPath}/uploads/product/${dto.imageFile}" alt="${dto.productName}" class="img-fluid">
							</c:when>
							<c:otherwise>
								<div class="no-image-box">
									<i class="bi bi-image" style="font-size: 3rem;"></i>
									<p class="mt-2">이미지 준비중</p>
								</div>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
				
				<!-- 서브 이미지 영역 (예시) -->
				<div class="row mb-5">
					<div class="col-6">
						<div class="sub-image-placeholder bg-light d-flex align-items-center justify-content-center" style="height:300px;">
							<span>상세 컷 1</span>
						</div>
					</div>
					<div class="col-6">
						<div class="sub-image-placeholder bg-light d-flex align-items-center justify-content-center" style="height:300px;">
							<span>상세 컷 2</span>
						</div>
					</div>
				</div>

				<!-- 상품 정보 영역 -->
				<div class="product-info-section mb-5">
					<h4 class="mb-3">상품 설명</h4>
					<div class="product-info-text">
						<!-- content (HTML 포함) 출력 -->
						<div class="content-body mb-4">
							${dto.content}
						</div>
						
						<div class="product-meta-info p-3 bg-light rounded">
							<p class="mb-1"><strong>카테고리:</strong> ${categoryName != null ? categoryName : '기타'}</p>
							<p class="mb-0"><strong>등록일:</strong> ${dto.regDate}</p>
						</div>
					</div>
				</div>

				<!-- 고시 정보 (아코디언) -->
				<div class="legal-info-section mb-5">
					<div class="accordion" id="accordionLegal">
						<div class="accordion-item">
							<h2 class="accordion-header" id="headingOne">
								<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne">
									상품 고시 정보 (자세히 보기)
								</button>
							</h2>
							<div id="collapseOne" class="accordion-collapse collapse" data-bs-parent="#accordionLegal">
								<div class="accordion-body">
									<table class="table table-sm table-bordered mb-0">
										<tr><th class="bg-light" width="30%">제품명</th><td>${dto.productName}</td></tr>
										<tr><th class="bg-light">제조국</th><td>Vietnam</td></tr>
										<tr><th class="bg-light">제조년월</th><td>2024.10</td></tr>
										<tr><th class="bg-light">소재</th><td>천연가죽(소), 합성가죽, 폴리에스터 100%</td></tr>
									</table>
								</div>
							</div>
						</div>
						<div class="accordion-item">
							<h2 class="accordion-header" id="headingTwo">
								<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo">
									배송 및 반품 안내
								</button>
							</h2>
							<div id="collapseTwo" class="accordion-collapse collapse" data-bs-parent="#accordionLegal">
								<div class="accordion-body">
									<ul class="ps-3 mb-0">
										<li>배송 기간은 주문일로부터 평균 2-3일 소요됩니다.</li>
										<li>제주 및 도서 산간 지역은 추가 배송비가 발생할 수 있습니다.</li>
										<li>단순 변심 반품은 상품 수령 후 7일 이내 가능합니다.</li>
									</ul>
								</div>
							</div>
						</div>
					</div>
				</div>

				<!-- 추천 상품 (캐러셀) -->
				<div class="recommend-section mt-5 border-top pt-5">
					<div class="recommend-header d-flex justify-content-between align-items-center mb-4">
						<h5>함께 보면 좋은 상품</h5>
						<div class="carousel-nav">
							<button class="btn btn-outline-secondary btn-sm prev-btn rounded-circle"><i class="bi bi-chevron-left"></i></button>
							<button class="btn btn-outline-secondary btn-sm next-btn rounded-circle"><i class="bi bi-chevron-right"></i></button>
						</div>
					</div>
					
					<div class="carousel-container overflow-hidden position-relative">
						<div class="carousel-track d-flex" style="gap: 20px; transition: transform 0.3s ease-in-out;">
							<c:choose>
								<c:when test="${not empty recommendList}">
									<c:forEach var="item" items="${recommendList}">
										<div class="recommend-card" style="min-width: 200px; width: 200px; cursor: pointer;" onclick="location.href='${pageContext.request.contextPath}/product/detail?productNo=${item.productNo}'">
											<div class="card-img-placeholder bg-light d-flex align-items-center justify-content-center mb-2" style="height: 200px; border-radius: 4px;">
												<span class="text-muted">Img</span>
											</div>
											<div class="p-1">
												<div class="text-truncate fw-bold mb-1">${item.productName}</div>
												<div class="text-muted small"><fmt:formatNumber value="${item.price}" pattern="#,###"/>원</div>
											</div>
										</div>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<!-- 추천 상품 데이터 없을 때 더미 -->
									<c:forEach var="i" begin="1" end="5">
										<div class="recommend-card" style="min-width: 200px; width: 200px;">
											<div class="card-img-placeholder bg-light d-flex align-items-center justify-content-center mb-2" style="height: 200px; border-radius: 4px;">
												<span class="text-muted">추천 ${i}</span>
											</div>
											<div class="p-1">
												<div class="text-truncate fw-bold mb-1">추천 상품 ${i}</div>
												<div class="text-muted small">129,000원</div>
											</div>
										</div>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</div>

			</div> <!-- End Left Col -->

			<!-- 오른쪽 사이드바 (Sticky) -->
			<div class="col-lg-4 sidebar-wrapper">
				<div class="sticky-sidebar p-4 border bg-white rounded shadow-sm" style="position:sticky; top: 120px; z-index: 10;">
					<div class="product-category text-muted small mb-2">${dto.categoryNo == 1 ? '남성 라이프스타일' : '신발'}</div>
					<h3 class="sidebar-title mb-3" style="font-weight: 700; word-break: keep-all;">${dto.productName}</h3>
					<div class="sidebar-price h5 mb-4">
						<fmt:formatNumber value="${dto.price}" pattern="#,###"/> 원
					</div>
					
					<hr class="my-4">
					
					<div class="option-group mb-4">
						<label class="option-label fw-bold mb-2 d-block">Color</label>
						<div class="d-flex gap-2">
							<span class="color-chip selected" data-color="Black" style="background-color: #000;" title="Black"></span>
							<span class="color-chip" data-color="White" style="background-color: #fff; border: 1px solid #ddd;" title="White"></span>
							<span class="color-chip" data-color="Red" style="background-color: #d32f2f;" title="Red"></span>
						</div>
						<div class="selected-color-text mt-2 small text-muted">선택된 색상: <span id="selectedColorName">Black</span></div>
					</div>
					
					<div class="option-group mb-4">
						<div class="d-flex justify-content-between align-items-center mb-2">
							<label class="option-label fw-bold">Size</label>
							<a href="#" class="text-decoration-underline small text-muted">사이즈 가이드</a>
						</div>
						<div class="d-flex flex-wrap gap-2">
							<c:forEach var="sz" begin="230" end="280" step="5">
								<button type="button" class="btn btn-outline-dark size-btn" onclick="selectSize(this)">${sz}</button>
							</c:forEach>
						</div>
					</div>
					
					<div class="action-buttons mt-5">
						<button type="button" class="btn btn-dark w-100 py-3 mb-2 rounded-0 fs-6 fw-bold">장바구니 담기</button>
						<button type="button" class="btn btn-outline-dark w-100 py-3 rounded-0 fs-6 fw-bold">바로 구매하기</button>
						<button type="button" class="btn btn-light w-100 mt-2 py-2 border rounded-0"><i class="bi bi-heart"></i> 위시리스트</button>
					</div>
					
					<div class="shipping-info mt-4 pt-3 border-top">
						<p class="mb-1 small"><i class="bi bi-truck me-2"></i>무료 배송</p>
						<p class="mb-0 small"><i class="bi bi-box-seam me-2"></i>오늘 주문 시 내일 도착 예정</p>
					</div>
				</div>
			</div> <!-- End Right Col -->
			
		</div>
	</div>
</main>

<footer>
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>

<script>
$(document).ready(function() {
	// 1. 캐러셀 로직
	const track = $('.carousel-track');
	const itemWidth = 220; // width 200 + gap 20
	let currentPosition = 0;
	
	// 추천 상품 개수 (JSTL 변수 없으면 0 처리)
	const listSize = ${recommendList != null ? recommendList.size() : 5}; 
	const containerWidth = $('.carousel-container').width();
	const maxScroll = (itemWidth * listSize) - containerWidth;

	$('.next-btn').click(function() {
		if(maxScroll <= 0) return; // 스크롤 할 필요 없으면 리턴
		
		currentPosition += itemWidth * 2;
		if(currentPosition > maxScroll) currentPosition = maxScroll;
		track.css('transform', 'translateX(-' + currentPosition + 'px)');
	});

	$('.prev-btn').click(function() {
		currentPosition -= itemWidth * 2;
		if(currentPosition < 0) currentPosition = 0;
		track.css('transform', 'translateX(-' + currentPosition + 'px)');
	});
	
	// 2. 색상 선택 로직
	$('.color-chip').click(function() {
		$('.color-chip').removeClass('selected');
		$(this).addClass('selected');
		$('#selectedColorName').text($(this).data('color'));
	});
});

// 3. 사이즈 선택 함수
function selectSize(btn) {
	$('.size-btn').removeClass('active btn-dark').addClass('btn-outline-dark');
	$(btn).removeClass('btn-outline-dark').addClass('active btn-dark');
}
</script>

</body>
</html>