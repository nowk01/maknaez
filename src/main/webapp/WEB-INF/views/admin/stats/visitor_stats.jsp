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

                <div class="stat-card-grid">
                    <div class="stat-card"><span class="stat-label">TODAY VISITORS</span><div class="stat-value">1,240 명</div></div>
                    <div class="stat-card"><span class="stat-label">TOTAL PAGE VIEWS</span><div class="stat-value">5,892 PV</div></div>
                    <div class="stat-card"><span class="stat-label">AVG. STAY TIME</span><div class="stat-value">04:25</div></div>
                    <div class="stat-card"><span class="stat-label">BOUNCE RATE</span><div class="stat-value" style="color: #ff4e00;">32.5%</div></div>
                </div>

                <div class="chart-grid">
                    <div class="card-box">
                        <h5 class="chart-title">일일 방문자 추이 (Daily Traffic)</h5>
                        <div class="chart-container"><canvas id="visitorChart"></canvas></div>
                    </div>
                    <div class="card-box">
                        <h5 class="chart-title">유입 경로 분석 (Referrer Ratio)</h5>
                        <div class="chart-container"><canvas id="referralChart"></canvas></div>
                    </div>
                </div>

                <div class="card-box">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 style="font-size:15px; font-weight:800; color:#1a1c1e; margin:0;">TOP REFERRAL SOURCES</h5>
                        <button type="button" class="btn-luxury">TRAFFIC REPORT DOWNLOAD</button>
                    </div>
                    <table class="table">
                        <thead>
                            <tr><th>RANK</th><th>유입 소스(Source)</th><th>방문수</th><th>직전 대비</th><th>전환율(CVR)</th></tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><span class="rank-badge">1</span></td>
                                <td class="fw-bold">Naver Search <small class="text-muted">(Organic)</small></td>
                                <td>850 명</td><td style="color:#1cc88a; font-weight:700;">▲ 12%</td><td>3.2%</td>
                            </tr>
                            <tr>
                                <td><span class="rank-badge">2</span></td>
                                <td class="fw-bold">Instagram Ads <small class="text-muted">(Social)</small></td>
                                <td>420 명</td><td style="color:#ff4e00; font-weight:700;">▼ 5%</td><td>5.8%</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <script src="${pageContext.request.contextPath}/dist/js/admin_visitor_stats.js"></script>
</body>
</html>