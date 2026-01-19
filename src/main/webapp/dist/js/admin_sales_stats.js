document.addEventListener("DOMContentLoaded", function() {
    loadSalesData();
});

function loadSalesData() {
    $.ajax({
        url: 'sales_api',
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            updateCards(data);

            const recentSales = data.recentSales || [];
            renderChart(recentSales);

            const topProducts = data.topProducts || [];
            updateTopProducts(topProducts);
        },
        error: function(xhr, status, error) {
            console.error("통계 데이터 로드 실패:", error);
        }
    });
}

function updateCards(data) {
    const fmt = (num) => new Intl.NumberFormat('ko-KR').format(num);
    $('#card-today-sales').text('₩ ' + fmt(data.todaySales));
    $('#card-month-sales').text('₩ ' + fmt(data.monthSales));
    $('#card-order-count').text(fmt(data.todayOrderCount) + ' 건');
}

// [핵심 수정 부분] renderChart 함수
function renderChart(salesList) {
    const canvasId = 'salesChart'; // 캔버스 ID

    // 1. 데이터 유효성 검사
    if (!Array.isArray(salesList) || salesList.length === 0) {
        console.warn("차트 데이터가 없습니다.");
        return;
    }

    // 2. [중요] 해당 캔버스에 이미 그려진 차트가 있는지 확인하고 파괴(Destroy)
    // Chart.getChart(ID)는 Chart.js 3.0+ 에서 지원하는 내장 함수입니다.
    const existingChart = Chart.getChart(canvasId);
    if (existingChart) {
        existingChart.destroy();
    }

    const ctx = document.getElementById(canvasId).getContext('2d');

    // 3. 데이터 가공
    const labels = salesList.map(item => item.statsDate);
    const revenues = salesList.map(item => item.totalRevenue);

    // 4. 그라데이션 효과
    const gradient = ctx.createLinearGradient(0, 0, 0, 400);
    gradient.addColorStop(0, 'rgba(255, 78, 0, 0.4)');
    gradient.addColorStop(1, 'rgba(255, 78, 0, 0.0)');

    // 5. 새 차트 생성 (변수에 담을 필요 없음)
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: '일별 매출',
                data: revenues,
                borderColor: '#ff4e00',
                backgroundColor: gradient,
                borderWidth: 2,
                pointBackgroundColor: '#fff',
                pointBorderColor: '#ff4e00',
                pointRadius: 4,
                fill: true,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return ' 매출: ₩ ' + new Intl.NumberFormat('ko-KR').format(context.parsed.y);
                        }
                    }
                }
            },
            scales: {
				y: {
			        beginAtZero: true,
			        grace: '20%', 
			        
			        grid: { borderDash: [2, 4] },
			        ticks: {
			            font: {
			                size: 12 
			            },
			            callback: function(value) {
			                return '₩' + new Intl.NumberFormat('ko-KR').format(value);
			            }
			        }
			    },
			    x: {
			        grid: { display: false }
			    }
            }
        }
    });
}

function updateTopProducts(products) {
    const $tbody = $('#top-product-table tbody');
    $tbody.empty();

    if (!products || products.length === 0) {
        $tbody.append('<tr><td colspan="3" class="text-center">데이터가 없습니다.</td></tr>');
        return;
    }

    products.forEach((p, index) => {
        const sizeBadge = p.productSize ? 
            `<span class="badge bg-secondary ms-1" style="font-size:0.8em;">${p.productSize}</span>` : '';

        const row = `
            <tr>
                <td style="vertical-align: middle;">
                    <span class="badge bg-light text-dark border">${index + 1}</span>
                </td>
                <td class="text-truncate" style="max-width: 150px; vertical-align: middle;">
                    <div class="fw-bold text-dark">${p.productName}</div>
                    ${sizeBadge} </td>
                <td class="text-end fw-bold" style="vertical-align: middle;">
                    <div>₩ ${new Intl.NumberFormat('ko-KR').format(p.totalRevenue)}</div>
                    <div class="text-muted small">${p.salesCount}개 판매</div>
                </td>
            </tr>
        `;
        $tbody.append(row);
    });
}