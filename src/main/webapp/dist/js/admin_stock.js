document.addEventListener("DOMContentLoaded", function() {
    const checkAll = document.getElementById('checkAll');
    if (checkAll) {
        checkAll.addEventListener('change', function() {
            const checkboxes = document.querySelectorAll('tbody input[name="optIds"]');
            checkboxes.forEach(cb => {
                cb.checked = checkAll.checked;
            });
        });
    }
});

function openStockModal(prodId, optId, prodName, size, currentStock) {
    const modalTitle = document.getElementById('modalTitle');
    const inputName = document.getElementById('modalProdName');
    const inputStock = document.getElementById('modalCurrentStock');
    const inputOptId = document.getElementById('modalOptId');
    const inputMode = document.getElementById('modalMode');
    const stockArea = document.getElementById('currentStockArea');
	const inputProdId = document.getElementById('modalProdId');

    modalTitle.textContent = "재고 개별 관리";
    inputName.value = prodName + " [" + size + "mm]";
    inputStock.value = currentStock + " 개";
    inputOptId.value = optId;
	inputProdId.value = prodId;
	
    inputMode.value = "single";
    stockArea.style.display = "block"; 
	
    const myModal = new bootstrap.Modal(document.getElementById('stockModal'));
    myModal.show();
}

function openBulkStockModal() {
    const checkedBoxes = document.querySelectorAll('tbody input[name="optIds"]:checked');
    if(checkedBoxes.length === 0) {
        alert("일괄 처리할 상품을 목록에서 선택해주세요.");
        return;
    }

    const modalTitle = document.getElementById('modalTitle');
    const inputName = document.getElementById('modalProdName');
    const stockArea = document.getElementById('currentStockArea');
    const inputMode = document.getElementById('modalMode');
    
    modalTitle.textContent = "재고 일괄 관리 (Bulk Update)";
    inputName.value = checkedBoxes.length + "개 품목 선택됨";
    stockArea.style.display = "none"; 
    inputMode.value = "bulk";

    const myModal = new bootstrap.Modal(document.getElementById('stockModal'));
    myModal.show();
}

function updateStockSubmit() {
    const mode = document.getElementById('modalMode').value;
    const qty = document.getElementById('modalChangeQty').value;
    const reason = document.getElementById('modalReason').value;
    
    if(!qty || parseInt(qty) === 0) {
        alert("변동 수량을 입력하세요.");
        return;
    }

    let optIds = [];
	let prodIds = [];
    
    if(mode === 'single') {
        optIds.push(document.getElementById('modalOptId').value);
		prodIds.push(document.getElementById('modalProdId').value);
    } else {
        const checkedBoxes = document.querySelectorAll('tbody input[name="optIds"]:checked');
        checkedBoxes.forEach(function(cb) {
            optIds.push(cb.value);
			
			const prodIdInput = cb.previousElementSibling; 
            if(prodIdInput && prodIdInput.name === 'prodId') {
                prodIds.push(prodIdInput.value);
            }
        });
    }

    $.ajax({
        type: "POST",
        url: cp + "/admin/product/updateStock",
        traditional: true,
        data: {
            optIds: optIds,
			prodIds: prodIds,
            qty: qty,
            reason: reason
        },
        dataType: "json",
        success: function(data) {
            if(data.state === "true") {
                alert("재고가 성공적으로 반영되었습니다.");
                location.reload(); // 새로고침
            } else {
                alert("처리 중 오류가 발생했습니다.");
            }
        },
        error: function(e) {
            console.log(e);
            alert("서버 통신 오류");
        }
    });
}

function downloadStockExcel() {
    alert("현재 재고 리스트를 엑셀 파일로 추출합니다.");
}