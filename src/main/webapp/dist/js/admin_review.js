/**
 * MAKNAEZ Admin Review Logic - Professional Wide UI
 */
let currentReviewNum = 0;
let lastRequestId = 0;

function getContextPath() {
    return window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
}

function searchList() {
    document.searchForm.submit();
}

function openReview(num) {
    currentReviewNum = num;
    const cp = getContextPath();
	
	const requestId = ++lastRequestId;
    
    // 1. UI 초기화: 왼쪽 리스트 선택 효과
    document.querySelectorAll('.inquiry-item').forEach(el => el.classList.remove('active'));
    if(event && event.currentTarget) {
        event.currentTarget.classList.add('active');
    }

    // 2. UI 초기화: 메인 화면 전환
    const emptyState = document.getElementById('emptyState');
    if(emptyState) emptyState.style.display = 'none';
    
    const reviewView = document.getElementById('reviewView');
    if(reviewView) {
        reviewView.classList.remove('d-none');
        reviewView.classList.add('d-flex');
    }
    
    // 내용 및 입력창 리셋
    const reviewBody = document.getElementById('reviewBody');
    reviewBody.innerHTML = ""; 
    
    const replyArea = document.getElementById('replyContent');
    replyArea.value = "";
    replyArea.disabled = false;
    replyArea.placeholder = "이 리뷰에 답글을 입력하세요...";
    
    // [AJAX] 데이터 요청 (파라미터명 reviewId 확인)
    $.ajax({
        type: "GET",
        url: cp + "/admin/cs/review_detail",
        data: { reviewId: num }, 
        dataType: "json",
        success: function(data) {
			
			if (requestId !== lastRequestId) return;
			
            console.log("Review Data:", data);

            if(data.status === "success") {
                // 상단 헤더 정보 세팅
                document.getElementById('reviewTitle').innerText = "[" + (data.productName || "상품정보 없음") + "]";
                document.getElementById('reviewUser').innerText = (data.userName || data.writerName) + " (" + (data.reg_date || data.regDate) + ")";
                
                // 숨김 버튼 상태 업데이트 (enabled가 0이면 숨김상태라고 가정)
                updateBlindButton(data.enabled);

                // 별점 문자열 생성
                const score = data.score || 5;
                const stars = "★".repeat(score) + "☆".repeat(5 - score);
                
                // 1) 고객의 리뷰 말풍선
                let contentText = data.content || "";
                let reviewHtml = `
                    <div class="message-row user">
                        <div class="bubble-wrap">
                            <div class="sender-name">작성자 : ${data.userName || data.writerName}</div>
                            <div class="message-bubble">
                                <div style="color:#ff4e00; margin-bottom:8px;">${stars} <span style="color:#666; font-size:11px;">(${data.optionValue || '옵션없음'})</span></div>
                                ${contentText.replace(/\n/g, "<br>")}
                                ${data.reviewImg ? `<br><img src="${cp}/uploads/review/${data.reviewImg}" class="review-img">` : ''}
                            </div>
                        </div>
                        <span class="message-time">${data.reg_date || ''}</span>
                    </div>`;
                reviewBody.insertAdjacentHTML('beforeend', reviewHtml);
                
                // 2) 관리자의 답글 말풍선 (있을 경우에만)
                if(data.replyContent) {
                    let adminHtml = `
                        <div class="message-row admin">
                            <div class="bubble-wrap">
                                <div class="sender-name">관리자</div>
                                <div class="message-bubble">${data.replyContent.replace(/\n/g, "<br>")}</div>
                            </div>
                            <span class="message-time">${data.replyDate || ''}</span>
                        </div>`;
                    reviewBody.insertAdjacentHTML('beforeend', adminHtml);
                    
                    // 답글이 있으면 입력창 비활성화
                    replyArea.value = data.replyContent;
                    replyArea.disabled = true;
                    replyArea.placeholder = "이미 답변이 등록되었습니다.";
                }
                
                // 스크롤 최하단으로 이동
                setTimeout(() => {
                    reviewBody.scrollTo({ top: reviewBody.scrollHeight, behavior: 'smooth' });
                }, 100);
            } else {
                alert("리뷰 데이터를 불러오는데 실패했습니다.");
            }
        },
        error: function(e) {
            console.error(e);
            alert("서버와의 통신 중 에러가 발생했습니다.");
        }
    });
}

// 답글 등록 함수
function sendReply() {
    const content = document.getElementById('replyContent').value.trim();
    const cp = getContextPath();
    
    if(!currentReviewNum || !content) {
        alert("답글 내용을 입력해주세요.");
        return;
    }
    
    if(!confirm("이 리뷰에 답글을 등록하시겠습니까?")) return;
    
    $.ajax({
        type: "POST",
        url: cp + "/admin/cs/review_reply",
        data: { reviewId: currentReviewNum, replyContent: content },
        dataType: "json",
        success: function(data) {
            if(data.status === "success") {
                alert("답글이 등록되었습니다.");
                openReview(currentReviewNum); // 화면 갱신
            } else {
                alert("답글 등록 실패: " + (data.message || "오류"));
            }
        },
        error: function() {
            alert("서버 통신 오류");
        }
    });
}

// 리뷰 삭제 함수
function deleteReview() {
    if (!currentReviewNum) {
        alert("선택된 리뷰가 없습니다.");
        return;
    }
    
    if (!confirm("정말 이 리뷰를 삭제하시겠습니까?\n삭제 후에는 복구할 수 없습니다.")) {
        return;
    }

    const cp = getContextPath();
    // GET 방식 삭제 요청 (필요시 POST로 변경)
    location.href = cp + "/admin/cs/review_delete?reviewId=" + currentReviewNum;
}

// 리뷰 숨김/공개 토글 함수
function toggleBlind() {
    if (!currentReviewNum) return;
    
    const btn = document.getElementById('btnBlind');
    // 현재 버튼 텍스트가 '숨김 해제'인지 확인
    const isCurrentlyBlind = btn.innerText.includes("해제");
    
    // 보낼 상태값 결정 (숨겨져 있으면 1(공개)로, 아니면 0(숨김)으로)
    // DB의 enabled 컬럼: 1=정상, 0=숨김 이라고 가정
    const nextStatus = isCurrentlyBlind ? 1 : 0; 
    
    const msg = isCurrentlyBlind ? "숨김 처리를 해제하시겠습니까?" : "이 리뷰를 사용자에게 보이지 않게 숨기겠습니까?";

    if(!confirm(msg)) return;

    const cp = getContextPath();
    $.ajax({
        type: "POST",
        url: cp + "/admin/cs/review_status", // 컨트롤러 매핑 필요
        data: { reviewId: currentReviewNum, enabled: nextStatus },
        dataType: "json",
        success: function(data) {
            if (data.status === "success") {
                alert("상태가 변경되었습니다.");
                // 버튼 UI 즉시 업데이트 (DB 다시 안 불러오고)
                updateBlindButton(nextStatus);
            } else {
                alert("상태 변경 실패");
            }
        },
        error: function() {
            alert("서버 통신 오류");
        }
    });
}

// 숨김 버튼 UI 업데이트 헬퍼 함수
function updateBlindButton(enabledStatus) {
    const btn = document.getElementById('btnBlind');
    const span = btn.querySelector('span');
    const icon = btn.querySelector('i');
    
    if (enabledStatus == 0) { // 현재 숨김 상태임
        btn.classList.add('active');
        icon.className = 'far fa-eye';
        span.innerText = "숨김 해제";
    } else { // 현재 정상 상태임
        btn.classList.remove('active');
        icon.className = 'far fa-eye-slash';
        span.innerText = "숨김";
    }
}