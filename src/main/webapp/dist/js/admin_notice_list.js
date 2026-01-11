document.addEventListener("DOMContentLoaded", function() {
    // 1. 전체 선택
    const checkAll = document.getElementById('checkAll');
    if(checkAll) {
        checkAll.addEventListener('change', function() {
            document.querySelectorAll('.chk').forEach(cb => cb.checked = checkAll.checked);
        });
    }

    // 2. 선택 삭제 (백엔드 연동용)
    const btnDelete = document.getElementById('btnDeleteSelected');
    if(btnDelete) {
        btnDelete.addEventListener('click', function() {
            const selected = document.querySelectorAll('.chk:checked');
            if(selected.length === 0) {
                alert("삭제할 게시물을 선택하세요.");
                return;
            }
            
            if(confirm(`${selected.length}건의 공지사항을 삭제하시겠습니까?`)) {
                // 실제 구현 시 백엔드 삭제 API 호출 로직이 들어갈 자리
                alert("선택하신 게시물이 삭제되었습니다.");
            }
        });
    }
});