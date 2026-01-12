document.addEventListener("DOMContentLoaded", function() {
    // 목록으로 버튼 이벤트 (필요 시)
    const btnList = document.querySelector(".btn-list");
    if(btnList) {
        btnList.addEventListener("click", function() {
            // JSP에서 넘겨준 contextPath를 전역변수로 쓰거나 직접 이동
            // location.href = contextPath + "/admin/cs/notice_list";
        });
    }

    // 첨부파일 다운로드 알림 등 추가 기능 로직
    const fileLink = document.querySelector(".file-box a");
    if(fileLink) {
        fileLink.onclick = function() {
            console.log("파일 다운로드를 시작합니다.");
        };
    }
});