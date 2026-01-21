/* review.js - 수정버전 */

/** 1. 탭 전환 기능 */
function showTab(tabName) {
    const tabBtns = document.querySelectorAll('.tab-btn');
    const tabContents = document.querySelectorAll('.review-tab-content');

    tabBtns.forEach(btn => btn.classList.remove('active'));
    tabContents.forEach(content => content.classList.remove('active'));

    if (tabName === 'writable') {
        tabBtns[0].classList.add('active');
        document.getElementById('tab-writable').classList.add('active');
    } else {
        tabBtns[1].classList.add('active');
        document.getElementById('tab-written').classList.add('active');
    }
}

/** 2. 정렬 메뉴 토글 */
function toggleSortMenu(btn) {
    const dropdown = btn.closest('.PendingReviews__order_dropdown');
    dropdown.classList.toggle('open');
    const menu = dropdown.querySelector('.sm-salomon__dropdown-menu');
    menu.classList.toggle('active');
}

/** 3. 정렬 옵션 선택 */
function selectSort(item, sortName, sortCodeParam) {
    // JSP 상단에 const contextPath = "${pageContext.request.contextPath}"; 선언 필요
    location.href = contextPath + '/member/mypage/review?sort=' + sortCodeParam;
}

/** 4. 리뷰 작성 모달 열기 */
function openReviewModal(orderNum, productNum, prodName, thumbNail) {
    console.log("모달 열기 시도:", orderNum, prodName); // 디버깅용

    // 데이터 세팅
    document.getElementById('modalOrderNum').value = orderNum;
    document.getElementById('modalProductNum').value = productNum;
    document.getElementById('modalProdName').innerText = prodName;
    
    // 이미지 경로 설정 (이미지 없으면 기본 이미지)
    let imgPath = contextPath + "/uploads/product/" + thumbNail;
    if(!thumbNail || thumbNail === 'null' || thumbNail === '') {
        imgPath = contextPath + "/dist/images/no-image.png";
    }
    document.getElementById('modalImg').src = imgPath;
    
    // 폼 및 상태 초기화
    document.forms['reviewForm'].reset();
    document.getElementById('textCount').innerText = '0';
    removeImage(); // 미리보기 이미지 제거
    
    // 별점 5점 초기화
    const starBtns = document.querySelectorAll('.star-btn');
    starBtns.forEach(btn => btn.classList.add('active'));
    const starText = document.querySelector('.star-text');
    if(starText) starText.innerText = "아주 좋아요!";
    document.getElementById('ratingInput').value = 5;

    document.getElementById('reviewModal').style.display = 'flex';
}

/** 5. 리뷰 작성 모달 닫기 */
function closeReviewModal() {
    document.getElementById('reviewModal').style.display = 'none';
}

/** 6. 폼 유효성 검사 (수정됨) */
function validateReviewForm() {
    console.log("유효성 검사 시작..."); // 클릭 확인용
    
    // 폼 가져오기
    const form = document.reviewForm;
    
    // 1. 별점 검사 (혹시 0점일 경우)
    const rating = document.getElementById("ratingInput").value;
    if (!rating || rating == "0") {
        alert("별점을 선택해주세요.");
        return false;
    }

    // 2. 내용 길이 검사 [수정: 20자 -> 5자]
    const content = form.content.value.trim();
    if (content.length < 5) {
        alert("리뷰 내용은 최소 5자 이상 입력하셔야 합니다.\n현재 글자수: " + content.length);
        form.content.focus();
        return false;
    }
    
    // 3. 동의 체크박스 검사 [추가됨]
    // JSP에 <input type="checkbox" id="agreeCheck"> 라고 ID를 줘야 작동합니다.
    const agree = document.getElementById("agreeCheck");
    if (agree && !agree.checked) {
        alert("개인정보 수집 및 이용에 동의해주세요.");
        agree.focus();
        return false;
    }

    console.log("유효성 검사 통과! 전송 시작.");
    return true;
}

/** 7. 별점 클릭 이벤트 (DOM 로드 후 실행) */
document.addEventListener('DOMContentLoaded', function() {
    const starBtns = document.querySelectorAll('.star-btn');
    const ratingInput = document.getElementById('ratingInput');
    const starText = document.querySelector('.star-text');
    const texts = ["별로예요", "그저 그래요", "보통이에요", "맘에 들어요", "아주 좋아요!"];

    if(starBtns) {
        starBtns.forEach(btn => {
            btn.addEventListener('click', function(e) {
                // 버튼 타입이 submit이 되지 않도록 방지
                e.preventDefault(); 
                
                const value = parseInt(this.getAttribute('data-value'));
                ratingInput.value = value;
                
                starBtns.forEach(star => {
                    const starVal = parseInt(star.getAttribute('data-value'));
                    if (starVal <= value) {
                        star.classList.add('active');
                    } else {
                        star.classList.remove('active');
                    }
                });
                
                if(starText) starText.innerText = texts[value-1];
            });
        });
        // 초기 로딩 시 5점 활성화
        starBtns.forEach(btn => btn.classList.add('active'));
    }
});

/** 8. 글자수 세기 */
function checkByte(obj) {
    const maxByte = 500;
    const textVal = obj.value;
    const textLen = textVal.length;
    
    document.getElementById('textCount').innerText = textLen;
    
    if (textLen > maxByte) {
        alert("최대 " + maxByte + "자까지 입력 가능합니다.");
        obj.value = textVal.substring(0, maxByte);
        document.getElementById('textCount').innerText = maxByte;
    }
}

/** 9. 이미지 미리보기 */
function previewImage(input) {
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function(e) {
            const previewBox = document.getElementById('imagePreview');
            const previewImg = previewBox.querySelector('img');
            previewImg.src = e.target.result;
            
            document.querySelector('.upload-btn').style.display = 'none';
            previewBox.style.display = 'block';
        };
        reader.readAsDataURL(input.files[0]);
    }
}

/** 10. 이미지 삭제 */
function removeImage() {
    const input = document.getElementById('fileUpload');
    if(input) input.value = "";
    
    const previewBox = document.getElementById('imagePreview');
    const uploadBtn = document.querySelector('.upload-btn');
    
    if(previewBox) previewBox.style.display = 'none';
    if(uploadBtn) uploadBtn.style.display = 'flex';
}