<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>주문 내역 관리 - MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_order_list.css">
</head>
<body>

    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                
                <div class="page-header">
                    <h3 class="page-title">주문 내역 관리</h3>
                    <p class="page-desc">Integrated Order Search & Management</p>
                </div>

                <div class="card-box">
                    <form class="search-grid">
                        <div>
                            <label class="form-label">주문 기간 (Order Period)</label>
                            <div class="d-flex align-items-center">
                                <input type="date" class="form-control" value="2026-01-01">
                                <span class="mx-2 text-muted">~</span>
                                <input type="date" class="form-control" value="2026-01-11">
                            </div>
                        </div>
                        <div>
                            <label class="form-label">주문 상태</label>
                            <select class="form-select">
                                <option>전체 상태</option>
                                <option>결제완료</option>
                                <option>배송중</option>
                                <option>취소/반품</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label">결제 수단</label>
                            <select class="form-select">
                                <option>전체 수단</option>
                                <option>신용카드</option>
                                <option>무통장입금</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label">통합 검색 (Search)</label>
                            <input type="text" class="form-control" placeholder="주문번호, ID, 상품명 입력">
                        </div>
                        <div>
                            <button type="button" class="btn-orange-main">SEARCH</button>
                        </div>
                    </form>
                </div>

                <div class="card-box">
                    <div class="list-header">
                        <div class="count-info">Showing <b>4</b> orders results</div>
                        <div class="action-group">
                            <button type="button" class="btn" onclick="updateOrderStatus()">상태 일괄변경</button>
                            <button type="button" class="btn" onclick="updateOrderStatus()">발주 확인</button>
                            <button type="button" class="btn" onclick="excelDownload()">EXCEL 다운로드</button>
                        </div>
                    </div>

                    <table class="table">
                        <thead>
                            <tr>
                                <th style="width: 40px;"><input type="checkbox" id="checkAll" class="form-check-input"></th>
                                <th>주문번호</th>
                                <th>주문일시</th>
                                <th>주문자</th>
                                <th style="width: 25%;">상품정보</th>
                                <th>결제금액</th>
                                <th>현재상태</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td><a href="#" class="order-no">20260105-001</a></td>
                                <td class="text-muted" style="font-size: 13px;">2026.01.05<br>14:30</td>
                                <td class="fw-bold">이누야샤<br><span class="text-muted small" style="font-weight: 400;">(user_01)</span></td>
                                <td class="text-start">
                                    <span class="fw-bold">MAKNAEZ SHOE A</span><br>
                                    <span class="text-muted small">옵션: 브라운 / 250 </span>
                                </td>
                                <td class="price-text">1,850,000원</td>
                                <td><span class="badge-luxury st-paid">결제완료</span></td>
                                <td><button class="btn btn-sm btn-light border-0"><i class="fas fa-file-alt text-muted"></i></button></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td><a href="#" class="order-no">20260105-002</a></td>
                                <td class="text-muted" style="font-size: 13px;">2026.01.05<br>12:15</td>
                                <td class="fw-bold">나루토<br><span class="text-muted small" style="font-weight: 400;">(user_02)</span></td>
                                <td class="text-start">
                                    <span class="fw-bold">MAKNAEZ SHOE 550 </span><br>
                                    <span class="text-muted small">옵션: 화이트 / 270 </span>
                                </td>
                                <td class="price-text">145,000원</td>
                                <td><span class="badge-luxury st-paid">결제완료</span></td>
                                <td><button class="btn btn-sm btn-light border-0"><i class="fas fa-file-alt text-muted"></i></button></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td><a href="#" class="order-no">20260104-005</a></td>
                                <td class="text-muted" style="font-size: 13px;">2026.01.04<br>09:40</td>
                                <td class="fw-bold">진격의거인<br><span class="text-muted small" style="font-weight: 400;">(user_03)</span></td>
                                <td class="text-start">
                                    <span class="fw-bold">MAKNAEZ SHOE B </span><br>
                                    <span class="text-muted small">옵션: 블랙 / 245 </span>
                                </td>
                                <td class="price-text">150,000원</td>
                                <td><span class="badge-luxury st-ship">배송중</span></td>
                                <td><button class="btn btn-sm btn-light border-0"><i class="fas fa-shipping-fast text-muted"></i></button></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td><a href="#" class="order-no" style="opacity: 0.5; border-bottom: none;">20260103-011</a></td>
                                <td class="text-muted" style="font-size: 13px;">2026.01.03<br>18:20</td>
                                <td class="fw-bold">짱구는못말려<br><span class="text-muted small" style="font-weight: 400;">(user_zzang)</span></td>
                                <td class="text-start" style="opacity: 0.5;">
                                    <span class="fw-bold">MAKNAEZ SHOE C </span><br>
                                    <span class="text-muted small">옵션: 그레이 / 275 </span>
                                </td>
                                <td class="price-text" style="opacity: 0.5;">159,000원</td>
                                <td><span class="badge-luxury st-cancel">주문취소</span></td>
                                <td><button class="btn btn-sm btn-light border-0"><i class="fas fa-times-circle text-muted"></i></button></td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="mt-5 d-flex justify-content-center">
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
    </div>
    
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <script src="${pageContext.request.contextPath}/dist/js/admin_order_list.js"></script>
</body>
</html>