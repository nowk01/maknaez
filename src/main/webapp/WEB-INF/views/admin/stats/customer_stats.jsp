<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 통계 분석 | MAKNAEZ ADMIN</title>
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
                    <h3 class="page-title">회원 & VIP 분석</h3>
                    <p class="page-desc">Customer Demographics & VIP Ranking</p>
                </div>

                <div class="stat-card-grid">
                    <div class="stat-card">
                        <span class="stat-label">TOTAL MEMBERS</span>
                        <div class="stat-value" id="totalMember">0 명</div>
                    </div>
                    <div class="stat-card">
                        <span class="stat-label">NEW MEMBERS (7 DAYS)</span>
                        <div class="stat-value text-orange" id="newMember7">0 명</div>
                    </div>
                   <div class="stat-card">
					    <span class="stat-label">TOP VIP RATIO (> LV.40)</span>
					    <div class="stat-value" id="vipRatio">0 %</div> </div>
                </div>

                <div class="chart-row-2">
                    <div class="card-box">
                        <h5 class="chart-title">NEW REGISTRATION TREND (7 DAYS)</h5>
                        <div class="chart-container-sm">
                            <canvas id="trendChart"></canvas>
                        </div>
                    </div>
                    <div class="card-box">
                        <h5 class="chart-title">MEMBER GRADE DISTRIBUTION</h5>
                        <div class="chart-container-sm">
                            <canvas id="gradeChart"></canvas>
                        </div>
                    </div>
                </div>

                <div class="chart-row-2">
                    <div class="card-box">
                        <h5 class="chart-title">AGE GROUP DISTRIBUTION</h5>
                        <div class="chart-container-sm">
                            <canvas id="ageChart"></canvas>
                        </div>
                    </div>
                    <div class="card-box">
                        <h5 class="chart-title">GENDER RATIO</h5>
                        <div class="chart-container-sm">
                            <canvas id="genderChart"></canvas>
                        </div>
                    </div>
                </div>

                <div class="card-box mt-4">
                    <h5 class="chart-title">
                        VIP CUSTOMER RANKING
                        <small style="font-size:12px; color:#999; font-weight:normal; margin-left:10px;">
                            * 컬럼 헤더를 클릭하여 정렬하세요 (Excel Style)
                        </small>
                    </h5>
                    
                    <div class="table-responsive">
					    <table class="table table-hover vip-table" id="vipTable">
					        <thead>
					            <tr>
					                <th style="cursor: default;">순위</th>
					                <th style="cursor: default;">회원 ID</th>
					                <th style="cursor: default;">회원명</th>
					                
					                <th onclick="sortTable(3)">등급 <span class="sort-icon"></span></th>
					                <th onclick="sortTable(4, 'num')">구매 횟수 <span class="sort-icon">▼</span></th>
					                <th onclick="sortTable(5, 'money')">누적 구매 금액 <span class="sort-icon"></span></th>
					                <th onclick="sortTable(6)">가입일 <span class="sort-icon"></span></th>
					            </tr>
					        </thead>
					        <tbody id="vipTableBody">
					            </tbody>
					    </table>
					</div>
                </div>

            </div>
        </div>
    </div>
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <script src="${pageContext.request.contextPath}/dist/js/admin_customer_stats.js"></script>
</body>
</html>