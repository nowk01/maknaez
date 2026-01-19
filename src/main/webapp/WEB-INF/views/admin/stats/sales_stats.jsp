<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>매출 분석 통계 | MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_sales_stats.css">
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
                        <span class="stat-label">TODAY REVENUE</span>
                        <div class="stat-value point" id="card-today-sales">₩ 0</div>
                        <span class="stat-desc">오늘 하루 결제 완료 금액</span>
                    </div>
                    <div class="stat-card">
                        <span class="stat-label">MONTHLY REVENUE</span>
                        <div class="stat-value" id="card-month-sales">₩ 0</div>
                        <span class="stat-desc">이번 달 누적 결제 금액</span>
                    </div>
                    <div class="stat-card">
                        <span class="stat-label">TODAY ORDERS</span>
                        <div class="stat-value" id="card-order-count">0 건</div>
                        <span class="stat-desc">오늘 신규 주문 (취소 제외)</span>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-8 mb-4">
                        <div class="card-box">
                            <h4 class="box-title">최근 7일 매출 추이</h4>
                            <div class="chart-container" style="height: 350px;">
                                <canvas id="salesChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-4 mb-4">
                        <div class="card-box">
                            <h4 class="box-title">인기 판매 상품 (TOP 5)</h4>
                            <div class="table-responsive">
                                <table class="table table-hover" id="top-product-table">
                                    <thead>
                                        <tr>
                                            <th>순위</th>
                                            <th>상품명</th>
                                            <th class="text-end">금액</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <script src="${pageContext.request.contextPath}/dist/js/admin_sales_stats.js"></script>
</body>
</html>