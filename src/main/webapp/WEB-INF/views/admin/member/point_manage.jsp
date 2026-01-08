<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마일리지 관리 - MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    
    <style>
        /* [공통 스타일] 회원 조회 페이지와 동일하게 유지 */
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
        }
        .table td {
            vertical-align: middle;
            text-align: center;
            font-size: 14px;
        }

        /* 버튼 스타일 */
        .btn-excel {
            background-color: #206bc4; /* 엑셀 다운로드는 보통 녹색 계열이나, 테마에 맞춰 남색/파랑 유지 */
            border-color: #206bc4;
            color: white;
            font-size: 13px;
            font-weight: 500;
        }
        .btn-give {
            background-color: #0ca678; /* 지급 버튼 (초록) */
            border-color: #0ca678;
            color: white;
            font-size: 13px;
            font-weight: 500;
            margin-right: 5px;
        }

        /* [마일리지 전용 스타일] */
        .point-plus {
            color: #0d6efd; /* 적립: 파랑 */
            font-weight: bold;
        }
        .point-minus {
            color: #dc3545; /* 사용: 빨강 */
            font-weight: bold;
        }
    </style>
</head>
<body>

    <div id="wrapper">
        
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

        <div id="page-content-wrapper">
            
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                
                <h3 class="fw-bold mb-4">마일리지 관리</h3>

                <div class="card-box">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="search-label">조회 기간 (지급/사용일)</label>
                            <div class="input-group">
                                <input type="date" class="form-control" value="2026-01-01">
                                <span class="input-group-text">~</span>
                                <input type="date" class="form-control" value="2026-01-08">
                            </div>
                        </div>
                        
                        <div class="col-md-3">
                            <label class="search-label">구분</label>
                            <select class="form-select">
                                <option selected>전체</option>
                                <option value="EARN">적립 (+)</option>
                                <option value="USE">사용 (-)</option>
                            </select>
                        </div>
                        
                        <div class="col-md-5">
                            <label class="search-label">회원 검색</label>
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="아이디, 이름으로 검색">
                                <button class="btn btn-outline-secondary" type="button">🔍</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-box">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h5 class="fw-bold m-0 d-inline-block me-2">마일리지 내역</h5>
                            <span class="text-muted small">총 15건</span>
                        </div>
                        <div>
                            <button class="btn btn-give">💰 마일리지 지급</button>
                            <button class="btn btn-excel">엑셀 다운로드</button>
                        </div>
                    </div>

                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th style="width: 50px;"><input type="checkbox" class="form-check-input"></th>
                                <th>번호</th>
                                <th>아이디</th>
                                <th>이름</th>
                                <th>내용</th>
                                <th>변동금액</th>
                                <th>처리일시</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td>3</td>
                                <td>user_01</td>
                                <td>증강산려</td>
                                <td>회원가입 축하금</td>
                                <td class="point-plus">+ 3,000 P</td>
                                <td>2026-01-05 14:30</td>
                                <td>
                                    <button class="btn btn-sm btn-light border" title="상세보기">📝</button>
                                </td>
                            </tr>
                            
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td>2</td>
                                <td>user_02</td>
                                <td>칸바람나락</td>
                                <td>상품 구매 사용 (주문번호: 260105001)</td>
                                <td class="point-minus">- 1,500 P</td>
                                <td>2026-01-04 10:15</td>
                                <td>
                                    <button class="btn btn-sm btn-light border" title="상세보기">📝</button>
                                </td>
                            </tr>

                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td>1</td>
                                <td>user_03</td>
                                <td>현곡</td>
                                <td>포토리뷰 작성 적립</td>
                                <td class="point-plus">+ 500 P</td>
                                <td>2026-01-02 09:00</td>
                                <td>
                                    <button class="btn btn-sm btn-light border" title="상세보기">📝</button>
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