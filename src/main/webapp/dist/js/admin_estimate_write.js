// 견적서 출력 함수
function printEstimate() {
    window.print();
}

// 리스트로 돌아가기
function goBackList() {
    // 이전 페이지 히스토리가 있으면 뒤로가기, 없으면 리스트로 직접 이동
    if (document.referrer.indexOf('/admin/order/estimate_list') !== -1) {
        history.back();
    } else {
        location.href = "/admin/order/estimate_write?orderNum=" + orderNum;
    }
}

// 혹시 모를 로딩 시 추가 로직 필요할 경우
document.addEventListener("DOMContentLoaded", function() {
    console.log("Estimate Write Page Loaded.");
});