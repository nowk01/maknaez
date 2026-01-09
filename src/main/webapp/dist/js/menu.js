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
	
// 헤더 스크롤 애니메이션
const header = document.querySelector('header');
   
   if (header) {
       // 공통 스타일 동적 주입 (header.css 수정 없이 모든 페이지 적용)
       const style = document.createElement('style');
       style.innerHTML = `
           /* 헤더 스크롤 애니메이션 스타일 */
           body > header {
               position: sticky;
               top: 0;
               z-index: 1020;
               width: 100%;
               background-color: #fff;
               transition: transform 0.3s ease-in-out;
           }
           body > header.header-hidden {
               transform: translateY(-100%);
           }
       `;
       document.head.appendChild(style);

       // 스크롤 감지 로직
       let lastScrollTop = 0;
       
       window.addEventListener('scroll', function() {
           let scrollTop = window.pageYOffset || document.documentElement.scrollTop;
           
           // 50px 이상 스크롤 했을 때만 반응
           if (scrollTop > lastScrollTop && scrollTop > 50) {
               // 아래로 스크롤: 헤더 숨김
               header.classList.add('header-hidden');
           } else {
               // 위로 스크롤: 헤더 보임
               header.classList.remove('header-hidden');
           }
		   // 음수 (바운스) 방지용
           lastScrollTop = scrollTop <= 0 ? 0 : scrollTop;
       });
   }
	
	
});
