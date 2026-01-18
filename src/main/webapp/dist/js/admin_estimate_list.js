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

function deleteEstimate() {
}

function downloadExcel() {
    alert("견적서 목록을 엑셀로 추출합니다.");
}