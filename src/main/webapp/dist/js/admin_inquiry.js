/**
 * MAKNAEZ Admin Inquiry Logic - Professional Wide UI
 */
let currentInquiryNum = 0;

// Context Path를 동적으로 취득하는 함수
function getContextPath() {
    return window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
}

function searchList() {
    document.searchForm.submit();
}

function openChat(num) {
    currentInquiryNum = num;
    const cp = getContextPath();
    
    // 리스트 활성화 처리 (클릭된 항목 강조)
    document.querySelectorAll('.inquiry-item').forEach(el => el.classList.remove('active'));
    if(event && event.currentTarget) {
        event.currentTarget.classList.add('active');
    }

    // 초기 화면(Empty State) 숨기고 채팅창 보이기
    const emptyState = document.getElementById('emptyState');
    if(emptyState) emptyState.style.display = 'none';
    
    const chatView = document.getElementById('chatView');
    if(chatView) {
        chatView.classList.remove('d-none');
        chatView.classList.add('d-flex');
    }
    
    const chatBody = document.getElementById('chatBody');
    chatBody.innerHTML = ""; 
    
    const replyArea = document.getElementById('replyContent');
    replyArea.value = "";
    replyArea.disabled = false;
    replyArea.placeholder = "답변 내용을 입력하세요...";
    
    // AJAX 요청: 상세 내용 불러오기
    $.ajax({
        type: "GET",
        url: cp + "/admin/cs/inquiry_detail",
        data: { num: num },
        dataType: "json",
        success: function(data) {
            if(data.status === "success") {
                document.getElementById('chatTitle').innerText = data.subject;
                document.getElementById('chatUser').innerText = data.userName + " (" + data.reg_date + ")";
                
                // 1) 고객의 질문 (왼쪽 - 'user' 클래스)
                let userHtml = `
                    <div class="message-row user">
                        <div class="message-bubble">${data.content.replace(/\n/g, "<br>")}</div>
                        <span class="message-time">${data.reg_date}</span>
                    </div>`;
                chatBody.insertAdjacentHTML('beforeend', userHtml);
                
                // 2) 관리자의 답변이 있다면 (오른쪽 - 'admin' 클래스)
                if(data.replyContent) {
                    let adminHtml = `
                        <div class="message-row admin">
                            <span class="message-time">${data.replyDate || ''}</span>
                            <div class="message-bubble">${data.replyContent.replace(/\n/g, "<br>")}</div>
                        </div>`;
                    chatBody.insertAdjacentHTML('beforeend', adminHtml);
                    
                    // 답변 완료 시 입력창 제어
                    replyArea.disabled = true;
                    replyArea.placeholder = "답변이 완료된 문의입니다.";
                }
                
                // 스크롤을 최하단으로 부드럽게 이동
                setTimeout(() => {
                    chatBody.scrollTo({ top: chatBody.scrollHeight, behavior: 'smooth' });
                }, 100);
            }
        },
        error: function() {
            alert("데이터를 불러오는데 실패했습니다.");
        }
    });
}

function sendReply() {
    const content = document.getElementById('replyContent').value.trim();
    const cp = getContextPath();
    
    if(!currentInquiryNum || !content) {
        alert("답변 내용을 입력해주세요.");
        return;
    }
    if(!confirm("답변을 등록하시겠습니까?")) return;
    
    $.ajax({
        type: "POST",
        url: cp + "/admin/cs/inquiry_reply",
        data: { num: currentInquiryNum, replyContent: content },
        dataType: "json",
        success: function(data) {
            if(data.status === "success") {
                alert("답변이 등록되었습니다.");
                location.reload();
            }
        },
        error: function() {
            alert("통신 오류가 발생했습니다.");
        }
    });
}