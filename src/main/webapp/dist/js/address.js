/* =========================================
   배송지 관리 스크립트
========================================= */

// 1. [배송지 추가] 버튼 클릭
function openAddForm() {
    console.log("openAddForm 실행됨"); // 디버깅 로그

    const f = document.addrForm;
    f.reset();
    f.addrId.value = ""; 
    
    // JSP에 설정된 data-write-url 읽기
    f.action = f.dataset.writeUrl;
    
    const btnSubmit = document.getElementById("btnSubmit");
    if(btnSubmit) btnSubmit.value = "배송지 저장";

    toggleAddrForm(true);
}

// 2. [수정] 버튼 클릭
function editAddr(btn) {
    console.log("editAddr 실행됨"); // 디버깅 로그

    const f = document.addrForm;
    const data = btn.dataset; // data-* 속성 읽기
    
    // 값 채워넣기
    f.addrId.value       = data.id;
    f.receiverName.value = data.receiver;
    f.addrName.value     = data.addrname;
    f.receiverTel.value  = data.tel;
    f.zipCode.value      = data.zip;
    f.addr1.value        = data.addr1;
    f.addr2.value        = data.addr2;
    
    // 기본 배송지 체크박스 처리
    if (data.basic === "1") {
        f.isBasic.checked = true;
    } else {
        f.isBasic.checked = false;
    }

    // 수정 모드로 action 변경
    f.action = f.dataset.updateUrl;
    
    const btnSubmit = document.getElementById("btnSubmit");
    if(btnSubmit) btnSubmit.value = "배송지 수정";

    toggleAddrForm(true);
    
    // 스크롤 이동
    setTimeout(() => {
        const formArea = document.getElementById("addr_form_area");
        if(formArea) formArea.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }, 300);
}

// 3. 폼 열기/닫기
function toggleAddrForm(show) {
    const btnArea = document.getElementById("addr_btn_area");
    const formArea = document.getElementById("addr_form_area");

    if (show) {
        btnArea.classList.add("hide");
        setTimeout(() => {
            btnArea.style.display = "none";
            formArea.style.display = "block";
            requestAnimationFrame(() => {
                formArea.classList.add("active");
            });
        }, 200);
    } else {
        formArea.classList.remove("active");
        setTimeout(() => {
            formArea.style.display = "none";
            btnArea.style.display = "flex";
            btnArea.classList.remove("hide");
            if (document.addrForm) document.addrForm.reset();
        }, 300);
    }
}

// 4. 전송 (저장/수정)
function sendOk() {
    const f = document.addrForm;

    if (!f.receiverName.value.trim()) { alert("받는 분 성함을 입력하세요."); f.receiverName.focus(); return; }
    if (!f.addrName.value.trim()) { alert("배송지 이름을 입력하세요."); f.addrName.focus(); return; }
    if (!f.receiverTel.value.trim()) { alert("전화번호를 입력하세요."); f.receiverTel.focus(); return; }
    if (!f.zipCode.value.trim()) { alert("우편번호를 검색해주세요."); return; }
    if (!f.addr2.value.trim()) { alert("상세 주소를 입력해주세요."); f.addr2.focus(); return; }

    console.log("전송될 Action URL:", f.action); // 디버깅 로그
    f.submit();
}

// 5. 다음 주소 찾기
function daumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            var addr = (data.userSelectedType === 'R') ? data.roadAddress : data.jibunAddress;
            document.getElementById('zipCode').value = data.zonecode;
            document.getElementById("addr1").value = addr;
            document.getElementById("addr2").focus();
        }
    }).open();
}

// 6. 삭제
function deleteAddr(addrId) {
    if (confirm("정말 삭제하시겠습니까?")) {
        location.href = document.body.dataset.contextPath + "/member/mypage/addr/delete?addrId=" + addrId;
    }
}