<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>통합 주문 검색 - MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    
    <style>
        /* [공통 레이아웃 스타일] */
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
            font-size: 13px;
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
            font-size: 13px;
        }
        .table td {
            vertical-align: middle;
            text-align: center;
            font-size: 13px;
            padding: 12px 10px;
        }
        
        /* 테이블 내 텍스트 정렬/스타일 커스텀 */
        .product-info {
            text-align: left !important;
        }
        .product-name {
            font-weight: bold;
            color: #333;
            display: block;
            margin-bottom: 2px;
            text-decoration: none;
        }
        .product-name:hover { text-decoration: underline; }
        .product-option { font-size: 11px; color: #888; }
        
        .order-no {
            font-weight: bold;
            color: #2c5bf0;
            text-decoration: none;
        }
        
        /* 주문 상태 배지 스타일 */
        .badge-status {
            padding: 5px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 500;
            display: inline-block;
            min-width: 60px;
        }
        .st-paid { background-color: #e6fcf5; color: #0ca678; }       /* 결제완료 (민트/초록) */
        .st-ready { background-color: #fff9db; color: #f59f00; }      /* 상품준비 (노랑) */
        .st-ship { background-color: #e7f5ff; color: #1c7ed6; }       /* 배송중 (파랑) */
        .st-done { background-color: #f1f3f5; color: #495057; }       /* 배송완료 (회색) */
        .st-cancel { background-color: #fff5f5; color: #fa5252; }     /* 취소/반품 (빨강) */

        /* 버튼 */
        .btn-excel {
            background-color: #206bc4;
            border-color: #206bc4;
            color: white;
            font-size: 13px;
            font-weight: 500;
        }
        .btn-status-change {
            font-size: 12px;
            padding: 4px 8px;
        }
    </style>
</head>
<body>

    <div id="wrapper">
        
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

        <div id="page-content-wrapper">
            
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                
                <h3 class="fw-bold mb-4">통합 주문 검색</h3>

                <div class="card-box">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="search-label">주문일</label>
                            <div class="input-group">
                                <input type="date" class="form-control" value="2026-01-01">
                                <span class="input-group-text">~</span>
                                <input type="date" class="form-control" value="2026-01-08">
                            </div>
                        </div>
                        
                        <div class="col-md-2">
                            <label class="search-label">주문 상태</label>
                            <select class="form-select">
                                <option selected>전체 상태</option>
                                <option value="PAID">결제완료</option>
                                <option value="PREPARING">상품준비중</option>
                                <option value="SHIPPING">배송중</option>
                                <option value="DELIVERED">배송완료</option>
                                <option value="CANCEL">취소/반품</option>
                            </select>
                        </div>

                        <div class="col-md-2">
                            <label class="search-label">결제 수단</label>
                            <select class="form-select">
                                <option selected>전체</option>
                                <option value="CARD">신용카드</option>
                                <option value="BANK">무통장입금</option>
                                <option value="KAKAO">카카오페이</option>
                            </select>
                        </div>
                        
                        <div class="col-md-4">
                            <label class="search-label">상세 검색</label>
                            <div class="input-group">
                                <select class="form-select" style="max-width: 100px;">
                                    <option value="orderNo">주문번호</option>
                                    <option value="memberId">주문자 ID</option>
                                    <option value="productName">상품명</option>
                                </select>
                                <input type="text" class="form-control" placeholder="검색어 입력">
                                <button class="btn btn-outline-secondary" type="button">🔍</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-box">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h5 class="fw-bold m-0 d-inline-block me-2">주문 목록</h5>
                            <span class="text-muted small">총 5건</span>
                        </div>
                        
                        <div class="d-flex gap-2">
                            <select class="form-select form-select-sm" style="width: 130px;">
                                <option>상태 변경</option>
                                <option>상품준비중</option>
                                <option>배송중</option>
                            </select>
                            <button class="btn btn-sm btn-dark">적용</button>
                            <div class="vr mx-2"></div>
                            <button class="btn btn-excel">엑셀 다운로드</button>
                        </div>
                    </div>

                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th style="width: 40px;"><input type="checkbox" class="form-check-input"></th>
                                <th>주문번호</th>
                                <th>주문일시</th>
                                <th>주문자</th>
                                <th style="width: 30%;">상품정보</th>
                                <th>결제금액</th>
                                <th>상태</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td><a href="#" class="order-no">20260105-001</a></td>
                                <td>26-01-05<br><span class="text-muted small">14:30</span></td>
                                <td>
                                    증강산려<br>
                                    <span class="text-muted small">(user_01)</span>
                                </td>
                                <td class="product-info">
                                    <a href="#" class="product-name">프리미엄 가죽 소파 3인용</a>
                                    <span class="product-option">옵션: 다크브라운 / 수량: 1개</span>
                                </td>
                                <td class="fw-bold">850,000원</td>
                                <td><span class="badge-status st-paid">결제완료</span></td>
                                <td>
                                    <button class="btn btn-sm btn-light border" title="주문상세">📄</button>
                                </td>
                            </tr>
                            
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td><a href="#" class="order-no">20260105-002</a></td>
                                <td>26-01-05<br><span class="text-muted small">12:15</span></td>
                                <td>
                                    칸바람나락<br>
                                    <span class="text-muted small">(user_02)</span>
                                </td>
                                <td class="product-info">
                                    <a href="#" class="product-name">모던 LED 스탠드 조명</a>
                                    <span class="product-option">옵션: 화이트 / 수량: 2개</span>
                                </td>
                                <td class="fw-bold">45,000원</td>
                                <td><span class="badge-status st-ready">상품준비</span></td>
                                <td>
                                    <button class="btn btn-sm btn-light border" title="주문상세">📄</button>
                                </td>
                            </tr>

                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td><a href="#" class="order-no">20260104-005</a></td>
                                <td>26-01-04<br><span class="text-muted small">09:40</span></td>
                                <td>
                                    현곡<br>
                                    <span class="text-muted small">(user_03)</span>
                                </td>
                                <td class="product-info">
                                    <a href="#" class="product-name">원목 사이드 테이블</a>
                                    <span class="product-option">옵션: 네추럴우드 / 수량: 1개</span>
                                </td>
                                <td class="fw-bold">120,000원</td>
                                <td><span class="badge-status st-ship">배송중</span></td>
                                <td>
                                    <button class="btn btn-sm btn-light border" title="주문상세">📄</button>
                                    <button class="btn btn-sm btn-light border text-primary" title="배송조회">🚚</button>
                                </td>
                            </tr>
                            
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td><a href="#" class="order-no" style="text-decoration: line-through; color: #999;">20260103-011</a></td>
                                <td>26-01-03<br><span class="text-muted small">18:20</span></td>
                                <td>
                                    홍길동<br>
                                    <span class="text-muted small">(user_test)</span>
                                </td>
                                <td class="product-info">
                                    <span class="product-name text-muted">호텔식 침구 세트 (Q)</span>
                                    <span class="product-option">옵션: 그레이 / 수량: 1개</span>
                                </td>
                                <td class="fw-bold text-muted">159,000원</td>
                                <td><span class="badge-status st-cancel">주문취소</span></td>
                                <td>
                                    <button class="btn btn-sm btn-light border" title="취소상세">📄</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    
                    <nav aria-label="Page navigation" class="mt-4">
                        <ul class="pagination justify-content-center">
                            <li class="page-item disabled"><a class="page-link" href="#">&lt;</a></li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">2</a></li>
                            <li class="page-item"><a class="page-link" href="#">3</a></li>
                            <li class="page-item"><a class="page-link" href="#">&gt;</a></li>
                        </ul>
                    </nav>

                </div> </div> </div> </div> <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />

</body>
</html>