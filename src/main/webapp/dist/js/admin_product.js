/**
 * MAKNAEZ Admin Product List Script
 */

document.addEventListener("DOMContentLoaded", function() {
    // 1. 전체 선택 체크박스
    const checkAll = document.getElementById('checkAll');
    if (checkAll) {
        checkAll.addEventListener('change', function() {
            const checkboxes = document.querySelectorAll('tbody input[type="checkbox"]');
            checkboxes.forEach(cb => {
                cb.checked = checkAll.checked;
            });
        });
    }
});

// 상품 상태 변경 예시
function updateProductStatus() {
    const selected = document.querySelectorAll('tbody input[type="checkbox"]:checked');
    if (selected.length === 0) {
        alert("상태를 변경할 상품을 선택해주세요.");
        return;
    }
    alert(`${selected.length}개의 상품 상태를 업데이트합니다.`);
}

// 엑셀 다운로드
function excelDownload() {
    if(confirm("현재 목록을 Excel로 다운로드하시겠습니까?")) {
        console.log("Downloading excel...");
    }
}