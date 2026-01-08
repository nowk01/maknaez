<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>방문자 통계 - MAKNAEZ ADMIN</title>
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

        /* 통계 카드 스타일 */
        .visitor-card {
            padding: 20px;
            border-radius: 8px;
            color: #fff;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }
        .visitor-card:hover { transform: translateY(-3px); }
        
        /* 카드 배경색 그라디언트 */
        .bg-gradient-primary { background: linear-gradient(45deg, #4099ff, #73b4ff); }
        .bg-gradient-success { background: linear-gradient(45deg, #2ed8b6, #59e0c5); }
        .bg-gradient-warning { background: linear-gradient(45deg, #ffb64d, #ffcb80); }
        .bg-gradient-danger  { background: linear-gradient(45deg, #ff5370, #ff869a); }

        .card-inner {
            position: relative;
            z-index: 2;
        }
        .card-title-text {
            font-size: 14px;
            font-weight: 500;
            opacity: 0.9;
            margin-bottom: 5px;
        }
        .card-count-text {
            font-size: 24px;
            font-weight: 700;
        }
        .card-icon-bg {
            position: absolute;
            right: -10px;
            top: -10px;
            font-size: 80px;
            opacity: 0.2;
            transform: rotate(15deg);
            z-index: 1;
        }

        /* 차트 컨테이너 */
        .chart-container {
            position: relative;
            height: 320px;
            width: 100%;
        }

        /* 테이블 헤더 */
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
        
        /* 진행바 스타일 (브라우저 점유율 등) */
        .progress-label {
            display: flex;
            justify-content: space-between;
            font-size: 13px;
            margin-bottom: 4px;
            color: #555;
        }
        .progress-sm { height: 6px; border-radius: 4px; margin-bottom: 15px; }
    </style>
</head>
<body>

    <div id="wrapper">
        
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

        <div id="page-content-wrapper">
            
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                
                <h3 class="fw-bold mb-4">방문자 통계</h3>

				<div class="card-box">
                    <form class="row g-1 align-items-end">
                        <div class="col-md-3">
                            <label class="search-label">조회 기간</label>
                            <div class="input-group input-group-sm">
                                <input type="date" class="form-control" value="2026-01-01">
                                <span class="input-group-text">~</span>
                                <input type="date" class="form-control" value="2026-01-08">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <button type="button" class="btn btn-dark btn-sm w-100">조회</button>
                        </div>
                    </form>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-md-3">
                        <div class="visitor-card bg-gradient-primary">
                            <div class="card-inner">
                                <div class="card-title-text">오늘 방문자 수</div>
                                <div class="card-count-text">1,240</div>
                                <small><i class="fas fa-arrow-up"></i> 어제보다 +5%</small>
                            </div>
                            <i class="fas fa-eye card-icon-bg"></i>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="visitor-card bg-gradient-success">
                            <div class="card-inner">
                                <div class="card-title-text">주간 누적 방문</div>
                                <div class="card-count-text">8,530</div>
                                <small><i class="fas fa-arrow-up"></i> 지난주보다 +12%</small>
                            </div>
                            <i class="fas fa-chart-line card-icon-bg"></i>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="visitor-card bg-gradient-warning">
                            <div class="card-inner">
                                <div class="card-title-text">신규 방문자</div>
                                <div class="card-count-text">320</div>
                                <small class="text-white">전체 방문의 25%</small>
                            </div>
                            <i class="fas fa-user-plus card-icon-bg"></i>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="visitor-card bg-gradient-danger">
                            <div class="card-inner">
                                <div class="card-title-text">최대 동시 접속</div>
                                <div class="card-count-text">85</div>
                                <small class="text-white">14:00 기준</small>
                            </div>
                            <i class="fas fa-users card-icon-bg"></i>
                        </div>
                    </div>
                </div>

                <div class="row g-4 mb-4">
                    <div class="col-lg-8">
                        <div class="card-box">
                            <h5 class="fw-bold mb-4">일별 방문자 추이</h5>
                            <div class="chart-container">
                                <canvas id="visitorChart"></canvas>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-lg-4">
                        <div class="card-box">
                            <h5 class="fw-bold mb-4">접속 브라우저 / OS</h5>
                            
                            <div class="mb-4">
                                <div class="progress-label">
                                    <span>Chrome</span>
                                    <span class="fw-bold">65%</span>
                                </div>
                                <div class="progress progress-sm">
                                    <div class="progress-bar bg-primary" style="width: 65%"></div>
                                </div>

                                <div class="progress-label">
                                    <span>Safari (Mobile)</span>
                                    <span class="fw-bold">20%</span>
                                </div>
                                <div class="progress progress-sm">
                                    <div class="progress-bar bg-success" style="width: 20%"></div>
                                </div>

                                <div class="progress-label">
                                    <span>Edge</span>
                                    <span class="fw-bold">10%</span>
                                </div>
                                <div class="progress progress-sm">
                                    <div class="progress-bar bg-info" style="width: 10%"></div>
                                </div>

                                <div class="progress-label">
                                    <span>Others</span>
                                    <span class="fw-bold">5%</span>
                                </div>
                                <div class="progress progress-sm">
                                    <div class="progress-bar bg-secondary" style="width: 5%"></div>
                                </div>
                            </div>

                            <h6 class="fw-bold mb-3 border-top pt-3">기기별 접속</h6>
                            <div class="d-flex justify-content-center text-center">
                                <div class="px-3">
                                    <div class="fs-4 text-primary"><i class="fas fa-mobile-alt"></i></div>
                                    <div class="fw-bold mt-1">Mobile</div>
                                    <div class="text-muted small">58%</div>
                                </div>
                                <div class="px-3 border-start border-end">
                                    <div class="fs-4 text-dark"><i class="fas fa-desktop"></i></div>
                                    <div class="fw-bold mt-1">PC</div>
                                    <div class="text-muted small">35%</div>
                                </div>
                                <div class="px-3">
                                    <div class="fs-4 text-success"><i class="fas fa-tablet-alt"></i></div>
                                    <div class="fw-bold mt-1">Tablet</div>
                                    <div class="text-muted small">7%</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-box">
                    <h5 class="fw-bold mb-3">최근 접속 로그</h5>
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>접속 시간</th>
                                <th>IP 주소</th>
                                <th>접속 경로 (Referer)</th>
                                <th>OS / Browser</th>
                                <th>상태</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>2026-01-08 16:45:12</td>
                                <td>192.168.0.***</td>
                                <td>네이버 검색 (키워드: 쇼핑몰)</td>
                                <td>Windows 10 / Chrome</td>
                                <td><span class="badge bg-success bg-opacity-75">정상</span></td>
                            </tr>
                            <tr>
                                <td>2026-01-08 16:42:05</td>
                                <td>211.45.12.***</td>
                                <td>인스타그램 광고</td>
                                <td>iOS 17 / Safari</td>
                                <td><span class="badge bg-success bg-opacity-75">정상</span></td>
                            </tr>
                            <tr>
                                <td>2026-01-08 16:38:33</td>
                                <td>118.220.55.***</td>
                                <td>직접 접속</td>
                                <td>Android 14 / Samsung Internet</td>
                                <td><span class="badge bg-secondary">이탈</span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

            </div> </div> </div> <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var ctx = document.getElementById('visitorChart').getContext('2d');
            
            // 그라디언트 효과 생성 (차트 배경)
            var gradient = ctx.createLinearGradient(0, 0, 0, 300);
            gradient.addColorStop(0, 'rgba(64, 153, 255, 0.5)'); // 위쪽 색상
            gradient.addColorStop(1, 'rgba(64, 153, 255, 0.05)'); // 아래쪽 색상

            var visitorChart = new Chart(ctx, {
                type: 'line', 
                data: {
                    labels: ['01-02', '01-03', '01-04', '01-05', '01-06', '01-07', '01-08'],
                    datasets: [{
                        label: '일별 방문자 수',
                        data: [850, 920, 1100, 1240, 980, 1150, 1240],
                        borderColor: '#4099ff',
                        backgroundColor: gradient,
                        pointBackgroundColor: '#fff',
                        pointBorderColor: '#4099ff',
                        pointRadius: 4,
                        borderWidth: 2,
                        fill: true,
                        tension: 0.4 // 부드러운 곡선
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false }, // 범례 숨김 (깔끔하게)
                        tooltip: {
                            mode: 'index',
                            intersect: false,
                        }
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