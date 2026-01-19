/* */

document.addEventListener("DOMContentLoaded", function() {
    loadStatsData();
});

let statusChart, categoryChart, bestSellerChart, wishlistChart, cartChart;

// MAKNAEZ Brand Colors
const brandColor = '#ff4e00'; // 1등 & 포인트
const darkColor = '#1a1c1e';  // 2등 & 기본
const subColor = '#666666';   // 3등
const baseColor = '#d1d1d1';  // 4등 이하 (배경)

function loadStatsData() {
    $.ajax({
        url: 'product_stats_api',
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            updateSummaryCards(data);
            initStatusChart(data.orderStatus);
            initCategoryChart(data.categoryShare);
            initBestSellerChart(data.bestSellers);
            // 가로 막대 차트 (랭킹 강조 적용)
            initWishlistChart(data.topWishlist);
            initCartChart(data.topCart);
        },
        error: function(xhr) { console.error(xhr); }
    });
}

function updateSummaryCards(data) {
    const format = (n) => new Intl.NumberFormat().format(n);
    $('#claimCount').text(format(data.pendingClaimCount || 0) + " 건");
    
    const soldOut = data.soldOutCount || 0;
    $('#soldOutCount').text(format(soldOut) + " 품목");

    const lowStock = data.lowStockCount || 0;
    $('#lowStockCount').text(format(lowStock) + " 품목");
}

/* -----------------------------------------------------------
   도넛 & 파이 차트 (기존 유지)
----------------------------------------------------------- */
function initStatusChart(list) {
    const ctx = document.getElementById('statusChart').getContext('2d');
    if (statusChart) statusChart.destroy();
    statusChart = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: list.map(i => i.status),
            datasets: [{
                data: list.map(i => i.count),
                backgroundColor: [brandColor, darkColor, '#444', '#666', '#888', '#aaa'],
                borderWidth: 0,
                hoverOffset: 8
            }]
        },
        options: {
            responsive: true, maintainAspectRatio: false, cutout: '70%',
            plugins: { legend: { position: 'right', labels: { boxWidth: 10, font: { size: 12 } } } }
        }
    });
}

function initCategoryChart(list) {
    const ctx = document.getElementById('categoryChart').getContext('2d');
    if (categoryChart) categoryChart.destroy();
    categoryChart = new Chart(ctx, {
        type: 'pie',
        data: {
            labels: list.map(i => i.categoryName),
            datasets: [{
                data: list.map(i => i.totalRevenue),
                backgroundColor: [darkColor, brandColor, '#333', '#e04400', '#555', '#ff7b00', '#777', '#ff9500'],
                borderWidth: 1, borderColor: '#fff'
            }]
        },
        options: {
            responsive: true, maintainAspectRatio: false,
            plugins: { legend: { position: 'right', labels: { boxWidth: 10, font: { size: 11 } } } }
        }
    });
}

function initBestSellerChart(list) {
    const ctx = document.getElementById('bestSellerChart').getContext('2d');
    if (bestSellerChart) bestSellerChart.destroy();
    bestSellerChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: list.map(i => i.productName),
            datasets: [{
                label: '판매 수량',
                data: list.map(i => i.totalQty),
                // 여기도 1등만 오렌지로 포인트 줄 수 있음 (선택 사항)
                backgroundColor: list.map((_, i) => i === 0 ? brandColor : darkColor),
                borderRadius: 4, barPercentage: 0.5, maxBarThickness: 60
            }]
        },
        options: {
            responsive: true, maintainAspectRatio: false,
            scales: {
                y: { beginAtZero: true, grid: { color: '#f0f0f0' }, ticks: { precision: 0 } },
                x: { grid: { display: false }, ticks: { font: { size: 12 }, callback: function(val) { let l = this.getLabelForValue(val); return l.length > 10 ? l.substr(0, 10)+'..' : l; } } }
            },
            plugins: { legend: { display: false } }
        }
    });
}

/* -----------------------------------------------------------
   [랭킹 강조 로직 추가] 가로 막대 차트
----------------------------------------------------------- */

// 순위에 따른 색상 배열 생성 함수 (1등:오렌지, 2등:블랙, 3등:진회색, 나머지:연회색)
function generateRankColors(length) {
    return Array.from({length}, (_, i) => {
        if (i === 0) return '#ff4e00'; // 1st: Orange
        if (i === 1) return '#1a1c1e'; // 2nd: Black
        if (i === 2) return '#666666'; // 3rd: Dark Grey
        return '#d1d1d1';              // Rest: Light Grey
    });
}

function initWishlistChart(list) {
    createRankingHBar('wishlistChart', list, 'Wish Count', wishlistChart, c => wishlistChart = c);
}

function initCartChart(list) {
    createRankingHBar('cartChart', list, 'Cart Adds', cartChart, c => cartChart = c);
}

// 랭킹 전용 가로 바 차트 생성 함수
function createRankingHBar(id, list, label, instance, setInstance) {
    const ctx = document.getElementById(id).getContext('2d');
    if (instance) instance.destroy();

    const bgColors = generateRankColors(list.length);
    
    // Hover 시 색상 (조금 더 진하게)
    const hoverColors = bgColors.map(c => {
        if(c === '#ff4e00') return '#cc3d00';
        if(c === '#1a1c1e') return '#000000';
        if(c === '#d1d1d1') return '#b0b0b0';
        return '#444444';
    });

    const chart = new Chart(ctx, {
        type: 'bar',
        indexAxis: 'y', // 가로형
        data: {
            labels: list.map(i => i.productName),
            datasets: [{
                label: label,
                data: list.map(i => i.cnt),
                backgroundColor: bgColors,      // 순위별 색상 적용
                hoverBackgroundColor: hoverColors, // 마우스 올렸을 때 색상
                borderRadius: 3,
                barPercentage: 0.6,
                maxBarThickness: 50
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            indexAxis: 'y',
            scales: {
                x: { beginAtZero: true, grid: { display: false } },
                y: { grid: { color: '#f5f5f5' }, ticks: { font: { size: 12 } } }
            },
            plugins: { legend: { display: false } }
        }
    });
    setInstance(chart);
}