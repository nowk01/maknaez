/* js/menu.js */

document.addEventListener("DOMContentLoaded", function() {
    console.log("Menu Script Loaded");
    
    // 예시: 검색 버튼 클릭 시 알림 (필요 시 구현)
    const searchForm = document.querySelector('.search-box form');
    if(searchForm) {
        searchForm.addEventListener('submit', function(e) {
            // e.preventDefault(); // 실제 검색 시에는 제거
            // console.log("Searching...");
        });
    }
});