<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!-- 이미지 경로 변수 설정 -->
<jsp:include page="/WEB-INF/views/common/image_config.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${dto.prodName} - Maknaez Style</title>

<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/product-detail.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/header.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/footer.css">
  
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>

<style>
    .share-container { position: relative; display: inline-block; width: 30px; height: 30px; vertical-align: middle; }
    .share-trigger { font-size: 1.2rem; color: #333; position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); transition: all 0.3s ease; cursor: pointer; z-index: 2; }
    .share-options { position: absolute; top: 50%; right: 3px; transform: translateY(-50%); background-color: #fff; border: 1px solid #ddd; border-radius: 25px; height: 44px; display: flex; align-items: center; justify-content: center; gap: 0; width: 0; padding: 0; opacity: 0; visibility: hidden; overflow: hidden; transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94); z-index: 10; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
    .share-container:hover .share-trigger { opacity: 0; transform: translate(-50%, -50%) scale(0.5); }
    .share-container:hover .share-options { width: 110px; padding: 0 8px; opacity: 1; visibility: visible; }
    .share-btn { background: none; border: none; padding: 0; margin: 0; font-size: 1.15rem; color: #555; cursor: pointer; display: flex; align-items: center; justify-content: center; width: 40px; height: 34px; border-radius: 5px; transition: all 0.2s ease; }
    .share-btn i { line-height: 1; display: block; margin-top: 1px; margin-right: 12px; }
    .share-btn:hover { background-color: #f5f5f5; color: #000; transform: scale(1.1); }
    .share-divider { width: 1px; height: 14px; background-color: #e0e0e0; margin: 0 2px; flex-shrink: 0; }
    .star-rating-custom { display: inline-flex; align-items: center; }
    .star-rating-custom i { font-size: 0.75rem; color: #ddd; margin-right: 1px; }
    .star-rating-custom i.filled { color: #333; }
    .star-text-custom { font-size: 0.75rem; color: #888; margin-left: 4px; font-weight: 400; vertical-align: middle; position: relative; top: 1px; }
    .review-meta-mid .star-rating-custom { margin-right: 8px; }
    .toast-message { position: fixed; bottom: 50px; left: 50%; transform: translateX(-50%) translateY(20px); background-color: rgba(34, 34, 34, 0.95); color: #fff; padding: 12px 30px; border-radius: 50px; font-size: 0.95rem; font-weight: 400; z-index: 9999; opacity: 0; visibility: hidden; transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94); box-shadow: 0 5px 15px rgba(0,0,0,0.15); pointer-events: none; white-space: nowrap; }
    .toast-message.show { opacity: 1; visibility: visible; transform: translateX(-50%) translateY(0); }
    #stickySidebar .restock-alert .btn { border-radius: 30px; border: 1px solid #e0e0e0; color: #555; padding: 5px 15px; background-color: transparent; transition: all 0.2s; }
    #stickySidebar .restock-alert .btn:hover { background-color: #fff; border-color: #000 !important; color: #000; }
    .btn-cart-custom { border-radius: 30px; border: 1px solid #ddd; background-color: #fff; color: #111; transition: all 0.2s; }
    .btn-cart-custom:hover { background-color: #fff; border-color: #000 !important; color: #000; }
    .btn-buy-custom { border-radius: 30px; border: 1px solid #111; background-color: #111; color: #fff; transition: all 0.2s; margin-top: 10px; width: 100%; }
    .btn-buy-custom:hover { background-color: #333; border-color: #111 !important; color: #fff; }
</style>

</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main>
	<div class="container product-detail-container">
		
		<form name="buyForm" method="post">
			<input type="hidden" name="productNum" value="${dto.prodId}">
			<input type="hidden" name="detailNum" id="selectedDetailNum" value="">
			<input type="hidden" name="qty" id="selectedQty" value="1">
		</form>

		<div class="row">
			<div class="col-lg-8 detail-left-section">
				<div class="product-image-grid">
					<img src="${uploadPath}/${dto.thumbnail}" alt="${dto.prodName}" onerror="this.src='https://placehold.co/800x600?text=No+Image'">
					<img src="${uploadPath}/${dto.thumbnail}" alt="Product Image 2" onerror="this.src='https://placehold.co/800x600?text=No+Image'">
					<img src="${uploadPath}/${dto.thumbnail}" alt="Product Image 3" onerror="this.src='https://placehold.co/800x600?text=No+Image'">
                    <img src="${uploadPath}/${dto.thumbnail}" alt="Product Detail Cut" onerror="this.src='https://placehold.co/800x600?text=No+Image'">
                    <img src="${uploadPath}/${dto.thumbnail}" alt="Product Feature" onerror="this.src='https://placehold.co/800x600?text=No+Image'">
				</div>

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

				<div class="tab-content" id="myTabContent">
					<div class="tab-pane fade show active" id="info-pane" role="tabpanel">
						<div class="product-info-content">
							<c:out value="${dto.description}" escapeXml="false" />
                            
							<c:if test="${empty dto.description}">
								<p>상세 정보가 없습니다.</p>
                                <br>
                                <p>최상의 퍼포먼스를 위한 러닝화. 가볍고 통기성이 뛰어난 메쉬 소재로 제작되어 쾌적한 착화감을 제공합니다.</p>
                                <img src="https://placehold.co/700x500?text=Detail+Description+Image" class="img-fluid my-3">
                                <p>충격 흡수가 뛰어난 미드솔과 접지력이 우수한 아웃솔이 적용되어 안정적인 러닝을 도와줍니다.</p>
							</c:if>
						</div>
					</div>
				</div>

				<!-- 좌-하1: 제품 특징 (테이블 스타일) -->
				<div class="product-features">
					<h4>제품 특징</h4>
					<table class="detail-table">
						<tr><th>쿠셔닝</th><td>맥시멀 - 부드럽고 풍부한 쿠셔닝</td></tr>
						<tr><th>신발 너비</th><td>기본 - 발을 편안하게 감싸는 핏</td></tr>
						<tr><th>지형</th><td>로드, 혼합 - 다양한 노면 환경 대응</td></tr>
					</table>
				</div>

				<!-- 좌-하2: 고시 정보 (테이블 스타일) -->
				<div class="product-notice">
					<h4>상품 고시 정보</h4>
					<table class="detail-table">
						<tr><th>소재</th><td>갑피: 폴리에스테르 100%, 밑창: 합성고무</td></tr>
						<tr><th>제조국</th><td>베트남</td></tr>
						<tr><th>제조년월</th><td>2024.01</td></tr>
						<tr><th>수입원</th><td>(주)세미프로젝트 코리아</td></tr>
						<tr><th>A/S 책임자</th><td>고객센터 1588-0000</td></tr>
						<tr><th>품질보증기준</th><td>관련 법 및 소비자 분쟁해결 규정에 따름</td></tr>
					</table>
				</div>

			</div> <!-- End Left Column -->

			<!-- ================= RIGHT COLUMN (옵션 & 결제) ================= -->
			<div class="col-lg-4 detail-right-section">
				<div id="stickySidebar" class="sticky-sidebar">
					
                    <!-- [DB 데이터] 상품명 -->
					<div class="product-name">${dto.prodName}</div>
                    
                    <!-- [DB 데이터] 가격 표시 로직 (할인 적용) -->
					<div class="product-price">
                        <c:choose>
                            <c:when test="${dto.discountRate > 0}">
                                <span style="text-decoration: line-through; font-size: 0.9em; color: #999; margin-right: 8px;">
                                    <fmt:formatNumber value="${dto.originalPrice}" pattern="#,###"/> 원
                                </span>
                                <span style="color: #dc3545; font-weight: bold;">
                                    <fmt:formatNumber value="${dto.salePrice}" pattern="#,###"/> 원
                                </span>
                                <span class="badge bg-danger rounded-pill" style="font-size: 0.8rem; vertical-align: middle; margin-left: 5px;">
                                    ${dto.discountRate}% OFF
                                </span>
                            </c:when>
                            <c:otherwise>
                                <fmt:formatNumber value="${dto.price}" pattern="#,###"/> 원
                            </c:otherwise>
                        </c:choose>
                    </div>

					<div class="product-actions-top">
						<!-- [유지] 별점 흑백 테마 & 사이즈 축소 -->
						<div class="star-rating-custom">
							<i class="bi bi-star-fill filled"></i>
							<i class="bi bi-star-fill filled"></i>
							<i class="bi bi-star-fill filled"></i>
							<i class="bi bi-star-fill filled"></i>
							<i class="bi bi-star-half filled"></i>
							<span class="star-text-custom">(4.8)</span>
						</div>
						
						<div class="action-icons" style="display: flex; gap: 15px; align-items: center;">
                            
                            <div class="share-container">
                                <i class="bi bi-share share-trigger" title="공유하기"></i>
                                
                                <div class="share-options">
                                    <button type="button" class="share-btn" onclick="shareKakao()" title="카카오톡 공유">
                                        <i class="bi bi-chat-fill"></i>
                                    </button>
                                    
                                    <div class="share-divider"></div>
                                    
                                    <button type="button" class="share-btn" onclick="copyLink()" title="링크 복사">
                                        <i class="bi bi-link-45deg" style="font-size: 1.3rem;"></i>
                                    </button>
                                </div>
                            </div>

							<i class="bi bi-heart" id="wishBtn" title="찜하기" style="cursor: pointer;"></i>
						</div>
					</div>

					<div class="color-options">
						<div class="color-label">컬러 : ${dto.cateCode} (임시 표시)</div>
						<div class="color-thumbs">
							<div class="color-thumb active"><img src="https://placehold.co/60/000000/FFFFFF?text=BK" alt="Black"></div>
							<div class="color-thumb"><img src="https://placehold.co/60/FFFFFF/000000?text=WH" alt="White"></div>
							<div class="color-thumb"><img src="https://placehold.co/60/FF0000/FFFFFF?text=RD" alt="Red"></div>
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
                        <span class="restock-text-left" style="font-size:0.85rem; color:#666;">원하시는 옵션이 없으신가요?</span>
						<button type="button" class="btn btn-sm btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#restockModal">
							<i class="bi bi-bell"></i> 입고알림신청
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
						<button type="button" class="btn btn-buy-custom" onclick="buyNow()">구매하기</button>
					</div>

				</div>
			</div>
		</div>

		<div id="sentinelNode" class="sentinel-point"></div>

		<!--  REVIEW SECTION (기존 유지) -->
		<div id="reviewSection" class="review-wrapper">
            <!-- (리뷰 헤더 생략 - 원본 그대로) -->
             <div class="review-header-container">
                <h3 class="review-header-title">Reviews <span id="reviewTotalCount" style="font-weight:400; font-size:0.9em; color:#888;">(128)</span></h3>
                
                <div class="review-search-box">
                    <input type="text" id="reviewKeyword" placeholder="리뷰 키워드 검색" onkeyup="if(window.event.keyCode==13){searchReview()}">
                    <i class="bi bi-search" onclick="searchReview()"></i>
                </div>
            </div>
            
            <div id="reviewContentArea">
                 <!-- 리뷰 내용은 스크립트로 로드됨 -->
            </div>
            
            <div id="reviewPagination" class="mt-4 d-flex justify-content-center">
                <!-- Static Pagination -->
                <nav aria-label="Page navigation">
                  <ul class="pagination">
                    <li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>
                    <li class="page-item active"><a class="page-link" href="#" style="background-color:#333; border-color:#333;">1</a></li>
                    <li class="page-item"><a class="page-link" href="#" style="color:#333;">2</a></li>
                    <li class="page-item"><a class="page-link" href="#" style="color:#333;">3</a></li>
                    <li class="page-item"><a class="page-link" href="#" style="color:#333;">Next</a></li>
                  </ul>
                </nav>
            </div>
		</div>

		<div id="recommendSection" class="recommend-section mt-5 pt-5 border-top">
			<h3>추천 상품</h3>
			<div class="recommend-carousel mt-4">
				<div class="row">
					<div class="col-3">
						<div class="card border-0">
							<img src="https://placehold.co/300x300" class="card-img-top" alt="Rec 1">
							<div class="card-body px-0">
								<h6 class="card-title">SPEEDCROSS 6</h6>
								<p class="card-text text-muted">198,000 원</p>
							</div>
						</div>
					</div>
                    <!-- (나머지 추천상품) -->
                    <div class="col-3">
						<div class="card border-0">
							<img src="https://placehold.co/300x300" class="card-img-top" alt="Rec 2">
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
const contextPath = "${pageContext.request.contextPath}";
const productNum = "${dto.prodId}"; // [수정] DB ID 사용

// ... (공유하기 등 기존 스크립트 그대로) ...

function copyLink() {
    let url = window.location.href;
    const msg = "링크가 클립보드에 복사되었습니다";
    
    const t = document.createElement("textarea");
    document.body.appendChild(t);
    t.value = url;
    t.select();
    
    try {
        const successful = document.execCommand('copy');
        if (successful) showToast(msg);
        else alert("링크 복사에 실패했습니다.");
    } catch (err) {
        alert("링크 복사에 실패했습니다.");
    }
    document.body.removeChild(t);
}

// ...

$(document).ready(function() {
	// ... (기존 이벤트 핸들러 유지) ...
    
	$('.plus').click(function() {
		let q = parseInt($('.qty-input').val());
		if(q < 10) { $('.qty-input').val(q + 1); $('#selectedQty').val(q + 1); }
	});
	
	$('.minus').click(function() {
		let q = parseInt($('.qty-input').val());
		if(q > 1) { $('.qty-input').val(q - 1); $('#selectedQty').val(q - 1); }
	});

    // 구매하기 버튼
	window.buyNow = function() {
		if(!checkSelection()) return;
        
        // 결제 페이지 이동 (prod_id + quantity + size)
        const qty = $('#selectedQty').val();
        const size = $('input[name="optionDetailNum"]:checked').val();
        
        location.href = "${pageContext.request.contextPath}/order/payment?prod_id=${dto.prodId}&quantity=" + qty + "&size=" + size;
	};

    // 장바구니 버튼
	window.addToCart = function() {
		if(!checkSelection()) return;
        // 추후 장바구니 로직 연결
		alert("장바구니에 담았습니다 (기능 미구현)");
	};

	function checkSelection() {
		if(!$('input[name="optionDetailNum"]:checked').val()) {
			alert("사이즈를 선택해주세요.");
			return false;
		}
		return true;
	}
	
    // 리뷰 로드 (일단 더미)
    setTimeout(function() {
        let mockData = generateMockReviews("");
        renderReviews(mockData);
    }, 100);
});

// ... (나머지 리뷰 렌더링 함수들 - 그대로 복사) ...
function showToast(message) {
    const existingToast = document.querySelector('.toast-message');
    if (existingToast) existingToast.remove();
    
    const toast = document.createElement('div');
    toast.className = 'toast-message';
    toast.innerText = message;
    document.body.appendChild(toast);

    setTimeout(() => { toast.classList.add('show'); }, 10);
    setTimeout(() => {
        toast.classList.remove('show');
        setTimeout(() => { toast.remove(); }, 400); 
    }, 2500);
}

function generateMockReviews(keyword) {
    if(keyword && keyword === "없음") return { count: 0, list: [], photoList: [] };

    const contents = [
        "배송도 빠르고 포장도 꼼꼼합니다. 실물이 훨씬 예쁘네요! 정사이즈 추천합니다.",
        "발볼이 넓은 편인데 반업하니까 딱 좋습니다. 쿠션감이 예술이네요."
    ];
    let list = [];
    for(let i=0; i<2; i++) {
        list.push({
            reviewNo: i,
            memberId: "user" + i,
            optionValue: "260mm",
            starRating: 5,
            footSize: "정사이즈",
            content: contents[i],
            regDate: "2023-10-15",
            isNew: true,
            images: [] 
        });
    }
    return { count: 128, list: list, photoList: [] };
}

function renderReviews(data) {
    let container = $('#reviewContentArea');
    let html = "";
    $('#reviewTotalCount').text("("+data.count+")");
    
    // 필터바 생략 (위 원본 코드 참고)
    html += '<div class="review-filter-row">...</div>';

    html += '<div id="reviewListContainer">';
    data.list.forEach(item => {
        html += `
        <div class="review-item">
            <div class="review-meta-top">
                <div class="d-flex align-items-center"><span class="review-badge-new">NEW</span><span>옵션 : ${item.optionValue}</span></div>
                <div class="review-writer-id">${item.memberId}***</div>
            </div>
            <div class="review-meta-mid">
                <div class="star-rating-custom"><i class="bi bi-star-fill filled"></i><i class="bi bi-star-fill filled"></i><i class="bi bi-star-fill filled"></i><i class="bi bi-star-fill filled"></i><i class="bi bi-star-fill filled"></i></div>
                <span class="foot-size-tag bg-light px-2 py-1 rounded text-secondary small ms-2">발 사이즈 : ${item.footSize}</span>
            </div>
            <div class="review-content">${item.content}<div class="review-date">${item.regDate}</div></div>
        </div>`;
    });
    html += '</div>';
    container.html(html);
}
</script>

<!-- Restock Modal -->
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