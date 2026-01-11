/**
 * MAKNAEZ Admin Sales Stats Logic
 * - Premium Interaction & Animation Edition
 */
document.addEventListener("DOMContentLoaded", function() {
    initSalesChart();
});

function initSalesChart() {
    const canvas = document.getElementById('premiumSalesChart');
    if(!canvas) return;

    const ctx = canvas.getContext('2d');
    
    // 1. 프리미엄 오렌지 그라데이션 생성
    const gradient = ctx.createLinearGradient(0, 0, 0, 400);
    gradient.addColorStop(0, 'rgba(255, 78, 0, 0.45)');   // 상단
    gradient.addColorStop(0.5, 'rgba(255, 78, 0, 0.15)'); // 중간
    gradient.addColorStop(1, 'rgba(255, 78, 0, 0)');      // 하단

    const salesData = {
        labels: ['01.05 Mon', '01.06 Tue', '01.07 Wed', '01.08 Thu', '01.09 Fri', '01.10 Sat', '01.11 Sun'],
        datasets: [{
            label: '일일 매출액',
            data: [1200000, 1900000, 1500000, 2800000, 2100000, 3500000, 2450000],
            borderColor: '#ff4e00',
            borderWidth: 4,
            backgroundColor: gradient,
            fill: true,
            tension: 0.4, // 곡선 미학
            pointBackgroundColor: '#ffffff',
            pointBorderColor: '#ff4e00',
            pointBorderWidth: 2,
            pointRadius: 6,
            pointHoverRadius: 10, // 마우스 올리면 커짐 (쩌는 효과)
            pointHoverBackgroundColor: '#ff4e00',
            pointHoverBorderColor: '#fff',
            pointHoverBorderWidth: 4
        }]
    };

    new Chart(ctx, {
        type: 'line',
        data: salesData,
        options: {
            responsive: true,
            maintainAspectRatio: false,
            // 애니메이션 설정 (부드럽게 차오름)
            animation: {
                duration: 2000,
                easing: 'easeOutQuart'
            },
            // 인터랙션 설정 (마우스 근처만 가도 반응)
            interaction: {
                intersect: false,
                mode: 'index',
            },
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: 'rgba(17, 17, 17, 0.9)', // 블랙 럭셔리 툴팁
                    titleFont: { size: 14, weight: 'bold' },
                    padding: 15,
                    cornerRadius: 2,
                    displayColors: false,
                    callbacks: {
                        label: function(context) {
                            return ' 매출액: ₩' + context.parsed.y.toLocaleString();
                        }
                    }
                }
            },
            scales: {
                y: { 
                    beginAtZero: true, 
                    grid: { color: 'rgba(0, 0, 0, 0.03)', drawBorder: false },
                    ticks: { 
                        callback: (val) => '₩' + (val/10000) + '만' 
                    }
                },
                x: { grid: { display: false } }
            }
        }
    });
}

function downloadStats() {
    alert("매출 통계 보고서(Excel) 생성을 시작합니다.");
}