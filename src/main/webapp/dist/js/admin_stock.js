/**
 * MAKNAEZ Admin Stock Management Logic
 */
document.addEventListener("DOMContentLoaded", function() {
    console.log("Stock Management System Active.");
});

// 전체 재고 업데이트 알림
function updateAllStock() {
    const rows = document.querySelectorAll('tbody tr').length;
    if(confirm(`${rows}개의 품목 재고 상태를 일괄 저장하시겠습니까?`)) {
        // 실제 AJAX 또는 Form 전송 로직
        alert("재고 변경사항이 정상적으로 반영되었습니다.");
    }
}

// 엑셀 다운로드
function downloadStockExcel() {
    alert("현재 재고 리스트를 엑셀 파일로 추출합니다.");
}