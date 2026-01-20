<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>방문자 통계 분석 | MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_visitor_stats.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                <div class="page-header">
                    <h3 class="page-title">방문자 통계 분석</h3>
                    <p class="page-desc">Visitor Traffic & Referral Analytics</p>
                </div>

                <div class="stat-card-grid three-cols">
				    <div class="stat-card">
				        <div class="card-icon-wrapper basic-icon">
				            <i class="fas fa-mouse-pointer"></i>
				        </div>
				        <div class="card-text-wrapper">
				            <span class="stat-label">TODAY LOGIN</span>
				            <div class="stat-value" id="todayTotalLogin">0 회</div>
				        </div>
				    </div>
				
				    <div class="stat-card active-user-card">
				        <div class="card-top-row">
				            <span class="live-indicator">
				                <span class="live-dot"></span>
				                <span class="live-text">LIVE</span>
				            </span>
				            <div class="card-icon-wrapper live-icon">
				                <i class="fas fa-globe"></i>
				            </div>
				        </div>
				        <div class="card-text-wrapper mt-2">
				            <span class="stat-label">NOW ACTIVE</span>
				            <div class="stat-value highlight-green">${currentCount} 명</div>
				        </div>
				    </div>
				
				    <div class="stat-card">
				        <div class="card-icon-wrapper visitor-icon">
				            <i class="fas fa-users"></i>
				        </div>
				        <div class="card-text-wrapper">
				            <span class="stat-label">TODAY VISITORS</span>
				            <div class="stat-value">${todayCount} 명</div>
				            <span class="stat-sub">사이트 방문자</span>
				        </div>
				    </div>
				</div>

                <div class="chart-row">
                    <div class="card-box full-width">
                        <div class="chart-header" style="display:flex; justify-content:space-between; align-items:center;">
                            <h5 class="chart-title">DAU (Daily/Monthly Active Users)</h5>
                            <div class="btn-group" role="group" aria-label="Date Toggle">
                                <input type="radio" class="btn-check" name="dauMode" id="modeDaily" value="daily" checked autocomplete="off">
                                <label class="btn btn-outline-dark btn-sm" for="modeDaily">일별 (Daily)</label>

                                <input type="radio" class="btn-check" name="dauMode" id="modeMonthly" value="monthly" autocomplete="off">
                                <label class="btn btn-outline-dark btn-sm" for="modeMonthly">월별 (Monthly)</label>
                            </div>
                        </div>
                        <div class="chart-container" style="height: 350px;">
                            <canvas id="dauChart"></canvas>
                        </div>
                    </div>
                </div>

                <div class="chart-grid">
                    <div class="card-box">
                        <h5 class="chart-title">HOURLY TRAFFIC (최근 30일)</h5>
                        <div class="chart-container">
                            <canvas id="hourlyChart"></canvas>
                        </div>
                    </div>

                    <div class="card-box">
                        <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom: 20px;">
                            <h5 class="chart-title" style="border:none; margin:0;">TOP REFERRAL SOURCES</h5>
                        </div>
                        <div class="chart-container">
                             <canvas id="referralChart"></canvas>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <script src="${pageContext.request.contextPath}/dist/js/admin_visitor_stats.js"></script>
</body>
</html>