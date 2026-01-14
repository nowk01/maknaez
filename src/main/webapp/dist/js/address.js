// 배송지 추가 / 닫기
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

            if (document.addrForm) {
                document.addrForm.reset();
            }
        }, 300);
    }
}

// [추가] 다음 우편번호 API 연동 함수
function daumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            var addr = ''; 
            
            if (data.userSelectedType === 'R') { 
                addr = data.roadAddress;
            } else { 
                addr = data.jibunAddress;
            }

            document.getElementById('zipCode').value = data.zonecode;
            document.getElementById("addr1").value = addr;
            
            // 커서를 상세주소 필드로 이동
            document.getElementById("addr2").focus();
        }
    }).open();
}

// 배송지 저장
function sendOk() {
    const f = document.addrForm;

    if (!f.addrName.value.trim()) {
        alert("배송지 이름을 입력하세요.");
        f.addrName.focus();
        return;
    }
    if (!f.receiverName.value.trim()) {
        alert("받는 분 성함을 입력하세요.");
        f.receiverName.focus();
        return;
    }
    if (!f.receiverTel.value.trim()) {
        alert("전화번호를 입력하세요.");
        f.receiverTel.focus();
        return;
    }
    if (!f.zipCode.value.trim()) {
        alert("우편번호를 검색해주세요.");
        return;
    }
    if (!f.addr2.value.trim()) {
        alert("상세 주소를 입력해주세요.");
        f.addr2.focus();
        return;
    }

    // JSP form 태그에 data-action을 추가했으므로 이제 작동합니다.
    f.action = f.dataset.action;
    f.submit();
}

// 배송지 삭제
function deleteAddr(addrId) {
    if (confirm("정말 삭제하시겠습니까?")) {
        // JSP body 태그에 data-context-path를 추가했으므로 이제 작동합니다.
        location.href =
            document.body.dataset.contextPath +
            "/member/mypage/addr/delete?addrId=" + addrId;
    }
}