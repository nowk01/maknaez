<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>취소/반품 관리 - MAKNAEZ ADMIN</title>
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
            font-size: 14px;
        }
        .table td {
            vertical-align: middle;
            text-align: center;
            font-size: 14px;
        }

        /* [취소/반품 전용 배지 스타일] */
        .badge-type {
            font-size: 11px;
            padding: 4px 8px;
            border-radius: 4px;
            font-weight: normal;
            border: 1px solid #ddd;
            background-color: #fff;
            color: #555;
        }
        
        .badge-status {
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
        }
        /* 상태별 색상 */
        .status-request { background-color: #fff5f5; color: #e03131; } /* 요청 (빨강) */
        .status-process { background-color: #e7f5ff; color: #1971c2; } /* 처리중 (파랑) */
        .status-done { background-color: #e6fcf5; color: #0ca678; }    /* 완료 (초록) */

        /* 상품명 스타일 */
        .product-name {
            text-align: left;
            padding-left: 10px !important;
            max-width: 250px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* 버튼 */
        .btn-excel {
            background-color: #206bc4;
            border-color: #206bc4;
            color: white;
            font-size: 13px;
        }
        .btn-action {
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
                
                <h3 class="fw-bold mb-4">취소/반품 관리</h3>

                <div class="card-box">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="search-label">접수 기간</label>
                            <div class="input-group">
                                <input type="date" class="form-control" value="2026-01-01">
                                <span class="input-group-text">~</span>
                                <input type="date" class="form-control" value="2026-01-08">
                            </div>
                        </div>
                        
                        <div class="col-md-2">
                            <label class="search-label">청구 유형</label>
                            <select class="form-select">
                                <option selected>전체</option>
                                <option value="CANCEL">취소</option>
                                <option value="RETURN">반품</option>
                                <option value="EXCHANGE">교환</option>
                            </select>
                        </div>

                        <div class="col-md-2">
                            <label class="search-label">처리 상태</label>
                            <select class="form-select">
                                <option selected>전체</option>
                                <option value="REQUEST">접수(요청)</option>
                                <option value="PROCESSING">처리중</option>
                                <option value="DONE">처리완료</option>
                            </select>
                        </div>
                        
                        <div class="col-md-4">
                            <label class="search-label">상세 검색</label>
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="주문번호, 회원ID, 상품명">
                                <button class="btn btn-outline-secondary" type="button">🔍</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-box">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h5 class="fw-bold m-0 d-inline-block me-2">클레임 목록</h5>
                            <span class="text-muted small">신규 요청 <span class="text-danger fw-bold">2</span>건</span>
                        </div>
                        <div>
                            <button class="btn btn-sm btn-outline-dark me-1">상태 일괄변경</button>
                            <button class="btn btn-excel">엑셀 다운로드</button>
                        </div>
                    </div>

                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th style="width: 40px;"><input type="checkbox" class="form-check-input"></th>
                                <th>접수일</th>
                                <th>유형</th>
                                <th>주문번호</th>
                                <th>상품명</th>
                                <th>신청자(ID)</th>
                                <th>사유</th>
                                <th>상태</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td>2026-01-08</td>
                                <td><span class="badge-type">반품</span></td>
                                <td><a href="#" class="text-decoration-none">260105001</a></td>
                                <td class="product-name">기본 라운드 티셔츠 (Black/L) 외 1건</td>
                                <td>홍길동(user1)</td>
                                <td>사이즈 불일치</td>
                                <td><span class="badge-status status-request">접수</span></td>
                                <td>
                                    <button class="btn btn-action btn-primary">승인</button>
                                </td>
                            </tr>
                            
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td>2026-01-07</td>
                                <td><span class="badge-type">취소</span></td>
                                <td><a href="#" class="text-decoration-none">260104088</a></td>
                                <td class="product-name">와이드 데님 팬츠</td>
                                <td>김철수(user2)</td>
                                <td>단순 변심</td>
                                <td><span class="badge-status status-done">완료</span></td>
                                <td>
                                    <button class="btn btn-action btn-light border">상세</button>
                                </td>
                            </tr>

                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td>2026-01-05</td>
                                <td><span class="badge-type">교환</span></td>
                                <td><a href="#" class="text-decoration-none">260102112</a></td>
                                <td class="product-name">소가죽 벨트</td>
                                <td>이영희(user3)</td>
                                <td>상품 불량</td>
                                <td><span class="badge-status status-process">수거중</span></td>
                                <td>
                                    <button class="btn btn-action btn-light border">상세</button>
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