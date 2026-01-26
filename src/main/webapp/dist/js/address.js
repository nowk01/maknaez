function openAddForm() {

    const f = document.addrForm;
    f.reset();
    f.addrId.value = ""; 
    
    f.action = f.dataset.writeUrl;
    
    const btnSubmit = document.getElementById("btnSubmit");
    if(btnSubmit) btnSubmit.value = "배송지 저장";

    toggleAddrForm(true);
}

function editAddr(btn) {

    const f = document.addrForm;
    const data = btn.dataset;
    
    f.addrId.value       = data.id;
    f.receiverName.value = data.receiver;
    f.addrName.value     = data.addrname;
    f.receiverTel.value  = data.tel;
    f.zipCode.value      = data.zip;
    f.addr1.value        = data.addr1;
    f.addr2.value        = data.addr2;
    
    if (data.basic === "1") {
        f.isBasic.checked = true;
    } else {
        f.isBasic.checked = false;
    }
    f.action = f.dataset.updateUrl;
    
    const btnSubmit = document.getElementById("btnSubmit");
    if(btnSubmit) btnSubmit.value = "배송지 수정";

    toggleAddrForm(true);
    
    setTimeout(() => {
        const formArea = document.getElementById("addr_form_area");
        if(formArea) formArea.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }, 300);
}

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

function sendOk() {
    const f = document.addrForm;

    if (!f.receiverName.value.trim()) { alert("받는 분 성함을 입력하세요."); f.receiverName.focus(); return; }
    if (!f.addrName.value.trim()) { alert("배송지 이름을 입력하세요."); f.addrName.focus(); return; }
    if (!f.receiverTel.value.trim()) { alert("전화번호를 입력하세요."); f.receiverTel.focus(); return; }
    if (!f.zipCode.value.trim()) { alert("우편번호를 검색해주세요."); return; }
    if (!f.addr2.value.trim()) { alert("상세 주소를 입력해주세요."); f.addr2.focus(); return; }

    console.log("전송될 Action URL:", f.action); 
    f.submit();
}

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

function deleteAddr(addrId) {
    if (confirm("정말 삭제하시겠습니까?")) {
        location.href = document.body.dataset.contextPath + "/member/mypage/addr/delete?addrId=" + addrId;
    }
}