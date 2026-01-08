<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>재고 관리 - MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    
    <style>
        /* [공통 레이아웃] */
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

        /* [재고 관리 전용 스타일] */
        .product-img-thumb {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 4px;
            border: 1px solid #eee;
        }
        
        .stock-input {
            width: 80px;
            text-align: center;
            display: inline-block;
        }

        /* 재고 상태 배지 */
        .badge-stock-out { background-color: #ffe3e3; color: #fa5252; } /* 품절 (빨강) */
        .badge-stock-low { background-color: #fff3bf; color: #f08c00; } /* 부족 (노랑) */
        .badge-stock-ok { background-color: #e6fcf5; color: #0ca678; }  /* 여유 (초록) */

        .product-info-text {
            text-align: left;
            padding-left: 10px;
        }
        .option-badge {
            font-size: 11px;
            background-color: #f1f3f5;
            color: #495057;
            padding: 2px 6px;
            border-radius: 3px;
            margin-top: 4px;
            display: inline-block;
        }
    </style>
</head>
<body>

    <div id="wrapper">
        
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

        <div id="page-content-wrapper">
            
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                
                <h3 class="fw-bold mb-4">재고 관리</h3>

                <div class="card-box">
                    <div class="row g-3">
                        <div class="col-md-3">
                            <label class="search-label">카테고리</label>
                            <select class="form-select">
                                <option selected>전체 카테고리</option>
                                <option value="OUTER">OUTER</option>
                                <option value="TOP">TOP</option>
                                <option value="BOTTOM">BOTTOM</option>
                            </select>
                        </div>
                        
                        <div class="col-md-3">
                            <label class="search-label">재고 상태</label>
                            <select class="form-select">
                                <option selected>전체</option>
                                <option value="soldout">품절 (0개)</option>
                                <option value="low">부족 (10개 미만)</option>
                                <option value="ok">여유</option>
                            </select>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="search-label">상품 검색</label>
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="상품명, 상품코드 검색">
                                <button class="btn btn-outline-secondary" type="button">🔍</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-box">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h5 class="fw-bold m-0 d-inline-block me-2">재고 현황</h5>
                            <span class="badge bg-danger bg-opacity-10 text-danger border border-danger p-1">품절 1건</span>
                            <span class="badge bg-warning bg-opacity-10 text-warning border border-warning p-1">부족 1건</span>
                        </div>
                        <div>
                            <button class="btn btn-outline-success btn-sm me-1" onclick="alert('변경사항이 저장되었습니다.')">💾 전체 저장</button>
                            <button class="btn btn-dark btn-sm" style="font-size: 13px;">엑셀 다운로드</button>
                        </div>
                    </div>

                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th width="40"><input type="checkbox" class="form-check-input"></th>
                                <th width="80">이미지</th>
                                <th>상품명 / 옵션</th>
                                <th>판매가</th>
                                <th width="150">현재 재고</th>
                                <th width="100">상태</th>
                                <th width="100">관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td>
                                    <div class="bg-light d-flex align-items-center justify-content-center product-img-thumb">
                                        <i class="fas fa-tshirt text-secondary"></i>
                                    </div>
                                </td>
                                <td>
                                    <div class="product-info-text">
                                        <div class="fw-bold">베이직 코튼 티셔츠</div>
                                        <span class="option-badge">Size: L / Color: White</span>
                                    </div>
                                </td>
                                <td>19,000원</td>
                                <td>
                                    <input type="number" class="form-control form-control-sm stock-input border-danger" value="0">
                                </td>
                                <td><span class="badge badge-stock-out">품절</span></td>
                                <td>
                                    <button class="btn btn-sm btn-light border">입고</button>
                                </td>
                            </tr>

                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td>
                                    <div class="bg-light d-flex align-items-center justify-content-center product-img-thumb">
                                        <i class="fas fa-tshirt text-secondary"></i>
                                    </div>
                                </td>
                                <td>
                                    <div class="product-info-text">
                                        <div class="fw-bold">와이드 데님 팬츠</div>
                                        <span class="option-badge">Size: M / Color: Blue</span>
                                    </div>
                                </td>
                                <td>39,000원</td>
                                <td>
                                    <input type="number" class="form-control form-control-sm stock-input border-warning" value="3">
                                </td>
                                <td><span class="badge badge-stock-low">부족</span></td>
                                <td>
                                    <button class="btn btn-sm btn-light border">입고</button>
                                </td>
                            </tr>

                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td>
                                    <div class="bg-light d-flex align-items-center justify-content-center product-img-thumb">
                                        <i class="fas fa-tshirt text-secondary"></i>
                                    </div>
                                </td>
                                <td>
                                    <div class="product-info-text">
                                        <div class="fw-bold">오버핏 체크 셔츠</div>
                                        <span class="option-badge">Size: FREE / Color: Green</span>
                                    </div>
                                </td>
                                <td>45,000원</td>
                                <td>
                                    <input type="number" class="form-control form-control-sm stock-input" value="150">
                                </td>
                                <td><span class="badge badge-stock-ok">여유</span></td>
                                <td>
                                    <button class="btn btn-sm btn-light border">입고</button>
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