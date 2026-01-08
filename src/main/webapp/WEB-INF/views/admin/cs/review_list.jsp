<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰 관리 - MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    
    <style>
        /* [공통 레이아웃] Split View */
        body { background-color: #f4f6f9; }
        
        .content-container {
            height: calc(100vh - 100px); /* 화면 꽉 차게 */
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .card-box {
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
            border: none;
            height: 100%;
            display: flex;
            flex-direction: column;
            padding: 0;
            overflow: hidden;
        }

        /* [좌측] 리뷰 목록 스타일 */
        .list-header {
            padding: 15px;
            border-bottom: 1px solid #eee;
            background: #fff;
        }
        
        .list-wrapper {
            overflow-y: auto;
            flex-grow: 1;
            background: #f8f9fa;
        }

        .review-item {
            padding: 15px;
            border-bottom: 1px solid #e9ecef;
            background: #fff;
            cursor: pointer;
            transition: background 0.2s;
            display: flex;
            gap: 12px; /* 이미지와 텍스트 간격 */
        }
        .review-item:hover { background-color: #f1f3f5; }
        .review-item.active {
            background-color: #e7f5ff;
            border-left: 4px solid #0d6efd;
        }

        /* 리스트 내 썸네일 이미지 */
        .review-thumb-list {
            width: 60px;
            height: 60px;
            border-radius: 4px;
            object-fit: cover;
            border: 1px solid #eee;
            flex-shrink: 0;
            background-color: #eee;
        }

        .review-content-wrap {
            flex-grow: 1;
            overflow: hidden;
        }

        .review-product { font-size: 12px; color: #888; margin-bottom: 2px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; }
        .review-text { font-size: 13px; color: #333; margin-bottom: 4px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; height: 38px; line-height: 1.4; }
        
        /* 별점 스타일 (노란색) */
        .star-rating { color: #fcc419; font-size: 12px; letter-spacing: -1px; }
        .star-rating i { margin-right: 1px; }

        .review-meta { display: flex; justify-content: space-between; align-items: center; font-size: 11px; color: #adb5bd; margin-top: 4px; }

        /* [우측] 상세 보기 스타일 */
        .detail-header {
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            background: #fff;
        }
        
        .detail-body {
            flex-grow: 1;
            padding: 20px;
            overflow-y: auto;
            background-color: #fff; /* 리뷰 상세는 흰 배경이 깔끔함 */
        }

        /* 상세 화면 내 상품 정보 박스 */
        .product-info-box {
            display: flex;
            align-items: center;
            background-color: #f8f9fa;
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 20px;
        }
        .product-thumb-detail { width: 40px; height: 40px; border-radius: 4px; object-fit: cover; margin-right: 10px; border: 1px solid #ddd; }
        
        /* 리뷰 본문 스타일 */
        .review-full-text {
            font-size: 14px;
            line-height: 1.6;
            color: #333;
            margin-bottom: 20px;
            white-space: pre-wrap;
        }
        
        /* 상세 화면 큰 이미지 */
        .review-img-detail {
            max-width: 100%;
            max-height: 400px;
            border-radius: 8px;
            border: 1px solid #eee;
            margin-bottom: 20px;
            display: block;
        }

        /* 관리자 답글 영역 */
        .admin-reply-section {
            background-color: #f1f3f5;
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
        }
        .reply-label { font-size: 13px; font-weight: bold; color: #495057; margin-bottom: 8px; display: flex; justify-content: space-between; }
        
        .empty-state {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100%;
            color: #adb5bd;
        }
        .empty-state i { font-size: 3rem; margin-bottom: 15px; }

        /* 상태 배지 */
        .badge-reply-wait { background: #fff3bf; color: #f08c00; padding: 2px 6px; border-radius: 4px; font-size: 10px; }
        .badge-reply-done { background: #e6fcf5; color: #0ca678; padding: 2px 6px; border-radius: 4px; font-size: 10px; }

        /* 스크롤바 커스텀 */
        .list-wrapper::-webkit-scrollbar, .detail-body::-webkit-scrollbar { width: 6px; }
        .list-wrapper::-webkit-scrollbar-thumb, .detail-body::-webkit-scrollbar-thumb { background-color: #ced4da; border-radius: 3px; }
    </style>
</head>
<body>

    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container pt-3">
                <h3 class="fw-bold mb-3 px-2">리뷰 관리</h3>

                <div class="row g-0 h-100">
                    
                    <div class="col-lg-4 h-100 border-end">
                        <div class="card-box">
                            <div class="list-header">
                                <div class="d-flex gap-2 mb-2">
                                    <select class="form-select form-select-sm">
                                        <option value="all">전체 별점</option>
                                        <option value="5">⭐⭐⭐⭐⭐ (5점)</option>
                                        <option value="1">⭐ (1점)</option>
                                    </select>
                                    <select class="form-select form-select-sm">
                                        <option value="all">전체 상태</option>
                                        <option value="wait">미답변</option>
                                        <option value="done">답변완료</option>
                                    </select>
                                </div>
                                <div class="input-group input-group-sm">
                                    <input type="text" class="form-control" placeholder="상품명, 리뷰 내용 검색">
                                    <button class="btn btn-outline-secondary">🔍</button>
                                </div>
                            </div>

                            <div class="list-wrapper">
                                <div class="review-item" onclick="openDetail(1)">
                                    <img src="https://via.placeholder.com/60" class="review-thumb-list" alt="review_img">
                                    
                                    <div class="review-content-wrap">
                                        <div class="review-product">베이직 울 코트</div>
                                        <div class="star-rating">
                                            <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i>
                                            <span class="text-dark fw-bold ms-1">5.0</span>
                                        </div>
                                        <div class="review-text">색감이 화면이랑 똑같고 너무 예뻐요! 배송도 빨라서 좋았습니다. 추천해요~</div>
                                        <div class="review-meta">
                                            <span>user_01 | 2026-01-08</span>
                                            <span class="badge-reply-wait">미답변</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="review-item" onclick="openDetail(2)">
                                    <img src="https://via.placeholder.com/60/000000/FFFFFF/?text=Pants" class="review-thumb-list" alt="review_img">
                                    <div class="review-content-wrap">
                                        <div class="review-product">와이드 데님 팬츠</div>
                                        <div class="star-rating">
                                            <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star text-secondary opacity-25"></i><i class="fas fa-star text-secondary opacity-25"></i>
                                            <span class="text-dark fw-bold ms-1">3.0</span>
                                        </div>
                                        <div class="review-text">생각보다 기장이 좀 기네요. 수선해서 입어야 할 것 같습니다. 재질은 좋아요.</div>
                                        <div class="review-meta">
                                            <span>user_02 | 2026-01-07</span>
                                            <span class="badge-reply-done">답변완료</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="review-item" onclick="openDetail(3)">
                                    <img src="https://via.placeholder.com/60/FF0000/FFFFFF/?text=Knit" class="review-thumb-list" alt="review_img">
                                    <div class="review-content-wrap">
                                        <div class="review-product">캐시미어 니트</div>
                                        <div class="star-rating">
                                            <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i>
                                            <span class="text-dark fw-bold ms-1">4.5</span>
                                        </div>
                                        <div class="review-text">부드럽고 따뜻해요. 보풀만 안 일어나면 완벽할 듯! 잘 입을게요.</div>
                                        <div class="review-meta">
                                            <span>user_03 | 2026-01-05</span>
                                            <span class="badge-reply-wait">미답변</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-8 h-100 ps-lg-3 pt-3 pt-lg-0">
                        <div class="card-box" id="detailContainer">
                            
                            <div class="empty-state" id="emptyState">
                                <i class="fas fa-star-half-alt"></i>
                                <p>좌측 목록에서 리뷰를 선택해주세요.</p>
                            </div>

                            <div class="d-none d-flex flex-column h-100" id="detailView">
                                <div class="detail-header d-flex justify-content-between align-items-center">
                                    <div>
                                        <span class="badge bg-dark mb-1">PHOTO REVIEW</span>
                                        <h5 class="fw-bold m-0">리뷰 상세 정보</h5>
                                    </div>
                                    <div>
                                        <div class="form-check form-switch d-inline-block align-middle me-3">
                                            <input class="form-check-input" type="checkbox" id="reviewVisible" checked>
                                            <label class="form-check-label small" for="reviewVisible">게시글 공개</label>
                                        </div>
                                        <button class="btn btn-outline-danger btn-sm">삭제</button>
                                    </div>
                                </div>

                                <div class="detail-body">
                                    <div class="product-info-box">
                                        <img src="https://via.placeholder.com/40" class="product-thumb-detail" id="prodImg">
                                        <div>
                                            <div class="fw-bold text-dark" id="prodName">상품명 로딩중...</div>
                                            <div class="small text-muted">옵션: Black / L</div>
                                        </div>
                                        <div class="ms-auto text-end">
                                            <div class="small text-muted">작성자: <span id="writerId">user_01</span></div>
                                            <div class="small text-muted">작성일: 2026-01-08</div>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <div class="star-rating fs-5 mb-2" id="detailStars">
                                            <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i>
                                            <span class="text-dark fw-bold ms-2">5.0</span>
                                        </div>
                                        <div class="review-full-text" id="reviewContent">
                                            리뷰 내용이 여기에 표시됩니다.
                                        </div>
                                    </div>

                                    <div>
                                        <h6 class="fw-bold text-secondary small mb-2"><i class="fas fa-camera"></i> 첨부 사진</h6>
                                        <img src="" class="review-img-detail" id="reviewDetailImg" alt="첨부 이미지">
                                    </div>

                                    <div class="admin-reply-section">
                                        <div class="reply-label">
                                            <span><i class="fas fa-reply"></i> 관리자 답글</span>
                                        </div>
                                        <textarea class="form-control mb-2" rows="3" placeholder="고객님의 리뷰에 감사의 댓글을 남겨주세요..."></textarea>
                                        <div class="d-flex justify-content-end">
                                            <button class="btn btn-primary btn-sm px-4">답글 등록</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div> </div> </div> </div> <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />

    <script>
        // 리뷰 상세 보기 (더미 데이터 바인딩 예시)
        function openDetail(id) {
            // 활성화 스타일
            document.querySelectorAll('.review-item').forEach(el => el.classList.remove('active'));
            event.currentTarget.classList.add('active');

            // 화면 전환
            document.getElementById('emptyState').classList.add('d-none');
            document.getElementById('detailView').classList.remove('d-none');

            // 예시 데이터 설정 (실제론 AJAX 사용)
            if(id === 1) {
                document.getElementById('prodName').innerText = "베이직 울 코트";
                document.getElementById('reviewContent').innerText = "색감이 화면이랑 똑같고 너무 예뻐요! 배송도 빨라서 좋았습니다.\n\n재질도 부드럽고 핏이 딱 떨어져서 출근룩으로 최고입니다. 다른 색상도 구매하고 싶네요. 추천해요~";
                document.getElementById('reviewDetailImg').src = "https://via.placeholder.com/600x400"; // 큰 이미지
                document.getElementById('detailStars').innerHTML = '<i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i> <span class="text-dark fw-bold ms-2">5.0</span>';
            } else if (id === 2) {
                document.getElementById('prodName').innerText = "와이드 데님 팬츠";
                document.getElementById('reviewContent').innerText = "생각보다 기장이 좀 기네요. 키 160인데 수선해서 입어야 할 것 같습니다.\n\n그래도 허리 밴딩이라 편하고 색감은 예쁜 중청이라 맘에 듭니다.";
                document.getElementById('reviewDetailImg').src = "https://via.placeholder.com/600x400/000000/FFFFFF/?text=Denim+Photo";
                document.getElementById('detailStars').innerHTML = '<i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star text-secondary opacity-25"></i><i class="fas fa-star text-secondary opacity-25"></i> <span class="text-dark fw-bold ms-2">3.0</span>';
            } else {
                // ...
            }
        }
    </script>

</body>
</html>