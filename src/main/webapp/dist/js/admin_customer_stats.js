/**
 * MAKNAEZ Admin Customer Stats Logic - Professional Color Mix
 */
document.addEventListener("DOMContentLoaded", function() {
    initAgeChart();
    initGenderChart();
});

function initAgeChart() {
    const ctx = document.getElementById('ageChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['10대', '20대', '30대', '40대', '50대+'],
            datasets: [{
                label: '회원 수',
                data: [450, 1200, 850, 300, 150],
                // 세련된 차콜 그레이와 오렌지 포인트
                backgroundColor: ['#e2e2e2', '#ff4e00', '#333333', '#888888', '#bbbbbb'],
                borderRadius: 4,
                barPercentage: 0.6 // 안정감 있는 두께
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, grid: { color: '#f5f5f5' } },
                x: { grid: { display: false } }
            }
        }
    });
}

function initGenderChart() {
    const ctx = document.getElementById('genderChart').getContext('2d');
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Male', 'Female', 'Etc'],
            datasets: [{
                data: [55, 42, 3],
                // 오렌지, 블랙, 실버 조합
                backgroundColor: ['#ff4e00', '#1a1c1e', '#dddddd'],
                hoverOffset: 12,
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '65%', // 너무 얇지 않은 안정적인 두께
            plugins: {
                legend: { position: 'bottom', labels: { usePointStyle: true, padding: 20 } }
            }
        }
    });
}