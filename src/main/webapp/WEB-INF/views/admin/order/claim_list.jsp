<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>취소/교환 관리 - MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_claim_list.css">
</head>
<body>
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                <div class="page-header">
                    <h3 class="page-title">취소/교환 관리</h3>
                    <p class="page-desc">Shoes Claim & Exchange Protocol</p>
                </div>

                <div class="card-box">
                    <form class="search-grid">
                        <div>
                            <label class="form-label">접수 기간</label>
                            <input type="date" class="form-control" value="2026-01-01">
                        </div>
                        <div>
                            <label class="form-label">청구 유형</label>
                            <select class="form-select">
                                <option>전체 유형</option><option>취소</option><option>교환</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label">처리 상태</label>
                            <select class="form-select">
                                <option>전체 상태</option><option>접수 대기</option><option>완료</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label">상세 검색</label>
                            <input type="text" class="form-control" placeholder="주문번호 또는 ID">
                        </div>
                        <div><button type="button" class="btn-search">SEARCH</button></div>
                    </form>
                </div>

                <div class="card-box">
                    <div class="list-header">
                        <div style="font-size:14px; font-weight:600;">미처리 요청 <b style="color:#ff4e00;">2</b>건 / 전체 3건</div>
                        <div class="action-group">
                            <button type="button" class="btn-ctrl" onclick="approveClaim()">선택 일괄승인</button>
                            <button type="button" class="btn-ctrl" onclick="excelDownload()">EXCEL DOWNLOAD</button>
                        </div>
                    </div>

                    <table class="table">
                        <thead>
                            <tr>
                                <th style="width: 40px;"><input type="checkbox" id="checkAll"></th>
                                <th>접수일</th><th>유형</th><th>주문번호</th><th style="width: 25%;">상품명</th><th>신청자(ID)</th><th>사유</th><th>상태</th><th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><input type="checkbox"></td>
                                <td class="date-text">2026.01.11</td>
                                <td><span class="badge-luxury st-exchange">교환</span></td>
                                <td><a href="#" class="order-link">260111001</a></td>
                                <td class="text-start fw-bold">MAKNAEZ 덩크 로우 레트로</td>
                                <td>진격의거인 <small class="text-muted">(user_titan)</small></td>
                                <td class="text-muted">사이즈가 너무 큼 (교환요청)</td>
                                <td><span class="badge-luxury st-exchange">접수 대기</span></td>
                                <td><button class="btn btn-sm btn-dark" style="border-radius:0; padding:5px 15px;">승인</button></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"></td>
                                <td class="date-text">2026.01.08</td>
                                <td><span class="badge-luxury">취소</span></td>
                                <td><a href="#" class="order-link">260108042</a></td>
                                <td class="text-start fw-bold">에어 포스 1 '07 화이트</td>
                                <td>나루토 <small class="text-muted">(user_ninja)</small></td>
                                <td class="text-muted">잘못된 옵션 선택 (단순변심)</td>
                                <td><span class="badge-luxury">취소완료</span></td>
                                <td><button class="btn btn-sm btn-light border" style="border-radius:0; padding:5px 15px;">상세</button></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"></td>
                                <td class="date-text">2026.01.05</td>
                                <td><span class="badge-luxury st-exchange">교환</span></td>
                                <td><a href="#" class="order-link">260105112</a></td>
                                <td class="text-start fw-bold">클래식 러닝 워커 브라운</td>
                                <td>짱구는못말려 <small class="text-muted">(user_zzang)</small></td>
                                <td class="text-muted">상품 오른쪽 본드 자국 발견</td>
                                <td><span class="badge-luxury st-exchange">수거중</span></td>
                                <td><button class="btn btn-sm btn-light border" style="border-radius:0; padding:5px 15px;">상세</button></td>
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
    <script src="${pageContext.request.contextPath}/dist/js/admin_claim_list.js"></script>
</body>
</html>