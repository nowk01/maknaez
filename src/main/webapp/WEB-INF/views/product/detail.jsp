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
				<div class="main-image-area">
					<div class="main-image-placeholder">
						<i class="bi bi-image"></i>
						<!-- 실제 이미지가 있다면 <img src="..."> 사용 -->
						<br>파일명: ${dto.imageFile}
					</div>
				</div>
				<div class="row mb-5">
					<div class="col-6"><div class="bg-light" style="height:300px; display:flex; align-items:center; justify-content:center;">서브 1</div></div>
					<div class="col-6"><div class="bg-light" style="height:300px; display:flex; align-items:center; justify-content:center;">서브 2</div></div>
				</div>

				<!-- 상품 정보 영역 -->
				<div class="product-info-section">
					<h4>상품 설명</h4>
					<div class="product-info-text">
						<!-- content (HTML 포함) 출력 -->
						${dto.content}
						<br><br>
						<p class="text-muted">
							<!-- categoryName은 별도 변수로 받음 -->
							카테고리: ${categoryName} <br>
							등록일: ${dto.regDate}
						</p>
					</div>
				</div>

				<!-- 고시 정보 (아코디언) -->
				<div class="legal-info-section">
					<div class="accordion" id="accordionLegal">
						<div class="accordion-item">
							<h2 class="accordion-header" id="headingOne">
								<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne">
									상품 고시 정보 (자세히 보기)
								</button>
							</h2>
							<div id="collapseOne" class="accordion-collapse collapse" data-bs-parent="#accordionLegal">
								<div class="accordion-body">
									<table class="table table-sm">
										<tr><th width="30%">제품명</th><td>${dto.productName}</td></tr>
										<tr><th>제조국</th><td>Vietnam</td></tr>
										<tr><th>제조년월</th><td>2024.10</td></tr>
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
									배송 기간은 주문일로부터 2-3일 소요됩니다.
								</div>
							</div>
						</div>
					</div>
				</div>

				<!-- 추천 상품 (캐러셀) -->
				<div class="recommend-section mt-5">
					<div class="recommend-header d-flex justify-content-between align-items-center mb-3">
						<h5>함께 보면 좋은 상품</h5>
						<div class="d-flex gap-2">
							<button class="btn btn-outline-secondary btn-sm prev-btn"><i class="bi bi-chevron-left"></i></button>
							<button class="btn btn-outline-secondary btn-sm next-btn"><i class="bi bi-chevron-right"></i></button>
						</div>
					</div>
					
					<div class="carousel-container overflow-hidden">
						<div class="carousel-track d-flex" style="gap: 20px; transition: transform 0.3s ease-in-out;">
							<c:forEach var="item" items="${recommendList}">
								<div class="product-card" style="min-width: 200px; cursor: pointer;" onclick="location.href='${pageContext.request.contextPath}/product/detail?productNo=${item.productNo}'">
									<div class="card-img-placeholder bg-light d-flex align-items-center justify-content-center" style="height: 200px;">
										Img
									</div>
									<div class="p-2">
										<div class="text-truncate fw-bold">${item.productName}</div>
										<div class="text-muted small"><fmt:formatNumber value="${item.price}" pattern="#,###"/>원</div>
									</div>
								</div>
							</c:forEach>
						</div>
					</div>
				</div>

			</div> <!-- End Left Col -->

			<!-- 오른쪽 사이드바 (Sticky) -->
			<div class="col-lg-4 sidebar-wrapper">
				<div class="sticky-sidebar p-4 border bg-white" style="position:sticky; top: 100px;">
					<div class="sidebar-title h4">${dto.productName}</div>
					<div class="sidebar-price h5 mb-3">
						<fmt:formatNumber value="${dto.price}" pattern="#,###"/> KRW
					</div>
					
					<hr>
					
					<div class="option-group mb-3">
						<label class="option-label fw-bold mb-2">Color</label>
						<div class="d-flex gap-2">
							<span class="color-chip selected" style="width:30px; height:30px; background-color: black; border-radius:50%; cursor:pointer; border:2px solid #000;" title="Black"></span>
							<span class="color-chip" style="width:30px; height:30px; background-color: #eee; border-radius:50%; cursor:pointer;" title="White"></span>
						</div>
					</div>
					
					<div class="option-group mb-4">
						<label class="option-label fw-bold mb-2">Size</label>
						<div class="d-flex flex-wrap gap-2">
							<c:forEach var="sz" begin="230" end="280" step="10">
								<button type="button" class="btn btn-outline-dark size-btn" style="width:60px;">${sz}</button>
							</c:forEach>
						</div>
					</div>
					
					<div>
						<button type="button" class="btn btn-dark w-100 py-3 mb-2">장바구니 담기</button>
						<button type="button" class="btn btn-outline-dark w-100 py-3 fw-bold">바로 구매하기</button>
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
	// 캐러셀 로직
	const track = $('.carousel-track');
	const itemWidth = 220; 
	let currentPosition = 0;
	// 추천 상품 개수 예외처리 (null safe)
	const listSize = ${recommendList != null ? recommendList.size() : 0};
	const maxScroll = (itemWidth * listSize) - $('.carousel-container').width();

	$('.next-btn').click(function() {
		currentPosition += itemWidth * 2;
		if(maxScroll > 0 && currentPosition > maxScroll) currentPosition = maxScroll;
		track.css('transform', 'translateX(-' + currentPosition + 'px)');
	});

	$('.prev-btn').click(function() {
		currentPosition -= itemWidth * 2;
		if(currentPosition < 0) currentPosition = 0;
		track.css('transform', 'translateX(-' + currentPosition + 'px)');
	});
	
	$('.size-btn').click(function() {
		$('.size-btn').removeClass('active btn-dark').addClass('btn-outline-dark');
		$(this).removeClass('btn-outline-dark').addClass('active btn-dark');
	});
});
</script>

</body>
</html>