document.addEventListener("DOMContentLoaded", function() {
    const btnList = document.querySelector(".btn-list");
    if(btnList) {
        btnList.addEventListener("click", function() {
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