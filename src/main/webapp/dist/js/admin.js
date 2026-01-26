document.addEventListener('DOMContentLoaded', function() {
    
    const sidebarToggle = document.getElementById('sidebar-toggle');
    const wrapper = document.getElementById('wrapper');

    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', event => {
            event.preventDefault();
            wrapper.classList.toggle('toggled');
            
            setTimeout(() => {
                if(window.salesChartInstance) window.salesChartInstance.resize();
            }, 300);
        });
    }

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

    const currentPath = window.location.pathname;
    
    const menuItems = document.querySelectorAll('#sidebar-wrapper .list-group-item');

    menuItems.forEach(item => {
        item.classList.remove('active-menu');
        if (item.href && item.pathname === currentPath) {
            item.classList.add('active-menu');
            
            const parentCollapse = item.closest('.collapse');
            if (parentCollapse) {
                parentCollapse.classList.add('show');
                
                const parentToggle = document.querySelector(`a[href="#${parentCollapse.id}"]`);
                if (parentToggle) {
                    parentToggle.classList.remove('collapsed');
                    parentToggle.setAttribute('aria-expanded', 'true');
                }
            }
        }
    });
});