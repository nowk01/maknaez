function searchList() {
    const f = document.searchForm;
    f.submit();
}

// 1. 전체 선택/해제 기능
function checkAll(checkbox) {
    const items = document.querySelectorAll('.chk-item');
    items.forEach(item => {
        item.checked = checkbox.checked;
    });
}

// 2. 모달 열기 (선택된 회원 확인)
function openPointModal(mode) {
    const modal = document.getElementById('pointModal');
    const checkedItems = document.querySelectorAll('.chk-item:checked');
    const memberIdxInput = document.querySelector("input[name=memberIdx]"); // 상세페이지용 idx

    // 상세페이지인지 목록페이지인지 판별
    const isDetailPage = !!memberIdxInput;

    if (!isDetailPage && checkedItems.length === 0) {
        alert("처리가 필요한 회원을 선택해주세요.");
        return;
    }

    // 모달 UI 세팅
    const modalTitle = document.getElementById("pointModalLabel");
    const modalMode = document.getElementById("modalMode");
    const confirmBtn = document.querySelector("#pointModal .btn-primary") || document.getElementById("modalConfirmBtn");
    const pointHelp = document.getElementById("pointHelp");
    const selectedDiv = document.getElementById("selectedMembers");

    modalMode.value = mode;

    if (mode === '적립') {
        modalTitle.innerText = isDetailPage ? "포인트 [적립]" : "포인트 일괄 [적립]";
        if(confirmBtn) confirmBtn.innerText = "적립하기";
        if(pointHelp) pointHelp.innerText = "입력한 금액만큼 포인트가 더해집니다.";
    } else {
        modalTitle.innerText = isDetailPage ? "포인트 [차감]" : "포인트 일괄 [차감]";
        if(confirmBtn) confirmBtn.innerText = "차감하기";
        if(pointHelp) pointHelp.innerText = "입력한 금액만큼 포인트가 차감됩니다.";
    }

    // 선택된 회원 표시 로직
    if (isDetailPage) {
        const userId = document.querySelector(".text-orange").innerText;
        selectedDiv.innerHTML = `<div><span class="fw-bold">${userId}</span> 님 대상</div>`;
    } else {
        let html = "";
        checkedItems.forEach(item => {
            const memberIdx = item.value;
            const userId = document.getElementById("id_" + memberIdx).innerText;
            const userName = document.getElementById("name_" + memberIdx).innerText;
            html += `<div><span class="fw-bold">${userId}</span> (${userName})</div>`;
        });
        selectedDiv.innerHTML = html;
        document.getElementById("selectedCount").innerText = checkedItems.length;
    }

    const modalObj = new bootstrap.Modal(modal);
    modalObj.show();
}

// 3. 사유 선택 시 입력창 자동 완성
function changeReason(select) {
    const input = document.querySelector("input[name=reason]");
    if (select.value) {
        input.value = select.value;
    } else {
        input.value = "";
        input.focus();
    }
}

function submitPointUpdate() {
    const f = document.pointForm;
    const mode = f.mode.value;
    const reason = f.reason.value;
    let amount = f.point_amount.value;

    // 1. 유효성 검사
    if (!reason) {
        alert("사유를 입력해주세요.");
        f.reason.focus();
        return;
    }
    if (!amount || amount <= 0) {
        alert("유효한 포인트 금액을 입력해주세요.");
        f.point_amount.focus();
        return;
    }

    // 2. 선택된 회원 ID 수집
    const checkedItems = document.querySelectorAll('.chk-item:checked');
    let memberIdxList = [];
    checkedItems.forEach(item => memberIdxList.push(item.value));

    if(memberIdxList.length === 0) {
        alert("선택된 회원이 없습니다.");
        return;
    }

    // 3. 배열을 콤마 구분 문자열로 변환 (예: "10,25,33")
    // ajaxRequest 사용 시 배열 처리를 단순화하기 위함
    const memberIdxsStr = memberIdxList.join(",");

    // 4. 요청 파라미터 구성
    const url = "/maknaez/admin/member/updatePoint";
    const query = {
        memberIdxs: memberIdxsStr, // 문자열로 전송
        mode: mode,
        point_amount: amount,
        reason: reason
    };

    // 5. ajaxRequest 함수 호출 (util-jquery.js 활용)
    const fn = function(data) {
        if (data.state === "true") {
            alert("성공적으로 처리되었습니다.");
            location.reload(); 
        } else {
            alert("처리에 실패했습니다. ");
        }
    };

    // ajaxRequest(url, method, requestParams, responseType, callback)
    ajaxRequest(url, "post", query, "json", fn);
}
