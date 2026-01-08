<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>매출 통계 - MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    
    <style>
        /* [공통 레이아웃] */
        body { background-color: #f4f6f9; }
        
        .card-box {
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
            padding: 20px;
            margin-bottom: 20px;
            border: none;
        }

        .search-label {
            font-weight: 600;
            font-size: 14px;
            color: #555;
            margin-bottom: 8px;
            display: block;
        }

        /* 테이블 스타일 */
        .table th {
            background-color: #f8f9fa;
            font-weight: 600;
            text-align: center;
            border-bottom: 2px solid #dee2e6;
            vertical-align: middle;
        }
        .table td {
            vertical-align: middle;
            text-align: center;
            font-size: 14px;
        }

        /* [매출 통계 전용 스타일] */
        .stat-summary-card {
            background: #fff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.04);
            border-left: 4px solid #0d6efd; /* 포인트 컬러 */
            height: 100%;
        }
        .stat-title {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 5px;
            font-weight: 500;
        }
        .stat-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: #212529;
        }
        .stat-change {
            font-size: 0.85rem;
            margin-top: 5px;
        }
        .text-increase { color: #0ca678; }
        .text-decrease { color: #fa5252; }

        /* 색상 변형 */
        .border-purple { border-left-color: #7048e8; }
        .border-green { border-left-color: #0ca678; }
        .border-orange { border-left-color: #f76707; }

        /* 차트 영역 */
        .chart-container {
            position: relative;
            height: 350px;
            width: 100%;
        }
    </style>
</head>
<body>

    <div id="wrapper">
        
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

        <div id="page-content-wrapper">
            
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                
                <h3 class="fw-bold mb-4">매출 통계</h3>

                <div class="card-box">
                    <form class="row g-3 align-items-end">
                        <div class="col-md-2">
                            <label class="search-label">기간 설정</label>
                            <select class="form-select">
                                <option selected>일별 보기</option>
                                <option value="month">월별 보기</option>
                                <option value="year">연별 보기</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="search-label">조회 기간</label>
                            <div class="input-group">
                                <input type="date" class="form-control" value="2026-01-01">
                                <span class="input-group-text">~</span>
                                <input type="date" class="form-control" value="2026-01-08">
                            </div>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-primary w-100">조회</button>
                        </div>
                        <div class="col-md-4 text-end">
                            <button type="button" class="btn btn-outline-success">
                                <i class="fas fa-file-excel me-1"></i> 엑셀 다운로드
                            </button>
                        </div>
                    </form>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-md-3">
                        <div class="stat-summary-card">
                            <div class="stat-title">총 매출액</div>
                            <div class="stat-value">₩ 12,580,000</div>
                            <div class="stat-change text-increase">
                                <i class="fas fa-arrow-up"></i> 전주 대비 12%
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-summary-card border-purple">
                            <div class="stat-title">총 주문 건수</div>
                            <div class="stat-value">142 건</div>
                            <div class="stat-change text-increase">
                                <i class="fas fa-arrow-up"></i> 전주 대비 5%
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-summary-card border-green">
                            <div class="stat-title">실 결제 금액</div>
                            <div class="stat-value">₩ 11,200,000</div>
                            <div class="stat-change text-decrease">
                                <i class="fas fa-minus"></i> 변동 없음
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-summary-card border-orange">
                            <div class="stat-title">환불/취소 금액</div>
                            <div class="stat-value">₩ 1,380,000</div>
                            <div class="stat-change text-decrease">
                                <i class="fas fa-arrow-down"></i> 전주 대비 -2% (개선)
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-box">
                    <h5 class="fw-bold mb-4">매출 추이</h5>
                    <div class="chart-container">
                        <canvas id="salesChart"></canvas>
                    </div>
                </div>

                <div class="card-box">
                    <h5 class="fw-bold mb-3">일자별 상세 내역</h5>
                    <table class="table table-hover">
                        <thead class="table-light">
                            <tr>
                                <th>일자</th>
                                <th>주문수</th>
                                <th>주문금액</th>
                                <th>할인금액</th>
                                <th>실결제금액</th>
                                <th>환불금액</th>
                                <th>순매출</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>2026-01-08 (목)</td>
                                <td>25</td>
                                <td>2,500,000</td>
                                <td>100,000</td>
                                <td>2,400,000</td>
                                <td class="text-danger">0</td>
                                <td class="fw-bold text-primary">2,400,000</td>
                            </tr>
                            <tr>
                                <td>2026-01-07 (수)</td>
                                <td>30</td>
                                <td>3,000,000</td>
                                <td>200,000</td>
                                <td>2,800,000</td>
                                <td class="text-danger">-150,000</td>
                                <td class="fw-bold text-primary">2,650,000</td>
                            </tr>
                            <tr>
                                <td>2026-01-06 (화)</td>
                                <td>18</td>
                                <td>1,800,000</td>
                                <td>50,000</td>
                                <td>1,750,000</td>
                                <td class="text-danger">0</td>
                                <td class="fw-bold text-primary">1,750,000</td>
                            </tr>
                            <tr class="table-secondary fw-bold">
                                <td>합계</td>
                                <td>73</td>
                                <td>7,300,000</td>
                                <td>350,000</td>
                                <td>6,950,000</td>
                                <td class="text-danger">-150,000</td>
                                <td class="text-primary">6,800,000</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

            </div> </div> </div> <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var ctx = document.getElementById('salesChart').getContext('2d');
            var salesChart = new Chart(ctx, {
                type: 'line', // 꺾은선 그래프
                data: {
                    labels: ['01-01', '01-02', '01-03', '01-04', '01-05', '01-06', '01-07', '01-08'],
                    datasets: [{
                        label: '일별 매출액 (단위: 원)',
                        data: [1500000, 2300000, 1800000, 3200000, 2100000, 1800000, 2800000, 2400000],
                        borderColor: '#0d6efd',
                        backgroundColor: 'rgba(13, 110, 253, 0.1)',
                        tension: 0.3, // 곡선 부드럽게
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'top' }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: { borderDash: [2, 4] }
                        },
                        x: {
                            grid: { display: false }
                        }
                    }
                }
            });
        });
    </script>

</body>
</html>