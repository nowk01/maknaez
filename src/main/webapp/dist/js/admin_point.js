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
    const checkedItems = document.querySelectorAll('.chk-item:checked');
    if (checkedItems.length === 0) {
        alert("처리가 필요한 회원을 선택해주세요.");
        return;
    }

    // 모달 UI 세팅
    const modalTitle = document.getElementById("pointModalLabel");
    const modalMode = document.getElementById("modalMode");
    const confirmBtn = document.querySelector("#pointModal .btn-primary");
    const pointHelp = document.getElementById("pointHelp");

    modalMode.value = mode; // '적립' or '차감'

    if (mode === '적립') {
        modalTitle.innerText = "포인트 일괄 [적립]";
        modalTitle.className = "modal-title fw-bold text-primary";
        confirmBtn.className = "btn btn-primary";
        confirmBtn.innerText = "적립하기";
        pointHelp.innerText = "입력한 금액만큼 포인트가 더해집니다.";
    } else {
        modalTitle.innerText = "포인트 일괄 [차감]";
        modalTitle.className = "modal-title fw-bold text-danger";
        confirmBtn.className = "btn btn-danger";
        confirmBtn.innerText = "차감하기";
        pointHelp.innerText = "입력한 금액만큼 포인트가 차감됩니다.";
    }

    // 선택된 회원 리스트 표시 Logic
    const selectedDiv = document.getElementById("selectedMembers");
    const countSpan = document.getElementById("selectedCount");
    selectedDiv.innerHTML = "";
    
    let html = "";
    checkedItems.forEach(item => {
        const memberIdx = item.value;
        const userId = document.getElementById("id_" + memberIdx).innerText;
        const userName = document.getElementById("name_" + memberIdx).innerText;
        const curPoint = document.getElementById("point_" + memberIdx).value; // 히든값 가져오기

        html += `<div><span class="fw-bold">\${userId}</span> (\${userName}) - 현재: \${curPoint} P</div>`;
    });
    
    selectedDiv.innerHTML = html;
    countSpan.innerText = checkedItems.length;

    // 모달 띄우기 (Bootstrap 5 API)
    const modal = new bootstrap.Modal(document.getElementById('pointModal'));
    modal.show();
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
    const url = "${pageContext.request.contextPath}/admin/member/updatePoint";
    const query = {
        memberIdxs: memberIdxsStr, // 문자열로 전송
        mode: mode,
        amount: amount,
        reason: reason
    };

    // 5. ajaxRequest 함수 호출 (util-jquery.js 활용)
    const fn = function(data) {
        if (data.state === "true") {
            alert("성공적으로 처리되었습니다.");
            location.reload(); 
        } else {
            alert("처리에 실패했습니다. " + (data.message ? data.message : ""));
        }
    };

    // ajaxRequest(url, method, requestParams, responseType, callback)
    ajaxRequest(url, "post", query, "json", fn);
}