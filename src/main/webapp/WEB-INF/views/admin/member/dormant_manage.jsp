<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>휴면 회원 관리 | MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_dormant.css">
</head>
<body>
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                <div class="page-header">
                    <h3 class="page-title">휴면 회원 관리</h3>
                    <p class="page-desc">장기 미접속 회원 리스트를 관리하고 복구/삭제를 처리합니다.</p>
                </div>

                <div class="card-box">
                    <form name="searchForm" class="search-grid" onsubmit="return false;">
                        <div>
                            <label class="form-label">휴면 전환일</label>
                            <div class="d-flex align-items-center">
                                <input type="date" class="form-control" value="2025-01-01">
                                <span class="mx-2 text-muted">~</span>
                                <input type="date" class="form-control" value="2026-01-11">
                            </div>
                        </div>
                        <div>
                            <label class="form-label">정렬 기준</label>
                            <select class="form-select">
                                <option>최근 휴면 순</option>
                                <option>미접속 기간 긴 순</option>
                                <option>이름 순</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label">회원 검색</label>
                            <input type="text" class="form-control" placeholder="아이디 또는 회원명 입력">
                        </div>
                        <div>
                            <button type="button" class="btn-search-main" onclick="searchList()">검색</button>
                        </div>
                    </form>
                </div>

                <div class="card-box">
                    <div class="list-ctrl">
                        <div class="stat-text">휴면 대상자 <b>3</b>명이 조회되었습니다.</div>
                        <div class="btn-group-custom">
                            <button type="button" class="btn" onclick="restoreSelected()"><i class="fas fa-user-check me-1"></i>선택 복구</button>
                            <button type="button" class="btn" onclick="deleteSelected()" style="color: #ff4e00;"><i class="fas fa-user-slash me-1"></i>선택 삭제</button>
                            <button type="button" class="btn"><i class="fas fa-envelope me-1"></i>안내 메일 발송</button>
                        </div>
                    </div>

                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th style="width: 50px;"><input type="checkbox" id="checkAll"></th>
                                <th style="width: 80px;">번호</th>
                                <th>아이디</th>
                                <th>회원명</th>
                                <th>마지막 로그인</th>
                                <th>미접속 일수</th>
                                <th>휴면 전환일</th>
                                <th>상태</th>
                                <th style="width: 100px;">관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><input type="checkbox" class="chk-item"></td>
                                <td class="text-muted">3</td>
                                <td class="fw-bold">dormant_faker</td>
                                <td>이상혁</td>
                                <td>2024.01.10</td>
                                <td style="color: #ff4e00; font-weight: 700;">366일</td>
                                <td>2025.01.10</td>
                                <td><span class="k-badge dormant">휴면상태</span></td>
                                <td><button class="btn-sm-action">복구</button></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" class="chk-item"></td>
                                <td class="text-muted">2</td>
                                <td class="fw-bold">user_silver</td>
                                <td>심해어</td>
                                <td>2024.05.20</td>
                                <td style="color: #ff4e00; font-weight: 700;">236일</td>
                                <td>2025.05.20</td>
                                <td><span class="k-badge dormant">휴면상태</span></td>
                                <td><button class="btn-sm-action">복구</button></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" class="chk-item"></td>
                                <td class="text-muted">1</td>
                                <td class="fw-bold">test_maknae</td>
                                <td>김막내</td>
                                <td>2024.08.05</td>
                                <td style="color: #ff4e00; font-weight: 700;">159일</td>
                                <td>2025.08.05</td>
                                <td><span class="k-badge dormant">휴면상태</span></td>
                                <td><button class="btn-sm-action">복구</button></td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="mt-5 d-flex justify-content-center">
                        <nav>
                            <ul class="pagination" style="display:flex; list-style:none; gap:10px;">
                                <li style="padding:8px 15px; background:#111; color:#fff; border-radius:2px; cursor:pointer;">1</li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div> 
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <script src="${pageContext.request.contextPath}/dist/js/admin_dormant.js"></script>
</body>
</html>