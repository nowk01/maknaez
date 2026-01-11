<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>매출 분석 통계 | MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_sales_stats.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                <div class="page-header">
                    <h3 class="page-title">매출 분석 통계</h3>
                    <p class="page-desc">Revenue & Sales Performance Analytics</p>
                </div>

                <div class="stat-card-grid">
                    <div class="stat-card">
                        <span class="stat-label">TODAY SALES</span>
                        <div class="stat-value point">₩ 2,450,000</div>
                    </div>
                    <div class="stat-card">
                        <span class="stat-label">MONTHLY TOTAL</span>
                        <div class="stat-value">₩ 84,200,000</div>
                    </div>
                    <div class="stat-card">
                        <span class="stat-label">AVG. PRICE</span>
                        <div class="stat-value">₩ 145,000</div>
                    </div>
                    <div class="stat-card">
                        <span class="stat-label">ORDERS</span>
                        <div class="stat-value">158 건</div>
                    </div>
                </div>

                <div class="card-box">
                    <div class="chart-header" style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 25px;">
                        <div>
                            <span style="font-size: 15px; font-weight: 800; color: #111;">WEEKLY REVENUE TREND</span>
                            <p style="font-size: 12px; color: #aaa; margin-top: 4px;">마우스를 그래프 위에 올려 상세 데이터를 확인하세요.</p>
                        </div>
                        <div style="font-size: 11px; color: #ff4e00; font-weight: 700; border: 1px solid #ff4e00; padding: 2px 8px; border-radius: 20px;">
                            LIVE ANALYTICS
                        </div>
                    </div>
                    <div class="chart-container" style="position: relative; height: 350px; width: 100%;">
                        <canvas id="premiumSalesChart"></canvas>
                    </div>
                </div>

                <div class="card-box">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 style="font-size:15px; font-weight:800; color:#111; margin:0;">TOP SELLING PRODUCTS</h5>
                        <button type="button" class="btn btn-dark" style="width:180px; height:45px; font-weight:700; font-size:13px; border-radius:1px;" onclick="downloadStats()">
                            REPORT DOWNLOAD
                        </button>
                    </div>

                    <table class="table">
                        <thead>
                            <tr>
                                <th style="width:80px;">RANK</th>
                                <th style="text-align:left;">PRODUCT NAME (ITEM)</th>
                                <th>SOLD QTY</th>
                                <th>NET REVENUE</th>
                                <th>SHARE (%)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td style="font-weight:800; color:#ff4e00;">01</td>
                                <td style="text-align:left; font-weight:700;">MAKNAEZ Retro High 2026 Black</td>
                                <td>45 켤레</td>
                                <td style="font-weight:800;">₩ 8,325,000</td>
                                <td style="color:#888;">12.4%</td>
                            </tr>
                            <tr>
                                <td style="font-weight:800;">02</td>
                                <td style="text-align:left; font-weight:700;">Court Classic Low-V1 White</td>
                                <td>38 켤레</td>
                                <td style="font-weight:800;">₩ 4,940,000</td>
                                <td style="color:#888;">9.8%</td>
                            </tr>
                            <tr>
                                <td style="font-weight:800;">03</td>
                                <td style="text-align:left; font-weight:700;">Dunk Low Panda Custom</td>
                                <td>32 켤레</td>
                                <td style="font-weight:800;">₩ 4,160,000</td>
                                <td style="color:#888;">8.1%</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <script src="${pageContext.request.contextPath}/dist/js/admin_sales_stats.js?v=1.2"></script>
</body>
</html>