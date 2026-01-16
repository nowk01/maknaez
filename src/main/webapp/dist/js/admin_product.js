// admin_product.js

// 기존 checkAll 로직 유지
document.addEventListener("DOMContentLoaded", function() {
    const checkAll = document.getElementById('checkAll');
    if (checkAll) {
        checkAll.addEventListener('change', function() {
            const checkboxes = document.querySelectorAll('tbody input[name="prodIds"]');
            checkboxes.forEach(cb => {
                cb.checked = checkAll.checked;
            });
        });
    }
});

// [추가] 선택 삭제 기능
function deleteSelected() {
    // 1. 선택된 체크박스 확인
    const checkedBoxes = document.querySelectorAll('tbody input[name="prodIds"]:checked');
    if(checkedBoxes.length === 0) {
        alert("삭제할 상품을 선택해주세요.");
        return;
    }

    if(!confirm("선택한 상품을 삭제하시겠습니까?")) {
        return;
    }

    // 2. 체크된 값들을 배열에 담기
    let prodIds = [];
    checkedBoxes.forEach(function(cb) {
        prodIds.push(cb.value);
    });

    // 3. AJAX 전송
    $.ajax({
        type: "POST",
        url: cp + "/admin/product/delete", // Controller의 매핑 주소와 일치해야 함
        traditional: true, // [필수] 배열 전송 시 이 옵션이 있어야 서버에서 받음
        data: { prodIds: prodIds },
        success: function(data) {
            alert("정상적으로 삭제되었습니다.");
            location.reload(); // 리스트 새로고침
        },
        error: function(e) {
            console.log(e);
            alert("삭제 처리 중 에러가 발생했습니다.");
        }
    });
}