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

function viewOrderDetail(orderCode) {
    const url = window.location.origin + "/maknaez/admin/order/order_detail?orderCode=" + orderCode;
    const opt = "width=900, height=800, scrollbars=yes, resizable=yes";
    window.open(url, "OrderDetail", opt);
}

function updateOrderStatus() {
    const selected = document.querySelectorAll('input[name="orderNums"]:checked');
    if(selected.length === 0) {
        alert("처리할 주문을 선택해주세요.");
        return;
    }

    if(confirm("선택한 주문을 발주 확인 처리하시겠습니까?")) {
        alert("발주 처리가 완료되었습니다.");
    }
}

function excelDownload() {
    alert("현재 리스트를 엑셀 파일로 추출합니다.");
}