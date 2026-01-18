/**
 * [MAKNAEZ ADMIN] Estimate List 연동
 */
document.addEventListener("DOMContentLoaded", function() {
    const checkAll = document.getElementById('checkAll');
    if(checkAll) {
        checkAll.addEventListener('change', function() {
            document.querySelectorAll('tbody input[type="checkbox"]').forEach(box => {
                box.checked = checkAll.checked;
            });
        });
    }
});

// 주문번호를 가지고 바로 견적서 작성 페이지로 이동
function openEstimateWrite(orderNum) {
    if(!orderNum) {
        alert("주문 정보가 올바르지 않습니다.");
        return;
    }
    // 컨트롤러의 estimate_write?orderNum=... 로 이동
    location.href = "/admin/order/estimate_write?orderNum=" + orderNum;
}

function deleteEstimate() {
}

function downloadExcel() {
    alert("견적서 목록을 엑셀로 추출합니다.");
}