document.addEventListener("DOMContentLoaded", function() {
    // 전체 선택 체크박스 로직
    const checkAll = document.getElementById('checkAll');
    if(checkAll) {
        checkAll.addEventListener('change', function() {
            const items = document.querySelectorAll('.chk-item');
            items.forEach(item => item.checked = this.checked);
        });
    }
});

function searchList() {
    console.log("검색 버튼 클릭");
    // 실제 폼 전송이 필요할 때 아래 주석을 해제하세요.
    // document.searchForm.submit();
}