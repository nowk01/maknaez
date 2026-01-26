
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

function toggleSortMenu(btn) {
    const dropdown = btn.closest('.PendingReviews__order_dropdown');
    dropdown.classList.toggle('open');
    const menu = dropdown.querySelector('.sm-salomon__dropdown-menu');
    menu.classList.toggle('active');
}

function selectSort(item, sortName, sortCodeParam) {
    location.href = contextPath + '/member/mypage/review?sort=' + sortCodeParam;
}

function openReviewModal(orderNum, productNum, prodName, thumbNail) {
    console.log("모달 열기 시도:", orderNum, prodName); 

    document.getElementById('modalOrderNum').value = orderNum;
    document.getElementById('modalProductNum').value = productNum;
    document.getElementById('modalProdName').innerText = prodName;
    
    let imgPath = contextPath + "/uploads/product/" + thumbNail;
    if(!thumbNail || thumbNail === 'null' || thumbNail === '') {
        imgPath = contextPath + "/dist/images/no-image.png";
    }
    document.getElementById('modalImg').src = imgPath;
    
    document.forms['reviewForm'].reset();
    document.getElementById('textCount').innerText = '0';
    removeImage(); 
    
    const starBtns = document.querySelectorAll('.star-btn');
    starBtns.forEach(btn => btn.classList.add('active'));
    const starText = document.querySelector('.star-text');
    if(starText) starText.innerText = "아주 좋아요!";
    document.getElementById('ratingInput').value = 5;

    document.getElementById('reviewModal').style.display = 'flex';
}

function closeReviewModal() {
    document.getElementById('reviewModal').style.display = 'none';
}

function validateReviewForm() {
    console.log("유효성 검사 시작..."); 
    
    const form = document.reviewForm;
    
    const rating = document.getElementById("ratingInput").value;
    if (!rating || rating == "0") {
        alert("별점을 선택해주세요.");
        return false;
    }

    const content = form.content.value.trim();
    if (content.length < 5) {
        alert("리뷰 내용은 최소 5자 이상 입력하셔야 합니다.\n현재 글자수: " + content.length);
        form.content.focus();
        return false;
    }
    
    const agree = document.getElementById("agreeCheck");
    if (agree && !agree.checked) {
        alert("개인정보 수집 및 이용에 동의해주세요.");
        agree.focus();
        return false;
    }

    console.log("유효성 검사 통과! 전송 시작.");
    return true;
}

document.addEventListener('DOMContentLoaded', function() {
    const starBtns = document.querySelectorAll('.star-btn');
    const ratingInput = document.getElementById('ratingInput');
    const starText = document.querySelector('.star-text');
    const texts = ["별로예요", "그저 그래요", "보통이에요", "맘에 들어요", "아주 좋아요!"];

    if(starBtns) {
        starBtns.forEach(btn => {
            btn.addEventListener('click', function(e) {
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
        starBtns.forEach(btn => btn.classList.add('active'));
    }
});

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

function removeImage() {
    const input = document.getElementById('fileUpload');
    if(input) input.value = "";
    
    const previewBox = document.getElementById('imagePreview');
    const uploadBtn = document.querySelector('.upload-btn');
    
    if(previewBox) previewBox.style.display = 'none';
    if(uploadBtn) uploadBtn.style.display = 'flex';
}