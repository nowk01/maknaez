/* js/menu.js */

document.addEventListener("DOMContentLoaded", function() {
    console.log("Menu Script Loaded");
    
    const searchForm = document.querySelector('.search-box form');
    if(searchForm) {
        searchForm.addEventListener('submit', function(e) {
        });
    }
	
const header = document.querySelector('header');
   
   if (header) {
       const style = document.createElement('style');
       style.innerHTML = `
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

       let lastScrollTop = 0;
       
       window.addEventListener('scroll', function() {
           let scrollTop = window.pageYOffset || document.documentElement.scrollTop;
           
           if (scrollTop > lastScrollTop && scrollTop > 50) {
               header.classList.add('header-hidden');
           } else {
               header.classList.remove('header-hidden');
           }
           lastScrollTop = scrollTop <= 0 ? 0 : scrollTop;
       });
   }
	
	
});
