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

function approveClaim() {
    const selected = document.querySelectorAll('tbody input[type="checkbox"]:checked');
    if(selected.length === 0) return alert("처리할 항목을 선택해주세요.");
    if(confirm(`${selected.length}건의 요청을 승인하시겠습니까?`)) alert("처리가 완료되었습니다.");
}

function excelDownload() {
    alert("Excel 다운로드를 시작합니다.");
}