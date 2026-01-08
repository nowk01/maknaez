<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>1:1 문의 관리 - MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    
    <style>
        /* [공통 레이아웃] */
        body { background-color: #f4f6f9; }
        
        .content-container {
            height: calc(100vh - 100px); /* 화면 꽉 차게 */
            overflow: hidden; /* 내부 스크롤 사용 */
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
            padding: 0; /* 패딩 제거 (내부 요소 꽉 차게) */
            overflow: hidden;
        }

        /* [좌측] 문의 목록 스타일 */
        .inquiry-list-header {
            padding: 15px;
            border-bottom: 1px solid #eee;
            background: #fff;
        }
        
        .inquiry-list-wrapper {
            overflow-y: auto;
            flex-grow: 1;
            background: #f8f9fa;
        }

        .inquiry-item {
            padding: 15px;
            border-bottom: 1px solid #e9ecef;
            background: #fff;
            cursor: pointer;
            transition: background 0.2s;
            position: relative;
        }
        .inquiry-item:hover { background-color: #f1f3f5; }
        .inquiry-item.active {
            background-color: #e7f5ff;
            border-left: 4px solid #0d6efd;
        }

        .inquiry-info { display: flex; justify-content: space-between; margin-bottom: 5px; font-size: 12px; color: #888; }
        .inquiry-subject { font-weight: 600; font-size: 14px; margin-bottom: 5px; color: #333; }
        .inquiry-preview { font-size: 13px; color: #666; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

        /* 상태 배지 (클릭 시 변경 가능하게 디자인) */
        .status-badge {
            font-size: 11px;
            padding: 3px 8px;
            border-radius: 12px;
            cursor: pointer;
        }
        .status-wait { background-color: #fff3bf; color: #f08c00; } /* 답변대기 */
        .status-done { background-color: #e6fcf5; color: #0ca678; } /* 답변완료 */

        /* [우측] 대화창(채팅) 스타일 */
        .chat-header {
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #fff;
        }
        
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
        .message-row.user { justify-content: flex-start; } /* 고객 질문 (왼쪽) */
        .message-row.admin { justify-content: flex-end; }  /* 관리자 답변 (오른쪽) */

        .message-bubble {
            max-width: 70%;
            padding: 12px 16px;
            border-radius: 15px;
            position: relative;
            font-size: 14px;
            line-height: 1.5;
            box-shadow: 0 1px 2px rgba(0,0,0,0.1);
        }
        
        /* 고객 메시지 */
        .user .message-bubble {
            background-color: #fff;
            border-top-left-radius: 2px;
            color: #333;
        }
        /* 관리자 메시지 */
        .admin .message-bubble {
            background-color: #0d6efd; /* 파란색 */
            border-top-right-radius: 2px;
            color: #fff;
        }
        
        .message-time { font-size: 11px; color: #adb5bd; margin-top: 5px; margin: 0 5px; align-self: flex-end; }

        /* 입력창 영역 */
        .chat-footer {
            padding: 15px;
            background: #fff;
            border-top: 1px solid #eee;
        }
        
        /* 안내 문구 (초기 화면) */
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
        .inquiry-list-wrapper::-webkit-scrollbar,
        .chat-body::-webkit-scrollbar { width: 6px; }
        .inquiry-list-wrapper::-webkit-scrollbar-thumb,
        .chat-body::-webkit-scrollbar-thumb { background-color: #ced4da; border-radius: 3px; }
    </style>
</head>
<body>

    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container pt-3">
                <h3 class="fw-bold mb-3 px-2">1:1 문의 관리</h3>

                <div class="row g-0 h-100">
                    
                    <div class="col-lg-4 h-100 border-end">
                        <div class="card-box">
                            <div class="inquiry-list-header">
                                <div class="d-flex gap-2 mb-2">
                                    <select class="form-select form-select-sm" id="sortFilter">
                                        <option value="new">최신순</option>
                                        <option value="old">오래된순</option>
                                    </select>
                                    <select class="form-select form-select-sm" id="statusFilter">
                                        <option value="all">전체 상태</option>
                                        <option value="wait">답변 대기</option>
                                        <option value="done">답변 완료</option>
                                    </select>
                                </div>
                                <div class="input-group input-group-sm">
                                    <input type="text" class="form-control" placeholder="작성자, 제목 검색">
                                    <button class="btn btn-outline-secondary">🔍</button>
                                </div>
                            </div>

                            <div class="inquiry-list-wrapper">
                                <div class="inquiry-item" onclick="openChat(1, '사이즈 문의 드립니다.', 'user_01')">
                                    <div class="inquiry-info">
                                        <span>user_01 (홍길동)</span>
                                        <span>2026-01-08</span>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="inquiry-subject">XL 사이즈 재입고 언제 되나요?</div>
                                        <span class="badge status-badge status-wait" onclick="toggleStatus(this, event)">답변대기</span>
                                    </div>
                                    <div class="inquiry-preview">평소 105 입는데 작을까요? 재입고 일정...</div>
                                </div>

                                <div class="inquiry-item" onclick="openChat(2, '배송 지연 관련', 'user_02')">
                                    <div class="inquiry-info">
                                        <span>user_02 (김철수)</span>
                                        <span>2026-01-07</span>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="inquiry-subject">배송이 아직 출발을 안 했어요</div>
                                        <span class="badge status-badge status-done" onclick="toggleStatus(this, event)">답변완료</span>
                                    </div>
                                    <div class="inquiry-preview">주문한지 3일 지났는데 아직 배송준비중...</div>
                                </div>
                                
                                <div class="inquiry-item" onclick="openChat(3, '반품 접수 확인', 'user_03')">
                                    <div class="inquiry-info">
                                        <span>user_03 (이영희)</span>
                                        <span>2026-01-05</span>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="inquiry-subject">반품 수거 언제 해가시나요?</div>
                                        <span class="badge status-badge status-done" onclick="toggleStatus(this, event)">답변완료</span>
                                    </div>
                                    <div class="inquiry-preview">경비실에 맡겨두었다고 메모 남겼는데...</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-8 h-100 ps-lg-3 pt-3 pt-lg-0">
                        <div class="card-box" id="chatContainer">
                            
                            <div class="empty-state" id="emptyState">
                                <i class="far fa-comments"></i>
                                <p>좌측 목록에서 문의 내역을 선택해주세요.</p>
                            </div>

                            <div class="d-none d-flex flex-column h-100" id="chatView">
                                <div class="chat-header">
                                    <div>
                                        <h5 class="fw-bold m-0" id="chatTitle">제목이 들어갑니다</h5>
                                        <small class="text-muted" id="chatUser">작성자 정보</small>
                                    </div>
                                    <button class="btn btn-outline-danger btn-sm">삭제</button>
                                </div>

                                <div class="chat-body" id="chatBody">
                                    <div class="message-row user">
                                        <div class="message-bubble">
                                            안녕하세요, 이 상품 XL 사이즈 언제 재입고 되나요? 알림 신청 했는데 소식이 없어서요.
                                        </div>
                                        <span class="message-time">14:30</span>
                                    </div>
                                    
                                    <div class="message-row admin">
                                        <span class="message-time">14:45</span>
                                        <div class="message-bubble">
                                            안녕하세요 고객님, MAKNAEZ입니다.<br>
                                            해당 상품은 다음 주 수요일(1/14) 입고 예정입니다.<br>
                                            입고 즉시 알림톡 보내드리겠습니다. 감사합니다.
                                        </div>
                                    </div>
                                </div>

                                <div class="chat-footer">
                                    <div class="input-group">
                                        <textarea class="form-control" rows="2" placeholder="답변 내용을 입력하세요..." style="resize: none;"></textarea>
                                        <button class="btn btn-primary" type="button">전송</button>
                                    </div>
                                    <div class="form-check mt-2">
                                        <input class="form-check-input" type="checkbox" id="smsSend">
                                        <label class="form-check-label small text-muted" for="smsSend">
                                            답변 등록 시 SMS/알림톡 발송
                                        </label>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                </div> </div> </div> </div> <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />

    <script>
        // 1. 목록 클릭 시 우측 채팅창 열기
        function openChat(id, title, user) {
            // 활성화 스타일 표시
            document.querySelectorAll('.inquiry-item').forEach(el => el.classList.remove('active'));
            event.currentTarget.classList.add('active');

            // 우측 화면 전환
            document.getElementById('emptyState').classList.add('d-none');
            const chatView = document.getElementById('chatView');
            chatView.classList.remove('d-none');
            
            // 데이터 바인딩 (예시)
            document.getElementById('chatTitle').innerText = title;
            document.getElementById('chatUser').innerText = user + "님의 문의";
            
            // 실제 구현 시 여기서 AJAX로 대화 내용을 불러와 chatBody에 넣어야 함
        }

        // 2. 상태 배지 클릭 시 토글 (대기 <-> 완료)
        function toggleStatus(badge, e) {
            e.stopPropagation(); // 부모 클릭(채팅창 열기) 방지
            
            if (badge.classList.contains('status-wait')) {
                // 대기 -> 완료로 변경
                badge.classList.remove('status-wait');
                badge.classList.add('status-done');
                badge.innerText = "답변완료";
                // alert("상태가 '답변완료'로 변경되었습니다.");
            } else {
                // 완료 -> 대기로 변경
                badge.classList.remove('status-done');
                badge.classList.add('status-wait');
                badge.innerText = "답변대기";
            }
        }
    </script>

</body>
</html>