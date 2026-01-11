/**
 * MAKNAEZ Admin Review Logic - Professional Wide UI
 */
let currentReviewNum = 0;

function getContextPath() {
    return window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
}

function searchList() {
    document.searchForm.submit();
}

function openReview(num) {
    currentReviewNum = num;
    const cp = getContextPath();
    
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
        url: cp + "/admin/cs/review_detail", // 컨트롤러에 생성해야 함
        data: { num: num },
        dataType: "json",
        success: function(data) {
            if(data.status === "success") {
                document.getElementById('reviewTitle').innerText = "[" + data.productName + "]";
                document.getElementById('reviewUser').innerText = data.userName + " (" + data.reg_date + ")";
                
                // 별점 문자열 생성
                const stars = "★".repeat(data.score) + "☆".repeat(5 - data.score);
                
                // 1) 고객의 리뷰 (User 말풍선 스타일 활용)
                let reviewHtml = `
                    <div class="message-row user">
                        <div class="bubble-wrap">
                            <div class="sender-name">작성자 : ${data.userName}</div>
                            <div class="message-bubble">
                                <div style="color:#ff4e00; margin-bottom:8px;">${stars}</div>
                                ${data.content.replace(/\n/g, "<br>")}
                                ${data.saveFilename ? `<br><img src="${cp}/uploads/review/${data.saveFilename}" class="review-img">` : ''}
                            </div>
                        </div>
                        <span class="message-time">${data.reg_date}</span>
                    </div>`;
                reviewBody.insertAdjacentHTML('beforeend', reviewHtml);
                
                // 2) 관리자의 답글이 있다면 (Admin 말풍선 스타일 활용)
                if(data.replyContent) {
                    let adminHtml = `
                        <div class="message-row admin">
                            <div class="bubble-wrap">
                                <div class="sender-name">작성자 : 관리자</div>
                                <div class="message-bubble">${data.replyContent.replace(/\n/g, "<br>")}</div>
                            </div>
                            <span class="message-time">${data.replyDate || ''}</span>
                        </div>`;
                    reviewBody.insertAdjacentHTML('beforeend', adminHtml);
                    
                    replyArea.disabled = true;
                    replyArea.placeholder = "답글 작성이 완료된 리뷰입니다.";
                }
                
                setTimeout(() => {
                    reviewBody.scrollTo({ top: reviewBody.scrollHeight, behavior: 'smooth' });
                }, 100);
            }
        }
    });
}

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
        url: cp + "/admin/cs/review_reply", // 컨트롤러에 생성해야 함
        data: { num: currentReviewNum, replyContent: content },
        dataType: "json",
        success: function(data) {
            if(data.status === "success") {
                alert("답글이 등록되었습니다.");
                location.reload();
            }
        }
    });
}