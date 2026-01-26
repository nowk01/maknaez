
let dauChartInstance = null;
let hourlyChartInstance = null;
let referralChartInstance = null;

document.addEventListener("DOMContentLoaded", function() {
    loadVisitorStats('daily');

    const radios = document.getElementsByName('dauMode');
    radios.forEach(radio => {
        radio.addEventListener('change', function(e) {
            loadVisitorStats(e.target.value);
        });
    });

	    initReferralChart();
    
    const btnRefresh = document.getElementById('btnRefresh');
    if(btnRefresh) {
        btnRefresh.addEventListener('click', function() {
            const currentMode = document.querySelector('input[name="dauMode"]:checked').value;
            
            this.classList.add('spinning');
            
            loadVisitorStats(currentMode, function() {
                initReferralChart(); 
                
                setTimeout(() => {
                    btnRefresh.classList.remove('spinning');
                }, 500);
            });
        });
    }
});

function loadVisitorStats(mode, callback) {
    $.ajax({
        url: 'visitor_stats_api',
        type: 'GET',
        data: { mode: mode },
        dataType: 'json',
        success: function(data) {
            updateSummaryCards(data);
            renderDauChart(data.dauStats, mode);
            renderHourlyChart(data.hourlyStats);
            
            if (callback) callback();
        },
        error: function(err) {
            console.error("통계 데이터 로드 실패", err);
            if (callback) callback();
        }
    });
}

// 요약 카드 업데이트
function updateSummaryCards(data) {
    if(data.todayTotalLogin !== undefined) {
        const formatted = new Intl.NumberFormat().format(data.todayTotalLogin);
        const el = document.getElementById('todayTotalLogin');
        if(el) el.innerText = formatted + ' 회';
    }
}

function renderDauChart(statsData, mode) {
    const ctx = document.getElementById('dauChart').getContext('2d');
    
    const labels = statsData.map(item => item.date);
    const counts = statsData.map(item => item.count);
    
    if (dauChartInstance) {
        dauChartInstance.destroy();
    }

    dauChartInstance = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: (mode === 'daily' ? '일별' : '월별') + ' 접속자 수(명)',
                data: counts,
                borderColor: '#ff4e00',
                backgroundColor: 'rgba(255, 78, 0, 0.1)',
                borderWidth: 2,
                fill: true,
                tension: 0.3, // 곡선
                pointBackgroundColor: '#fff',
                pointBorderColor: '#ff4e00',
                pointRadius: 5,
                pointHoverRadius: 7
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false }, 
                tooltip: {
                    mode: 'index',
                    intersect: false,
                }
            },
            scales: {
                y: { 
                    beginAtZero: true, 
                    grid: { color: '#f0f0f0' },
                    ticks: { stepSize: 1 }
                },
                x: { 
                    grid: { display: false } 
                }
            }
        }
    });
}

function renderDauChart(statsData, mode) {
    const ctx = document.getElementById('dauChart').getContext('2d');
    
    if (dauChartInstance) dauChartInstance.destroy();

    const labels = statsData ? statsData.map(item => item.date) : [];
    const counts = statsData ? statsData.map(item => item.count) : [];

    dauChartInstance = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: (mode === 'daily' ? '일별' : '월별') + ' 접속자 수(명)',
                data: counts,
                borderColor: '#ff4e00',
                backgroundColor: 'rgba(255, 78, 0, 0.1)',
                borderWidth: 2,
                fill: true,
                tension: 0.3,
                pointBackgroundColor: '#fff',
                pointBorderColor: '#ff4e00',
                pointRadius: 5,
                pointHoverRadius: 7
            }]
        },
        options: {
            responsive: true, maintainAspectRatio: false,
            plugins: { legend: { display: false }, tooltip: { mode: 'index', intersect: false } },
            scales: {
                y: { beginAtZero: true, grid: { color: '#f0f0f0' }, ticks: { stepSize: 1 } },
                x: { grid: { display: false } }
            }
        }
    });
}

function renderHourlyChart(statsData) {
    const ctx = document.getElementById('hourlyChart').getContext('2d');
    
    if (hourlyChartInstance) hourlyChartInstance.destroy();

    const fullLabels = [];
    const fullData = [];
    const dataMap = {};
    
    if(statsData) {
        statsData.forEach(item => { dataMap[item.hour] = item.count; });
    }

    for(let i=0; i<24; i++) {
        const hourStr = i.toString().padStart(2, '0');
        fullLabels.push(hourStr + "시");
        fullData.push(dataMap[hourStr] || 0);
    }

    hourlyChartInstance = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: fullLabels,
            datasets: [{
                label: '접속 횟수',
                data: fullData,
                backgroundColor: '#1a1c1e',
                borderRadius: 4,
                barPercentage: 0.6
            }]
        },
        options: {
            responsive: true, maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, grid: { borderDash: [2, 4], color: '#eee' } },
                x: { grid: { display: false }, ticks: { maxTicksLimit: 12 } }
            }
        }
    });
}

function initReferralChart() {
    const ctx = document.getElementById('referralChart').getContext('2d');
    
    if (referralChartInstance) referralChartInstance.destroy();

    referralChartInstance = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Direct', 'Search', 'Social', 'Other'], // 라벨 예시 확장
            datasets: [{
                data: [45, 30, 15, 10], 
                backgroundColor: ['#1a1c1e', '#ff4e00', '#888', '#ddd'],
                borderWidth: 0,
                hoverOffset: 4
            }]
        },
        options: {
            responsive: true, maintainAspectRatio: false, cutout: '70%',
            plugins: { legend: { position: 'bottom', labels: { usePointStyle: true, padding: 20 } } }
        }
    });
}