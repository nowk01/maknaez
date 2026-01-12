<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마일리지 관리 | MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_point.css">
</head>
<body>
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                <div class="page-header">
                    <h3 class="page-title">마일리지 관리</h3>
                    <p class="page-desc">회원별 적립금 지급 및 차감 내역을 관리합니다.</p>
                </div>

                <div class="card-box">
                    <form name="searchForm" class="search-grid" onsubmit="return false;">
                        <div>
                            <label class="form-label">조회 기간</label>
                            <div class="d-flex align-items-center">
                                <input type="date" class="form-control" value="2025-01-01">
                                <span class="mx-2 text-muted">~</span>
                                <input type="date" class="form-control" value="2026-01-11">
                            </div>
                        </div>
                        <div>
                            <label class="form-label">구분 (Type)</label>
                            <select class="form-select">
                                <option>전체 내역</option>
                                <option>포인트 적립 (+)</option>
                                <option>포인트 차감 (-)</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label">회원 검색 (Search)</label>
                            <input type="text" class="form-control" placeholder="아이디 또는 회원명 입력">
                        </div>
                        <div>
                            <button type="button" class="btn-search-main" onclick="searchList()">SEARCH</button>
                        </div>
                    </form>
                </div>

                <div class="card-box">
                    <div class="list-ctrl">
                        <div class="stat-text">검색 결과 <b>3</b>건의 내역이 있습니다.</div>
                        <div class="btn-group-custom">
                            <button type="button" class="btn"><i class="fas fa-plus-circle me-1"></i>일괄 적립</button>
                            <button type="button" class="btn"><i class="fas fa-minus-circle me-1"></i>일괄 차감</button>
                            <button type="button" class="btn"><i class="fas fa-file-excel me-1"></i>엑셀 다운로드</button>
                        </div>
                    </div>

                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th style="width: 50px;"><input type="checkbox" id="checkAll"></th>
                                <th style="width: 80px;">번호</th>
                                <th>아이디</th>
                                <th>회원명</th>
                                <th>사유</th>
                                <th class="text-end">변동 금액</th>
                                <th>처리일</th>
                                <th>상태</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><input type="checkbox" class="chk-item"></td>
                                <td class="text-muted">3</td>
                                <td class="fw-bold">sample_user</td>
                                <td>홍길동</td>
                                <td class="text-start">신규 가입 축하 마일리지</td>
                                <td class="text-end point-text">+3,000 P</td>
                                <td class="text-muted">2026-01-11</td>
                                <td><span class="k-badge plus">적립완료</span></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" class="chk-item"></td>
                                <td class="text-muted">2</td>
                                <td class="fw-bold">maknaez_01</td>
                                <td>김막내</td>
                                <td class="text-start">상품 구매에 따른 자동 적립</td>
                                <td class="text-end point-text">+450 P</td>
                                <td class="text-muted">2026-01-10</td>
                                <td><span class="k-badge plus">적립완료</span></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" class="chk-item"></td>
                                <td class="text-muted">1</td>
                                <td class="fw-bold">test_id</td>
                                <td>테스터</td>
                                <td class="text-start">이벤트 참여 포인트 지급</td>
                                <td class="text-end point-text" style="color:#111;">-500 P</td>
                                <td class="text-muted">2026-01-08</td>
                                <td><span class="k-badge minus">차감완료</span></td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="mt-5 d-flex justify-content-center">
                        <nav>
                            <ul class="pagination" style="display:flex; list-style:none; gap:10px;">
                                <li style="padding:8px 15px; background:#111; color:#fff; border-radius:2px; cursor:pointer;">1</li>
                                <li style="padding:8px 15px; background:#fff; border:1px solid #eee; border-radius:2px; cursor:pointer;">2</li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div> 
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <script src="${pageContext.request.contextPath}/dist/js/admin_point.js"></script>
</body>
</html>