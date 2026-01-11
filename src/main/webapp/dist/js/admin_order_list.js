/**
 * MAKNAEZ Admin Order List Logic
 */
document.addEventListener("DOMContentLoaded", function() {
    // 1. 전체 선택 체크박스
    const checkAll = document.getElementById('checkAll');
    if(checkAll) {
        checkAll.addEventListener('change', function() {
            const boxes = document.querySelectorAll('tbody input[type="checkbox"]');
            boxes.forEach(box => box.checked = checkAll.checked);
        });
    }
});

// 주문 상태 업데이트
function updateOrderStatus() {
    const selectedCount = document.querySelectorAll('tbody input[type="checkbox"]:checked').length;
    if(selectedCount === 0) {
        alert("처리를 진행할 주문을 선택해주세요.");
        return;
    }
    if(confirm(`${selectedCount}건의 주문을 '발주 확인' 상태로 변경하시겠습니까?`)) {
        alert("정상적으로 처리되었습니다. (SUCCESS)");
    }
}

function excelDownload() {
    alert("현재 리스트를 엑셀 파일로 추출합니다.");
}