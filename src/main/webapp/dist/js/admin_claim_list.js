document.addEventListener("DOMContentLoaded", function() {
    // 체크박스 전체 선택
    const checkAll = document.getElementById('checkAll');
    if (checkAll) {
        checkAll.addEventListener('change', function() {
            document.querySelectorAll('tbody input[type="checkbox"]').forEach(box => {
                box.checked = checkAll.checked;
            });
        });
    }
});

function approveClaim() {
    const selected = document.querySelectorAll('tbody input[type="checkbox"]:checked');
    if (selected.length === 0) return alert("처리할 항목을 선택해주세요.");
    if (confirm(`${selected.length}건의 요청을 승인하시겠습니까?`)) alert("처리가 완료되었습니다.");
}

function excelDownload() {
    alert("Excel 다운로드를 시작합니다.");
}

// 모달창 열기
function openApproveModal(orderNum, type, productName, qty, link) {
    console.log("모달 열기 클릭됨:", orderNum);

    document.getElementById('m_orderNum').innerText = orderNum;
    document.getElementById('m_type').innerText = type;
    document.getElementById('m_product').innerText = productName;
    document.getElementById('m_qty').innerText = qty;

    document.getElementById('realApproveBtn').onclick = function() {
        location.href = link;
    };

    document.getElementById('approveModal').style.display = 'flex';
}

// 모달창 닫기
function closeModal() {
    document.getElementById('approveModal').style.display = 'none';
}