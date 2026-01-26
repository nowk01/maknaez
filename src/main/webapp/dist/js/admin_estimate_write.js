function goBackList() {
    if (document.referrer.indexOf('/admin/order/estimate_list') !== -1) {
        history.back();
    } else {
        location.href = "/admin/order/estimate_write?orderNum=" + orderNum;
    }
}

function downloadEstimate() {
    const orderNum = currentOrderNum; 
    
    if(!orderNum || orderNum === "" || orderNum.includes("${")) {
        alert("주문 번호를 불러오지 못했습니다.");
        return;
    }

    const safeOrderNum = encodeURIComponent(orderNum);
    const downloadUrl = contextPath + "/admin/order/estimate_download?orderNum=" + safeOrderNum;

    const iframe = document.createElement("iframe");
    iframe.style.display = "none";
    iframe.src = downloadUrl;
    document.body.appendChild(iframe);
    
    setTimeout(function() {
        document.body.removeChild(iframe);
    }, 1000);
}

document.addEventListener("DOMContentLoaded", function() {
    console.log("Estimate Write Page Loaded.");
});