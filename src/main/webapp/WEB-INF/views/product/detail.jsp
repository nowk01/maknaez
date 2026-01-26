<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<jsp:include page="/WEB-INF/views/common/image_config.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${dto.prodName} - Maknaez </title>

<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/product-detail.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/header.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/footer.css">
  
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>

<style>
    .share-container { position: relative; display: inline-block; width: 30px; height: 30px; vertical-align: middle; }
    .share-trigger { font-size: 1.2rem; color: #333; position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); transition: all 0.3s ease; cursor: pointer; z-index: 2; }
    .share-options { position: absolute; top: 50%; right: -12px; transform: translateY(-50%); background-color: #fff; border: 1px solid #ddd; border-radius: 25px; height: 44px; display: flex; align-items: center; justify-content: center; gap: 0; width: 0; padding: 0; opacity: 0; visibility: hidden; overflow: hidden; transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94); z-index: 10; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
    .share-container:hover .share-trigger { opacity: 0; transform: translate(-50%, -50%) scale(0.5); }
    .share-container:hover .share-options { width: 110px; padding: 0 8px; opacity: 1; visibility: visible; }
    .share-btn { background: none; border: none; padding: 0; margin: 0; font-size: 1.15rem; color: #555; cursor: pointer; display: flex; align-items: center; justify-content: center; width: 40px; height: 34px; border-radius: 5px; transition: all 0.2s ease; }
    .share-btn i { line-height: 1; display: block; margin-top: 1px; margin-right: 12px; }
    .share-btn:hover { background-color: #f5f5f5; color: #000; transform: scale(1.1); }
    .share-divider { width: 1px; height: 14px; background-color: #e0e0e0; margin: 0 2px; flex-shrink: 0; }
    .toast-message { position: fixed; bottom: 50px; left: 50%; transform: translateX(-50%) translateY(20px); background-color: rgba(34, 34, 34, 0.95); color: #fff; padding: 12px 30px; border-radius: 50px; font-size: 0.95rem; font-weight: 400; z-index: 9999; opacity: 0; visibility: hidden; transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94); box-shadow: 0 5px 15px rgba(0,0,0,0.15); pointer-events: none; white-space: nowrap; }
    .toast-message.show { opacity: 1; visibility: visible; transform: translateX(-50%) translateY(0); }
    #stickySidebar .restock-alert .btn { border-radius: 30px; border: 1px solid #e0e0e0; color: #555; padding: 5px 15px; background-color: transparent; transition: all 0.2s; }
    #stickySidebar .restock-alert .btn:hover { background-color: #fff; border-color: #000 !important; color: #000; }
    .btn-cart-custom { border-radius: 30px; border: 1px solid #ddd; background-color: #fff; color: #111; transition: all 0.2s; }
    .btn-cart-custom:hover { background-color: #fff; border-color: #000 !important; color: #000; }
    .btn-buy-custom { border-radius: 30px; border: 1px solid #111; background-color: #111; color: #fff; transition: all 0.2s; margin-top: 10px; width: 100%; }
    .btn-buy-custom:hover { background-color: #333; border-color: #111 !important; color: #fff; }

    .product-info-content img {
        max-width: 100%;
        height: auto;
    }

    input[type="radio"]:disabled + .size-btn {
        color: #ddd !important;
        border-color: #f0f0f0 !important;
        background-color: #fbfbfb !important;
        cursor: not-allowed !important;
        text-decoration: line-through; 
    }

    .review-wrapper { padding: 40px 0; background-color: #fff; }
    
    .review-header-container { 
        display: flex; 
        justify-content: space-between; 
        align-items: flex-end; 
        border-bottom: 2px solid #111; 
        padding-bottom: 10px; 
    }
    .review-header-title { font-size: 1.3rem; font-weight: 800; margin: 0; color: #111; letter-spacing: -0.5px; }
    .review-header-title span { color: #888; font-weight: 400; margin-left: 6px; font-size: 0.95rem; }
    
    .review-item { 
        padding: 25px 5px; 
        border-bottom: 1px solid #eee; 
        display: flex; 
        flex-direction: row; 
        justify-content: space-between;
        align-items: stretch;
    }
    .review-item:last-child { border-bottom: 1px solid #111; }

    .review-content-col {
        flex: 1; 
        padding-right: 20px;
        display: flex;
        flex-direction: column;
        justify-content: flex-start; 
    }

    .review-meta-option { 
        font-size: 0.85rem;
        margin-bottom: 6px;
    }
    .review-option-label {
        color: #999; 
    }
    .review-option-divider {
        color: #ddd;
        margin: 0 6px;
        font-size: 0.7rem;
        vertical-align: 1px;
    }
    .review-option-value {
        color: #000; 
        font-weight: 500;
    }

    .star-rating-custom { 
        color: #ddd; 
        font-size: 1.1rem; 
        letter-spacing: -1px; 
        line-height: 1; 
        margin-bottom: 12px;
        text-align: left;
    }
    .star-rating-custom .filled { color: #111; } 

    .review-img-wrapper {
        margin: 10px 0 5px 0; 
        font-size: 0; 
        line-height: 0;
        display: block; 
    }
    .review-img-thumb { 
        width: 120px; 
        height: 120px; 
        object-fit: cover; 
        cursor: zoom-in; 
        border: 1px solid #f1f1f1;
        display: inline-block; 
        transition: width 0.3s ease, height 0.3s ease; 
    }
    
    .review-img-thumb.zoomed {
        width: 360px; 
        height: 240px;
        cursor: zoom-out;
        margin-bottom: 10px; 
    }

    .review-content { 
        font-size: 0.95rem; 
        color: #222; 
        line-height: 1.1; 
        white-space: pre-wrap; 
        margin-top: 0;
    }
    .review-text-short { display: inline; }
    .review-text-full { display: none; }
    .review-more-btn { color: #999; font-size: 0.8rem; margin-left: 5px; cursor: pointer; text-decoration: underline; }
    .review-more-btn:hover { color: #333; }
    .review-divider-vertical {
        width: 1px;
        background: linear-gradient(to bottom, transparent 5%, #eee 5%, #eee 95%, transparent 95%);
        margin: 0 25px;
        flex-shrink: 0;
    }
    .review-user-col {
        width: 120px; 
        display: flex;
        flex-direction: column;
        justify-content: flex-start; 
        align-items: flex-end; 
        text-align: right;
        flex-shrink: 0;
        padding-top: 20px; 
    }

    .review-writer { font-weight: 700; font-size: 0.9rem; color: #333; margin-bottom: 6px; }
    .review-date { font-size: 0.8rem; color: #aaa; font-family: 'Roboto', sans-serif; }

    .pagination-container { display: flex; justify-content: center; margin-top: 30px; }
    .pagination-custom { display: flex; gap: 4px; list-style: none; padding: 0; margin: 0; }
    .page-item-custom { cursor: pointer; width: 28px; height: 28px; display: flex; align-items: center; justify-content: center; border: 1px solid #eee; background-color: #fff; font-size: 0.8rem; color: #555; transition: all 0.2s; }
    .page-item-custom:hover { border-color: #333; color: #333; }
    .page-item-custom.active { background-color: #333; color: #fff; border-color: #333; }
    .page-item-custom.disabled { color: #ddd; border-color: #fafafa; cursor: default; }

    .star-rating-header i { font-size: 0.75rem; color: #ddd; margin-right: 1px; }
    .star-rating-header i.filled { color: #333; }
    .star-text-header { font-size: 0.75rem; color: #888; margin-left: 4px; font-weight: 400; vertical-align: middle; position: relative; top: 1px; }
    
    #recommendSection .card-img-top {
        height: 250px;       
        object-fit: cover;   
        object-position: center; 
        width: 100%;
    }
    #recommendSection .card {
        transition: transform 0.2s;
    }
    #recommendSection .card:hover {
        transform: translateY(-5px);
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }
    
	.star-rating-header {
		display: flex;
		align-items: center;
		gap: 1px; 
	}
	.star-rating-header i {
		color: #e0e0e0; 
		font-size: 0.8rem;
	}
	.star-rating-header i.filled {
		color: #212529; 
	}
	.star-text-header {
		margin-left: 8px;
		font-weight: 700;
		color: #000; 
		font-size: 0.8rem;
		letter-spacing: -0.5px;
	}
	.review-count-header {
		margin-left: 8px;
		font-size: 0.9rem;
		color: #888; 
		text-decoration: underline;
		cursor: pointer;
	}
	.review-count-header:hover {
		color: #000;
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
			<input type="hidden" name="productNum" value="${dto.prodId}">
			<input type="hidden" name="detailNum" id="selectedDetailNum" value="">
			<input type="hidden" name="qty" id="selectedQty" value="1">
		</form>

		<div class="row">
			<div class="col-lg-8 detail-left-section">
				<div class="product-image-grid">
					<img src="${uploadPath}/${dto.thumbnail}" alt="${dto.prodName}" onerror="this.src='https://placehold.co/800x600?text=No+Image'">
					<c:forEach var="item" items="${listImg}" varStatus="status" begin="0" end="3">
                    <img src="${uploadPath}/${item.fileName}" alt="${dto.prodName}" 
                         onerror="this.src='https://placehold.co/800x600?text=No+Image'">
                </c:forEach>
				</div>

				<ul class="nav nav-tabs product-tabs mb-4" id="myTab" role="tablist">
					<li class="nav-item" role="presentation">
						<button class="nav-link active" id="info-tab" data-bs-toggle="tab" data-bs-target="#info-pane" type="button" role="tab">제품 정보</button>
					</li>
					<li class="nav-item" role="presentation">
						<button class="nav-link" id="review-tab" type="button" onclick="document.getElementById('reviewSection').scrollIntoView({behavior: 'smooth'})">리뷰</button>
					</li>
					<li class="nav-item" role="presentation">
						<button class="nav-link" id="recommend-tab" type="button" onclick="document.getElementById('recommendSection').scrollIntoView({behavior: 'smooth'})">추천</button>
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

				<div class="product-features">
					<h4>제품 특징</h4>
					<table class="detail-table">
					    <tr><th>방수 기능</th><td>방수 기능이 뛰어난 PFC프리 코어텍스 멤브레인이 쉽게 젖을 수 있는 겨울 환경에서 발을 보호해줍니다.</td></tr>
                        <tr><th>윈터 프로텍션</th><td>새로운 고어텍스 ePE 멤브레인 소재를 사용했습니다. 어퍼에 적용된 클로즈드 메쉬 구조가 외부로부터 돌이나 흙이 들어오지 않도록 막아줍니다. 또한 코팅된 퀵레이스가 윈터 프로텍션 기능을 한층 더 강화시켜줍니다.</td></tr>
                        <tr><th>안정감</th><td>아웃솔의 다운힐 섀시와 러그 구조가 어떤 지형에서도 안정적인 움직임을 만들어줍니다.</td></tr>
                        <tr><th>GORE-TEX PFC free</th><td>새로운 경량 고어텍스 멤브레인은 탄소발자국을 최소화하여 제작되었습니다. 워터프루프 기능과 통기성이 우수한 소재입니다. 폴리에틸렌(ePE)를 바탕으로 제작했습니다.</td></tr>
                        <tr><th>Abrasion-resistant TPU material</th><td>내구성이 뛰어난 소재를 사용했기 때문에 오랫동안 착용해도 손상이 최소화됩니다.</td></tr>    
					</table>
				</div>

				<div class="product-notice">
					<h4>상품 고시 정보</h4>
					<table class="detail-table">
					   <tr><th>Lacing system</th><td>Quicklace®</td></tr>
	                   <tr><th>Drop (mm)</th><td>10</td></tr>
	                   <tr><th>Inlay sole</th><td>Textile</td></tr>
	                   <tr><th>Lining</th><td>Textile</td></tr>
	                   <tr><th>Outsole</th><td>Rubber</td></tr>
	                   <tr><th>Upper</th><td>Synthetic / Textile</td></tr>
	                   <tr><th>Weight(g)</th><td>357</td></tr>
	                   <tr><th>제조국</th><td>Vietnam / Cambodia / China</td></tr>
	                   <tr><th>제조연월</th><td>수입제품으로 각 제품별 입고 시기에 따라 상이하여 정확한 제조연월 제공이 어렵습니다. 제조연월을 확인하시려면 고객센터에 문의하시기 바라며, 정확한 제조연월은 배송받으신 제품의 라벨을 참고하시기 바랍니다.</td></tr>
	                   <tr><th>수입원/판매원</th><td>(주)막내즈컴퍼니</td></tr>
	                   <tr><th>취급시 주의사항</th><td>라벨 유의사항 참조</td></tr>
	                   <tr><th>품질보증기준</th><td>관련법 및 소비자분쟁 해결기준에 따름</td></tr>
	                   <tr><th>A/S 책임자와 전화번호</th><td>막내즈컴퍼니/070-0000-0000</td></tr>
					</table>
				</div>

			</div> <div class="col-lg-4 detail-right-section">
				<div id="stickySidebar" class="sticky-sidebar">
					
                    <div class="product-name">${dto.prodName}</div>
                    
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
						<div class="star-rating-header">
							<c:set var="rating" value="${reviewStats.AVGRATING != null ? reviewStats.AVGRATING : 0}"/>
							<c:set var="reviewCount" value="${reviewStats.TOTALCOUNT != null ? reviewStats.TOTALCOUNT : 0}"/>
							
							<c:forEach var="i" begin="1" end="5">
								<c:choose>
									<c:when test="${rating >= i}">
										<i class="bi bi-star-fill filled"></i>
									</c:when>
									<c:when test="${rating >= i - 0.5}">
										<i class="bi bi-star-half filled"></i>
									</c:when>
									<c:otherwise>
										<i class="bi bi-star filled" style="color: #ddd;"></i>
									</c:otherwise>
								</c:choose>
							</c:forEach>
							
							<span class="star-text-header">(${rating})</span>
							<span class="review-count-header" onclick="document.getElementById('reviewSection').scrollIntoView({behavior: 'smooth'})">리뷰 ${reviewCount}개</span>
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

							<c:choose>
                                <c:when test="${isUserLiked}">
                                    <i class="bi bi-heart-fill text-danger" id="wishBtn" title="찜 취소" style="cursor: pointer;"></i>
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-heart" id="wishBtn" title="찜하기" style="cursor: pointer;"></i>
                                </c:otherwise>
                            </c:choose>
						</div>
					</div>

                <div class="color-options mb-4">
                    <div class="color-label mb-2 fw-bold">
                        컬러 : <span class="text-primary">${dto.colorCode}</span>
                    </div>
                    
                    <div class="color-thumbs">
                        <c:choose>
                            <c:when test="${not empty dto.colorOptions}">
                                <c:forEach var="colorItem" items="${dto.colorOptions}">
                                    <div class="color-thumb ${colorItem.prodId == dto.prodId ? 'active' : ''}" 
                                         onclick="location.href='${pageContext.request.contextPath}/product/detail?prod_id=${colorItem.prodId}'"
                                         title="${colorItem.prodName}">
                                        <img src="${uploadPath}/${colorItem.thumbnail}" alt="${colorItem.colorCode}" onerror="this.src='https://placehold.co/60x60?text=IMG'">
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="color-thumb active">
                                    <img src="${uploadPath}/${dto.thumbnail}" alt="${dto.colorCode}" onerror="this.src='https://placehold.co/60x60?text=IMG'">
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>


					<div class="size-options">
						<div class="d-flex justify-content-between mb-2">
							<span class="fw-bold">사이즈</span>
						</div>
						<div class="size-grid">
							<c:set var="stdSizes" value="220,225,230,235,240,245,250,255,260,265,270,275,280,285,290"/>
							<c:forTokens items="${stdSizes}" delims="," var="stdSize">
                                <c:set var="targetOptId" value=""/>
                                <c:set var="targetStock" value="-1"/>
                                <c:set var="isFound" value="false"/>
                                
                                <c:forEach var="dbSize" items="${sizeList}">
                                    <c:if test="${dbSize.prodSize eq stdSize}">
                                        <c:set var="targetOptId" value="${dbSize.optId}"/>
                                        <c:set var="targetStock" value="${dbSize.stockQty}"/>
                                        <c:set var="isFound" value="true"/>
                                    </c:if>
                                </c:forEach>
                                
								<div class="size-item">
									<c:choose>
                                        <%-- DB에 존재하고 재고가 있는 경우 --%>
										<c:when test="${isFound && targetStock > 0}">
											<input type="radio" name="optionDetailNum" id="size_${targetOptId}" value="${targetOptId}">
											<label for="size_${targetOptId}" class="size-btn">${stdSize}</label>
										</c:when>
                                        <%-- DB에 존재하지만 재고가 없는 경우 --%>
                                        <c:when test="${isFound && targetStock <= 0}">
                                            <input type="radio" name="optionDetailNum" id="size_${targetOptId}" value="${targetOptId}" disabled>
                                            <label for="size_${targetOptId}" class="size-btn">${stdSize}</label>
                                        </c:when>
                                        <%-- DB에 아예 없는 경우 (품절 취급) --%>
										<c:otherwise>
											<input type="radio" name="optionDetailNum" id="size_null_${stdSize}" value="" disabled>
											<label for="size_null_${stdSize}" class="size-btn">${stdSize}</label>
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

		<div id="reviewSection" class="review-wrapper mt-5">
             <div class="review-header-container">
                <h3 class="review-header-title">리뷰<span id="reviewTotalCount">(0)</span></h3>     
            </div>            
            <div id="reviewContentArea">
                 <div class="text-center py-5">
                    <div class="spinner-border text-secondary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>
            </div>
            
            <div id="reviewPagination" class="pagination-container"></div>
		</div>

		<div id="recommendSection" class="recommend-section mt-5 pt-5 border-top">
    <h3>추천 상품</h3>
    <div class="recommend-carousel mt-4">
        <div class="row">
            <c:choose>
                <%-- 추천 상품이 있는 경우 --%>
                <c:when test="${not empty relatedProducts}">
                    <c:forEach var="item" items="${relatedProducts}">
                        <div class="col-6 col-md-3">
                            <div class="card border-0 h-100" style="cursor: pointer;" 
                                 onclick="location.href='${pageContext.request.contextPath}/product/detail?prod_id=${item.prodId}'">
                                
                                <%-- 썸네일 이미지 --%>
                                <img src="${uploadPath}/${item.thumbnail}" class="card-img-top" 
                                     alt="${item.prodName}" 
                                     onerror="this.src='https://placehold.co/300x300?text=No+Image'">
                                
                                <div class="card-body px-0">
                                    <h6 class="card-title text-truncate">${item.prodName}</h6>
                                    
                                    <p class="card-text">
                                        <%-- 할인 상품인 경우 --%>
                                        <c:if test="${item.discountRate > 0}">
                                            <span class="text-danger fw-bold" style="margin-right:5px;">${item.discountRate}%</span>
                                            <span class="text-muted text-decoration-line-through" style="font-size:0.9rem;">
                                                <fmt:formatNumber value="${item.price}" pattern="#,###"/>
                                            </span>
                                            <br>
                                            <span class="fw-bold">
                                                <fmt:formatNumber value="${item.price * (100 - item.discountRate) / 100}" pattern="#,###"/> 원
                                            </span>
                                        </c:if>
                                        
                                        <%-- 일반 상품인 경우 --%>
                                        <c:if test="${item.discountRate == 0}">
                                            <span class="text-muted">
                                                <fmt:formatNumber value="${item.price}" pattern="#,###"/> 원
                                            </span>
                                        </c:if>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                
                <%-- 추천 상품이 없는 경우 --%>
                <c:otherwise>
                    <div class="col-12 text-center py-5">
                        <p class="text-muted">추천 상품이 없습니다.</p>
                    </div>
                </c:otherwise>
            </c:choose>
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
const productNum = "${dto.prodId}"; 

const isLoggedIn = ${not empty sessionScope.member ? 'true' : 'false'};

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


try {
    Kakao.init('카카오API키'); // 발급받은 키 유지 현재 정식출시 어플이 아니므로 링크가 삽입되지 않을 수 있음.
} catch(e) {
    console.log("카카오 SDK 초기화 실패 (키 미입력)");
}

function shareKakao() {
	try {
		Kakao.Share.sendDefault({
			objectType: 'commerce',
			content: {
				title: '${dto.prodName}',
				imageUrl: window.location.origin + contextPath + '/uploads/product/${dto.thumbnail}',
				link: {
					mobileWebUrl: window.location.href,
					webUrl: window.location.href,
				},
			},
			commerce: {
				productName: '${dto.prodName}',
				regularPrice: ${dto.originalPrice},
				discountRate: ${dto.discountRate},
				discountPrice: ${dto.price}
			},
			buttons: [
				{
					title: '구매하기',
					link: {
						mobileWebUrl: window.location.href,
						webUrl: window.location.href,
					},
				},
			],
		});
	} catch(e) {
		alert('카카오톡 공유에 실패했습니다.');
	}
}


$(document).ready(function() {
	$('.plus').click(function() { let q = parseInt($('.qty-input').val()); if(q < 10) { $('.qty-input').val(q + 1); $('#selectedQty').val(q + 1); } });
	$('.minus').click(function() { let q = parseInt($('.qty-input').val()); if(q > 1) { $('.qty-input').val(q - 1); $('#selectedQty').val(q - 1); } });

	window.buyNow = function() {
		if(!checkSelection()) return;
        const qty = $('#selectedQty').val();
        const sizeOptId = $('input[name="optionDetailNum"]:checked').val();
        
        location.href = contextPath + "/order/payment?prod_id=" + productNum + "&quantity=" + qty + "&opt_id=" + sizeOptId;
	};

	window.addToCart = function() {
        if (!isLoggedIn) {
            if(confirm("로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?")) {
                location.href = contextPath + "/member/login";
            }
            return;
        }

		if(!checkSelection()) return;

        const qty = $('#selectedQty').val();
        const sizeOptId = $('input[name="optionDetailNum"]:checked').val();

        $.ajax({
            type: "POST",
            url: contextPath + "/cart/insert",
            data: {
                prodId: productNum,
                optId: sizeOptId,
                quantity: qty
            },
            dataType: "json",
            success: function(res) {
                if(res.status === "success") {
                    if(confirm("장바구니에 담았습니다.\n장바구니로 이동하시겠습니까?")) {
                        location.href = contextPath + "/order/cart";
                    }
                } else if(res.status === "login_required") {
                    alert("로그인이 필요합니다.");
                    location.href = contextPath + "/member/login";
                } else {
                    alert("장바구니 담기 실패: " + (res.message || "오류가 발생했습니다."));
                }
            },
            error: function(xhr) {
                console.error(xhr);
                alert("서버 통신 중 오류가 발생했습니다.");
            }
        });
	};

	function checkSelection() {
		if(!$('input[name="optionDetailNum"]:checked').val()) {
			alert("사이즈를 선택해주세요.");
			return false;
		}
		return true;
	}
	
    if(productNum) {
        loadReviews(productNum, 1);
    }
    $('#wishBtn').click(function() {
        if (!isLoggedIn) {
            if(confirm("로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?")) {
                location.href = contextPath + "/member/login";
            }
            return;
        }

        let $btn = $(this);
        
        $.ajax({
            url: contextPath + "/product/insertWish",
            type: "POST",
            data: { prod_id: productNum }, 
            dataType: "json",
            success: function(data) {
                if(data.state === "true") {
                    $btn.removeClass('bi-heart').addClass('bi-heart-fill text-danger');
                    showToast("관심 상품에 추가되었습니다.");
                } else if(data.state === "false") {
                    $btn.removeClass('bi-heart-fill text-danger').addClass('bi-heart');
                    showToast("관심 상품에서 삭제되었습니다.");
                } else if(data.state === "login_required") {
                    alert("로그인이 필요합니다.");
                    location.href = contextPath + "/member/login";
                } else {
                    alert("처리에 실패했습니다.");
                }
            },
            error: function(e) {
                console.log(e);
                alert("서버 통신 중 오류가 발생했습니다.");
            }
        });
    });
});

function loadReviews(prodId, page) {
    if(!page) page = 1;

    $.ajax({
        url: '${pageContext.request.contextPath}/review/list',
        type: 'GET',
        data: { prodId: prodId, pageNo: page }, 
        dataType: 'json',
        success: function(response) {
            console.log("Review Data:", response);
            if (response.status === 'success') {
                renderReviews(response.data);
                $('#reviewTotalCount').text('(' + response.count + ')');
                renderPaging(response.pageNo, response.totalPage);
            } else {
                console.error('리뷰 로드 실패:', response.message);
                $('#reviewContentArea').html('<div class="text-center py-5 text-muted">리뷰 로드 중 오류가 발생했습니다.<br>(' + response.message + ')</div>');
            }
        },
        error: function(xhr) {
            console.error('Ajax Error:', xhr.responseText);
            $('#reviewContentArea').html('<div class="text-center py-5 text-muted">서버 통신 오류가 발생했습니다.</div>');
        }
    });
}

function renderReviews(reviews) {
    let container = $('#reviewContentArea');
    container.empty();

    if (!reviews || reviews.length === 0) {
        container.html(`<div class="text-center py-5 bg-white" style="color: #999;"><i class="bi bi-chat-square-dots" style="font-size:2rem; display:block; margin-bottom:10px; color:#eee;"></i><p class="mb-0">아직 등록된 리뷰가 없습니다.</p></div>`);
        return;
    }

    let html = '<div id="reviewListContainer">';
    const maxLen = 60; 
    
    $.each(reviews, function(idx, item) {
        let stars = '';
        for (let i = 0; i < 5; i++) {
            stars += (i < item.starRating) 
                ? '<i class="bi bi-star-fill filled"></i>' 
                : '<i class="bi bi-star-fill"></i>';
        }

        let imgHtml = '';
        if (item.reviewImg && item.reviewImg.trim() !== '') {
            const imgPath = '${pageContext.request.contextPath}/uploads/review/' + item.reviewImg;
            imgHtml = `<div class="review-img-wrapper"><img src="\${imgPath}" class="review-img-thumb" alt="리뷰 이미지" onclick="toggleZoom(this)"></div>`;
        }
        let contentHtml = '';
        if (item.content.length > maxLen) {
            contentHtml = `<span class="review-text-short">\${item.content.substring(0, maxLen)}...</span><span class="review-text-full">\${item.content}</span><span onclick="toggleReview(this)" class="review-more-btn">더보기</span>`;
        } else {
            contentHtml = item.content;
        }
        
        let replyHtml = '';
        if (item.replyContent && item.replyContent.trim() !== '') {
            replyHtml = `
                <div class="seller-reply-box" style="margin-top: 15px; background-color: #f8f9fa; padding: 15px; border-radius: 8px; border: 1px solid #eee;">
                    <div style="font-weight: bold; font-size: 0.9rem; color: #333; margin-bottom: 5px;">
                        <span style="color: #0d6efd; margin-right: 5px;">↳</span> 판매자 답변
                        <span style="font-weight: normal; font-size: 0.8rem; color: #999; margin-left: 8px;">\${item.replyDate}</span>
                    </div>
                    <div style="font-size: 0.9rem; color: #555; white-space: pre-wrap; line-height: 1.4;">\${item.replyContent}</div>
                </div>
            `;
        }

        html += `
        <div class="review-item">
            <div class="review-content-col">
                <div class="review-meta-option">
                    <span class="review-option-label">상품옵션</span>
                    <span class="review-option-divider">|</span>
                    <span class="review-option-value">\${item.optionValue}</span>
                </div>                
                <div class="star-rating-custom">\${stars}</div>   
                <div class="review-content">
                    <div style="margin-bottom:0px;">\${contentHtml}</div>\${imgHtml}  
                </div>
            </div>
            <div class="review-divider-vertical"></div>

            <div class="review-user-col">
                <div class="review-writer">\${item.writerName}</div>
                <div class="review-date">\${item.regDate}</div>
            </div>
        </div>`;
    });    
    html += '</div>';
    container.html(html);
}

function toggleReview(btn) {
    const parent = $(btn).parent();
    const isExpanded = $(btn).text() === "접기";
    
    if (isExpanded) {
        parent.find('.review-text-short').show();
        parent.find('.review-text-full').hide();
        $(btn).text("더보기");
    } else {
        parent.find('.review-text-short').hide();
        parent.find('.review-text-full').show(); // display:inline or block
        parent.find('.review-text-full').css('display', 'inline');
        $(btn).text("접기");
    }
}

function toggleZoom(img) {
    if (img.classList.contains('zoomed')) {
        img.classList.remove('zoomed');
    } else {
        document.querySelectorAll('.review-img-thumb.zoomed').forEach(el => el.classList.remove('zoomed'));
        img.classList.add('zoomed');
    }
}

function renderPaging(current_page, total_page) {
    let container = $('#reviewPagination');
    container.empty();
    
    if(total_page === 0) return;

    let pageBlock = 5;
    let startPage = Math.floor((current_page - 1) / pageBlock) * pageBlock + 1;
    let endPage = startPage + pageBlock - 1;
    if(endPage > total_page) endPage = total_page;

    let html = '<ul class="pagination-custom">';

    if(startPage > 1) {
        html += `<li class="page-item-custom" onclick="loadReviews(productNum, \${startPage-1})"><i class="bi bi-chevron-left"></i></li>`;
    } else {
        html += `<li class="page-item-custom disabled"><i class="bi bi-chevron-left"></i></li>`;
    }

    for(let i = startPage; i <= endPage; i++) {
        if(current_page === i) {
            html += `<li class="page-item-custom active">\${i}</li>`;
        } else {
            html += `<li class="page-item-custom" onclick="loadReviews(productNum, \${i})">\${i}</li>`;
        }
    }

    if(endPage < total_page) {
        html += `<li class="page-item-custom" onclick="loadReviews(productNum, \${endPage+1})"><i class="bi bi-chevron-right"></i></li>`;
    } else {
        html += `<li class="page-item-custom disabled"><i class="bi bi-chevron-right"></i></li>`;
    }

    html += '</ul>';
    container.html(html);
}

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

function searchReview() {
    alert("검색 기능은 준비중입니다.");
}

function requestRestockAlarm() {
    const prodId = "${dto.prodId}"; 
    $.ajax({
        type: "POST",
        url: "${pageContext.request.contextPath}/product/restockSubmit",
        data: { prodId: prodId },
        dataType: "json",
        success: function(data) {
            if (data.state === "login_required") {
                if(confirm("로그인이 필요한 서비스입니다. 로그인 페이지로 이동하시겠습니까?")) {
                    location.href = "${pageContext.request.contextPath}/member/login";
                }
            
            } else if (data.state === "true") {
                $('#restockModal .btn-close').click();
                
                showToast(data.message);
                
                $('#wishBtn').removeClass('bi-heart').addClass('bi-heart-fill text-danger');
                
            } else {
                $('#restockModal .btn-close').click();
                showToast(data.message);
            }
        },
        error: function(e) {
            console.log(e);
            alert("서버 통신 중 오류가 발생했습니다.");
        }
    });
}
</script>

<div class="modal fade" id="restockModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">입고 알림 신청</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body text-center">
        <p class="my-3">
            원하시는 사이즈가 품절인가요?<br><br>
            입고 알림 신청 시 <strong>[관심 상품]</strong>에 자동 추가되며,<br>
            상품 재입고 시 등록된 이메일로 알림을 보내드립니다.
        </p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-dark w-100" onclick="requestRestockAlarm()">신청하기</button>
      </div>
    </div>
  </div>	
</div>

</body>
</html>