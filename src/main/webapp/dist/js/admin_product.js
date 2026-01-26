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

function deleteSelected() {
    const checkedBoxes = document.querySelectorAll('tbody input[name="prodIds"]:checked');
    if(checkedBoxes.length === 0) {
        alert("삭제할 상품을 선택해주세요.");
        return;
    }

    if(!confirm("선택한 상품을 삭제하시겠습니까?")) {
        return;
    }
    let prodIds = [];
    checkedBoxes.forEach(function(cb) {
        prodIds.push(cb.value);
    });

    $.ajax({
        type: "POST",
        url: cp + "/admin/product/delete", 
        traditional: true, 
        data: { prodIds: prodIds },
        success: function(data) {
            alert("정상적으로 삭제되었습니다.");
            location.reload(); 
        },
        error: function(e) {
            console.log(e);
            alert("삭제 처리 중 에러가 발생했습니다.");
        }
    });
}