document.addEventListener('DOMContentLoaded', function() {
    
    // --- 1. Sidebar Toggle Logic ---
    const sidebarToggle = document.getElementById('sidebar-toggle');
    const wrapper = document.getElementById('wrapper');

    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', event => {
            event.preventDefault();
            wrapper.classList.toggle('toggled');
            
            // 사이드바가 움직일 때 차트 크기도 재조정
            setTimeout(() => {
                if(window.salesChartInstance) window.salesChartInstance.resize();
            }, 300);
        });
    }

    // --- 2. Chart Logic ---
    const ctx = document.getElementById('salesChart');
    if (ctx) {
        window.salesChartInstance = new Chart(ctx.getContext('2d'), {
            type: 'line',
            data: {
                labels: ['12/29', '12/30', '12/31', '1/1', '1/2', '1/3', '1/4', '1/5'],
                datasets: [{
                    label: '매출',
                    data: [850, 920, 1100, 750, 980, 1240, 1150, 1245],
                    borderColor: '#2c5bf0',
                    backgroundColor: 'rgba(44, 91, 240, 0.1)',
                    tension: 0.4,
                    fill: true,
                    pointRadius: 4,
                    pointHoverRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: false, grid: { borderDash: [5, 5] } },
                    x: { grid: { display: false } }
                }
            }
        });
    }

    // --- 3. Menu Active State Logic (추가된 부분) ---
    // 현재 페이지의 URL 경로를 가져옵니다.
    const currentPath = window.location.pathname;
    
    // 사이드바의 모든 메뉴 링크를 선택합니다.
    const menuItems = document.querySelectorAll('#sidebar-wrapper .list-group-item');

    menuItems.forEach(item => {
        // 기존에 하드코딩된 active-menu 클래스가 있다면 제거합니다 (홈 대시보드 등)
        item.classList.remove('active-menu');
        
        // 링크의 경로가 현재 페이지 경로와 일치하는지 확인합니다.
        // item.href는 전체 URL을 반환하므로 pathname 속성을 사용하여 경로만 비교합니다.
        if (item.href && item.pathname === currentPath) {
            // 일치하는 메뉴에 active-menu 클래스를 추가합니다.
            item.classList.add('active-menu');
            
            // 만약 해당 메뉴가 서브메뉴(collapse) 안에 있다면, 그 부모 메뉴를 펼칩니다.
            const parentCollapse = item.closest('.collapse');
            if (parentCollapse) {
                // 부모 메뉴 펼치기
                parentCollapse.classList.add('show');
                
                // 부모 카테고리 링크(화살표 등)의 스타일도 열림 상태로 변경합니다.
                const parentToggle = document.querySelector(`a[href="#${parentCollapse.id}"]`);
                if (parentToggle) {
                    parentToggle.classList.remove('collapsed');
                    parentToggle.setAttribute('aria-expanded', 'true');
                    // 필요하다면 부모 메뉴에도 하이라이트를 줄 수 있습니다.
                    // parentToggle.classList.add('active-menu'); 
                }
            }
        }
    });
});