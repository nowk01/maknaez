
document.addEventListener("DOMContentLoaded", function() {
	const checkAll = document.getElementById('checkAll');
	if (checkAll) {
		checkAll.addEventListener('change', function() {
			const boxes = document.querySelectorAll('tbody input[name="orderNums"]');
			boxes.forEach(box => box.checked = checkAll.checked);
		});
	}
});

function bulkTrackingUpdate() {
	const selected = document.querySelectorAll('input[name="orderNums"]:checked');
	if (selected.length === 0) {
		alert("처리할 주문을 선택해주세요.");
		return;
	}

	alert("준비 중인 기능입니다. 선택한 주문들에 대한 운송장 입력 팝업이 호출됩니다.");
}

function openInvoiceModal(orderNum) {
	const invoiceNum = prompt("주문번호 [" + orderNum + "] 의 운송장 번호를 입력하세요.");
	if (invoiceNum) {
		alert("송장번호 [" + invoiceNum + "] 가 등록되었습니다. 주문 상태가 '배송중'으로 변경됩니다.");

	}
}

function excelDownload() {
	const selected = document.querySelectorAll('input[name="orderNums"]:checked');

	let msg = "";
	if (selected.length > 0) {
		msg = "선택한 " + selected.length + "건의 주문 내역을 엑셀로 저장하시겠습니까?";
	} else {
		msg = "선택된 항목이 없습니다. 현재 검색된 전체 내역을 엑셀로 저장하시겠습니까?";
	}

	if (confirm(msg)) {
		alert("파일 생성을 시작합니다.");

	}
}

function viewOrderDetail(orderCode) {
	const url = window.location.origin + "/maknaez/admin/order/order_detail?orderCode=" + orderCode;
	const opt = "width=900, height=800, scrollbars=yes, resizable=yes";
	window.open(url, "OrderDetail", opt);
}

function searchList() {
    let startDate = document.getElementById("startDate").value;
    let endDate = document.getElementById("endDate").value;
    let status = document.getElementById("status").value;
    let sortKey = document.getElementById("sortKey").value;
    let searchValue = document.getElementById("searchValue").value;

    let url = contextPath + "/admin/order/order_list";
    let query = "page=1";

    if (startDate && endDate) query += "&startDate=" + startDate + "&endDate=" + endDate;
    if (status) query += "&status=" + encodeURIComponent(status);
    if (sortKey) query += "&sortKey=" + sortKey;
    if (searchValue) query += "&searchValue=" + encodeURIComponent(searchValue);

    location.href = url + "?" + query;
}