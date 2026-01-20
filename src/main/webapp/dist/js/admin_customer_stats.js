/* [admin_customer_stats.js] - 최종 수정본 */

document.addEventListener("DOMContentLoaded", function() {
    loadCustomerStats();

    const btnRefresh = document.getElementById('btnRefresh');
    if(btnRefresh) {
        btnRefresh.addEventListener('click', function() {
            this.classList.add('spinning');
            
            loadCustomerStats(function() {
                setTimeout(() => {
                    btnRefresh.classList.remove('spinning');
                }, 500);
            });
        });
    }
});

const palette = ['#ff4e00', '#333333', '#555555', '#777777', '#999999', '#bbbbbb', '#dddddd'];

function loadCustomerStats(callback) {
    $.ajax({
        url: 'customer_stats_api',
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            updateSummary(data);
            initTrendChart(data.newMemberTrend); // 이 함수가 아래에 정의되어 있어야 함
            initGradeChart(data.gradeDist);
            initAgeChart(data.ageDist);
            initGenderChart(data.genderDist);
            
            vipDataList = data.vipList;
            renderVipTable(vipDataList); 
            
            if (callback) callback();
        },
        error: function(err) { 
            console.error(err); 
            if (callback) callback();
        }
    });
}

function updateSummary(data) {
    const format = (n) => new Intl.NumberFormat().format(n);
    $('#totalMember').text(format(data.totalMemberCount) + " 명");
	
	$('#dormantMember').text(format(data.dormantCount || 0) + " 명");
    $('#withdrawnMember').text(format(data.withdrawnCount || 0) + " 명");
    
    const ratio = data.vipRatio || 0;
    $('#vipRatio').text(ratio + " %"); 

    let newSum = 0;
    if(data.newMemberTrend) {
        data.newMemberTrend.forEach(item => newSum += item.count);
    }
    $('#newMember7').text("+ " + format(newSum) + " 명");
}

/* --- Charts --- */

// [빠진 함수 추가] 1. 신규 가입 추이 차트
function initTrendChart(list) {
    const canvasId = 'trendChart';
    
    const existingChart = Chart.getChart(canvasId);
    if (existingChart) existingChart.destroy();

    const ctx = document.getElementById(canvasId).getContext('2d');
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: list.map(i => i.joinDate),
            datasets: [{
                label: '신규 가입',
                data: list.map(i => i.count),
                borderColor: '#ff4e00',
                backgroundColor: 'rgba(255, 78, 0, 0.1)',
                borderWidth: 2, fill: true, tension: 0.4
            }]
        },
        options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } } }
    });
}

// 헬퍼 함수: 레벨 -> 티어 변환
function getTierInfo(level) {
    if (level <= 10) return { name: 'IRON', color: '#5f6368', bg: '#f1f3f4' };       
    if (level <= 20) return { name: 'BRONZE', color: '#a15c1e', bg: '#faeadd' };     
    if (level <= 30) return { name: 'SILVER', color: '#70757a', bg: '#e8eaed' };     
    if (level <= 40) return { name: 'GOLD', color: '#f29900', bg: '#fef7e0' };       
    if (level <= 50) return { name: 'PLATINUM', color: '#188038', bg: '#e6f4ea' };   
    return { name: 'UNKNOWN', color: '#000', bg: '#fff' };
}

// 2. 등급별 분포 차트 (티어 적용 버전 하나만 남김)
function initGradeChart(list) {
    const canvasId = 'gradeChart';
    
    const existingChart = Chart.getChart(canvasId);
    if (existingChart) existingChart.destroy();

    // 데이터 그룹화
    const tierCounts = { 'IRON': 0, 'BRONZE': 0, 'SILVER': 0, 'GOLD': 0, 'PLATINUM': 0 };
    
    if(list) {
        list.forEach(item => {
            const tier = getTierInfo(item.grade).name;
            if(tierCounts[tier] !== undefined) {
                tierCounts[tier] += item.count;
            }
        });
    }

    const labels = ['IRON', 'BRONZE', 'SILVER', 'GOLD', 'PLATINUM'];
    const dataValues = labels.map(label => tierCounts[label]);
    
    // 티어별 색상
    const bgColors = [
        '#9aa0a6', // IRON
        '#cd7f32', // BRONZE
        '#bdc1c6', // SILVER
        '#fbbc04', // GOLD
        '#0f9d58'  // PLATINUM
    ];

    const ctx = document.getElementById(canvasId).getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: '회원 수',
                data: dataValues,
                backgroundColor: bgColors,
                borderRadius: 4,
                barPercentage: 0.6
            }]
        },
        options: { 
            responsive: true, 
            maintainAspectRatio: false, 
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, grid: { color: '#f0f0f0' }, ticks: { stepSize: 1 } },
                x: { grid: { display: false } }
            }
        }
    });
}

// 3. 연령별 분포 차트
function initAgeChart(list) {
    const canvasId = 'ageChart';

    const existingChart = Chart.getChart(canvasId);
    if (existingChart) existingChart.destroy();

    const ctx = document.getElementById(canvasId).getContext('2d');
    const bgColors = list.map((_, i) => palette[i % palette.length]);

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: list.map(i => i.ageGroup),
            datasets: [{
                label: '인원',
                data: list.map(i => i.count),
                backgroundColor: bgColors,
                borderRadius: 4
            }]
        },
        options: { 
            responsive: true, maintainAspectRatio: false, 
            plugins: { legend: { display: false } } 
        }
    });
}

// 4. 성별 분포 차트
function initGenderChart(list) {
    const canvasId = 'genderChart';

    const existingChart = Chart.getChart(canvasId);
    if (existingChart) existingChart.destroy();

    const ctx = document.getElementById(canvasId).getContext('2d');
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: list.map(i => i.gender),
            datasets: [{
                data: list.map(i => i.count),
                backgroundColor: ['#ff4e00', '#222', '#ddd']
            }]
        },
        options: { responsive: true, maintainAspectRatio: false, cutout: '60%' }
    });
}

/* --- VIP Table Sorting --- */
let vipDataList = [];
let sortState = { col: 4, asc: false }; 

function renderVipTable(list) {
    const tbody = $('#vipTableBody');
    tbody.empty();

    if(!list || list.length === 0) {
        tbody.append('<tr><td colspan="7" class="text-center">데이터가 없습니다.</td></tr>');
        return;
    }

    list.forEach((item, index) => {
        let rankBadgeClass = 'rank-badge';
        if(index === 0) rankBadgeClass += ' rank-1';
        else if(index === 1) rankBadgeClass += ' rank-2';
        else if(index === 2) rankBadgeClass += ' rank-3';
        
        const tier = getTierInfo(item.grade);
        
        const money = new Intl.NumberFormat('ko-KR').format(item.totalPayment);
        let regDate = item.regDate ? item.regDate.substring(0, 10) : '-';

        const row = `
            <tr>
                <td><span class="${rankBadgeClass}">${index + 1}</span></td>
                <td>${item.userId}</td>
                <td style="font-weight:bold;">${item.userName}</td>
                
                <td>
                    <span style="background-color:${tier.bg}; color:${tier.color}; 
                                 padding:4px 8px; border-radius:4px; font-weight:700; font-size:12px;">
                        ${tier.name}
                    </span>
                    <span style="color:#999; font-size:11px; margin-left:4px;">(Lv.${item.grade})</span>
                </td>
                
                <td>${item.orderCount} 회</td>
                <td style="color:#ff4e00; font-weight:800;">₩ ${money}</td>
                <td>${regDate}</td>
            </tr>
        `;
        tbody.append(row);
    });
}

window.sortTable = function(colIndex, type) {
    if(sortState.col === colIndex) {
        sortState.asc = !sortState.asc;
    } else {
        sortState.col = colIndex;
        sortState.asc = true;
        if(type === 'num' || type === 'money') sortState.asc = false;
    }

    vipDataList.sort((a, b) => {
        let valA, valB;
        switch(colIndex) {
            case 3: valA = a.grade; valB = b.grade; break;
            case 4: valA = a.orderCount; valB = b.orderCount; break;
            case 5: valA = a.totalPayment; valB = b.totalPayment; break;
            case 6: valA = a.regDate; valB = b.regDate; break;
            default: return 0;
        }
        if (valA < valB) return sortState.asc ? -1 : 1;
        if (valA > valB) return sortState.asc ? 1 : -1;
        return 0;
    });

    renderVipTable(vipDataList);
    updateSortIcons(colIndex, sortState.asc);
};

function updateSortIcons(colIndex, isAsc) {
    $('.sort-icon').text('');
    const icon = isAsc ? '▲' : '▼';
    $('#vipTable th').eq(colIndex).find('.sort-icon').text(icon);
}