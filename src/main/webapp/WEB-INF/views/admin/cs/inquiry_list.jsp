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

        /* 상태 배지 */
        .status-badge {
            font-size: 11px;
            padding: 3px 8px;
            border-radius: 12px;
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
                                <form name="searchForm" action="${pageContext.request.contextPath}/admin/cs/inquiry_list" method="get">
	                                <div class="d-flex gap-2 mb-2">
	                                    <select class="form-select form-select-sm" name="status" onchange="searchList()">
	                                        <option value="all" ${status == 'all' ? 'selected' : ''}>전체 상태</option>
	                                        <option value="wait" ${status == 'wait' ? 'selected' : ''}>답변 대기</option>
	                                        <option value="done" ${status == 'done' ? 'selected' : ''}>답변 완료</option>
	                                    </select>
	                                </div>
	                                <div class="input-group input-group-sm">
	                                    <input type="text" class="form-control" name="keyword" value="${keyword}" placeholder="작성자, 제목 검색">
	                                    <button type="button" class="btn btn-outline-secondary" onclick="searchList()">🔍</button>
	                                </div>
                                </form>
                            </div>

                            <div class="inquiry-list-wrapper">
                            	<c:forEach var="dto" items="${list}">
	                                <div class="inquiry-item" onclick="openChat('${dto.num}')">
	                                    <div class="inquiry-info">
	                                        <span>${dto.userName} (${dto.userId})</span>
	                                        <span>${dto.reg_date}</span>
	                                    </div>
	                                    <div class="d-flex justify-content-between align-items-center">
	                                        <div class="inquiry-subject">${dto.subject}</div>
	                                        <c:choose>
	                                        	<c:when test="${not empty dto.replyContent}">
	                                        		<span class="badge status-badge status-done">답변완료</span>
	                                        	</c:when>
	                                        	<c:otherwise>
	                                        		<span class="badge status-badge status-wait">답변대기</span>
	                                        	</c:otherwise>
	                                        </c:choose>
	                                    </div>
	                                    <div class="inquiry-preview">${dto.content}</div>
	                                </div>
                                </c:forEach>
                                
                                <c:if test="${empty list}">
                                	<div class="d-flex justify-content-center align-items-center p-5 text-muted">
                                		등록된 문의가 없습니다.
                                	</div>
                                </c:if>
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
                                        <h5 class="fw-bold m-0" id="chatTitle">제목</h5>
                                        <small class="text-muted" id="chatUser">작성자 정보</small>
                                    </div>
                                    </div>

                                <div class="chat-body" id="chatBody">
                                    </div>

                                <div class="chat-footer">
                                    <div class="input-group">
                                        <textarea class="form-control" id="replyContent" rows="2" placeholder="답변 내용을 입력하세요..." style="resize: none;"></textarea>
                                        <button class="btn btn-primary" type="button" onclick="sendReply()">전송</button>
                                    </div>
                                    <div class="form-check mt-2">
                                        <input class="form-check-input" type="checkbox" id="smsSend">
                                        <label class="form-check-label small text-muted" for="smsSend">
                                            답변 등록 시 SMS/알림톡 발송 (준비중)
                                        </label>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />

    <script>
    	// 검색 기능
    	function searchList() {
    		const f = document.searchForm;
    		f.submit();
    	}
    
        // 현재 선택된 문의 번호 저장
        let currentInquiryNum = 0;

        // 1. 목록 클릭 시 상세 내용 불러오기 (AJAX)
        function openChat(num) {
        	currentInquiryNum = num;
        	
            // 활성화 스타일 표시
            document.querySelectorAll('.inquiry-item').forEach(el => el.classList.remove('active'));
            event.currentTarget.classList.add('active');

            // 우측 화면 전환
            document.getElementById('emptyState').classList.add('d-none');
            const chatView = document.getElementById('chatView');
            chatView.classList.remove('d-none');
            
            // 기존 내용 초기화
            const chatBody = document.getElementById('chatBody');
            chatBody.innerHTML = "";
            
            // 답변 입력창 초기화
            const replyArea = document.getElementById('replyContent');
            replyArea.value = "";
            replyArea.disabled = false;
            replyArea.placeholder = "답변 내용을 입력하세요...";
            
            // AJAX 요청
            const url = "${pageContext.request.contextPath}/admin/cs/inquiry_detail";
            const query = "num=" + num;
            
            $.ajax({
            	type: "GET",
            	url: url,
            	data: query,
            	dataType: "json",
            	success: function(data) {
            		if(data.status === "success") {
            			// 헤더 세팅
            			document.getElementById('chatTitle').innerText = data.subject;
            			document.getElementById('chatUser').innerText = data.userName + " 님의 문의 (" + data.reg_date + ")";
            			
            			// 1) 사용자 질문 표시
            			let userHtml = '';
            			userHtml += '<div class="message-row user">';
            			userHtml += '  <div class="message-bubble">' + data.content.replace(/\n/g, "<br>") + '</div>';
            			userHtml += '  <span class="message-time">질문</span>';
            			userHtml += '</div>';
            			chatBody.insertAdjacentHTML('beforeend', userHtml);
            			
            			// 2) 답변이 있다면 표시
            			if(data.replyContent) {
            				let adminHtml = '';
            				adminHtml += '<div class="message-row admin">';
            				adminHtml += '  <span class="message-time">' + (data.replyDate ? data.replyDate : '') + '</span>';
            				adminHtml += '  <div class="message-bubble">' + data.replyContent.replace(/\n/g, "<br>") + '</div>';
            				adminHtml += '</div>';
            				chatBody.insertAdjacentHTML('beforeend', adminHtml);
            				
            				// 답변 완료 상태 처리
            				replyArea.value = "";
            				replyArea.placeholder = "이미 답변이 완료된 문의입니다.";
            				replyArea.disabled = true;
            			}
            			
            			// 스크롤 최하단 이동
            			chatBody.scrollTop = chatBody.scrollHeight;
            			
            		} else {
            			alert("해당 문의 내용을 불러올 수 없습니다.");
            		}
            	},
            	error: function(e) {
            		console.log(e.responseText);
            	}
            });
        }
        
        // 2. 답변 전송 (AJAX)
        function sendReply() {
        	const content = document.getElementById('replyContent').value.trim();
        	
        	if(!currentInquiryNum) {
        		alert("문의를 선택해주세요.");
        		return;
        	}
        	if(!content) {
        		alert("답변 내용을 입력해주세요.");
        		return;
        	}
        	
        	if(!confirm("답변을 등록하시겠습니까?")) return;
        	
        	const url = "${pageContext.request.contextPath}/admin/cs/inquiry_reply";
        	const query = "num=" + currentInquiryNum + "&replyContent=" + encodeURIComponent(content);
        	
        	$.ajax({
        		type: "POST",
        		url: url,
        		data: query,
        		dataType: "json",
        		success: function(data) {
        			if(data.status === "success") {
        				alert("답변이 등록되었습니다.");
        				// 목록 갱신을 위해 새로고침 (가장 깔끔한 방법)
        				location.reload();
        			} else {
        				alert("답변 등록에 실패했습니다.");
        			}
        		},
        		error: function(e) {
        			console.log(e.responseText);
        			alert("서버 통신 오류가 발생했습니다.");
        		}
        	});
        }
    </script>

</body>
</html>