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
        /* Flatpickr Custom Style */
        .flatpickr-calendar {
            border: none !important;
            border-radius: 16px !important;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2) !important;
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

        /* Layout */
        html, body { height: 100vh; overflow: hidden; background-color: #f5f6f8; font-family: 'Pretendard', sans-serif; color: #333; }
        #wrapper { display: flex; height: 100%; width: 100%; }
        
        #page-content-wrapper { 
            flex-grow: 1; display: flex; flex-direction: column; min-width: 0; height: 100%; 
            overflow-y: auto;
        }
        
        .workspace { 
            flex-grow: 1; padding: 25px 35px; display: grid; 
            grid-template-columns: 6.5fr 3.5fr; 
            grid-template-rows: 130px minmax(500px, 1fr);
            gap: 25px; 
            height: auto; 
            min-height: calc(100vh - 70px);
        }

        .card-box { 
            background: #fff; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.02); 
            border: 1px solid rgba(0,0,0,0.03); padding: 24px; display: flex; flex-direction: column; 
            transition: transform 0.2s ease-in-out; 
            overflow: visible !important;
        }
        .card-box:hover { transform: translateY(-3px); box-shadow: 0 8px 25px rgba(0,0,0,0.05); }

        .stats-grid { grid-column: 1 / 2; display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; }
        .stat-item { justify-content: center; padding: 20px; }
        .stat-label { font-size: 0.8rem; color: #999; font-weight: 600; margin-bottom: 8px; }
        .stat-val { font-family: 'Manrope', sans-serif; font-size: 1.5rem; font-weight: 800; color: #2d3436; }
        .stat-badge { font-size: 0.7rem; font-weight: 700; margin-left: 8px; padding: 3px 8px; border-radius: 6px; display: inline-block; vertical-align: middle; }
        .bg-up { background: #e6fcf5; color: #00b894; } .bg-down { background: #fff5f5; color: #ff6b6b; } .bg-neutral { background: #f1f3f5; color: #868e96; }

        .chart-section { grid-column: 1 / 2; grid-row: 2 / 3; overflow: hidden; min-height: 400px; }
        .chart-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .chart-title { font-weight: 800; font-size: 1.1rem; color: #2d3436; }
        .chart-canvas-wrapper { flex-grow: 1; position: relative; width: 100%; height: 100%; }

        .side-stack { grid-column: 2 / 3; grid-row: 1 / 3; display: flex; flex-direction: column; gap: 25px; height: 100%; overflow: visible !important; }

        .schedule-card { flex: 1; padding: 0; overflow: visible !important; border-radius: 20px; min-height: 520px; }
        .cal-area { padding: 25px 25px 15px 25px; background: #fff; border-bottom: 1px solid #f1f3f5; border-radius: 20px 20px 0 0; }
        .cal-header-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; position: relative; z-index: 100; }
        .cal-nav-wrapper { display: flex; align-items: center; gap: 12px; }
        .cal-header-text { font-size: 1.2rem; font-weight: 800; color:#2d3436; min-width: 150px; text-align: center; font-family: 'Manrope', sans-serif; }
        .nav-arrow-btn { color: #adb5bd; cursor: pointer; font-size: 1rem; padding: 5px; transition: 0.2s; }
        .nav-arrow-btn:hover { color: #ff4e00; transform: scale(1.2); }
        .btn-cal-toggle { background-color: #ff4e00; color: #fff; border: none; width: 36px; height: 36px; border-radius: 10px; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: 0.2s; box-shadow: 0 4px 10px rgba(255, 78, 0, 0.2); }
        .btn-cal-toggle:hover { background-color: #e04400; transform: scale(1.05); }
        .cal-weekdays { display: flex; justify-content: space-between; margin-bottom: 12px; color: #adb5bd; font-size: 0.75rem; font-weight: 700; padding: 0 5px; }
        .cal-days { display: flex; justify-content: space-between; font-weight: 600; font-size: 0.95rem; color: #495057; }
        .cal-d { width: 36px; height: 36px; line-height: 36px; text-align: center; border-radius: 10px; cursor: pointer; transition: 0.2s; font-family: 'Manrope', sans-serif; position: relative; }
        .cal-d:hover { background: #f8f9fa; color: #000; }
        .cal-d.active { background: #2d3436; color: #fff; box-shadow: 0 4px 12px rgba(45, 52, 54, 0.3); transform: scale(1.1); font-weight: 800; }
        .cal-d.other-month { color: #e9ecef; } 

        .memo-dot {
            position: absolute;
            bottom: 4px;
            left: 50%;
            transform: translateX(-50%);
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: #ff4e00;
        }

        .memo-preview {
            position: absolute;
            top: 42px;
            left: 50%;
            transform: translateX(-50%);
            background: #fff4ec;
            color: #ff4e00;
            font-size: 0.65rem;
            padding: 2px 6px;
            border-radius: 6px;
            white-space: nowrap;
            max-width: 70px;
            overflow: hidden;
            text-overflow: ellipsis;
            box-shadow: 0 2px 6px rgba(255,78,0,0.2);
        }

        .todo-area { flex-grow: 1; padding: 20px 25px; background: #fdfdfd; overflow-y: auto; border-radius: 0 0 20px 20px; }
        .todo-title { font-size: 0.9rem; font-weight: 700; margin-bottom: 12px; color: #868e96; display:flex; justify-content:space-between; align-items:center; }
        .todo-add-btn { border:none; background:#ff4e00; color:#fff; border-radius:8px; padding:4px 10px; font-size:0.75rem; cursor:pointer; }
        .todo-add-btn:hover { background:#e04400; }

        .todo-row { background: #fff; padding: 12px 14px; border-radius: 12px; margin-bottom: 10px; border: 1px solid #f1f3f5; display: flex; align-items: center; gap:10px; transition: all 0.2s; }
        .todo-row:hover { transform: translateX(3px); border-color: #e9ecef; box-shadow: 0 2px 8px rgba(0,0,0,0.02); }

        .custom-chk { width: 20px; height: 20px; border: 2px solid #ced4da; border-radius: 6px; display: flex; align-items: center; justify-content: center; cursor: pointer; flex-shrink:0; }
        .custom-chk.checked { background: #ff4e00; border-color: #ff4e00; } 
        .custom-chk.checked::after { content: '✔'; color: #fff; font-size: 10px; }

        .todo-content { font-size: 0.85rem; font-weight: 500; color: #495057; flex-grow:1; cursor:text; }
        .todo-content.done { text-decoration: line-through; color: #adb5bd; }

        .todo-del { border:none; background:none; color:#adb5bd; cursor:pointer; font-size:0.8rem; }
        .todo-del:hover { color:#ff6b6b; }

        /* ===== Modal ===== */
        .memo-modal-backdrop {
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.35);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 99999;
        }
        .memo-modal {
            background: #fff;
            border-radius: 16px;
            width: 320px;
            padding: 20px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.2);
            animation: pop 0.2s ease;
        }
        @keyframes pop {
            from { transform: scale(0.95); opacity:0; }
            to { transform: scale(1); opacity:1; }
        }
        .memo-modal h4 {
            margin: 0 0 10px;
            font-size: 1rem;
            font-weight: 800;
            color:#2d3436;
        }
        .memo-modal textarea {
            width: 100%;
            height: 90px;
            border-radius: 10px;
            border: 1px solid #dee2e6;
            padding: 10px;
            resize: none;
            font-size: 0.85rem;
            outline: none;
        }
        .memo-modal textarea:focus { border-color:#ff4e00; box-shadow:0 0 0 3px rgba(255,78,0,0.1); }
        .memo-modal-actions {
            margin-top: 12px;
            display:flex;
            justify-content:flex-end;
            gap:8px;
        }
        .memo-btn {
            border:none;
            border-radius:8px;
            padding:6px 14px;
            font-size:0.8rem;
            cursor:pointer;
        }
        .memo-btn.cancel { background:#f1f3f5; color:#495057; }
        .memo-btn.save { background:#ff4e00; color:#fff; }
        .memo-btn.delete { background:#fff5f5; color:#ff6b6b; margin-right:auto; }
        .memo-btn:hover { opacity:0.85; }

        .hidden-date-input { position: absolute; right: 0; top: 0; opacity: 0; width: 0; height: 0; pointer-events: none; }
    </style>
</head>
<body>

<div id="wrapper">
    <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

    <div id="page-content-wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

        <div class="workspace">
            <!-- ================= LEFT SIDE (UNCHANGED) ================= -->
            <div class="stats-grid">
			    <div class="card-box stat-item" 
			         onclick="location.href='${pageContext.request.contextPath}/admin/stats/sales_stats'" 
			         style="cursor: pointer;">
			        <div class="stat-label">오늘의 매출</div>
			        <div class="d-flex align-items-center">
			            <div class="stat-val" id="main-today-sales">loading...</div>
			            <span class="stat-badge" id="main-diff-sales"></span>
			        </div>
			    </div>
			
			    <div class="card-box stat-item" 
			         onclick="location.href='${pageContext.request.contextPath}/admin/order/order_list'" 
			         style="cursor: pointer;">
			        <div class="stat-label">신규 주문</div>
			        <div class="d-flex align-items-center">
			            <div class="stat-val" id="main-new-orders">loading...</div>
			            <span class="stat-badge" id="main-diff-orders"></span>
			        </div>
			    </div>
			
			    <div class="card-box stat-item" 
			         onclick="location.href='${pageContext.request.contextPath}/admin/cs/inquiry_list'" 
			         style="cursor: pointer;">
			        <div class="stat-label">미답변 문의</div>
			        <div class="d-flex align-items-center">
			            <div class="stat-val" style="color: #ff6b6b;" id="main-inquiry-count">loading...</div>
			            <span class="stat-badge bg-down" id="main-inquiry-badge">! Action</span>
			        </div>
			    </div>
			
			    <div class="card-box stat-item">
			        <div class="stat-label">실시간 방문자</div>
			        <div class="d-flex align-items-center">
			            <div class="stat-val highlight-green">${currentCount}</div>
			            <span class="stat-badge bg-neutral" style="color: #2ecc71; background: #e6f9ed; border: 1px solid #b7ebc9;">
			                <span class="live-dot" style="display:inline-block; width:6px; height:6px; background:#2ecc71; border-radius:50%; margin-right:4px;"></span>
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

            <!-- ================= RIGHT SIDE (YOU OWN THIS) ================= -->
            <div class="side-stack">
                <!-- ===== CALENDAR + TODO ===== -->
                <div class="card-box schedule-card">
                    <div class="cal-area">
                        <div class="cal-header-row">
                            <div class="cal-nav-wrapper">
                                <i class="fas fa-chevron-left nav-arrow-btn" onclick="changeWeek(-1)"></i>
                                <div class="cal-header-text" id="calDisplayMonth">January 2026</div>
                                <i class="fas fa-chevron-right nav-arrow-btn" onclick="changeWeek(1)"></i>
                            </div>
                            
                            <div id="calBtnWrapper" style="position: relative;">
                                <button type="button" class="btn-cal-toggle" id="openCalBtn">
                                    <i class="fas fa-calendar-alt"></i>
                                </button>
                                <input type="text" id="hiddenDatePick" class="hidden-date-input">
                            </div>
                        </div>

                        <div class="cal-weekdays"><span>S</span><span>M</span><span>T</span><span>W</span><span>T</span><span>F</span><span>S</span></div>
                        <div class="cal-days" id="weekGrid"></div>
                    </div>

                    <div class="todo-area">
                        <div class="todo-title">
                            오늘 할 일
                            <button class="todo-add-btn" onclick="addTodo()">+ 추가</button>
                        </div>
                        <div id="todoList"></div>
                    </div>
                </div>
            </div> 
        </div>
    </div>
</div>

<!-- ===== Memo Modal ===== -->
<div class="memo-modal-backdrop" id="memoModal">
    <div class="memo-modal">
        <h4 id="memoModalTitle">메모</h4>
        <textarea id="memoTextarea" placeholder="메모를 입력하세요..."></textarea>
        <div class="memo-modal-actions">
            <button class="memo-btn delete" id="memoDeleteBtn" onclick="deleteMemo()">삭제</button>
            <button class="memo-btn cancel" onclick="closeMemoModal()">취소</button>
            <button class="memo-btn save" onclick="saveMemo()">저장</button>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://npmcdn.com/flatpickr/dist/l10n/ko.js"></script>

<script>
    /* ===================== LEFT SIDE ORIGINAL JS (UNCHANGED) ===================== */
    let mainChartInstance = null;
    let currentWeekStart = new Date(); 
    const day = currentWeekStart.getDay();
    currentWeekStart.setDate(currentWeekStart.getDate() - day); 

    document.addEventListener("DOMContentLoaded", function() {
        loadMainSalesData('daily');
        loadInquiryData();
        renderWeekView();
        initTodos();
        initMemos();
        updateOnlineCount();

        const today = new Date();
        const tomorrow = new Date();
        tomorrow.setDate(today.getDate() + 1);

        const fp = flatpickr("#hiddenDatePick", {
            locale: "ko",
            mode: "range",
            defaultDate: [today, tomorrow],
            dateFormat: "Y-m-d",
            appendTo: document.getElementById('calBtnWrapper'),
            position: 'auto',
            onClose: function(selectedDates) {
                if(selectedDates.length > 0) {
                    currentWeekStart = new Date(selectedDates[0]);
                    const d = currentWeekStart.getDay();
                    currentWeekStart.setDate(currentWeekStart.getDate() - d);
                    renderWeekView();
                }
            }
        });
        document.getElementById('openCalBtn').addEventListener('click', function() { fp.open(); });
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
                    $badge.text('! Action')
                          .removeClass('bg-neutral').addClass('bg-down') 
                          .show();
                } else {
                    $badge.text('✓ Clear')
                          .removeClass('bg-down').addClass('bg-neutral') 
                          .css('color', '#2ecc71'); 
                }
            },
            error: function(err) {
                console.error("미답변 문의 로드 실패:", err);
            }
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
            error: function(error) { console.error("매출 데이터 로드 실패:", error); }
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
                    label: 'Sales Revenue', data: revenues, 
                    borderColor: '#ff4e00', borderWidth: 2.5, backgroundColor: gradient, 
                    pointBackgroundColor: '#fff', pointBorderColor: '#ff4e00', 
                    pointBorderWidth: 2, pointRadius: 4, pointHoverRadius: 6, tension: 0.35, fill: true 
                }]
            },
            options: { 
                responsive: true, maintainAspectRatio: false, 
                plugins: { 
                    legend: { display: false }, 
                    tooltip: { 
                        backgroundColor: 'rgba(0,0,0,0.8)', padding: 10, cornerRadius: 8, displayColors: false,
                        callbacks: { label: function(c) { return ' ₩ ' + new Intl.NumberFormat('ko-KR').format(c.parsed.y); } }
                    } 
                }, 
                scales: { 
                    x: { grid: { display: false }, ticks: { color: '#adb5bd', font: { size: 11 } } }, 
                    y: { beginAtZero: true, border: { display: false }, grid: { color: '#f1f3f5', borderDash: [5, 5] }, ticks: { color: '#adb5bd', callback: function(v) { return new Intl.NumberFormat('ko-KR', { notation: "compact" }).format(v); } } } 
                }, 
                layout: { padding: { top: 10, bottom: 10, left: 0, right: 0 } } 
            }
        });
    }

    function updateButtonStyles(mode) {
        const btnW = document.getElementById('btnWeekly');
        const btnM = document.getElementById('btnMonthly');
        if (mode === 'daily') { 
            btnW.classList.replace('btn-outline-light', 'btn-dark'); btnW.classList.remove('text-dark', 'border');
            btnM.classList.replace('btn-dark', 'btn-outline-light'); btnM.classList.add('text-dark', 'border');
        } else { 
            btnM.classList.replace('btn-outline-light', 'btn-dark'); btnM.classList.remove('text-dark', 'border');
            btnW.classList.replace('btn-dark', 'btn-outline-light'); btnW.classList.add('text-dark', 'border');
        }
    }

    function updateOnlineCount() {
        const el = document.getElementById('onlineCount');
        if(el) el.innerText = document.querySelectorAll('.on-dot.active').length + ' Online';
    }

    function changeWeek(direction) {
        currentWeekStart.setDate(currentWeekStart.getDate() + (direction * 7));
        renderWeekView();
    }

    /* ===================== CALENDAR + MEMO ===================== */
    let memoData = {};
    let selectedMemoDate = null;

    function initMemos() {
        const saved = localStorage.getItem('calendarMemos');
        memoData = saved ? JSON.parse(saved) : {};
    }

    function saveMemoStorage() {
        localStorage.setItem('calendarMemos', JSON.stringify(memoData));
    }

    function renderWeekView() {
        const grid = document.getElementById('weekGrid');
        const title = document.getElementById('calDisplayMonth');
        grid.innerHTML = "";
        const today = new Date();
        let tempDate = new Date(currentWeekStart);
        title.innerText = tempDate.toLocaleString('default', { month: 'long' }) + " " + tempDate.getFullYear();

        for (let i = 0; i < 7; i++) {
            const div = document.createElement('div');
            div.className = 'cal-d';
            const yyyyMmDd = tempDate.toISOString().slice(0,10);
            div.innerText = tempDate.getDate();
            div.dataset.date = yyyyMmDd;

            if (tempDate.toDateString() === today.toDateString()) div.classList.add('active');
            if (tempDate.getMonth() !== currentWeekStart.getMonth()) div.classList.add('other-month');

            if (memoData[yyyyMmDd]) {
                const dot = document.createElement('div');
                dot.className = 'memo-dot';
                div.appendChild(dot);

                const preview = document.createElement('div');
                preview.className = 'memo-preview';
                preview.innerText = memoData[yyyyMmDd];
                div.appendChild(preview);
            }
            
            div.onclick = function() {
                document.querySelectorAll('.cal-d').forEach(d => d.classList.remove('active'));
                this.classList.add('active');
                openMemoModal(this.dataset.date);
            };
            grid.appendChild(div);
            tempDate.setDate(tempDate.getDate() + 1);
        }
    }

    function openMemoModal(dateStr) {
        selectedMemoDate = dateStr;
        const modal = document.getElementById('memoModal');
        const textarea = document.getElementById('memoTextarea');
        const delBtn = document.getElementById('memoDeleteBtn');
        document.getElementById('memoModalTitle').innerText = dateStr + " 메모";

        textarea.value = memoData[dateStr] || "";
        delBtn.style.display = memoData[dateStr] ? 'inline-block' : 'none';

        modal.style.display = 'flex';
        textarea.focus();
    }

    function closeMemoModal() {
        document.getElementById('memoModal').style.display = 'none';
        selectedMemoDate = null;
    }

    function saveMemo() {
        const text = document.getElementById('memoTextarea').value.trim();
        if (text) {
            memoData[selectedMemoDate] = text;
        } else {
            delete memoData[selectedMemoDate];
        }
        saveMemoStorage();
        closeMemoModal();
        renderWeekView();
    }

    function deleteMemo() {
        if (selectedMemoDate && memoData[selectedMemoDate]) {
            delete memoData[selectedMemoDate];
            saveMemoStorage();
            closeMemoModal();
            renderWeekView();
        }
    }

    document.getElementById('memoModal').addEventListener('click', function(e) {
        if (e.target === this) closeMemoModal();
    });

    /* ===================== TODO LIST ===================== */
    let todos = [];

    function initTodos() {
        const saved = localStorage.getItem('dashboardTodos');
        todos = saved ? JSON.parse(saved) : [];
        renderTodos();
    }

    function saveTodos() {
        localStorage.setItem('dashboardTodos', JSON.stringify(todos));
    }

    function renderTodos() {
        const list = document.getElementById('todoList');
        list.innerHTML = "";
        todos.forEach((todo, idx) => {
            const row = document.createElement('div');
            row.className = 'todo-row';

            const chk = document.createElement('div');
            chk.className = 'custom-chk' + (todo.done ? ' checked' : '');
            chk.onclick = () => toggleTodo(idx);

            const content = document.createElement('div');
            content.className = 'todo-content' + (todo.done ? ' done' : '');
            content.innerText = todo.text;
            content.ondblclick = () => editTodo(idx, content);

            const del = document.createElement('button');
            del.className = 'todo-del';
            del.innerHTML = '<i class="fas fa-trash"></i>';
            del.onclick = () => deleteTodo(idx);

            row.appendChild(chk);
            row.appendChild(content);
            row.appendChild(del);
            list.appendChild(row);
        });
    }

    function addTodo() {
        const text = prompt("할 일을 입력하세요");
        if (!text) return;
        todos.push({ text, done: false });
        saveTodos();
        renderTodos();
    }

    function toggleTodo(idx) {
        todos[idx].done = !todos[idx].done;
        saveTodos();
        renderTodos();
    }

    function deleteTodo(idx) {
        if (!confirm("삭제할까요?")) return;
        todos.splice(idx, 1);
        saveTodos();
        renderTodos();
    }

    function editTodo(idx, el) {
        const old = todos[idx].text;
        const input = document.createElement('input');
        input.type = 'text';
        input.value = old;
        input.style.width = '100%';
        input.style.border = '1px solid #dee2e6';
        input.style.borderRadius = '6px';
        input.style.padding = '4px 6px';
        el.replaceWith(input);
        input.focus();

        input.onblur = () => finish();
        input.onkeydown = (e) => { if (e.key === 'Enter') finish(); };

        function finish() {
            const val = input.value.trim();
            todos[idx].text = val || old;
            saveTodos();
            renderTodos();
        }
    }
</script>

</body>
</html>
