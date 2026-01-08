<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 통계 - MAKNAEZ ADMIN</title>
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
            height: 100%; /* 카드 높이 맞춤 */
        }

        /* 통계 요약 카드 스타일 */
        .stat-card {
            display: flex;
            align-items: center;
            padding: 20px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.04);
            transition: transform 0.2s;
        }
        .stat-card:hover { transform: translateY(-3px); }
        
        .stat-icon-wrapper {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            margin-right: 15px;
            flex-shrink: 0;
        }
        .bg-blue-light { background-color: #e7f5ff; color: #1c7ed6; }
        .bg-green-light { background-color: #e6fcf5; color: #0ca678; }
        .bg-orange-light { background-color: #fff4e6; color: #f76707; }
        .bg-red-light { background-color: #ffe3e3; color: #fa5252; }

        .stat-info h6 {
            color: #868e96;
            margin-bottom: 5px;
            font-size: 0.9rem;
        }
        .stat-info h3 {
            margin: 0;
            font-weight: 700;
            color: #343a40;
        }

        /* 차트 컨테이너 */
        .chart-container {
            position: relative;
            height: 300px;
            width: 100%;
        }
        
        /* 테이블 헤더 */
        .table th {
            background-color: #f8f9fa;
            text-align: center;
        }
        .table td { text-align: center; vertical-align: middle; }
    </style>
</head>
<body>

    <div id="wrapper">
        
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

        <div id="page-content-wrapper">
            
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                
                <h3 class="fw-bold mb-4">회원 통계 (연령/성별)</h3>

                <div class="row g-3 mb-4">
                    <div class="col-md-3">
                        <div class="stat-card">
                            <div class="stat-icon-wrapper bg-blue-light">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="stat-info">
                                <h6>총 회원수</h6>
                                <h3>1,245 명</h3>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card">
                            <div class="stat-icon-wrapper bg-green-light">
                                <i class="fas fa-user-plus"></i>
                            </div>
                            <div class="stat-info">
                                <h6>신규 가입 (오늘)</h6>
                                <h3>+ 12 명</h3>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card">
                            <div class="stat-icon-wrapper bg-orange-light">
                                <i class="fas fa-bed"></i>
                            </div>
                            <div class="stat-info">
                                <h6>휴면 회원</h6>
                                <h3>58 명</h3>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card">
                            <div class="stat-icon-wrapper bg-red-light">
                                <i class="fas fa-user-times"></i>
                            </div>
                            <div class="stat-info">
                                <h6>탈퇴 회원 (누적)</h6>
                                <h3>34 명</h3>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row g-4 mb-4">
                    <div class="col-lg-5">
                        <div class="card-box">
                            <h5 class="fw-bold mb-3 border-bottom pb-3">성별 비율</h5>
                            <div class="chart-container">
                                <canvas id="genderChart"></canvas>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-lg-7">
                        <div class="card-box">
                            <h5 class="fw-bold mb-3 border-bottom pb-3">연령대별 분포</h5>
                            <div class="chart-container">
                                <canvas id="ageChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-box">
                    <h5 class="fw-bold mb-3">등급별 회원 현황</h5>
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>등급</th>
                                <th>회원 수</th>
                                <th>비율</th>
                                <th>평균 구매액</th>
                                <th>전월 대비 증감</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="fw-bold text-warning">GOLD</td>
                                <td>150 명</td>
                                <td>12%</td>
                                <td>₩ 1,200,000</td>
                                <td class="text-success"><i class="fas fa-arrow-up"></i> 2%</td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-secondary">SILVER</td>
                                <td>400 명</td>
                                <td>32%</td>
                                <td>₩ 550,000</td>
                                <td class="text-success"><i class="fas fa-arrow-up"></i> 5%</td>
                            </tr>
                            <tr>
                                <td class="fw-bold" style="color: #cd7f32;">BRONZE</td>
                                <td>695 명</td>
                                <td>56%</td>
                                <td>₩ 120,000</td>
                                <td class="text-danger"><i class="fas fa-arrow-down"></i> -1%</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

            </div> </div> </div> <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            
            // 1. 성별 차트 (Pie Chart)
            const genderCtx = document.getElementById('genderChart').getContext('2d');
            new Chart(genderCtx, {
                type: 'doughnut', // 도넛 차트
                data: {
                    labels: ['남성', '여성'],
                    datasets: [{
                        data: [45, 55], // 데이터 예시 (남 45%, 여 55%)
                        backgroundColor: ['#339af0', '#ff6b6b'],
                        borderWidth: 0
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'bottom' }
                    }
                }
            });

            // 2. 연령대 차트 (Bar Chart)
            const ageCtx = document.getElementById('ageChart').getContext('2d');
            new Chart(ageCtx, {
                type: 'bar',
                data: {
                    labels: ['10대', '20대', '30대', '40대', '50대', '60대 이상'],
                    datasets: [{
                        label: '회원 수',
                        data: [120, 450, 380, 200, 80, 15], // 데이터 예시
                        backgroundColor: '#20c997',
                        borderRadius: 5
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false } // 범례 숨김
                    },
                    scales: {
                        y: { beginAtZero: true },
                        x: { grid: { display: false } }
                    }
                }
            });
        });
    </script>

</body>
</html>