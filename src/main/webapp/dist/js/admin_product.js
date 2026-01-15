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
    // 체크된 항목 찾기
    const checkedBoxes = document.querySelectorAll('tbody input[name="prodIds"]:checked');
    if(checkedBoxes.length === 0) {
        alert("삭제할 상품을 선택해주세요.");
        return;
    }

    if(!confirm("선택한 상품을 정말 삭제하시겠습니까?")) {
        return;
    }

    // 값 배열로 변환
    let prodIds = [];
    checkedBoxes.forEach(function(cb) {
        prodIds.push(cb.value);
    });

    // jQuery Ajax 사용
    $.ajax({
        type: "POST",
        url:  cp + "/admin/product/delete", // cp는 jsp 상단 script에서 정의 필요
        traditional: true, // 배열 전송 시 필수
        data: { prodIds: prodIds },
        success: function(data) {
            alert("삭제되었습니다.");
            location.reload();
        },
        error: function(e) {
            console.log(e);
            alert("삭제 중 오류가 발생했습니다.");
        }
    });
}