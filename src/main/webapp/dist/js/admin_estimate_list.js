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

function deleteEstimate() {
    const selected = document.querySelectorAll('tbody input[type="checkbox"]:checked');
    if(selected.length === 0) return alert("삭제할 견적 요청을 선택해주세요.");
    if(confirm(`${selected.length}건의 요청을 삭제하시겠습니까?`)) alert("성공적으로 삭제되었습니다.");
}

function downloadExcel() {
    alert("견적서 목록을 엑셀로 추출합니다.");
}