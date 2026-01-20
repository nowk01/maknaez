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

function searchList() {
    let startDate = document.getElementById("startDate").value;
    let endDate = document.getElementById("endDate").value;
    let status = document.getElementById("status").value;
    let searchValue = document.getElementById("searchValue").value;

    let url = contextPath + "/admin/order/estimate_list";
    let query = "page=1";

    if (startDate) query += "&startDate=" + startDate;
    if (endDate) query += "&endDate=" + endDate;
    if (status) query += "&status=" + encodeURIComponent(status);
    if (searchValue) query += "&searchValue=" + encodeURIComponent(searchValue);

    location.href = url + "?" + query;
}


function closeModal() {
    document.getElementById('approveModal').style.display = 'none';
}