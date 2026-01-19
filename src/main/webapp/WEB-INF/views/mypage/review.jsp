<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>상품 리뷰</title>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/mypage.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/my_review.css">

<script>
    const contextPath = "${pageContext.request.contextPath}";
</script>
</head>
<body>

    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <div class="mypage-wrapper">
        
        <aside class="account-sidebar">
            <h2 class="sidebar-heading">마이페이지</h2>
            
            <div class="sidebar-menu-list">
                <div class="menu-card">
                    <h3 class="menu-title">구매내역</h3>
                    <a href="${pageContext.request.contextPath}/member/mypage/orderList" class="menu-link">주문/배송조회</a>
                    <a href="${pageContext.request.contextPath}/member/mypage/cancelList" class="menu-link">취소/반품조회</a>
                </div>

                <div class="menu-card">
                    <h3 class="menu-title">혜택내역</h3>
                    <a href="${pageContext.request.contextPath}/member/mypage/review" class="menu-link active">상품 리뷰</a>
                    <a href="${pageContext.request.contextPath}/member/mypage/membership" class="menu-link">포인트/쿠폰</a>
                </div>

                <div class="menu-card">
                    <h3 class="menu-title">상품내역</h3>
                    <a href="${pageContext.request.contextPath}/member/mypage/recent" class="menu-link">최근 본 상품</a>
                    <a href="${pageContext.request.contextPath}/member/mypage/wishList" class="menu-link">관심 상품</a>
                </div>

                <div class="menu-card">
                    <h3 class="menu-title">회원정보</h3>
                    <a href="${pageContext.request.contextPath}/member/mypage/myInfo" class="menu-link">내 정보 관리</a>
                    <a href="${pageContext.request.contextPath}/member/mypage/addr" class="menu-link">배송지 관리</a>
                    <a href="${pageContext.request.contextPath}/member/mypage/level_benefit" class="menu-link">회원등급</a>
                </div>
                
                <a href="${pageContext.request.contextPath}/member/logout" class="menu-link logout-link">로그아웃</a>
            </div>
        </aside>

        <main class="account-main">
            <h1 class="page-header">상품 리뷰</h1>

            <div class="review-tabs">
                <button type="button" class="tab-btn active" onclick="showTab('writable')">
                    작성 가능한 리뷰 <span>(${not empty dataCount ? dataCount : 0})</span>
                </button>
                <button type="button" class="tab-btn" onclick="showTab('written')">
   					 작성한 리뷰 <span>(${not empty writtenDataCount ? writtenDataCount : 0})</span>
				</button>
            </div>

            <div id="tab-writable" class="review-tab-content active">
                
                <div class="sort-header">
                    <div class="sort-dropdown">
                        <button type="button" class="sort-btn" onclick="toggleSortMenu(this)">
                            <span class="sort-label">과거 구매순</span>
                            <svg xmlns="http://www.w3.org/2000/svg" width="10" height="10" viewBox="0 0 12 12">
                                <path d="M2 4l4 4 4-4" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                            </svg>
                        </button>
                        <div class="sort-menu">
                            <div class="sort-item" onclick="selectSort(this, '과거 구매순', 'oldest')">과거 구매순</div>
                            <div class="sort-item" onclick="selectSort(this, '최근 구매순', 'newest')">최근 구매순</div>
                            <div class="sort-item" onclick="selectSort(this, '작성기한 임박순', 'deadline')">작성기한 임박순</div>
                        </div>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach var="dto" items="${list}">
                            <div class="review-card">
                                <div class="card-header">
                                    <span class="order-date">${dto.orderDate}</span>
                                    <span class="order-status">배송완료</span>
                                    <span class="order-number">No. ${dto.orderNum}</span>
                                </div>

                                <div class="card-body">
                                    <div class="product-thumb">
                                        <img src="${pageContext.request.contextPath}/uploads/product/${dto.thumbNail}" 
                                             onerror="this.src='${pageContext.request.contextPath}/dist/images/no-image.png'" alt="상품">
                                    </div>
                                    <div class="product-details">
                                        <div class="product-name">${dto.productName}</div>
                                        <div class="product-option">[옵션] ${not empty dto.pdSize ? dto.pdSize : '-'}</div>
                                        <div class="product-price"><fmt:formatNumber value="${dto.totalAmount}" pattern="#,###" />원</div>
                                    </div>
                                    <div class="card-actions">
                                        <a href="${pageContext.request.contextPath}/product/detail?productNum=${dto.productNum}" class="btn-action">상품상세</a>
                                        <button type="button" class="btn-action btn-black" 
                                                onclick="openReviewModal('${dto.orderNum}', '${dto.productNum}', '${dto.productName}', '${dto.thumbNail}')">리뷰쓰기</button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">작성 가능한 리뷰가 없습니다.</div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div id="tab-written" class="review-tab-content">
    <c:choose>
        <c:when test="${not empty writtenList}">
            <c:forEach var="dto" items="${writtenList}">
                <div class="review-card">
                    <div class="card-header">
                        <span class="order-date">${dto.regDate}</span>
                        <span class="order-status" style="color:#007bff;">작성완료</span>
                        <span class="order-number">No. ${dto.orderNum}</span>
                    </div>

                    <div class="card-body">
                        <div class="product-thumb">
                            <img src="${pageContext.request.contextPath}/uploads/product/${dto.thumbNail}" 
                                 onerror="this.src='${pageContext.request.contextPath}/dist/images/no-image.png'" alt="상품">
                        </div>

                        <div class="product-details">
                            <div class="product-name">${dto.productName}</div>
                            
                            <div class="star-rating" style="margin: 5px 0; color: #f5c518; font-size: 14px;">
                                <c:forEach begin="1" end="${dto.starRating}">★</c:forEach>
                                <c:forEach begin="1" end="${5 - dto.starRating}">☆</c:forEach>
                            </div>

                            <div class="review-content" style="font-size: 14px; color: #555; line-height: 1.4; margin-top: 5px;">
                                ${dto.content}
                            </div>

                            <c:if test="${not empty dto.reviewImg}">
                                <div class="review-image" style="margin-top: 10px;">
                                    <img src="${pageContext.request.contextPath}/uploads/review/${dto.reviewImg}" 
                                         style="width: 80px; height: 80px; object-fit: cover; border-radius: 4px; border: 1px solid #eee;" alt="리뷰이미지">
                                </div>
                            </c:if>
                        </div>

                        <div class="card-actions">
                            <a href="${pageContext.request.contextPath}/product/detail?prodId=${dto.prodId}" class="btn-action">상품보기</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        
        <c:otherwise>
            <div class="empty-state">작성한 리뷰 내역이 없습니다.</div>
        </c:otherwise>
    </c:choose>
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
                    <li>상품과 무관한 내용, 악의적 비방, 개인정보 노출 등은 사전 안내 없이 삭제될 수 있습니다.</li>
                </ul>
            </div>
        </main>
    </div>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
    <jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />

    <div id="reviewModal" class="modal-overlay">
        <div class="modal-content review-write-modal">
            
            <div class="modal-header">
                <h3>후기 작성</h3>
                <button type="button" class="close-btn" onclick="closeReviewModal()">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 6L6 18M6 6l12 12"></path></svg>
                </button>
            </div>
            
            <form name="reviewForm" action="${pageContext.request.contextPath}/member/mypage/review/write" method="post" enctype="multipart/form-data" onsubmit="return validateReviewForm();">
                <input type="hidden" name="orderNum" id="modalOrderNum">
                <input type="hidden" name="productNum" id="modalProductNum">
                
                <div class="modal-body custom-scroll">
                    
                    <div class="rw-product-section">
                        <div class="rw-prod-img">
                            <img id="modalImg" src="" alt="상품이미지">
                        </div>
                        <div class="rw-prod-info">
                            <span class="rw-brand-name">상품 정보</span>
                            <span id="modalProdName" class="rw-prod-name"></span>
                            <span class="rw-prod-opt">옵션 정보 로딩중...</span>
                        </div>
                    </div>

                    <div class="rw-section rw-star-section">
                        <h4 class="rw-section-title">이 상품 어떠셨나요?</h4>
                        <div class="star-rating-box">
                            <div class="stars" id="starContainer">
                                <button type="button" class="star-btn" data-value="1"><svg viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg></button>
                                <button type="button" class="star-btn" data-value="2"><svg viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg></button>
                                <button type="button" class="star-btn" data-value="3"><svg viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg></button>
                                <button type="button" class="star-btn" data-value="4"><svg viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg></button>
                                <button type="button" class="star-btn" data-value="5"><svg viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg></button>
                            </div>
                            <input type="hidden" name="rating" id="ratingInput" value="5">
                            <p class="star-text">별점을 선택해주세요.</p>
                        </div>
                    </div>

                    <div class="rw-divider"></div>

                    <div class="rw-section">
                        <div class="rw-title-group">
                            <h4 class="rw-section-title">어떤 점이 좋았나요?</h4>
                            <span class="rw-guide-text">최소 20자 이상</span>
                        </div>
                        <div class="rw-textarea-box">
                            <textarea name="content" id="reviewContent" class="rw-textarea" 
                                placeholder="다른 회원들이 참고할 수 있도록 착용감, 핏, 소재 등을 중심으로 자세히 적어주세요."
                                oninput="checkByte(this)"></textarea>
                            <div class="rw-text-count">
                                <span id="textCount">0</span> / 500
                            </div>
                        </div>
                    </div>

                    <div class="rw-section">
                        <h4 class="rw-section-title">사진 첨부 (선택)</h4>
                        <div class="rw-upload-box">
                            <label for="fileUpload" class="upload-btn">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#ccc" stroke-width="2"><path d="M12 5v14M5 12h14"/></svg>
                                <span>사진 추가</span>
                            </label>
                            <input type="file" name="selectFile" id="fileUpload" accept="image/*" class="file-input" onchange="previewImage(this)">
                            
                            <div id="imagePreview" class="image-preview" style="display:none;">
                                <img src="" alt="미리보기">
                                <button type="button" class="remove-img-btn" onclick="removeImage()">×</button>
                            </div>
                        </div>
                        <p class="rw-guide-sub">상품과 무관한 사진은 삭제될 수 있습니다.</p>
                    </div>

                    <div class="rw-divider"></div>

                    <div class="rw-agree-box">
                        <label class="checkbox-label">
                            <input type="checkbox" required>
                            <span class="checkmark"></span>
                            <span class="agree-text">작성된 후기는 홍보 콘텐츠로 사용될 수 있습니다. (필수)</span>
                        </label>
                    </div>

                </div>
                
                <div class="modal-footer">
                    <button type="submit" class="btn-submit full-width">등록하기</button>
                </div>
            </form>
        </div>
    </div>

   <script src="${pageContext.request.contextPath}/dist/js/myreview.js"></script>
</body>
</html>