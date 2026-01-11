<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>견적서 관리 - MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_estimate_list.css">
</head>
<body>
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                <div class="page-header">
                    <h3 class="page-title">견적서 관리</h3>
                    <p class="page-desc">Shoes B2B & Bulk Order Management</p>
                </div>

                <div class="card-box">
                    <form class="search-grid">
                        <div>
                            <label class="form-label" style="font-size:12px;">요청 기간</label>
                            <input type="date" class="form-control" value="2026-01-01">
                        </div>
                        <div>
                            <label class="form-label" style="font-size:12px;">진행 상태</label>
                            <select class="form-select">
                                <option>전체 상태</option><option>견적 대기</option><option>발송 완료</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label" style="font-size:12px;">상세 검색</label>
                            <input type="text" class="form-control" placeholder="요청자명, 연락처, 상품명 입력">
                        </div>
                        <div><button type="button" class="btn-search">SEARCH</button></div>
                    </form>
                </div>

                <div class="card-box">
                    <div class="list-header">
                        <div style="font-size:14px; font-weight:600;">
                            미처리 요청 <b style="color:#ff4e00;">1</b>건 / 전체 4건
                        </div>
                        <div class="action-group">
                            <button type="button" class="btn-ctrl" onclick="deleteEstimate()">선택 삭제</button>
                            <button type="button" class="btn-ctrl" onclick="downloadExcel()">EXCEL DOWNLOAD</button>
                        </div>
                    </div>

                    <table class="table">
                        <thead>
                            <tr>
                                <th style="width: 40px;"><input type="checkbox" id="checkAll"></th>
                                <th>번호</th><th>요청자(ID)</th><th>연락처</th><th style="width: 30%;">상품명 / 요청내용</th><th>수량</th><th>요청일</th><th>상태</th><th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><input type="checkbox"></td>
                                <td class="text-muted">4</td>
                                <td><span style="font-weight:700;">진격의거인</span><br><small class="text-muted">(user_titan)</small></td>
                                <td style="color:#888;">010-1234-5678</td>
                                <td style="text-align:left; font-weight:600; color:#555;">마라톤 대회용 러닝화 200켤레 대량 견적 요청</td>
                                <td style="font-weight:800;">200개</td>
                                <td style="color:#888;">2026.01.11</td>
                                <td><span class="badge-luxury st-waiting">견적 대기</span></td>
                                <td><button class="btn btn-sm btn-dark" style="border-radius:0; padding: 5px 15px;">작성</button></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"></td>
                                <td class="text-muted">3</td>
                                <td><span style="font-weight:700;">나루토</span><br><small class="text-muted">(user_naruto)</small></td>
                                <td style="color:#888;">010-9876-5432</td>
                                <td style="text-align:left; font-weight:600; color:#555;">닌자 마을 단체 보급용 샌들 견적 문의</td>
                                <td style="font-weight:800;">100개</td>
                                <td style="color:#888;">2026.01.07</td>
                                <td><span class="badge-luxury">발송 완료</span></td>
                                <td><button class="btn btn-sm btn-light border" style="border-radius:0; padding: 5px 15px;">상세</button></td>
                            </tr>
                        </tbody>
                    </table>

                    <ul class="pagination">
                        <li class="page-item"><a class="page-link" href="#">PREV</a></li>
                        <li class="page-item active"><a class="page-link" href="#">1</a></li>
                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                        <li class="page-item"><a class="page-link" href="#">NEXT</a></li>
                    </ul>
                </div> 
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <script src="${pageContext.request.contextPath}/dist/js/admin_estimate_list.js"></script>
</body>
</html>