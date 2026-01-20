/**
 * MAKNAEZ Admin Visitor Stats Logic
 * - DAU(Daily/Monthly), Hourly Traffic, Referral
 */

// 전역 차트 객체 (업데이트 시 파괴 후 재생성 위해)
let dauChartInstance = null;
let hourlyChartInstance = null;
let referralChartInstance = null;

document.addEventListener("DOMContentLoaded", function() {
    // 1. 초기 로드 (기본값 Daily)
    loadVisitorStats('daily');

    // 2. 토글 버튼 이벤트 리스너 등록
    const radios = document.getElementsByName('dauMode');
    radios.forEach(radio => {
        radio.addEventListener('change', function(e) {
            loadVisitorStats(e.target.value);
        });
    });

    // 3. 유입 경로 차트 (더미 데이터 유지 - 기존 코드 활용)
    initReferralChart();
});

// 데이터 가져오기 및 렌더링
function loadVisitorStats(mode) {
    $.ajax({
        url: 'visitor_stats_api', // contextPath는 footerResources 등에서 정의되어 있다고 가정
        type: 'GET',
        data: { mode: mode },
        dataType: 'json',
        success: function(data) {
            // 요약 카드 업데이트
            updateSummaryCards(data);

            // 차트 업데이트
            renderDauChart(data.dauStats, mode);
            renderHourlyChart(data.hourlyStats);
        },
        error: function(err) {
            console.error("통계 데이터 로드 실패", err);
        }
    });
}

// 요약 카드 업데이트
function updateSummaryCards(data) {
    if(data.todayTotalLogin !== undefined) {
        // 숫자 포맷팅
        const formatted = new Intl.NumberFormat().format(data.todayTotalLogin);
        document.getElementById('todayTotalLogin').innerText = formatted + ' 회';
    }
}

// 1. DAU 차트 렌더링 (Line Chart)
function renderDauChart(statsData, mode) {
    const ctx = document.getElementById('dauChart').getContext('2d');
    
    // 데이터 가공
    const labels = statsData.map(item => item.date);
    const counts = statsData.map(item => item.count);
    
    // 기존 차트 파괴
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
                borderColor: '#ff4e00', // 포인트 컬러 사용
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
                legend: { display: false }, // 범례 숨김
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

// 2. 시간대별 접속량 렌더링 (Bar Chart)
function renderHourlyChart(statsData) {
    const ctx = document.getElementById('hourlyChart').getContext('2d');

    // 00시 ~ 23시 라벨 생성 및 데이터 매핑
    const fullLabels = [];
    const fullData = [];
    
    // DB에서 온 데이터 Map으로 변환
    const dataMap = {};
    if(statsData) {
        statsData.forEach(item => {
            dataMap[item.hour] = item.count;
        });
    }

    for(let i=0; i<24; i++) {
        const hourStr = i.toString().padStart(2, '0');
        fullLabels.push(hourStr + "시");
        fullData.push(dataMap[hourStr] || 0); // 데이터 없으면 0
    }

    if (hourlyChartInstance) {
        hourlyChartInstance.destroy();
    }

    hourlyChartInstance = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: fullLabels,
            datasets: [{
                label: '접속 횟수',
                data: fullData,
                backgroundColor: '#1a1c1e', // 짙은 색상
                borderRadius: 4,
                barPercentage: 0.6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false }
            },
            scales: {
                y: { 
                    beginAtZero: true, 
                    grid: { borderDash: [2, 4], color: '#eee' } 
                },
                x: { 
                    grid: { display: false },
                    ticks: { maxTicksLimit: 12 } // X축 라벨 너무 많으면 줄이기
                }
            }
        }
    });
}

// 3. 유입 경로 차트 (기존 로직 유지 - Doughnut)
function initReferralChart() {
    const ctx = document.getElementById('referralChart').getContext('2d');
    
    if (referralChartInstance) {
        referralChartInstance.destroy();
    }

    referralChartInstance = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Direct', 'Other'],
            datasets: [{
                data: [80, 20], // 더미 데이터
                backgroundColor: ['#111', '#888','#ff4e00' , '#ddd'],
                borderWidth: 0,
                hoverOffset: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '70%', // 도넛 두께
            plugins: {
                legend: { position: 'bottom', labels: { usePointStyle: true, padding: 20 } }
            }
        }
    });
}