<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
</head>
<body>

<div id="wrapper">
    
    <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

    <div id="page-content-wrapper">
        
        <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

        <div class="content-container">
            
            <div id="dashboard-section">
                <h4 class="fw-bold mb-4">대시보드</h4>
                <div class="row g-4 mb-4">
                    <div class="col-xl-3 col-md-6">
                        <div class="card card-custom p-3 h-100">
                            <div class="stat-card-title">오늘의 매출</div>
                            <div class="stat-card-value my-2">₩ 12,450,000</div>
                            <small class="text-success fw-bold">▲ 12.5% 전일대비</small>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="card card-custom p-3 h-100">
                            <div class="stat-card-title">신규 주문</div>
                            <div class="stat-card-value my-2">156 건</div>
                            <small class="text-success fw-bold">▲ 5건 증가</small>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="card card-custom p-3 h-100">
                            <div class="stat-card-title">신규 문의</div>
                            <div class="stat-card-value my-2">24 건</div>
                            <small class="text-danger fw-bold">! 미답변 8건</small>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="card card-custom p-3 h-100">
                            <div class="stat-card-title">방문자 수</div>
                            <div class="stat-card-value my-2">3,840 명</div>
                            <small class="text-success fw-bold"><i class="fas fa-user-friends"></i> 실시간 42명</small>
                        </div>
                    </div>
                </div>

                <div class="row g-4">
                    <div class="col-lg-8">
                        <div class="card card-custom p-4">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="fw-bold m-0">월간 매출 추이</h5>
                                <a href="#" class="text-decoration-none small fw-bold">연매출 보기 ></a>
                            </div>
                            <div class="chart-container">
                                <canvas id="salesChart"></canvas>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="card card-custom p-4 mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="fw-bold m-0 text-secondary">일정 및 메모</h5>
                                <i class="far fa-calendar-alt text-secondary"></i>
                            </div>
                            <div class="bg-light p-2 rounded text-center mb-3">
                                <strong>2026년 1월</strong>
                                <div class="small text-muted">S M T W T F S</div>
                            </div>
                            <div>
                                <h6 class="text-muted small">To-do List <i class="fas fa-plus-circle text-primary float-end"></i></h6>
                                <div class="form-check my-2">
                                    <input class="form-check-input" type="checkbox" id="todo1">
                                    <label class="form-check-label" for="todo1">설 연휴 배송 공지 등록</label>
                                </div>
                                <div class="form-check my-2">
                                    <input class="form-check-input" type="checkbox" id="todo2" checked>
                                    <label class="form-check-label text-decoration-line-through text-muted" for="todo2">오전 주문 건 발송 처리</label>
                                </div>
                            </div>
                        </div>
                        <div class="card card-custom p-4">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="fw-bold m-0">관리자 접속 현황</h5>
                                <i class="fas fa-user-shield text-secondary"></i>
                            </div>
                            <div class="d-flex justify-content-between mt-3 text-center">
                                <div><div class="avatar-circle bg-primary mx-auto">권</div><div class="small mt-1">권혁찬</div></div>
                                <div><div class="avatar-circle bg-danger mx-auto">서</div><div class="small mt-1">서유현</div></div>
                                <div><div class="avatar-circle bg-warning text-white mx-auto">최</div><div class="small mt-1">최하늘</div></div>
                                <div><div class="avatar-circle bg-secondary mx-auto">이</div><div class="small mt-1">이지영</div></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div id="member-section" class="d-none-custom">
                <h4 class="fw-bold mb-4">회원 조회</h4>
                <div class="card card-custom p-4 mb-4">
                    <div class="row g-3 align-items-end">
                        <div class="col-md-4">
                            <label class="form-label fw-bold small">가입 기간</label>
                            <div class="input-group">
                                <input type="text" class="form-control" value="2026-01-01">
                                <span class="input-group-text">~</span>
                                <input type="text" class="form-control" value="2026-01-05">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-bold small">회원 등급</label>
                            <select class="form-select">
                                <option>전체 등급</option>
                            </select>
                        </div>
                        <div class="col-md-5">
                            <label class="form-label fw-bold small">검색어</label>
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="이름, ID, 이메일">
                                <button class="btn btn-outline-secondary" type="button"><i class="fas fa-search"></i></button>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="card card-custom p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold m-0">회원 목록</h5>
                        <button class="btn btn-primary btn-sm">엑셀 다운로드</button>
                    </div>
                    <table class="table table-hover align-middle">
                        <thead class="table-light"><tr><th>ID</th><th>닉네임</th><th>등급</th><th>가입일</th><th>상태</th><th>관리</th></tr></thead>
                        <tbody>
                            <tr><td>user_01</td><td>증강살려</td><td><span class="badge bg-warning text-dark">GOLD</span></td><td>2026-01-01</td><td><span class="badge bg-success bg-opacity-10 text-success">정상</span></td><td><button class="btn btn-sm btn-light"><i class="far fa-edit"></i></button></td></tr>
                            <tr><td>user_02</td><td>환바람나락</td><td><span class="badge bg-secondary">SILVER</span></td><td>2026-01-02</td><td><span class="badge bg-success bg-opacity-10 text-success">정상</span></td><td><button class="btn btn-sm btn-light"><i class="far fa-edit"></i></button></td></tr>
                        </tbody>
                    </table>
                </div>
            </div>

        </div> <jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
        
    </div> </div> <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />

</body>
</html>