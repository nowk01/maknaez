document.addEventListener("DOMContentLoaded", function() {
    const btnList = document.querySelector(".btn-list");
    if(btnList) {
        btnList.addEventListener("click", function() {
        });
    }
	
    const fileLink = document.querySelector(".file-box a");
    if(fileLink) {
        fileLink.onclick = function() {
            console.log("파일 다운로드를 시작합니다.");
        };
    }
});