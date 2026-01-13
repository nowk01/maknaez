// 1. 검색 기능
function searchHistory() {
    const f = document.historySearchForm;
    if ((f.startDate.value && !f.endDate.value) || (!f.startDate.value && f.endDate.value)) {
        alert("시작일과 종료일을 모두 선택해주세요.");
        return;
    }
    f.submit();
}

// 2. 모달 열기 (+, - 버튼 연동)
function openPointModal(mode) {
    const modalTitle = document.getElementById("pointModalLabel");
    const modalMode = document.getElementById("modalMode");
    const confirmBtn = document.getElementById("modalConfirmBtn");
    
    modalMode.value = mode;

    if (mode === '적립') {
        modalTitle.innerText = "포인트 [적립]";
        modalTitle.style.color = "#ff4e00";
        confirmBtn.innerText = "적립하기";
        confirmBtn.style.backgroundColor = "#ff4e00";
    } else {
        modalTitle.innerText = "포인트 [차감]";
        modalTitle.style.color = "#111";
        confirmBtn.innerText = "차감하기";
        confirmBtn.style.backgroundColor = "#111";
    }

    const myModal = new bootstrap.Modal(document.getElementById('pointModal'));
    myModal.show();
}

// 3. 사유 선택 시 입력창 활성화
function changeReason(select) {
    const form = select.closest("form");
    const input = form.querySelector("input[name=reason]");
    
    if (select.value === "direct") {
        input.readOnly = false;
        input.value = ""; 
        input.focus();
    } else {
        input.readOnly = true;
        input.value = select.value;
    }
}

// 4. 포인트 업데이트 전송 (AJAX)
function submitPointUpdate() {
    const f = document.pointForm;
    const query = $(f).serialize();
    const url = "/admin/member/updatePoint"; // 프로젝트 경로에 맞게 수정 필요

    if (!f.reason.value.trim()) { alert("사유를 입력해주세요."); return; }
    if (!f.point_amount.value || f.point_amount.value <= 0) { alert("포인트를 입력해주세요."); return; }

    if(!confirm("반영하시겠습니까?")) return;

    $.post(url, query, function(data) {
        if(data.state === "true") {
            alert("완료되었습니다.");
            location.reload();
        } else {
            alert(data.message || "실패했습니다.");
        }
    }, "json");
}