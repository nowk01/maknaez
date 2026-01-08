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
});