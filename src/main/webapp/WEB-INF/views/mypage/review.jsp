<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

<style>
    /* 모달 배경 */
    .modal-overlay {
        display: none; /* 기본적으로 숨김 */
        position: fixed;
        top: 0; left: 0;
        width: 100%; height: 100%;
        background: rgba(0, 0, 0, 0.5);
        z-index: 9999;
        justify-content: center;
        align-items: center;
    }

    /* 모달 본문 */
    .modal-content {
        background: #fff;
        width: 500px;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        position: relative;
    }

    .modal-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        border-bottom: 1px solid #eee;
        padding-bottom: 15px;
    }

    .modal-header h3 { margin: 0; font-size: 20px; font-weight: 700; }
    .close-btn { background: none; border: none; font-size: 28px; cursor: pointer; line-height: 1; }

    /* 모달 내부 상품 정보 */
    .modal-product-info {
        display: flex;
        gap: 15px;
        background: #f8f9fa;
        padding: 15px;
        border-radius: 8px;
        margin-bottom: 20px;
        align-items: center;
    }
    .modal-product-info img {
        width: 60px; height: 60px; object-fit: cover; border-radius: 4px; border: 1px solid #ddd;
    }
    .modal-prod-name { font-weight: 600; font-size: 15px; color: #333; }

    /* 폼 요소 스타일 */
    .form-group { margin-bottom: 20px; }
    .form-group label { display: block; margin-bottom: 8px; font-weight: 600; font-size: 14px; }
    
    .form-select {
        width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px;
    }
    
    .form-textarea {
        width: 100%; height: 150px; padding: 12px; border: 1px solid #ddd; border-radius: 4px; resize: none; font-size: 14px; line-height: 1.5;
    }
    
    .form-file { width: 100%; font-size: 14px; }
    
    .point-guide { color: #ff4e00; font-size: 13px; margin-top: 5px; }

    /* 버튼 영역 */
    .modal-footer {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
        margin-top: 30px;
        border-top: 1px solid #eee;
        padding-top: 20px;
    }
    
    .btn-submit {
        background: #000; color: #fff; border: none; padding: 12px 25px; border-radius: 4px; cursor: pointer; font-weight: 600;
    }
    .btn-cancel {
        background: #fff; color: #333; border: 1px solid #ddd; padding: 12px 25px; border-radius: 4px; cursor: pointer;
    }
    .btn-submit:hover { background: #333; }
    .btn-cancel:hover { background: #f9f9f9; }
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
                    <li><a href="${pageContext.request.contextPath}/member/mypage/orderList">주문/배송조회</a></li>
                    <li><a href="${pageContext.request.contextPath}/member/mypage/cancelList">취소상품조회</a></li>
                </ul>
            </div>

            <div class="menu-group">
                <span class="menu-title">혜택내역</span>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/member/mypage/review" class="active">상품 리뷰</a></li>
                    <li><a href="#">포인트/쿠폰</a></li>
                </ul>
            </div>

            <div class="menu-group">
                <span class="menu-title">상품내역</span>
                <ul>
                    <li><a href="#">최근 본 상품</a></li>
                    <li><a href="${pageContext.request.contextPath}/member/mypage/wishList">관심 상품</a></li>
                </ul>
            </div>

            <div class="menu-group">
                <span class="menu-title">회원정보</span>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/member/mypage/myInfo">내 정보 관리</a></li>
                    <li><a href="${pageContext.request.contextPath}/member/mypage/addr">배송지 관리</a></li>
                    <li><a href="${pageContext.request.contextPath}/member/mypage/level_benefit">회원등급</a></li>
                </ul>
            </div>
            
            <div class="menu-group">
                 <ul>
                    <li><a href="${pageContext.request.contextPath}/member/logout" style="color:#999;">로그아웃</a></li>
                 </ul>
            </div>
        </aside>

        <main class="main-content">
            <h1 class="page-title">상품 리뷰</h1>

            <div class="review-tabs">
                <button type="button" class="tab-btn active"
                    onclick="showTab('writable')">작성 가능한 리뷰 (${not empty dataCount ? dataCount : 0})</button>
                <button type="button" class="tab-btn" onclick="showTab('written')">작성한
                    리뷰 (0)</button>
            </div>

            <div id="tab-writable" class="review-tab-content active">

                <div class="PendingReviews__header">
                    <div class="PendingReviews__order_dropdown">
                        <div style="height: 100%;">
                            <button type="button"
                                class="AppButton__button AppButton__button--style-plain"
                                onclick="toggleSortMenu(this)">
                                <div class="AppDropdown__label" style="--label-font-size: 14px;">
                                    과거 구매순</div>
                                <svg xmlns="http://www.w3.org/2000/svg"
                                    class="AppSvgIcon AppDropdown__icon"
                                    style="width: 9px; height: 8px;" viewBox="0 0 12 12">
                                    <path d="M2 4l4 4 4-4" fill="none" stroke="currentColor"
                                        stroke-width="1.5" stroke-linecap="round"
                                        stroke-linejoin="round" />
                                </svg>
                            </button>
                        </div>

                        <div class="sm-salomon__dropdown-menu">
                            <div class="sm-salomon__dropdown-item"
                                onclick="selectSort(this, '과거 구매순', 'oldest')">과거 구매순</div>
                            <div class="sm-salomon__dropdown-item"
                                onclick="selectSort(this, '최근 구매순', 'newest')">최근 구매순</div>
                            <div class="sm-salomon__dropdown-item"
                                onclick="selectSort(this, '작성기한 임박순', 'deadline')">작성기한
                                임박순</div>
                        </div>
                    </div>

                    <div class="PendingReviews__max-mileage-divider"></div>
                </div>

                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach var="dto" items="${list}">
                            <div class="review-target-card">
                                <div class="review-target-header">
                                    <div class="date-status">
                                        <strong>${dto.orderDate}</strong> <span style="color: #000;">배송완료</span>
                                    </div>
                                    <div class="order-no">No. ${dto.orderNum}</div>
                                </div>

                                <div class="review-target-body">
                                    <div class="review-prod-img">
                                        <img
                                            src="${pageContext.request.contextPath}/uploads/product/${dto.thumbNail}"
                                            onerror="this.src='${pageContext.request.contextPath}/dist/images/no-image.png'"
                                            alt="상품이미지">
                                    </div>
                                    <div class="review-prod-info">
                                        <div class="review-prod-name">${dto.productName}</div>
                                        <div class="review-prod-opt">[옵션] ${not empty dto.colorName ? dto.colorName : '-'}
                                            / ${not empty dto.sizeName ? dto.sizeName : '-'}</div>
                                        <div class="review-price">
                                            <fmt:formatNumber value="${dto.totalAmount}" pattern="#,###" />
                                            원
                                        </div>
                                    </div>
                                </div>

                                <div class="review-action-bar">
                                    <div class="action-label">선택 &gt;</div>
                                    <div class="action-btn-group">
                                        <a href="${pageContext.request.contextPath}/product/detail?productNum=${dto.productNum}"
                                            class="action-btn"> 상품상세 </a>
                                            
                                        <a href="#"
                                           onclick="openReviewModal('${dto.orderNum}', '${dto.productNum}', '${dto.productName}', '${dto.thumbNail}'); return false;"
                                           class="action-btn write-btn"> 리뷰쓰기 </a>
                                           
                                        <a href="#" class="action-btn"> 스타일올리기 </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="no-data-msg" style="padding: 60px 0;">작성 가능한 리뷰가
                            없습니다.</div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div id="tab-written" class="review-tab-content">
                <div class="PendingReviews__header">
                     <div class="PendingReviews__order_dropdown">
                        <button type="button"
                            class="AppButton__button AppButton__button--style-plain"
                            onclick="toggleSortMenu(this)">
                            <div class="AppDropdown__label">최신순</div>
                            <svg xmlns="http://www.w3.org/2000/svg"
                                class="AppSvgIcon AppDropdown__icon"
                                style="width: 9px; height: 8px;" viewBox="0 0 12 12">
                                <path d="M2 4l4 4 4-4" fill="none" stroke="currentColor"
                                    stroke-width="1.5" stroke-linecap="round"
                                    stroke-linejoin="round" />
                            </svg>
                        </button>

                        <div class="sm-salomon__dropdown-menu">
                            <div class="sm-salomon__dropdown-item"
                                onclick="selectSort(this, '최신순')">최신순</div>
                            <div class="sm-salomon__dropdown-item"
                                onclick="selectSort(this, '평점 높은순')">평점 높은순</div>
                            <div class="sm-salomon__dropdown-item"
                                onclick="selectSort(this, '평점 낮은순')">평점 낮은순</div>
                        </div>
                    </div>
                </div>
                <div class="no-data-msg" style="padding: 60px 0;">작성한 리뷰 내역이 없습니다.</div>
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

    <div id="reviewModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h3>리뷰 작성</h3>
                <button type="button" class="close-btn" onclick="closeReviewModal()">×</button>
            </div>
            
            <form name="reviewForm" action="${pageContext.request.contextPath}/member/mypage/review/write" method="post" enctype="multipart/form-data" onsubmit="return validateReviewForm();">
                <input type="hidden" name="orderNum" id="modalOrderNum">
                <input type="hidden" name="productNum" id="modalProductNum">
                
                <div class="modal-body">
                    <div class="modal-product-info">
                        <img id="modalImg" src="" alt="상품이미지">
                        <span id="modalProdName" class="modal-prod-name"></span>
                    </div>
                    
                    <div class="form-group">
                        <label>별점 선택</label>
                        <select name="rating" class="form-select">
                            <option value="5">★★★★★ (아주 좋아요)</option>
                            <option value="4">★★★★☆ (맘에 들어요)</option>
                            <option value="3">★★★☆☆ (보통이에요)</option>
                            <option value="2">★★☆☆☆ (그저 그래요)</option>
                            <option value="1">★☆☆☆☆ (별로예요)</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>리뷰 내용</label>
                        <textarea name="content" class="form-textarea" placeholder="최소 20자 이상 작성해 주세요. 자세한 후기는 다른 고객에게 큰 도움이 됩니다."></textarea>
                    </div>

                    <div class="form-group">
                        <label>사진 첨부 (선택)</label>
                        <input type="file" name="selectFile" accept="image/*" class="form-file">
                        <p class="point-guide">* 포토 리뷰 작성 시 3,000P 추가 지급!</p>
                    </div>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeReviewModal()">취소</button>
                    <button type="submit" class="btn-submit">등록하기</button>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
    <jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />

    <script>
    // 1. 탭 전환 기능
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

    // 2. 드롭다운 메뉴 열기/닫기
    function toggleSortMenu(btn) {
        const dropdown = btn.closest('.PendingReviews__order_dropdown');
        const menu = dropdown.querySelector('.sm-salomon__dropdown-menu');
        
        document.querySelectorAll('.PendingReviews__order_dropdown').forEach(d => {
            if(d !== dropdown) {
                d.classList.remove('open');
                const m = d.querySelector('.sm-salomon__dropdown-menu');
                if(m) m.classList.remove('active');
            }
        });

        menu.classList.toggle('active');
        dropdown.classList.toggle('open'); 
    }

    // 3. 정렬 옵션 로직
    function selectSort(item, sortName, sortCodeParam) {
        const dropdown = item.closest('.PendingReviews__order_dropdown');
        const label = dropdown.querySelector('.AppDropdown__label');
        label.innerText = sortName;
        
        const menu = dropdown.querySelector('.sm-salomon__dropdown-menu');
        menu.classList.remove('active');
        dropdown.classList.remove('open');
        
        let sortCode = sortCodeParam; 

        if (!sortCode) {
            if(sortName === '과거 구매순') sortCode = 'oldest';
            else if(sortName === '최근 구매순' || sortName === '최신순') sortCode = 'newest';
            else if(sortName === '작성기한 임박순') sortCode = 'deadline';
            else if(sortName === '평점 높은순') sortCode = 'rating_high';
            else if(sortName === '평점 낮은순') sortCode = 'rating_low';
        }

        location.href = '${pageContext.request.contextPath}/member/mypage/review?sort=' + sortCode;
    }

    // 4. 외부 클릭 시 드롭다운 닫기
    document.addEventListener('click', function(event) {
        document.querySelectorAll('.PendingReviews__order_dropdown.open').forEach(dropdown => {
            if (!dropdown.contains(event.target)) {
                dropdown.classList.remove('open');
                const menu = dropdown.querySelector('.sm-salomon__dropdown-menu');
                if(menu) menu.classList.remove('active');
            }
        });
    });

    // 5. 리뷰 모달 열기
    function openReviewModal(orderNum, productNum, prodName, thumbNail) {
        document.getElementById('modalOrderNum').value = orderNum;
        document.getElementById('modalProductNum').value = productNum;
        document.getElementById('modalProdName').innerText = prodName;
        
        // 이미지 경로 설정
        var contextPath = "${pageContext.request.contextPath}";
        var imgPath = contextPath + "/uploads/product/" + thumbNail;
        
        // 이미지가 없을 경우 기본 이미지 처리 (옵션)
        if(!thumbNail || thumbNail === 'null') {
            imgPath = contextPath + "/dist/images/no-image.png";
        }
        
        document.getElementById('modalImg').src = imgPath;
        document.getElementById('reviewModal').style.display = 'flex';
    }

    // 6. 리뷰 모달 닫기
    function closeReviewModal() {
        document.getElementById('reviewModal').style.display = 'none';
        document.forms['reviewForm'].reset();
    }

    // 7. 리뷰 폼 유효성 검사
    function validateReviewForm() {
        const form = document.reviewForm;
        if(form.content.value.trim().length < 20) {
            alert("리뷰 내용은 최소 20자 이상 입력하셔야 합니다.");
            form.content.focus();
            return false;
        }
        return true;
    }
    </script>

</body>
</html>