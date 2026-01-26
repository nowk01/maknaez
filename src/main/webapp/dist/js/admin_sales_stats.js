document.addEventListener("DOMContentLoaded", function() {
    loadSalesData('daily');

    const btnRefresh = document.getElementById('btnRefresh');
    if(btnRefresh) {
        btnRefresh.addEventListener('click', function() {
            const currentMode = document.querySelector('input[name="salesMode"]:checked').value;
            this.classList.add('spinning');
            loadSalesData(currentMode, function() {
                setTimeout(() => btnRefresh.classList.remove('spinning'), 500);
            });
        });
    }

    const radios = document.getElementsByName('salesMode');
    radios.forEach(radio => {
        radio.addEventListener('change', function(e) {
            loadSalesData(e.target.value);
        });
    });
});

function loadSalesData(mode, callback) {
    $.ajax({
        url: 'sales_api',
        type: 'GET',
        data: { mode: mode }, 
        dataType: 'json',
        success: function(data) {
            updateCards(data);
            
            renderChart(data.salesTrend, mode); 
            
            updateTopProducts(data.topProducts);

            if (callback) callback();
        },
        error: function(xhr, status, error) {
            console.error("통계 데이터 로드 실패:", error);
            if (callback) callback();
        }
    });
}

function updateCards(data) {
    const fmt = (num) => new Intl.NumberFormat('ko-KR').format(num);

    $('#card-today-sales').text('₩ ' + fmt(data.todaySales));
    $('#diff-today-sales').text(data.todaySalesDiff)
                          .removeClass('text-success text-danger')
                          .addClass(data.todaySalesColor); 
    $('#text-today-diff').text(data.todaySalesDiff + (data.todaySalesColor === 'text-success' ? ' 증가' : ' 감소'));

    $('#card-month-sales').text('₩ ' + fmt(data.monthSales));
    $('#diff-month-sales').text(data.monthSalesDiff)
                          .removeClass('text-success text-danger')
                          .addClass(data.monthSalesColor);
    $('#text-month-diff').text(data.monthSalesDiff + (data.monthSalesColor === 'text-success' ? ' 증가' : ' 감소'));

    $('#card-order-count').text(fmt(data.todayOrderCount) + ' 건');
    $('#diff-order-count').text(data.orderDiffStr)
                          .removeClass('text-success text-danger')
                          .addClass(data.orderDiffColor);
    $('#text-order-diff').text(data.orderDiffStr + (data.orderDiffColor === 'text-success' ? ' 증가' : ' 감소'));
}

function renderChart(salesList, mode) {
    const canvasId = 'salesChart';
    const existingChart = Chart.getChart(canvasId);
    if (existingChart) existingChart.destroy();

    if (!Array.isArray(salesList) || salesList.length === 0) {
        return; 
    }

    const ctx = document.getElementById(canvasId).getContext('2d');
    const labels = salesList.map(item => item.statsDate); // "MM-DD" or "YYYY-MM"
    const revenues = salesList.map(item => item.totalRevenue);

    const gradient = ctx.createLinearGradient(0, 0, 0, 400);
    gradient.addColorStop(0, 'rgba(255, 78, 0, 0.4)');
    gradient.addColorStop(1, 'rgba(255, 78, 0, 0.0)');

    new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: (mode === 'daily' ? '일별' : '월별') + ' 매출',
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
                    grid: { borderDash: [2, 4] },
                    ticks: {
                        callback: function(value) {
                            return '₩' + new Intl.NumberFormat('ko-KR').format(value);
                        }
                    }
                },
                x: { grid: { display: false } }
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