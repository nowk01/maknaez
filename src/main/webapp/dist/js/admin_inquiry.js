/**
 * MAKNAEZ Admin Inquiry Logic - Professional Wide UI
 * 최종 수정: 연동 경로 및 예외 처리 보강
 */
let currentInquiryNum = 0;

// Context Path를 안전하게 취득하는 함수
function getContextPath() {
    const hostIndex = location.href.indexOf(location.host) + location.host.length;
    const contextPath = location.href.substring(hostIndex, location.href.indexOf('/', hostIndex + 1));
    return contextPath === '/admin' || contextPath === '/cs' ? '' : contextPath;
}

function searchList() {
    document.searchForm.submit();
}

/**
 * 1:1 문의 채팅창 오픈 및 데이터 연동
 */
function openChat(num, element) {
    currentInquiryNum = num;
    const cp = getContextPath();
    
    // 1. 리스트 활성화 디자인 처리
    const items = document.querySelectorAll('.inquiry-item');
    items.forEach(el => el.classList.remove('active'));
    if(element) {
        element.classList.add('active');
    }

    // 2. 초기 화면(Empty State) 제어
    const emptyState = document.getElementById('emptyState');
    if(emptyState) emptyState.style.display = 'none';
    
    const chatView = document.getElementById('chatView');
    if(chatView) {
        chatView.classList.remove('d-none');
        chatView.style.display = 'flex'; // d-flex 강제 적용
    }
    
    // 3. 채팅창 초기화
    const chatBody = document.getElementById('chatBody');
    const replyArea = document.getElementById('replyContent');
    chatBody.innerHTML = '<div class="text-center py-5"><div class="spinner-border text-primary"></div></div>'; 
    replyArea.value = "";
    replyArea.disabled = false;
    replyArea.placeholder = "답변 내용을 입력하세요...";
    
    // 4. AJAX 요청: 상세 내용 불러오기
    $.ajax({
        type: "GET",
        url: cp + "/admin/cs/inquiry_detail",
        data: { num: num },
        dataType: "json",
        success: function(data) {
            chatBody.innerHTML = ""; // 로딩 바 제거
            
            if(data.status === "success") {
                document.getElementById('chatTitle').innerText = data.subject;
                document.getElementById('chatUser').innerText = data.userName + " (" + data.reg_date + ")";
                
                // [고객 질문 출력]
                let userHtml = `
                    <div class="message-row user">
                        <div class="message-bubble">${data.content.replace(/\n/g, "<br>")}</div>
                        <span class="message-time">${data.reg_date}</span>
                    </div>`;
                chatBody.insertAdjacentHTML('beforeend', userHtml);
                
                // [관리자 답변 출력]
                if(data.replyContent && data.replyContent.trim() !== "") {
                    let adminHtml = `
                        <div class="message-row admin">
                            <span class="message-time">${data.replyDate || ''}</span>
                            <div class="message-bubble">${data.replyContent.replace(/\n/g, "<br>")}</div>
                        </div>`;
                    chatBody.insertAdjacentHTML('beforeend', adminHtml);
                    
                    // 이미 답변이 있으면 수정 모드 알림 또는 입력창 유지
                    replyArea.placeholder = "이전 답변이 존재합니다. 수정 시 내용을 입력하세요.";
                }
                
                // 스크롤 최하단 이동
                setTimeout(() => {
                    chatBody.scrollTop = chatBody.scrollHeight;
                }, 100);
                
            } else if(data.status === "permission_denied") {
                alert("관리자 권한이 만료되었습니다. 다시 로그인해주세요.");
                location.href = cp + "/member/login";
            }
        },
        error: function() {
            alert("상세 데이터를 불러오지 못했습니다. 경로를 확인하세요.");
        }
    });
}

/**
 * 답변 등록 프로세스
 */
function sendReply() {
    const replyContent = document.getElementById('replyContent').value.trim();
    const cp = getContextPath();
    
    if(!currentInquiryNum) {
        alert("선택된 문의가 없습니다.");
        return;
    }
    
    if(!replyContent) {
        alert("답변 내용을 입력해주세요.");
        return;
    }
    
    if(!confirm("답변을 등록(수정)하시겠습니까?")) return;
    
    $.ajax({
        type: "POST",
        url: cp + "/admin/cs/inquiry_reply",
        data: { num: currentInquiryNum, replyContent: replyContent },
        dataType: "json",
        success: function(data) {
            if(data.status === "success") {
                alert("답변이 정상적으로 처리되었습니다.");
                // 화면 갱신 없이 실시간성 부여를 위해 reload 사용
                location.reload();
            } else {
                alert("답변 등록 실패: " + data.status);
            }
        },
        error: function() {
            alert("통신 오류가 발생했습니다.");
        }
    });
}