document.addEventListener("DOMContentLoaded", function() {
    loadStatsData();
	
	const btnRefresh = document.getElementById('btnRefresh');
    if(btnRefresh) {
        btnRefresh.addEventListener('click', function() {
            this.classList.add('spinning');
            
            loadStatsData(function() {
                setTimeout(() => {
                    btnRefresh.classList.remove('spinning');
                }, 500);
            });
        });
    }
});

let statusChart, categoryChart, bestSellerChart, wishlistChart, cartChart;

const brandColor = '#ff4e00'; 
const darkColor = '#1a1c1e';  
const subColor = '#666666';   
const baseColor = '#d1d1d1';  

function loadStatsData(callback) { 
    $.ajax({
        url: 'product_stats_api',
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            updateSummaryCards(data);
            initStatusChart(data.orderStatus);
            initCategoryChart(data.categoryShare);
            initBestSellerChart(data.bestSellers);
            initWishlistChart(data.topWishlist);
            initCartChart(data.topCart);
            
            if (callback) callback(); 
        },
        error: function(xhr) { 
            console.error(xhr);
            if (callback) callback();
        }
    });
}

function updateSummaryCards(data) {
    const format = (n) => new Intl.NumberFormat().format(n);
    $('#inquiryCount').text(format(data.pendingInquiryCount || 0) + " 건");
    
    const soldOut = data.soldOutCount || 0;
    $('#soldOutCount').text(format(soldOut) + " 품목");

    const lowStock = data.lowStockCount || 0;
    $('#lowStockCount').text(format(lowStock) + " 품목");
}

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

function generateRankColors(length) {
    return Array.from({length}, (_, i) => {
        if (i === 0) return '#ff4e00';
        if (i === 1) return '#1a1c1e'; 
        if (i === 2) return '#666666'; 
        return '#d1d1d1';              
    });
}

function initWishlistChart(list) {
    createRankingHBar('wishlistChart', list, 'Wish Count', wishlistChart, c => wishlistChart = c);
}

function initCartChart(list) {
    createRankingHBar('cartChart', list, 'Cart Adds', cartChart, c => cartChart = c);
}

function createRankingHBar(id, list, label, instance, setInstance) {
    const ctx = document.getElementById(id).getContext('2d');
    if (instance) instance.destroy();

    const bgColors = generateRankColors(list.length);
    const hoverColors = bgColors.map(c => {
        if(c === '#ff4e00') return '#cc3d00';
        if(c === '#1a1c1e') return '#000000';
        if(c === '#d1d1d1') return '#b0b0b0';
        return '#444444';
    });

    const chart = new Chart(ctx, {
        type: 'bar',
        indexAxis: 'y', 
        data: {
            labels: list.map(i => i.productName),
            datasets: [{
                label: label,
                data: list.map(i => i.cnt),
                backgroundColor: bgColors,     
                hoverBackgroundColor: hoverColors, 
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