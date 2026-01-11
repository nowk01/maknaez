<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>고객 통계 분석 | MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_customer_stats.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                <div class="page-header">
                    <h3 class="page-title">고객 통계 분석</h3>
                    <p class="page-desc">Customer Demographics & Behavior Analytics</p>
                </div>

                <div class="stat-card-grid">
                    <div class="stat-card"><span class="stat-label">TOTAL MEMBERS</span><div class="stat-value">2,958 명</div></div>
                    <div class="stat-card"><span class="stat-label">NEW MEMBERS</span><div class="stat-value point">+ 142</div></div>
                    <div class="stat-card"><span class="stat-label">VIP CUSTOMERS</span><div class="stat-value">85 명</div></div>
                    <div class="stat-card"><span class="stat-label">RETENTION RATE</span><div class="stat-value">64.2%</div></div>
                </div>

                <div class="chart-grid">
                    <div class="card-box">
                        <h5 style="font-size:15px; font-weight:800; color:#111; margin-bottom:20px;">연령대별 분포</h5>
                        <div class="chart-container"><canvas id="ageChart"></canvas></div>
                    </div>
                    <div class="card-box">
                        <h5 style="font-size:15px; font-weight:800; color:#111; margin-bottom:20px;">성별 비중</h5>
                        <div class="chart-container"><canvas id="genderChart"></canvas></div>
                    </div>
                </div>

                <div class="card-box">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 style="font-size:15px; font-weight:800; color:#111; margin:0;">VIP CUSTOMER RANKING</h5>
                        <button class="btn btn-sm btn-outline-dark" style="border-radius:0; font-weight:700; padding:8px 20px;">EXCEL DOWNLOAD</button>
                    </div>
                    <table class="table">
                        <thead>
                            <tr><th>순위</th><th>고객명(ID)</th><th>구매 횟수</th><th>누적 구매금액</th><th>최근 구매일</th><th>등급</th></tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><span class="rank-badge">TOP 1</span></td>
                                <td class="fw-bold">진격의거인 <small class="text-muted">(user_titan)</small></td>
                                <td>24회</td><td class="fw-bold" style="color:#ff4e00;">₩ 12,450,000</td><td>2026.01.10</td><td><span style="color:#ff4e00; font-weight:800;">LEGEND</span></td>
                            </tr>
                            <tr>
                                <td><span class="rank-badge">TOP 2</span></td>
                                <td class="fw-bold">나루토 <small class="text-muted">(ninja_77)</small></td>
                                <td>18회</td><td class="fw-bold">₩ 8,900,000</td><td>2026.01.08</td><td><span style="font-weight:800;">VIP</span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <script src="${pageContext.request.contextPath}/dist/js/admin_customer_stats.js"></script>
</body>
</html>