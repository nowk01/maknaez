<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MAKNAEZ - Admin Workspace</title>

<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
<link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">

<style>
.flatpickr-calendar {
    border: none !important;
    border-radius: 16px !important;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2) !important;
    padding: 20px !important;
    font-family: 'Manrope', 'Pretendard', sans-serif !important;
    width: 340px !important; 
    left: auto !important; 
    right: 0 !important; 
    top: 120% !important;
    margin-top: 5px !important;
    z-index: 9999 !important;
}
.flatpickr-calendar::before, .flatpickr-calendar::after { display: none !important; }
.flatpickr-day.nextMonthDay { visibility: hidden !important; pointer-events: none; }
.flatpickr-day.prevMonthDay { color: #f1f3f5 !important; }
.flatpickr-months { margin-bottom: 20px !important; align-items: center !important; }
.flatpickr-current-month { padding-top: 0 !important; font-size: 1.2rem !important; font-weight: 800 !important; }
.flatpickr-monthDropdown-months { font-weight: 800 !important; }
span.flatpickr-weekday { color: #adb5bd !important; font-weight: 700 !important; font-size: 0.85rem !important; }
.flatpickr-day {
    border-radius: 12px !important;
    font-weight: 600 !important; color: #495057; border: none !important;
    font-size: 1rem !important; line-height: 42px !important; margin: 2px 0 !important;
}
.flatpickr-day:hover { background: #f8f9fa !important; }
.flatpickr-day.selected, .flatpickr-day.startRange, .flatpickr-day.endRange {
    background: #ff4e00 !important; color: #fff !important;
    box-shadow: 0 4px 10px rgba(255, 78, 0, 0.3) !important; border-color: #ff4e00 !important;
}
.flatpickr-day.inRange {
    background: #fff5f0 !important; color: #ff4e00 !important;
    box-shadow: -5px 0 0 #fff5f0, 5px 0 0 #fff5f0 !important; border-color: transparent !important;
}

html, body { height: 100vh; overflow: hidden; background-color: #f5f6f8; font-family: 'Pretendard', sans-serif; color: #333; }
#wrapper { display: flex; height: 100%; width: 100%; }
#page-content-wrapper { flex-grow: 1; display: flex; flex-direction: column; min-width: 0; height: 100%; overflow-y: auto; }
.workspace { flex-grow: 1; padding: 25px 35px; display: grid; grid-template-columns: 6.5fr 3.5fr; grid-template-rows: 130px minmax(500px, 1fr); gap: 25px; min-height: calc(100vh - 70px); }
.card-box { background: #fff; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.02); border: 1px solid rgba(0,0,0,0.03); padding: 24px; display: flex; flex-direction: column; transition: transform 0.2s ease-in-out; }
.card-box:hover { transform: translateY(-3px); box-shadow: 0 8px 25px rgba(0,0,0,0.05); }
.stats-grid { grid-column: 1 / 2; display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; }
.stat-item { justify-content: center; padding: 20px; }
.stat-label { font-size: 0.8rem; color: #999; font-weight: 600; margin-bottom: 8px; }
.stat-val { font-family: 'Manrope', sans-serif; font-size: 1.5rem; font-weight: 800; color: #2d3436; }
.stat-badge { font-size: 0.7rem; font-weight: 700; margin-left: 8px; padding: 3px 8px; border-radius: 6px; display: inline-block; vertical-align: middle; }
.bg-up { background: #e6fcf5; color: #00b894; }
.bg-down { background: #fff5f5; color: #ff6b6b; }
.bg-neutral { background: #f1f3f5; color: #868e96; }
.chart-section { grid-column: 1 / 2; grid-row: 2 / 3; overflow: hidden; min-height: 400px; }
.chart-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
.chart-title { font-weight: 800; font-size: 1.1rem; color: #2d3436; }
.chart-canvas-wrapper { flex-grow: 1; position: relative; width: 100%; height: 100%; }
.side-stack { grid-column: 2 / 3; grid-row: 1 / 3; display: flex; flex-direction: column; gap: 25px; height: 100%; }

.calendar-card { flex: 1.35; padding: 0; border-radius: 20px; overflow: hidden; }
.cal-header { padding: 18px 24px 12px; background: #fff; border-bottom: 1px solid #f1f3f5; }
.cal-header-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
.cal-nav { display: flex; align-items: center; gap: 14px; }
.cal-title { font-size: 1.1rem; font-weight: 800; font-family: 'Manrope', sans-serif; min-width: 160px; text-align: center; }
.cal-btn { color: #adb5bd; cursor: pointer; font-size: 1rem; padding: 6px; transition: 0.2s; }
.cal-btn:hover { color: #ff4e00; transform: scale(1.2); }
.memo-btn { background: #ff4e00; color: #fff; border: none; width: 34px; height: 34px; border-radius: 12px; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: 0.2s; box-shadow: 0 4px 10px rgba(255,78,0,0.25); }
.memo-btn:hover { background: #e04400; transform: scale(1.05); }
.cal-weekdays { display: grid; grid-template-columns: repeat(7, 1fr); text-align: center; color: #adb5bd; font-size: 0.7rem; font-weight: 700; margin-bottom: 8px; }
.cal-body { padding: 8px 14px 14px; background: #fff; display: grid; grid-template-columns: repeat(7, 1fr); gap: 6px; }
.cal-cell { min-height: 38px; background: #fafafa; border-radius: 12px; padding: 6px; font-size: 0.75rem; font-weight: 700; color: #495057; position: relative; cursor: pointer; transition: 0.2s; border: 1px solid transparent; }
.cal-cell:hover { background: #fff; border-color: #f1f3f5; box-shadow: 0 4px 12px rgba(0,0,0,0.04); transform: translateY(-2px); }
.cal-cell.other-month { background: #fdfdfd; color: #ced4da; }
.cal-cell.today { border: 2px solid #ff4e00; }
.cal-date-num { font-size: 0.7rem; font-weight: 800; }
.memo-preview { margin-top: 4px; background: #fff5f0; color: #ff4e00; font-size: 0.6rem; font-weight: 700; border-radius: 6px; padding: 2px 4px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.memo-dot { position: absolute; bottom: 6px; right: 6px; width: 6px; height: 6px; border-radius: 50%; background: #ff4e00; }

.todo-card { flex: 0.65; border-radius: 20px; height: 300px; overflow: hidden; display: flex; flex-direction: column;}
.todo-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
.todo-title { font-size: 0.95rem; font-weight: 800; color: #495057; }
.todo-add-btn { background: #ff4e00; color: #fff; border: none; border-radius: 10px; padding: 6px 12px; font-size: 0.7rem; font-weight: 700; cursor: pointer; transition: 0.2s; }
.todo-add-btn:hover { background: #e04400; transform: scale(1.05); }
.todo-list { display: flex; flex-direction: column; gap: 10px; overflow-y: auto; max-height: 260px; padding-right: 4px; }
.todo-item { background: #fff; padding: 14px 14px; border-radius: 12px; border: 1px solid #f1f3f5; display: flex; align-items: center; gap: 12px; transition: 0.2s; }
.todo-item:hover { transform: translateX(3px); border-color: #e9ecef; box-shadow: 0 2px 8px rgba(0,0,0,0.03); }
.todo-check { width: 20px; height: 20px; border: 2px solid #ced4da; border-radius: 6px; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: 0.2s; }
.todo-check.checked { background: #ff4e00; border-color: #ff4e00; }
.todo-check.checked::after { content: "✔"; color: #fff; font-size: 11px; }
.todo-text { flex-grow: 1; font-size: 0.85rem; font-weight: 600; color: #495057; outline: none; border: none; background: transparent; }
.todo-text.done { text-decoration: line-through; color: #adb5bd; }
.todo-del { color: #ced4da; cursor: pointer; font-size: 0.8rem; transition: 0.2s; }
.todo-del:hover { color: #ff6b6b; }

.memo-modal-bg { position: fixed; inset: 0; background: rgba(0,0,0,0.35); display: none; align-items: center; justify-content: center; z-index: 9999; }
.memo-modal { width: 360px; background: #fff; border-radius: 20px; padding: 22px 22px 20px; box-shadow: 0 20px 50px rgba(0,0,0,0.2); animation: popIn 0.2s ease-out; }
@keyframes popIn { from { transform: scale(0.9); opacity: 0; } to { transform: scale(1); opacity: 1; } }
.memo-modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px; }
.memo-modal-title { font-weight: 800; font-size: 1rem; color: #2d3436; }
.memo-close { color: #adb5bd; cursor: pointer; font-size: 1rem; padding: 4px; transition: 0.2s; }
.memo-close:hover { color: #ff4e00; transform: scale(1.2); }
.memo-date { font-size: 0.75rem; font-weight: 700; color: #868e96; margin-bottom: 8px; }
.memo-textarea { width: 100%; min-height: 120px; border-radius: 12px; border: 1px solid #f1f3f5; padding: 12px; font-size: 0.8rem; font-weight: 600; outline: none; resize: none; font-family: 'Pretendard', sans-serif; }
.memo-textarea:focus { border-color: #ff4e00; box-shadow: 0 0 0 3px rgba(255,78,0,0.08); }
.memo-actions { display: flex; justify-content: space-between; margin-top: 12px; }
.memo-del-btn { background: #fff; border: 1px solid #ffe3e3; color: #ff6b6b; border-radius: 10px; padding: 7px 14px; font-size: 0.7rem; font-weight: 700; cursor: pointer; }
.memo-save-btn { background: #ff4e00; border: none; color: #fff; border-radius: 10px; padding: 7px 16px; font-size: 0.7rem; font-weight: 800; cursor: pointer; }
.memo-save-btn:hover { background: #e04400; }
.todo-list::-webkit-scrollbar { width: 6px; }
.todo-list::-webkit-scrollbar-thumb { background: #e9ecef; border-radius: 10px; }
</style>
</head>

<body>
<div id="wrapper">
    <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
    <div id="page-content-wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />
        <div class="workspace">
            <div class="stats-grid">
                <div class="card-box stat-item" onclick="location.href='${pageContext.request.contextPath}/admin/stats/sales_stats'" style="cursor:pointer;">
                    <div class="stat-label">오늘의 매출</div>
                    <div class="d-flex align-items-center">
                        <div class="stat-val" id="main-today-sales">loading...</div>
                        <span class="stat-badge" id="main-diff-sales"></span>
                    </div>
                </div>
                <div class="card-box stat-item" onclick="location.href='${pageContext.request.contextPath}/admin/order/order_list'" style="cursor:pointer;">
                    <div class="stat-label">신규 주문</div>
                    <div class="d-flex align-items-center">
                        <div class="stat-val" id="main-new-orders">loading...</div>
                        <span class="stat-badge" id="main-diff-orders"></span>
                    </div>
                </div>
                <div class="card-box stat-item" onclick="location.href='${pageContext.request.contextPath}/admin/cs/inquiry_list'" style="cursor:pointer;">
                    <div class="stat-label">미답변 문의</div>
                    <div class="d-flex align-items-center">
                        <div class="stat-val" style="color:#ff6b6b;" id="main-inquiry-count">loading...</div>
                        <span class="stat-badge bg-down" id="main-inquiry-badge">! Action</span>
                    </div>
                </div>
                <div class="card-box stat-item">
                    <div class="stat-label">실시간 방문자</div>
                    <div class="d-flex align-items-center">
                        <div class="stat-val highlight-green">${currentCount}</div>
                        <span class="stat-badge bg-neutral" style="color:#2ecc71; background:#e6f9ed; border:1px solid #b7ebc9;">
                            <span class="live-dot" style="display:inline-block;width:6px;height:6px;background:#2ecc71;border-radius:50%;margin-right:4px;"></span>
                            Live
                        </span>
                    </div>
                </div>
            </div>
            <div class="card-box chart-section">
                <div class="chart-header">
                    <span class="chart-title">Revenue Analytics</span>
                    <div class="btn-group" role="group">
                        <button type="button" class="btn btn-sm btn-dark rounded-start-3 px-3" id="btnWeekly" onclick="loadMainSalesData('daily')">Weekly</button>
                        <button type="button" class="btn btn-sm btn-outline-light text-dark border rounded-end-3 px-3" id="btnMonthly" onclick="loadMainSalesData('monthly')">Monthly</button>
                    </div>
                </div>
                <div class="chart-canvas-wrapper">
                    <canvas id="mainChart"></canvas>
                </div>
            </div>
            <div class="side-stack">
                <div class="card-box calendar-card">
                    <div class="cal-header">
                        <div class="cal-header-row">
                            <div class="cal-nav">
                                <i class="fas fa-chevron-left cal-btn" onclick="changeMonth(-1)"></i>
                                <div class="cal-title" id="calTitle">2026년 January</div>
                                <i class="fas fa-chevron-right cal-btn" onclick="changeMonth(1)"></i>
                            </div>
                            <button class="memo-btn" onclick="openMemoModal(new Date())" title="오늘 메모 작성">
                                <i class="fas fa-note-sticky"></i>
                            </button>
                        </div>
                        <div class="cal-weekdays">
                            <span>S</span><span>M</span><span>T</span><span>W</span><span>T</span><span>F</span><span>S</span>
                        </div>
                    </div>
                    <div class="cal-body" id="calendarGrid"></div>
                </div>
                <div class="card-box todo-card">
                    <div class="todo-header">
                        <span class="todo-title">오늘 할 일</span>
                        <button class="todo-add-btn" onclick="addTodo()">+ 추가</button>
                    </div>
                    <div class="todo-list" id="todoList"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="memo-modal-bg" id="memoModalBg">
    <div class="memo-modal">
        <div class="memo-modal-header">
            <span class="memo-modal-title">📌 일정 메모</span>
            <i class="fas fa-times memo-close" onclick="closeMemoModal()"></i>
        </div>
        <div class="memo-date" id="memoDateText"></div>
        <textarea class="memo-textarea" id="memoTextarea" placeholder="이 날짜에 대한 메모를 입력하세요..."></textarea>
        <div class="memo-actions">
            <button class="memo-del-btn" onclick="deleteMemo()">삭제</button>
            <button class="memo-save-btn" onclick="saveMemo()">저장</button>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
let mainChartInstance = null;

document.addEventListener("DOMContentLoaded", function() {
    loadMainSalesData('daily');
    loadInquiryData();
    initCalendar();
    initTodos();
});

function loadInquiryData() {
    $.ajax({
        url: '${pageContext.request.contextPath}/admin/stats/product_stats_api',
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            const count = data.pendingInquiryCount || 0;
            $('#main-inquiry-count').text(count);
            const $badge = $('#main-inquiry-badge');
            if (count > 0) {
                $badge.text('! Action').removeClass('bg-neutral').addClass('bg-down').show();
            } else {
                $badge.text('✓ Clear').removeClass('bg-down').addClass('bg-neutral').css('color', '#2ecc71');
            }
        },
        error: function(err) { console.error("로드 실패:", err); }
    });
}

function loadMainSalesData(mode) {
    updateButtonStyles(mode);
    $.ajax({
        url: '${pageContext.request.contextPath}/admin/stats/sales_api',
        type: 'GET',
        data: { mode: mode },
        dataType: 'json',
        success: function(data) {
            updateMainCards(data);
            renderMainChart(data.salesTrend, mode);
        },
        error: function(error) { console.error("로드 실패:", error); }
    });
}

function updateMainCards(data) {
    const fmt = (num) => new Intl.NumberFormat('ko-KR').format(num);
    $('#main-today-sales').text('₩ ' + fmt(data.todaySales));
    const $salesBadge = $('#main-diff-sales');
    $salesBadge.text(data.todaySalesDiff).removeClass('bg-up bg-down bg-neutral');
    $salesBadge.addClass(data.todaySalesColor === 'text-success' ? 'bg-up' : 'bg-down');
    $('#main-new-orders').text(fmt(data.todayOrderCount));
    const $orderBadge = $('#main-diff-orders');
    $orderBadge.text(data.orderDiffStr).removeClass('bg-up bg-down bg-neutral');
    $orderBadge.addClass(data.orderDiffColor === 'text-success' ? 'bg-up' : 'bg-down');
}

function renderMainChart(salesList, mode) {
    const ctx = document.getElementById('mainChart').getContext('2d');
    if (mainChartInstance) mainChartInstance.destroy();
    const labels = salesList.map(item => item.statsDate);
    const revenues = salesList.map(item => item.totalRevenue);
    let gradient = ctx.createLinearGradient(0, 0, 0, 400);
    gradient.addColorStop(0, 'rgba(255, 78, 0, 0.15)');
    gradient.addColorStop(1, 'rgba(255, 255, 255, 0)');
    mainChartInstance = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Sales Revenue',
                data: revenues,
                borderColor: '#ff4e00',
                borderWidth: 2.5,
                backgroundColor: gradient,
                pointBackgroundColor: '#fff',
                pointBorderColor: '#ff4e00',
                pointBorderWidth: 2,
                pointRadius: 4,
                pointHoverRadius: 6,
                tension: 0.35,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: 'rgba(0,0,0,0.8)',
                    padding: 10,
                    cornerRadius: 8,
                    displayColors: false,
                    callbacks: {
                        label: function(c) {
                            return ' ₩ ' + new Intl.NumberFormat('ko-KR').format(c.parsed.y);
                        }
                    }
                }
            },
            scales: {
                x: { grid: { display: false }, ticks: { color: '#adb5bd', font: { size: 11 } } },
                y: {
                    beginAtZero: true,
                    border: { display: false },
                    grid: { color: '#f1f3f5', borderDash: [5, 5] },
                    ticks: {
                        color: '#adb5bd',
                        callback: function(v) { return new Intl.NumberFormat('ko-KR', { notation: "compact" }).format(v); }
                    }
                }
            },
            layout: { padding: { top: 10, bottom: 10, left: 0, right: 0 } }
        }
    });
}

function updateButtonStyles(mode) {
    const btnW = document.getElementById('btnWeekly');
    const btnM = document.getElementById('btnMonthly');
    if (mode === 'daily') {
        btnW.classList.replace('btn-outline-light', 'btn-dark');
        btnW.classList.remove('text-dark', 'border');
        btnM.classList.replace('btn-dark', 'btn-outline-light');
        btnM.classList.add('text-dark', 'border');
    } else {
        btnM.classList.replace('btn-outline-light', 'btn-dark');
        btnM.classList.remove('text-dark', 'border');
        btnW.classList.replace('btn-dark', 'btn-outline-light');
        btnW.classList.add('text-dark', 'border');
    }
}

let calCurrentDate = new Date();
let selectedMemoDate = null;
let memoData = {};

function initCalendar() {
    loadMemoStorage();
    renderCalendar();
}

function changeMonth(diff) {
    calCurrentDate.setMonth(calCurrentDate.getMonth() + diff);
    renderCalendar();
}

function renderCalendar() {
    const grid = document.getElementById('calendarGrid');
    const title = document.getElementById('calTitle');
    grid.innerHTML = "";
    const year = calCurrentDate.getFullYear();
    const month = calCurrentDate.getMonth();
    title.innerText = year + "년 " + calCurrentDate.toLocaleString('default', { month: 'long' });
    const firstDay = new Date(year, month, 1);
    const startDay = firstDay.getDay();
    const lastDate = new Date(year, month + 1, 0).getDate();
    const prevLastDate = new Date(year, month, 0).getDate();
    const today = new Date();
    today.setHours(0,0,0,0);
    let dayCount = 1;
    let nextMonthDay = 1;
    for (let i = 0; i < 42; i++) {
        const cell = document.createElement('div');
        cell.className = 'cal-cell';
        let displayDate;
        let isOtherMonth = false;
        if (i < startDay) {
            displayDate = new Date(year, month - 1, prevLastDate - startDay + i + 1);
            isOtherMonth = true;
        } else if (dayCount > lastDate) {
            displayDate = new Date(year, month + 1, nextMonthDay++);
            isOtherMonth = true;
        } else {
            displayDate = new Date(year, month, dayCount++);
        }
        const ymd = formatDate(displayDate);
        const num = document.createElement('div');
        num.className = 'cal-date-num';
        num.innerText = displayDate.getDate();
        cell.appendChild(num);
        if (isOtherMonth) cell.classList.add('other-month');
        if (displayDate.getTime() === today.getTime()) cell.classList.add('today');
        if (memoData[ymd]) {
            const dot = document.createElement('div');
            dot.className = 'memo-dot';
            cell.appendChild(dot);
        }
        cell.onclick = function() { openMemoModal(displayDate); };
        grid.appendChild(cell);
    }
}

function openMemoModal(dateObj) {
    selectedMemoDate = new Date(dateObj);
    const ymd = formatDate(selectedMemoDate);
    document.getElementById('memoDateText').innerText = selectedMemoDate.getFullYear() + "년 " + (selectedMemoDate.getMonth() + 1) + "월 " + selectedMemoDate.getDate() + "일";
    document.getElementById('memoTextarea').value = memoData[ymd] || "";
    document.getElementById('memoModalBg').style.display = 'flex';
}

function closeMemoModal() { document.getElementById('memoModalBg').style.display = 'none'; }

function saveMemo() {
    const text = document.getElementById('memoTextarea').value.trim();
    const ymd = formatDate(selectedMemoDate);
    if (text) { memoData[ymd] = text; } else { delete memoData[ymd]; }
    saveMemoStorage();
    closeMemoModal();
    renderCalendar();
}

function deleteMemo() {
    const ymd = formatDate(selectedMemoDate);
    delete memoData[ymd];
    saveMemoStorage();
    closeMemoModal();
    renderCalendar();
}

function formatDate(d) {
    const m = (d.getMonth() + 1).toString().padStart(2, '0');
    const day = d.getDate().toString().padStart(2, '0');
    return d.getFullYear() + "-" + m + "-" + day;
}

function saveMemoStorage() { localStorage.setItem("adminCalendarMemos", JSON.stringify(memoData)); }

function loadMemoStorage() {
    const saved = localStorage.getItem("adminCalendarMemos");
    if (saved) memoData = JSON.parse(saved);
}

let todos = [];

function initTodos() {
    const saved = localStorage.getItem("adminTodos");
    if (saved) todos = JSON.parse(saved);
    else {
        todos = [
            { text: "오전 결제 건 발송", done: true },
            { text: "CS 주간 리포트 작성", done: false }
        ];
    }
    renderTodos();
}

function saveTodos() { localStorage.setItem("adminTodos", JSON.stringify(todos)); }

function renderTodos() {
    const list = document.getElementById('todoList');
    list.innerHTML = "";
    todos.forEach((todo, idx) => {
        const row = document.createElement('div');
        row.className = 'todo-item';
        const chk = document.createElement('div');
        chk.className = 'todo-check' + (todo.done ? ' checked' : '');
        chk.onclick = function() {
            todo.done = !todo.done;
            saveTodos();
            renderTodos();
        };
        const input = document.createElement('input');
        input.type = 'text';
        input.className = 'todo-text' + (todo.done ? ' done' : '');
        input.value = todo.text;
        input.onchange = function() {
            todo.text = this.value;
            saveTodos();
        };
        const del = document.createElement('i');
        del.className = 'fas fa-trash todo-del';
        del.onclick = function() {
            todos.splice(idx, 1);
            saveTodos();
            renderTodos();
        };
        row.appendChild(chk);
        row.appendChild(input);
        row.appendChild(del);
        list.appendChild(row);
    });
}

function addTodo() {
    todos.unshift({ text: "", done: false });
    renderTodos();
    saveTodos();
}
</script>
</body>
</html>