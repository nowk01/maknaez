<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>주문 내역 관리 - MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    
    <style>
        /* [Design Strategy] Orange Minimal Luxury (1번 사진 무드 결합) */
        body { 
            background-color: #fcfcfd; 
            color: #202224; 
            font-family: 'Pretendard', -apple-system, sans-serif;
            letter-spacing: -0.5px;
        }
        
        .content-container { padding: 40px; }
        
        /* 1번 스타일의 시크한 헤더 */
        .page-header { margin-bottom: 35px; border-left: 5px solid #ff4e00; padding-left: 20px; }
        .page-title { font-weight: 800; font-size: 26px; color: #1a1c1e; margin: 0; }
        .page-desc { color: #8a8a8a; font-size: 14px; margin-top: 4px; text-transform: uppercase; letter-spacing: 1px; }

        /* 각진 미니멀 카드 UI */
        .card-box {
            background: #ffffff;
            border-radius: 2px; /* 1번 사진의 샤프한 느낌 */
            border: 1px solid #eee;
            box-shadow: 0 10px 30px rgba(0,0,0,0.02);
            padding: 30px;
            margin-bottom: 30px;
        }

        /* 오렌지 포인트 검색 폼 */
        .search-grid { display: grid; grid-template-columns: 1.2fr 0.8fr 0.8fr 1.5fr auto; gap: 15px; align-items: end; }
        .form-label { font-weight: 700; color: #333; font-size: 12px; margin-bottom: 10px; display: block; text-transform: uppercase; }
        .form-control, .form-select {
            border-radius: 0; border: none; border-bottom: 1px solid #ddd; height: 40px; font-size: 14px; padding: 0; transition: all 0.3s;
        }
        .form-control:focus, .form-select:focus {
            border-bottom: 2px solid #ff4e00; box-shadow: none;
        }
        .btn-orange-main {
            background: #ff4e00; color: #fff; border: none; padding: 0 30px; font-weight: 700; font-size: 13px; height: 40px; transition: 0.3s;
        }
        .btn-orange-main:hover { background: #000; color: #fff; box-shadow: 0 4px 12px rgba(255, 78, 0, 0.2); }

        /* 리스트 컨트롤 바 */
        .list-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .count-info { font-size: 14px; color: #666; }
        .count-info b { color: #ff4e00; font-size: 16px; }
        
        .action-group .btn { 
            font-size: 12px; font-weight: 600; padding: 7px 15px; border-radius: 0; margin-left: 5px; border: 1px solid #ddd; background: #fff; color: #555;
        }
        .action-group .btn:hover { border-color: #ff4e00; color: #ff4e00; }

        /* 프리미엄 테이블 */
        .table { width: 100%; border-top: 2px solid #1a1c1e; }
        .table thead th {
            background: #fbfbfb; color: #222; font-weight: 700; font-size: 13px; padding: 15px; border-bottom: 1px solid #eee; text-align: center;
        }
        .table tbody td {
            padding: 18px 15px; vertical-align: middle; border-bottom: 1px solid #f5f5f5; text-align: center; font-size: 14px; color: #444;
        }
        .table tbody tr:hover { background-color: #fcfcfc; }

        /* 오렌지 & 다크 배지 스타일 */
        .badge-luxury {
            font-size: 11px; font-weight: 700; padding: 4px 10px; border-radius: 0; border: 1px solid #eee; display: inline-block; text-transform: uppercase;
        }
        .st-paid { border-color: #ff4e00; color: #ff4e00; background: #fffaf7; }    /* 결제완료 */
        .st-ship { border-color: #1a1c1e; color: #1a1c1e; background: #f9fafb; }    /* 배송중 */
        .st-cancel { border-color: #eee; color: #bbb; background: #fff; text-decoration: line-through; } /* 취소 */

        /* 텍스트 강조 */
        .order-no { font-family: 'Inter', sans-serif; font-weight: 800; color: #1a1c1e; text-decoration: none; border-bottom: 1px solid #1a1c1e; }
        .order-no:hover { color: #ff4e00; border-color: #ff4e00; }
        .price-text { font-weight: 800; color: #1a1c1e; }
        
        /* 페이지네이션 */
        .pagination .page-link { border: none; color: #999; font-size: 14px; padding: 8px 15px; font-weight: 600; }
        .pagination .page-item.active .page-link { background: none; color: #ff4e00; font-weight: 800; text-decoration: underline; text-underline-offset: 5px; }
    </style>
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
                                <input type="date" class="form-control" value="2026-01-08">
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
                            <button class="btn-orange-main">SEARCH</button>
                        </div>
                    </form>
                </div>

                <div class="card-box">
                    <div class="list-header">
                        <div class="count-info">Showing <b>4</b> orders results</div>
                        <div class="action-group">
                            <button class="btn">상태 일괄변경</button>
                            <button class="btn">발주 확인</button>
                            <button class="btn">EXCEL 다운로드</button>
                        </div>
                    </div>

                    <table class="table">
                        <thead>
                            <tr>
                                <th style="width: 40px;"><input type="checkbox" class="form-check-input"></th>
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
                                <td class="price-text">1850,000원</td>
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
                                <td class="fw-bold">짱구는못말려<br><span class="text-muted small" style="font-weight: 400;">(user_test)</span></td>
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
</body>
</html>