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
    
    document.querySelectorAll('.inquiry-item').forEach(el => el.classList.remove('active'));
    if(event && event.currentTarget) {
        event.currentTarget.classList.add('active');
    }

    const emptyState = document.getElementById('emptyState');
    if(emptyState) emptyState.style.display = 'none';
    
    const reviewView = document.getElementById('reviewView');
    if(reviewView) {
        reviewView.classList.remove('d-none');
        reviewView.classList.add('d-flex');
    }
    
    const reviewBody = document.getElementById('reviewBody');
    reviewBody.innerHTML = ""; 
    
    const replyArea = document.getElementById('replyContent');
    replyArea.value = "";
    replyArea.disabled = false;
    replyArea.placeholder = "이 리뷰에 답글을 입력하세요...";
    
    $.ajax({
        type: "GET",
        url: cp + "/admin/cs/review_detail",
        data: { reviewId: num }, 
        dataType: "json",
        success: function(data) {
			
			if (requestId !== lastRequestId) return;
			
            console.log("Review Data:", data);

            if(data.status === "success") {
                document.getElementById('reviewTitle').innerText = "[" + (data.productName || "상품정보 없음") + "]";
                document.getElementById('reviewUser').innerText = (data.userName || data.writerName) + " (" + (data.reg_date || data.regDate) + ")";
                
                updateBlindButton(data.enabled);

                const score = data.score || 5;
                const stars = "★".repeat(score) + "☆".repeat(5 - score);
                
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
                    
                    replyArea.value = data.replyContent;
                    replyArea.disabled = true;
                    replyArea.placeholder = "이미 답변이 등록되었습니다.";
                }
                
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
    location.href = cp + "/admin/cs/review_delete?reviewId=" + currentReviewNum;
}

// 리뷰 숨김/공개 토글 함수
function toggleBlind() {
    if (!currentReviewNum) return;
    
    const btn = document.getElementById('btnBlind');
    const isCurrentlyBlind = btn.innerText.includes("해제");
    
    const nextStatus = isCurrentlyBlind ? 1 : 0; 
    
    const msg = isCurrentlyBlind ? "숨김 처리를 해제하시겠습니까?" : "이 리뷰를 사용자에게 보이지 않게 숨기겠습니까?";

    if(!confirm(msg)) return;

    const cp = getContextPath();
    $.ajax({
        type: "POST",
        url: cp + "/admin/cs/review_status",
        data: { reviewId: currentReviewNum, enabled: nextStatus },
        dataType: "json",
        success: function(data) {
            if (data.status === "success") {
                alert("상태가 변경되었습니다.");
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

function updateBlindButton(enabledStatus) {
    const btn = document.getElementById('btnBlind');
    const span = btn.querySelector('span');
    const icon = btn.querySelector('i');
    
    if (enabledStatus == 0) { 
        btn.classList.add('active');
        icon.className = 'far fa-eye';
        span.innerText = "숨김 해제";
    } else {
        btn.classList.remove('active');
        icon.className = 'far fa-eye-slash';
        span.innerText = "숨김";
    }
}