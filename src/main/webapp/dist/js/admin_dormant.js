document.addEventListener("DOMContentLoaded", function() {
    // 전체 선택 기능
    const checkAll = document.getElementById('checkAll');
    if(checkAll) {
        checkAll.addEventListener('change', function() {
            const items = document.querySelectorAll('.chk-item');
            items.forEach(item => item.checked = this.checked);
        });
    }
});

function searchList() {
    console.log("휴면 회원 검색 클릭");
}

function restoreSelected() {
    alert("선택한 회원을 복구하시겠습니까?");
}

function deleteSelected() {
    alert("선택한 회원을 삭제하시겠습니까? 삭제 후 복구가 불가능합니다.");
}