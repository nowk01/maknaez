<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 목록 - MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    
    <style>
        /* [공통 스타일] 기존 페이지들과 동일하게 유지 */
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
            white-space: nowrap; /* 헤더 줄바꿈 방지 */
        }
        .table td {
            vertical-align: middle;
            text-align: center;
            font-size: 14px;
        }

        /* [상품 관리 전용 스타일] */
        .product-img-thumb {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 4px;
            border: 1px solid #eee;
            background-color: #f8f9fa;
        }
        
        .product-name-link {
            text-decoration: none;
            color: #333;
            font-weight: 500;
            display: block;
            text-align: left;
            padding-left: 10px;
        }
        .product-name-link:hover {
            color: #0d6efd;
            text-decoration: underline;
        }
        
        .product-code {
            display: block;
            font-size: 11px;
            color: #888;
            text-align: left;
            padding-left: 10px;
            margin-bottom: 2px;
        }

        /* 상태 배지 */
        .badge-status {
            padding: 5px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 500;
        }
        .status-sale { background-color: #e6fcf5; color: #0ca678; } /* 판매중 (민트) */
        .status-soldout { background-color: #fff5f5; color: #e03131; } /* 품절 (빨강) */
        .status-stop { background-color: #f1f3f5; color: #868e96; } /* 판매중지 (회색) */

        /* 버튼 */
        .btn-register {
            background-color: #2c5bf0; /* 메인 테마 블루 */
            border-color: #2c5bf0;
            color: white;
            font-size: 13px;
            font-weight: 500;
            margin-right: 5px;
        }
        .btn-excel {
            background-color: #198754; /* 엑셀은 녹색 */
            border-color: #198754;
            color: white;
            font-size: 13px;
            font-weight: 500;
        }
    </style>
</head>
<body>

    <div id="wrapper">
        
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

        <div id="page-content-wrapper">
            
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                
                <h3 class="fw-bold mb-4">상품 목록/관리</h3>

                <div class="card-box">
                    <div class="row g-3">
                        <div class="col-md-2">
                            <label class="search-label">카테고리</label>
                            <select class="form-select">
                                <option selected>전체</option>
                                <option value="TOP">상의</option>
                                <option value="BOTTOM">하의</option>
                                <option value="OUTER">아우터</option>
                                <option value="SHOES">신발</option>
                            </select>
                        </div>
                        
                        <div class="col-md-2">
                            <label class="search-label">판매 상태</label>
                            <select class="form-select">
                                <option selected>전체</option>
                                <option value="SALE">판매중</option>
                                <option value="SOLDOUT">품절</option>
                                <option value="STOP">판매중지</option>
                            </select>
                        </div>
                        
                        <div class="col-md-5">
                            <label class="search-label">상품 검색</label>
                            <div class="input-group">
                                <select class="form-select" style="max-width: 120px;">
                                    <option value="name">상품명</option>
                                    <option value="code">상품코드</option>
                                </select>
                                <input type="text" class="form-control" placeholder="검색어를 입력하세요">
                                <button class="btn btn-outline-secondary" type="button">🔍</button>
                            </div>
                        </div>
                        
                        <div class="col-md-3">
                            <label class="search-label">등록일</label>
                             <div class="input-group">
                                <input type="date" class="form-control" value="2026-01-01">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-box">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h5 class="fw-bold m-0 d-inline-block me-2">상품 목록</h5>
                            <span class="text-muted small">총 120개</span>
                        </div>
                        <div>
                            <button class="btn btn-register" onclick="location.href='${pageContext.request.contextPath}/admin/product/write'">+ 상품 등록</button>
                            <button class="btn btn-excel">엑셀 다운로드</button>
                        </div>
                    </div>

                    <table class="table table-hover">
                        <colgroup>
                            <col width="40">
                            <col width="50">
                            <col width="70">
                            <col width="100">
                            <col width="*">
                            <col width="100">
                            <col width="80">
                            <col width="80">
                            <col width="100">
                            <col width="100">
                        </colgroup>
                        <thead>
                            <tr>
                                <th><input type="checkbox" class="form-check-input"></th>
                                <th>No</th>
                                <th>이미지</th>
                                <th>카테고리</th>
                                <th>상품정보 (코드/명)</th>
                                <th>판매가</th>
                                <th>재고</th>
                                <th>상태</th>
                                <th>등록일</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td>120</td>
                                <td>
                                    <img src="https://via.placeholder.com/50" class="product-img-thumb" alt="상품">
                                </td>
                                <td>아우터</td>
                                <td>
                                    <span class="product-code">P2026010501</span>
                                    <a href="#" class="product-name-link">오버핏 울 코트 (Black)</a>
                                </td>
                                <td>189,000</td>
                                <td>50</td>
                                <td><span class="badge-status status-sale">판매중</span></td>
                                <td>2026-01-05</td>
                                <td>
                                    <button class="btn btn-sm btn-light border" title="수정">✏️</button>
                                    <button class="btn btn-sm btn-light border text-danger" title="삭제">🗑️</button>
                                </td>
                            </tr>
                            
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td>119</td>
                                <td>
                                    <img src="https://via.placeholder.com/50" class="product-img-thumb" alt="상품">
                                </td>
                                <td>신발</td>
                                <td>
                                    <span class="product-code">S2026010405</span>
                                    <a href="#" class="product-name-link">어반 러닝화 V2</a>
                                </td>
                                <td>89,000</td>
                                <td class="text-danger fw-bold">0</td>
                                <td><span class="badge-status status-soldout">품절</span></td>
                                <td>2026-01-04</td>
                                <td>
                                    <button class="btn btn-sm btn-light border" title="수정">✏️</button>
                                    <button class="btn btn-sm btn-light border text-danger" title="삭제">🗑️</button>
                                </td>
                            </tr>

                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td>118</td>
                                <td>
                                    <img src="https://via.placeholder.com/50" class="product-img-thumb" alt="상품">
                                </td>
                                <td>상의</td>
                                <td>
                                    <span class="product-code">T2025123101</span>
                                    <a href="#" class="product-name-link">베이직 기모 후드티</a>
                                </td>
                                <td>39,000</td>
                                <td>12</td>
                                <td><span class="badge-status status-stop">판매중지</span></td>
                                <td>2025-12-31</td>
                                <td>
                                    <button class="btn btn-sm btn-light border" title="수정">✏️</button>
                                    <button class="btn btn-sm btn-light border text-danger" title="삭제">🗑️</button>
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
                            <li class="page-item"><a class="page-link" href="#">4</a></li>
                            <li class="page-item"><a class="page-link" href="#">5</a></li>
                            <li class="page-item"><a class="page-link" href="#">&gt;</a></li>
                        </ul>
                    </nav>

                </div> </div> </div> </div> <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />

</body>
</html>