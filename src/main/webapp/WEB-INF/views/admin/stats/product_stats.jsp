<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 통계 분석 | MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_product_stats.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                <div class="page-header">
				    <div class="header-text">
				        <h3 class="page-title">상품 통계 분석</h3>
				        <p class="page-desc">Product Analytics</p>
				    </div>
				    <button type="button" id="btnRefresh" class="btn-refresh" title="데이터 갱신">
				        <span class="icon-box">
				            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
				                <path d="M4 12C4 16.4183 7.58172 20 12 20C14.5422 20 16.7944 18.8118 18.242 16.945M20 12C20 7.58172 16.4183 4 12 4C9.55998 4 7.38883 5.09349 5.92383 6.81665" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
				                <path d="M6 3V7H2" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
				            </svg>
				        </span>
				        <span>새로고침</span>
				    </button>
				</div>

                <div class="stat-card-grid">
				    <div class="stat-card">
				        <span class="stat-label">UNANSWERED INQUIRIES (1:1 문의)</span>
				        <div class="stat-value text-orange" id="inquiryCount">0 건</div>
				    </div>
				
				    <div class="stat-card" style="border-left: 4px solid #d93025;">
				        <span class="stat-label">SOLD OUT PRODUCTS (STOCK 0)</span>
				        <div class="stat-value" id="soldOutCount" style="color: #d93025;">0 개</div>
				    </div>
				
				    <div class="stat-card">
				        <span class="stat-label">LOW STOCK ALERT (1~10 left)</span>
				        <div class="stat-value" id="lowStockCount">0 개</div>
				    </div>
				</div>

                <div class="chart-row-2">
                    <div class="card-box">
                        <h5 class="chart-title">ORDER STATUS TREND</h5>
                        <div class="chart-container-sm">
                            <canvas id="statusChart"></canvas>
                        </div>
                    </div>
                    <div class="card-box">
                        <h5 class="chart-title">REVENUE BY CATEGORY</h5>
                        <div class="chart-container-sm">
                            <canvas id="categoryChart"></canvas>
                        </div>
                    </div>
                </div>

                <div class="card-box mt-4">
                    <h5 class="chart-title">TOP 10 BEST SELLERS</h5>
                    <div class="chart-container-lg">
                        <canvas id="bestSellerChart"></canvas>
                    </div>
                </div>

                <div class="chart-row-2 mt-4">
                    <div class="card-box">
                        <h5 class="chart-title">MOST WISHLISTED PRODUCTS</h5>
                        <div class="chart-container-md">
                            <canvas id="wishlistChart"></canvas>
                        </div>
                    </div>
                    <div class="card-box">
                        <h5 class="chart-title">MOST CART ADDED PRODUCTS</h5>
                        <div class="chart-container-md">
                            <canvas id="cartChart"></canvas>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <script src="${pageContext.request.contextPath}/dist/js/admin_product_stats.js"></script>
</body>
</html>