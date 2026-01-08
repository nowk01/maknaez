<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 Q&A 관리 - MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    
    <style>
        /* [공통 레이아웃] Split View 적용 */
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

        /* [좌측] Q&A 목록 스타일 */
        .qna-list-header {
            padding: 15px;
            border-bottom: 1px solid #eee;
            background: #fff;
        }
        
        .qna-list-wrapper {
            overflow-y: auto;
            flex-grow: 1;
            background: #f8f9fa;
        }

        .qna-item {
            padding: 15px;
            border-bottom: 1px solid #e9ecef;
            background: #fff;
            cursor: pointer;
            transition: background 0.2s;
            position: relative;
        }
        .qna-item:hover { background-color: #f1f3f5; }
        .qna-item.active {
            background-color: #e7f5ff;
            border-left: 4px solid #0d6efd;
        }

        /* 상품명 표시 스타일 */
        .qna-product { 
            font-size: 12px; 
            color: #6c757d; 
            margin-bottom: 4px; 
            display: block; 
            overflow: hidden; 
            text-overflow: ellipsis; 
            white-space: nowrap; 
        }
        .qna-product i { color: #adb5bd; margin-right: 4px; }
        
        .qna-subject { 
            font-weight: 600; 
            font-size: 14px; 
            margin-bottom: 6px; 
            color: #333; 
            display: flex; 
            align-items: center; 
            gap: 5px; 
        }
        .fa-lock { color: #adb5bd; font-size: 12px; } /* 비밀글 아이콘 */
        
        .qna-meta { display: flex; justify-content: space-between; font-size: 12px; color: #888; }

        /* 상태 배지 (클릭 가능) */
        .status-badge {
            font-size: 11px;
            padding: 3px 8px;
            border-radius: 12px;
            cursor: pointer;
        }
        .status-wait { background-color: #fff3bf; color: #f08c00; } /* 답변대기 */
        .status-done { background-color: #e6fcf5; color: #0ca678; } /* 답변완료 */

        /* [우측] 상세 보기 스타일 */
        .detail-header {
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            background: #fff;
        }
        .detail-product-info {
            background: #f8f9fa;
            padding: 10px 15px;
            border-radius: 5px;
            margin-top: 10px;
            font-size: 13px;
            display: flex;
            align-items: center;
        }
        .product-thumb { width: 40px; height: 40px; background: #ddd; border-radius: 4px; margin-right: 10px; object-fit: cover; }

        .chat-body {
            flex-grow: 1;
            padding: 20px;
            overflow-y: auto;
            background-color: #f0f2f5;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        /* 말풍선 스타일 */
        .message-row { display: flex; margin-bottom: 10px; }
        .message-row.user { justify-content: flex-start; } 
        .message-row.admin { justify-content: flex-end; }  

        .message-bubble {
            max-width: 75%;
            padding: 12px 16px;
            border-radius: 15px;
            position: relative;
            font-size: 14px;
            line-height: 1.5;
            box-shadow: 0 1px 2px rgba(0,0,0,0.1);
        }
        
        .user .message-bubble { background-color: #fff; border-top-left-radius: 2px; color: #333; }
        .admin .message-bubble { background-color: #0d6efd; border-top-right-radius: 2px; color: #fff; }
        .message-time { font-size: 11px; color: #adb5bd; margin: 0 5px; align-self: flex-end; }

        .chat-footer { padding: 15px; background: #fff; border-top: 1px solid #eee; }
        
        .empty-state {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100%;
            color: #adb5bd;
        }
        .empty-state i { font-size: 3rem; margin-bottom: 15px; }

        /* 스크롤바 커스텀 */
        .qna-list-wrapper::-webkit-scrollbar, .chat-body::-webkit-scrollbar { width: 6px; }
        .qna-list-wrapper::-webkit-scrollbar-thumb, .chat-body::-webkit-scrollbar-thumb { background-color: #ced4da; border-radius: 3px; }
    </style>
</head>
<body>

    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container pt-3">
                <h3 class="fw-bold mb-3 px-2">상품 Q&A 관리</h3>

                <div class="row g-0 h-100">
                    
                    <div class="col-lg-4 h-100 border-end">
                        <div class="card-box">
                            <div class="qna-list-header">
                                <div class="d-flex gap-2 mb-2">
                                    <select class="form-select form-select-sm">
                                        <option value="all">전체 상품</option>
                                        <option value="outer">Outer</option>
                                        <option value="top">Top</option>
                                    </select>
                                    <select class="form-select form-select-sm">
                                        <option value="wait">답변 대기</option>
                                        <option value="done">답변 완료</option>
                                    </select>
                                </div>
                                <div class="input-group input-group-sm">
                                    <input type="text" class="form-control" placeholder="상품명, 내용 검색">
                                    <button class="btn btn-outline-secondary">🔍</button>
                                </div>
                            </div>

                            <div class="qna-list-wrapper">
                                <div class="qna-item" onclick="openDetail(1, '베이직 울 코트', '사이즈 문의 드립니다.', 'user_01', true)">
                                    <div class="qna-product"><i class="fas fa-tshirt"></i> 베이직 울 코트 (Black/L)</div>
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <div class="qna-subject">
                                            <i class="fas fa-lock"></i> 사이즈 문의 드립니다.
                                        </div>
                                        <span class="badge status-badge status-wait" onclick="toggleStatus(this, event)">답변대기</span>
                                    </div>
                                    <div class="qna-meta">
                                        <span>user_01</span>
                                        <span>2026-01-08</span>
                                    </div>
                                </div>

                                <div class="qna-item" onclick="openDetail(2, '데님 와이드 팬츠', '재입고 일정 문의', 'user_02', false)">
                                    <div class="qna-product"><i class="fas fa-tshirt"></i> 데님 와이드 팬츠 (Blue/M)</div>
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <div class="qna-subject">재입고 일정 문의</div>
                                        <span class="badge status-badge status-done" onclick="toggleStatus(this, event)">답변완료</span>
                                    </div>
                                    <div class="qna-meta">
                                        <span>user_02</span>
                                        <span>2026-01-07</span>
                                    </div>
                                </div>

                                <div class="qna-item" onclick="openDetail(3, '캐시미어 니트', '배송 언제 출발하나요?', 'user_03', true)">
                                    <div class="qna-product"><i class="fas fa-tshirt"></i> 캐시미어 니트 (Beige/Free)</div>
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <div class="qna-subject">
                                            <i class="fas fa-lock"></i> 배송 언제 출발하나요?
                                        </div>
                                        <span class="badge status-badge status-done" onclick="toggleStatus(this, event)">답변완료</span>
                                    </div>
                                    <div class="qna-meta">
                                        <span>user_03</span>
                                        <span>2026-01-06</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-8 h-100 ps-lg-3 pt-3 pt-lg-0">
                        <div class="card-box" id="detailContainer">
                            
                            <div class="empty-state" id="emptyState">
                                <i class="far fa-question-circle"></i>
                                <p>좌측 목록에서 Q&A 항목을 선택해주세요.</p>
                            </div>

                            <div class="d-none d-flex flex-column h-100" id="detailView">
                                <div class="detail-header">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div>
                                            <h5 class="fw-bold m-0" id="detailTitle">제목 영역</h5>
                                            <small class="text-muted" id="detailUser">작성자 정보</small>
                                        </div>
                                        <div>
                                            <button class="btn btn-outline-danger btn-sm">삭제</button>
                                            <button class="btn btn-outline-secondary btn-sm" onclick="location.href='#'">상품보기</button>
                                        </div>
                                    </div>
                                    
                                    <div class="detail-product-info">
                                        <img src="" alt="" class="product-thumb" id="productImg"> <div>
                                            <div class="fw-bold" id="productName">상품명 영역</div>
                                            <div class="text-muted small">옵션: Black / L</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="chat-body">
                                    <div class="message-row user">
                                        <div class="message-bubble">
                                            <div class="fw-bold mb-1 text-primary">Q. 질문</div>
                                            평소 100 사이즈 입는데 L 사이즈 주문하면 잘 맞을까요?<br>
                                            그리고 오늘 주문하면 언제 배송 시작되는지 궁금합니다.
                                        </div>
                                        <span class="message-time">09:30</span>
                                    </div>
                                    
                                    <div class="message-row admin">
                                        <span class="message-time">10:15</span>
                                        <div class="message-bubble">
                                            <div class="fw-bold mb-1 text-warning">A. 답변</div>
                                            안녕하세요 고객님, MAKNAEZ입니다.<br>
                                            해당 상품은 정사이즈로 제작되어 평소 입으시는 100(L) 사이즈를 추천드립니다.<br>
                                            오늘 오후 2시 이전 결제 건은 당일 출고 예정입니다. 감사합니다.
                                        </div>
                                    </div>
                                </div>

                                <div class="chat-footer">
                                    <div class="input-group">
                                        <textarea class="form-control" rows="3" placeholder="답변 내용을 입력하세요..." style="resize: none;"></textarea>
                                        <button class="btn btn-primary" type="button">답변 등록</button>
                                    </div>
                                    <div class="form-check mt-2">
                                        <input class="form-check-input" type="checkbox" id="secretReply" checked>
                                        <label class="form-check-label small text-muted" for="secretReply">
                                            비밀글로 답변 등록 (작성자만 확인 가능)
                                        </label>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                </div> </div> </div> </div> <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />

    <script>
        // 1. 상세 화면 열기
        function openDetail(id, prodName, title, user, isSecret) {
            // 활성화 스타일 적용
            document.querySelectorAll('.qna-item').forEach(el => el.classList.remove('active'));
            event.currentTarget.classList.add('active');

            // 화면 전환
            document.getElementById('emptyState').classList.add('d-none');
            document.getElementById('detailView').classList.remove('d-none');
            
            // 데이터 바인딩 (예시)
            let displayTitle = title;
            if(isSecret) displayTitle = '<i class="fas fa-lock me-2 text-muted"></i>' + title;
            
            document.getElementById('detailTitle').innerHTML = displayTitle;
            document.getElementById('detailUser').innerText = user + " | 2026-01-08";
            document.getElementById('productName').innerText = prodName;
            
            // 실제 구현 시 AJAX로 질문 내용과 기존 답변을 불러와야 함
        }

        // 2. 답변 상태 토글 (대기 <-> 완료)
        function toggleStatus(badge, e) {
            e.stopPropagation(); // 부모 클릭 이벤트 전파 방지
            
            if (badge.classList.contains('status-wait')) {
                // 대기 -> 완료
                badge.classList.remove('status-wait');
                badge.classList.add('status-done');
                badge.innerText = "답변완료";
            } else {
                // 완료 -> 대기
                badge.classList.remove('status-done');
                badge.classList.add('status-wait');
                badge.innerText = "답변대기";
            }
        }
    </script>

</body>
</html>