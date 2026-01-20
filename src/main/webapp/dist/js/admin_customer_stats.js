/* [admin_customer_stats.js] */

document.addEventListener("DOMContentLoaded", function() {
    loadCustomerStats();
});

// 컬러 팔레트 (등급/연령대별 구분을 위해 다양화)
const palette = ['#ff4e00', '#333333', '#555555', '#777777', '#999999', '#bbbbbb', '#dddddd'];

function loadCustomerStats() {
    $.ajax({
        url: 'customer_stats_api',
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            updateSummary(data);
            initTrendChart(data.newMemberTrend);
            initGradeChart(data.gradeDist);  // 색상 변경 적용
            initAgeChart(data.ageDist);      // 색상 변경 적용
            initGenderChart(data.genderDist);
            
            // VIP 테이블 초기화
            vipDataList = data.vipList;
            renderVipTable(vipDataList); 
        },
        error: function(err) { console.error(err); }
    });
}

function updateSummary(data) {
    const format = (n) => new Intl.NumberFormat().format(n);
    $('#totalMember').text(format(data.totalMemberCount) + " 명");
	
	$('#dormantMember').text(format(data.dormantCount || 0) + " 명");
    $('#withdrawnMember').text(format(data.withdrawnCount || 0) + " 명");
    
    // [수정] VIP 비율 연동
    const ratio = data.vipRatio || 0;
    $('#vipRatio').text(ratio + " %"); // 소수점은 SQL에서 이미 처리함

    let newSum = 0;
    if(data.newMemberTrend) {
        data.newMemberTrend.forEach(item => newSum += item.count);
    }
    $('#newMember7').text("+ " + format(newSum) + " 명");
}

/* --- Charts (색상 로직 수정) --- */

function initTrendChart(list) {
    const ctx = document.getElementById('trendChart').getContext('2d');
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

// [수정] 등급별 분포도 - 막대마다 다른 색상 적용
function initGradeChart(list) {
    const ctx = document.getElementById('gradeChart').getContext('2d');
    
    // 데이터 개수에 맞춰 색상 배열 생성
    const bgColors = list.map((_, i) => palette[i % palette.length]);

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: list.map(i => 'Level ' + i.grade),
            datasets: [{
                label: '회원 수',
                data: list.map(i => i.count),
                backgroundColor: bgColors, // 배열 적용
                borderRadius: 4
            }]
        },
        options: { 
            responsive: true, maintainAspectRatio: false, 
            plugins: { legend: { display: false } } // 범례 숨김 (색상만으로 구분)
        }
    });
}

// [수정] 연령별 분포도 - 막대마다 다른 색상 적용
function initAgeChart(list) {
    const ctx = document.getElementById('ageChart').getContext('2d');
    
    // 데이터 개수에 맞춰 색상 배열 생성
    const bgColors = list.map((_, i) => palette[i % palette.length]);

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: list.map(i => i.ageGroup),
            datasets: [{
                label: '인원',
                data: list.map(i => i.count),
                backgroundColor: bgColors, // 배열 적용
                borderRadius: 4
            }]
        },
        options: { 
            responsive: true, maintainAspectRatio: false, 
            plugins: { legend: { display: false } } 
        }
    });
}

function initGenderChart(list) {
    const ctx = document.getElementById('genderChart').getContext('2d');
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

/* --- VIP Table Sorting (수정됨) --- */
let vipDataList = [];
let sortState = { col: 4, asc: false }; // 초기값: 구매횟수(4) 내림차순

function renderVipTable(list) {
    const tbody = $('#vipTableBody');
    tbody.empty();

    if(!list || list.length === 0) {
        tbody.append('<tr><td colspan="7" class="text-center">데이터가 없습니다.</td></tr>');
        return;
    }

    list.forEach((item, index) => {
        let badgeClass = 'rank-badge';
        if(index === 0) badgeClass += ' rank-1';
        else if(index === 1) badgeClass += ' rank-2';
        else if(index === 2) badgeClass += ' rank-3';
        
        const money = new Intl.NumberFormat('ko-KR').format(item.totalPayment);
        let regDate = item.regDate ? item.regDate.substring(0, 10) : '-';

        const row = `
            <tr>
                <td><span class="${badgeClass}">${index + 1}</span></td>
                <td>${item.userId}</td>
                <td style="font-weight:bold;">${item.userName}</td>
                <td>LV.${item.grade}</td>
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