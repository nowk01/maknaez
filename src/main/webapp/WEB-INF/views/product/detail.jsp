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

<!-- 카카오톡 SDK 추가 -->
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>

<style>
    /* [수정] 공유하기 버튼 - 너비 확장 및 아이콘 정렬 개선 */
    .share-container {
        position: relative;
        display: inline-block;
        width: 30px; 
        height: 30px;
        vertical-align: middle;
    }

    /* 기본 공유 아이콘 */
    .share-trigger {
        font-size: 1.2rem;
        color: #333;
        position: absolute;
        top: 50%; 
        left: 50%;
        transform: translate(-50%, -50%);
        transition: all 0.3s ease;
        cursor: pointer;
        z-index: 2;
    }

    /* Hover 시 나타나는 메뉴 (알약 모양) */
    .share-options {
        position: absolute;
        top: 50%;
        right: 3px; 
        transform: translateY(-50%);
        
        background-color: #fff;
        border: 1px solid #ddd;
        border-radius: 25px; 
        height: 44px; 
        
        display: flex;
        align-items: center;
        justify-content: center; 
        gap: 0; 
        
        /* 초기 상태: 숨김 */
        width: 0;
        padding: 0;
        opacity: 0;
        visibility: hidden;
        overflow: hidden;
        
        transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        z-index: 10;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }

    /* 호버 인터랙션 */
    .share-container:hover .share-trigger {
        opacity: 0;
        transform: translate(-50%, -50%) scale(0.5); 
    }

    .share-container:hover .share-options {
        width: 110px; 
        padding: 0 8px;
        opacity: 1;
        visibility: visible;
    }

    /* 내부 버튼 스타일 */
    .share-btn {
        background: none;
        border: none;
        padding: 0;
        margin: 0;
        
        font-size: 1.15rem; 
        color: #555;
        cursor: pointer;
        
        display: flex;
        align-items: center;
        justify-content: center;
        
        width: 40px; 
        height: 34px;
        border-radius: 5px; 
        transition: all 0.2s ease;
    }
    
    /* [수정] 아이콘 우측 여백 추가 */
    .share-btn i {
        line-height: 1;
        display: block;
        margin-top: 1px;
        margin-right: 12px; /* 요청하신 간격 적용 */
    }
    
    .share-btn:hover {
        background-color: #f5f5f5; 
        color: #000;
        transform: scale(1.1);
    }
    
    /* 구분선 */
    .share-divider {
        width: 1px;
        height: 14px;
        background-color: #e0e0e0;
        margin: 0 2px;
        flex-shrink: 0;
    }

    /* [유지] 별점 스타일 */
    .star-rating-custom {
        display: inline-flex;
        align-items: center;
    }
    .star-rating-custom i {
        font-size: 0.75rem; 
        color: #ddd; 
        margin-right: 1px;
    }
    .star-rating-custom i.filled {
        color: #333; 
    }
    .star-text-custom {
        font-size: 0.75rem;
        color: #888;
        margin-left: 4px;
        font-weight: 400;
        vertical-align: middle;
        position: relative;
        top: 1px;
    }
    
    .review-meta-mid .star-rating-custom {
        margin-right: 8px;
    }

    /* [추가] 토스트 알림 메시지 스타일 */
    .toast-message {
        position: fixed;
        bottom: 50px;
        left: 50%;
        transform: translateX(-50%) translateY(20px); 
        background-color: rgba(34, 34, 34, 0.95); 
        color: #fff;
        padding: 12px 30px;
        border-radius: 50px; 
        font-size: 0.95rem;
        font-weight: 400;
        z-index: 9999;
        opacity: 0;
        visibility: hidden;
        transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        box-shadow: 0 5px 15px rgba(0,0,0,0.15);
        pointer-events: none; 
        white-space: nowrap;
    }

    .toast-message.show {
        opacity: 1;
        visibility: visible;
        transform: translateX(-50%) translateY(0); 
    }

    /* =================================================================
       [신규 추가] 버튼 스타일 커스터마이징 (둥근 모서리 & 테두리 유지)
       ================================================================= */
    
    #stickySidebar .restock-alert .btn {
        border-radius: 30px; 
        border: 1px solid #e0e0e0;
        color: #555;
        padding: 5px 15px;
        background-color: transparent;
        transition: all 0.2s;
    }
    #stickySidebar .restock-alert .btn:hover {
        background-color: #fff;
        border-color: #000 !important; 
        color: #000;
    }

    .btn-cart-custom {
        border-radius: 30px; 
        border: 1px solid #ddd;
        background-color: #fff;
        color: #111;
        transition: all 0.2s;
    }
    .btn-cart-custom:hover {
        background-color: #fff;
        border-color: #000 !important; 
        color: #000;
    }

    .btn-buy-custom {
        border-radius: 30px; 
        border: 1px solid #111;
        background-color: #111;
        color: #fff;
        transition: all 0.2s;
        margin-top: 10px; 
        width: 100%;
    }
    .btn-buy-custom:hover {
        background-color: #333; 
        border-color: #111 !important; 
        color: #fff;
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
			<input type="hidden" name="productNum" value="${dto.productNo}">
			<input type="hidden" name="detailNum" id="selectedDetailNum" value="">
			<input type="hidden" name="qty" id="selectedQty" value="1">
		</form>

		<div class="row">
			<!-- ================= LEFT COLUMN (상세 정보) ================= -->
			<div class="col-lg-8 detail-left-section">
				
				<!-- 좌-상: 제품 이미지 그리드 -->
				<div class="product-image-grid">
					<img src="https://placehold.co/800x600?text=Product+Image+1" alt="Product Image 1">
					<img src="https://placehold.co/800x600?text=Product+Image+2" alt="Product Image 2">
					<img src="https://placehold.co/800x600?text=Product+Image+3" alt="Product Image 3">
                    <img src="https://placehold.co/800x600?text=Product+Image+4" alt="Product Detail Cut">
                    <img src="https://placehold.co/800x600?text=Product+Image+5+(Center)" alt="Product Feature">
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
						<div class="product-info-content">
							${dto.content}
							<c:if test="${empty dto.content}">
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
					
					<div class="product-name">${dto.productName}</div>
					<div class="product-price"><fmt:formatNumber value="${dto.price}" pattern="#,###"/> 원</div>

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
                            
                            <!-- [수정] 공유하기 버튼 (더 넓게, 중앙 정렬) -->
                            <div class="share-container">
                                <!-- 기본 아이콘 -->
                                <i class="bi bi-share share-trigger" title="공유하기"></i>
                                
                                <!-- 호버 시 나타나는 메뉴 -->
                                <div class="share-options">
                                    <!-- [수정] onclick 제거하고 data-kakao-share 속성 추가 -->
                                    <button type="button" class="share-btn" data-kakao-share title="카카오톡 공유">
                                        <i class="bi bi-chat-fill"></i>
                                    </button>
                                    
                                    <!-- [수정] 구분선 복구 -->
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
						<div class="color-label">컬러 : Black / Silver</div>
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

		<!-- 
             ===========================================================
             [REVIEW SECTION] 
             ===========================================================
        -->
		<div id="reviewSection" class="review-wrapper">
            
            <!-- [Header] -->
            <div class="review-header-container">
                <h3 class="review-header-title">Reviews <span id="reviewTotalCount" style="font-weight:400; font-size:0.9em; color:#888;">(128)</span></h3>
                
                <div class="review-search-box">
                    <input type="text" id="reviewKeyword" placeholder="리뷰 키워드 검색" onkeyup="if(window.event.keyCode==13){searchReview()}">
                    <i class="bi bi-search" onclick="searchReview()"></i>
                </div>
            </div>

            <!-- [Content Area] : 하드코딩된 레이아웃 복구 -->
            <div id="reviewContentArea">
                
                <!-- Filter Bar (Static) -->
                <div class="review-filter-row">
                    <div class="filter-left">
                        <label class="round-checkbox-wrapper">
                            <input type="checkbox" id="chkPhotoFirst">
                            <span class="round-checkbox-visual"></span>
                            포토/동영상 먼저보기
                        </label>
                    </div>
                    <div class="filter-right">
                        <select id="selFootSize" class="filter-select">
                            <option value="">발 사이즈 선택</option>
                            <option value="small">작음</option>
                            <option value="fit">정사이즈</option>
                            <option value="big">큼</option>
                        </select>
                    </div>
                </div>

                <!-- Hardcoded Review Item 1 -->
                <div class="review-item">
                    <div class="review-meta-top">
                        <div class="d-flex align-items-center">
                            <span class="review-badge-new">NEW</span>
                            <span>옵션 : 240mm</span>
                        </div>
                        <div class="review-writer-id">run_lov****</div>
                    </div>
                    
                    <div class="review-meta-mid">
                        <!-- 흑백 별점 (작은 사이즈) -->
                        <div class="star-rating-custom">
                            <i class="bi bi-star-fill filled"></i>
                            <i class="bi bi-star-fill filled"></i>
                            <i class="bi bi-star-fill filled"></i>
                            <i class="bi bi-star-fill filled"></i>
                            <i class="bi bi-star-fill filled"></i>
                        </div>
                        <span class="foot-size-tag bg-light px-2 py-1 rounded text-secondary small ms-2">
                            발 사이즈 : 정사이즈
                        </span>
                    </div>
                    
                    <div class="review-content">
                        배송도 빠르고 포장도 꼼꼼합니다. 실물이 훨씬 예쁘네요! 정사이즈 추천합니다.
                        <div class="review-date">2023-10-15</div>
                    </div>
                    
                    <div class="review-images-container">
                        <div class="review-thumb" style="background:#f8f9fa; display:flex; align-items:center; justify-content:center;">
                            <i class="bi bi-camera-fill text-muted"></i>
                        </div>
                    </div>
                </div>

                <!-- Hardcoded Review Item 2 -->
                <div class="review-item">
                    <div class="review-meta-top">
                        <div class="d-flex align-items-center">
                            <span>옵션 : 265mm</span>
                        </div>
                        <div class="review-writer-id">daily_****</div>
                    </div>
                    
                    <div class="review-meta-mid">
                        <div class="star-rating-custom">
                            <i class="bi bi-star-fill filled"></i>
                            <i class="bi bi-star-fill filled"></i>
                            <i class="bi bi-star-fill filled"></i>
                            <i class="bi bi-star-fill filled"></i>
                            <i class="bi bi-star-half filled"></i>
                        </div>
                        <span class="foot-size-tag bg-light px-2 py-1 rounded text-secondary small ms-2">
                            발 사이즈 : 발볼 넓음
                        </span>
                    </div>
                    
                    <div class="review-content">
                        발볼이 넓은 편인데 반업하니까 딱 좋습니다. 쿠션감이 예술이네요.
                        <div class="review-date">2023-10-14</div>
                    </div>
                </div>

            </div>
            
            <!-- [Pagination] -->
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
// 전역 변수 선언
const contextPath = "${pageContext.request.contextPath}";
const productNum = "${dto.productNo}"; 
let currentReviewPage = 1;

// [공유하기 기능 스크립트]
// ===================================================================

// [추가] 토스트 알림 메시지 함수
function showToast(message) {
    // 이미 존재하는 토스트 제거 (중복 방지)
    const existingToast = document.querySelector('.toast-message');
    if (existingToast) existingToast.remove();

    // 새 토스트 생성
    const toast = document.createElement('div');
    toast.className = 'toast-message';
    toast.innerText = message;
    document.body.appendChild(toast);

    // setTimeout으로 변경하여 DOM 추가 후 확실하게 스타일 적용 시점 분리
    setTimeout(() => {
        toast.classList.add('show');
    }, 10);

    // 2.5초 후 제거 시작
    setTimeout(() => {
        toast.classList.remove('show');
        // 애니메이션(0.4s) 종료 후 DOM에서 제거
        setTimeout(() => {
            toast.remove();
        }, 400); 
    }, 2500);
}

// [수정] 링크 복사 기능 (호환성 개선)
function copyLink() {
    // 1. 현재 주소를 가져오되, localhost인 경우 실제 IP로 변환 (개발 편의성)
    let url = window.location.href;
    const myPublicIP = "61.73.115.26:9090"; // ★ 실제 접속 가능한 IP로 변경하세요
    if (url.includes("localhost")) {
        url = url.replace("localhost:9090", myPublicIP);
    }

    const msg = "링크가 클립보드에 복사되었습니다";
    
    // 2. 임시 textarea 생성 (가장 호환성 높음)
    const t = document.createElement("textarea");
    document.body.appendChild(t);
    t.value = url;
    t.select();
    
    try {
        // execCommand 사용
        const successful = document.execCommand('copy');
        if (successful) {
            showToast(msg);
        } else {
            // 실패 시 navigator.clipboard 시도
            if (navigator.clipboard) {
                navigator.clipboard.writeText(url).then(() => {
                    showToast(msg);
                }).catch(() => {
                    alert("링크 복사에 실패했습니다.");
                });
            } else {
                alert("링크 복사에 실패했습니다.");
            }
        }
    } catch (err) {
        alert("링크 복사에 실패했습니다.");
    }
    
    document.body.removeChild(t);
}

// [수정] 카카오 초기화 및 공유 기능
try {
    Kakao.init('a53a314410a0900a26a5586abe6f8847'); // 발급받은 키 유지
} catch(e) {
    console.log("카카오 SDK 초기화 실패 (키 미입력)");
}

        // [중요] 현재 페이지 주소를 그대로 사용
        // 단, 카카오 개발자 센터의 '사이트 도메인'에 등록된 주소여야만 버튼 링크가 동작합니다.
        let pageUrl = window.location.href;
        
        // 상품명 안전 처리 (따옴표 등으로 인한 스크립트 오류 방지)
        var safeProductName = "<c:out value='${dto.productName}' escapeXml='true'/>";
        
        // 가격 처리 (소수점 제거 및 정수화)
        var safePrice = ${not empty dto.price ? dto.price : 0};
        safePrice = Math.floor(safePrice);

        // 디버깅: 공유 URL 확인 (콘솔창 F12)
        console.log("Kakao Share URL:", pageUrl);

        Kakao.Share.sendDefault({
            objectType: 'commerce',
            content: {
                title: safeProductName, 
                imageUrl: 'https://placehold.co/800x600?text=Maknaez+Product', 
                link: {
                    mobileWebUrl: pageUrl,
                    webUrl: pageUrl,
                },
            },
            commerce: {
                productName: safeProductName, 
                regularPrice: safePrice, 
                currencyUnit: '₩',
                currencyUnitPosition: 1,
            },
            buttons: [
                {
                    title: '구매하기',
                    link: {
                        mobileWebUrl: pageUrl,
                        webUrl: pageUrl,
                    },
                },
            ],
            // [추가] 전송 성공/실패 핸들링
            fail: function(err) {
                alert('카카오톡 공유 실패: ' + JSON.stringify(err));
            },
        });
    }
});

// ===================================================================

// 문서 로드 시 실행 (jQuery Legacy Support)
$(document).ready(function() {
    // 1. 기존 UI 이벤트 (스티키바, 수량조절, 장바구니 등)
	const sidebar = document.getElementById('stickySidebar');
	const sentinel = document.getElementById('sentinelNode');
	
    if(sentinel) {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) console.log("Review section reached");
            });
        });
        observer.observe(sentinel);
    }

	$('input[name="optionDetailNum"]').change(function() {
		$('#selectedDetailNum').val($(this).val());
	});

	$('.plus').click(function() {
		let q = parseInt($('.qty-input').val());
		if(q < 10) { $('.qty-input').val(q + 1); $('#selectedQty').val(q + 1); }
	});
	
	$('.minus').click(function() {
		let q = parseInt($('.qty-input').val());
		if(q > 1) { $('.qty-input').val(q - 1); $('#selectedQty').val(q - 1); }
	});

	window.addToCart = function() {
		if(!checkSelection()) return;
		alert("장바구니에 담았습니다 (기능 미구현)");
	};

	window.buyNow = function() {
		if(!checkSelection()) return;
		alert("구매 페이지로 이동합니다 (기능 미구현)");
	};

	function checkSelection() {
		if(!$('input[name="optionDetailNum"]:checked').val()) {
			alert("사이즈를 선택해주세요.");
			return false;
		}
		return true;
	}
	
	$('#wishBtn').click(function() {
		$(this).toggleClass('bi-heart bi-heart-fill text-danger');
	});

    // 2. 리뷰 데이터 강제 로드 호출 (레이아웃 확인을 위해 잠시 주석 처리)
    // loadReviews(1);
});

function scrollToReview() { document.getElementById('reviewSection').scrollIntoView({ behavior: 'smooth' }); }
function scrollToRecommend() { document.getElementById('recommendSection').scrollIntoView({ behavior: 'smooth' }); }

/* =========================================================
   [REVIEW LOGIC] - 데이터 강제 주입 로직
   ========================================================= */
function searchReview() {
    currentReviewPage = 1;
    loadReviews(1);
}

function loadReviews(page) {
    currentReviewPage = page;
    let keyword = $('#reviewKeyword').val() || ""; // null 방지
    
    // AJAX 호출 부분 (백엔드 연동 시 주석 해제)
    /*
    $.ajax({
        url: contextPath + "/review/list",
        data: { productNum: productNum, page: page, keyword: keyword },
        dataType: "json",
        success: function(data) { renderReviews(data); },
        error: function(e) { console.log(e.responseText); }
    });
    */
    
    // [강제 실행] 가짜 데이터를 0.1초 뒤에 렌더링 (화면 깜빡임 최소화)
    setTimeout(function() {
        let mockData = generateMockReviews(keyword);
        renderReviews(mockData);
    }, 100);
}

// 가짜 데이터 생성기 (생동감 있는 데이터)
function generateMockReviews(keyword) {
    // 키워드가 있고 '없음'이라고 검색하면 빈 데이터 리턴 테스트
    if(keyword && keyword === "없음") return { count: 0, list: [], photoList: [] };

    // 다양한 리뷰 텍스트 풀
    const contents = [
        "배송도 빠르고 포장도 꼼꼼합니다. 실물이 훨씬 예쁘네요! 정사이즈 추천합니다.",
        "발볼이 넓은 편인데 반업하니까 딱 좋습니다. 쿠션감이 예술이네요.",
        "고민하다 샀는데 진작 살 걸 그랬어요. 색감이 화면이랑 똑같고 어디에나 잘 어울립니다.",
        "선물용으로 구매했는데 받는 친구가 너무 좋아해요. 역시 믿고 사는 브랜드!",
        "가볍고 착화감이 좋아서 데일리로 신기 딱 좋습니다. 마감 처리도 깔끔해요.",
        "재입고 기다렸다가 바로 샀습니다. 기다린 보람이 있네요. 강력 추천!",
        "디자인이 유니크해서 마음에 듭니다. 신었을 때 발이 작아 보이는 효과가 있어요.",
        "생각보다 굽이 있어서 키높이 효과도 있네요. 하루 종일 걸어도 발이 안 아파요."
    ];
    
    const userIds = ["run_lover", "daily_look", "shoaholic", "happy_day", "sky_blue", "star_dust"];
    const sizes = ["230mm", "235mm", "240mm", "260mm", "270mm"];
    const footTypes = ["정사이즈", "발볼 넓음", "칼발", "발등 높음"];

    let list = [];
    // 5개의 리뷰 생성
    for(let i=0; i<5; i++) {
        let contentIdx = Math.floor(Math.random() * contents.length);
        let idIdx = Math.floor(Math.random() * userIds.length);
        
        list.push({
            reviewNo: i,
            memberId: userIds[idIdx] + (Math.floor(Math.random()*100)), // 랜덤 아이디
            optionValue: sizes[Math.floor(Math.random() * sizes.length)],
            starRating: (i % 3 === 0) ? 4 : 5, // 대부분 5점
            footSize: footTypes[Math.floor(Math.random() * footTypes.length)],
            content: contents[contentIdx],
            regDate: "2023-10-" + (10 + i),
            isNew: i < 2, // 상위 2개는 NEW 뱃지
            images: (i % 2 !== 0) ? ["dummy"] : [] // 홀수번째는 이미지 있음
        });
    }

    return {
        count: 128,
        list: list,
        photoList: ["p1","p2","p3","p4","p5","p6"] // 포토 요약용 더미
    };
}

// 화면 렌더링 (HTML 조립)
function renderReviews(data) {
    let container = $('#reviewContentArea');
    let html = "";
    
    $('#reviewTotalCount').text("("+data.count+")");

    if (!data.list || data.list.length === 0) {
        container.html('<div class="review-empty">리뷰가 없습니다.</div>');
        return;
    }

    // 1. 포토 요약 영역 (데이터가 있을 때만)
    if(data.photoList && data.photoList.length > 0) {
        html += `
        <div class="review-photo-summary">
            <div class="photo-summary-header">
                <span>포토&동영상 전체보기 <span style="color:#aaa;">></span></span>
            </div>
            <div class="photo-summary-list">`;
        data.photoList.forEach((item, idx) => {
            // 실제 이미지가 없으므로 회색 박스로 대체
            html += `<div class="photo-summary-item" style="background:#eee; display:flex; align-items:center; justify-content:center; color:#999;"><i class="bi bi-image"></i></div>`;
        });
        html += `   </div>
        </div>`;
    }

    // 2. 필터 바
    let isChecked = $('#chkPhotoFirst').is(':checked') ? 'checked' : '';
    html += `
    <div class="review-filter-row">
        <div class="filter-left">
            <label class="round-checkbox-wrapper">
                <input type="checkbox" id="chkPhotoFirst" onchange="loadReviews(1)" ${isChecked}>
                <span class="round-checkbox-visual"></span>
                포토/동영상 먼저보기
            </label>
        </div>
        <div class="filter-right">
            <select id="selFootSize" class="filter-select" onchange="loadReviews(1)">
                <option value="">발 사이즈 선택</option>
                <option value="small">작음</option>
                <option value="fit">정사이즈</option>
                <option value="big">큼</option>
            </select>
        </div>
    </div>`;

    // 3. 리뷰 리스트
    html += '<div id="reviewListContainer">';
    
    data.list.forEach(item => {
        // 아이디 마스킹
        let maskedId = item.memberId.length > 3 ? item.memberId.substring(0,3) + "****" : item.memberId + "***";
        
        // 별점 HTML 생성 (흑백 스타일 적용)
        let stars = "";
        for(let i=0; i<5; i++) {
            stars += (i < item.starRating) 
                ? '<i class="bi bi-star-fill filled"></i>' 
                : '<i class="bi bi-star-fill"></i>'; // 빈 별은 CSS에서 색상 제어
        }
        
        let newBadge = item.isNew ? '<span class="review-badge-new">NEW</span>' : '';

        html += `
        <div class="review-item">
            <div class="review-meta-top">
                <div class="d-flex align-items-center">
                    ${newBadge}
                    <span>옵션 : ${item.optionValue}</span>
                </div>
                <div class="review-writer-id">${maskedId}</div>
            </div>
            
            <div class="review-meta-mid">
                <div class="star-rating-custom">${stars}</div>
                <span class="foot-size-tag bg-light px-2 py-1 rounded text-secondary small ms-2">
                    발 사이즈 : ${item.footSize}
                </span>
            </div>
            
            <div class="review-content">
                ${item.content}
                <div class="review-date">${item.regDate}</div>
            </div>`;
            
            // 이미지 리뷰인 경우 썸네일 표시
            if(item.images && item.images.length > 0) {
                html += `
                <div class="review-images-container">
                    <div class="review-thumb" style="background:#f8f9fa; display:flex; align-items:center; justify-content:center;">
                        <i class="bi bi-camera-fill text-muted"></i>
                    </div>
                </div>`;
            }
            
        html += `</div>`;
    });
    
    html += '</div>'; // End list container

    // HTML 삽입
    container.html(html);
}
</script>