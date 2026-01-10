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
        /* [Design Strategy] Orange Minimal Luxury - Claim Version */
        body { 
            background-color: #fcfcfd; 
            color: #202224; 
            font-family: 'Pretendard', -apple-system, sans-serif;
            letter-spacing: -0.5px;
        }
        
        .content-container { padding: 40px; }
        
        /* 1번 스타일의 시크한 오렌지 헤더 */
        .page-header { margin-bottom: 35px; border-left: 5px solid #ff4e00; padding-left: 20px; }
        .page-title { font-weight: 800; font-size: 26px; color: #1a1c1e; margin: 0; }
        .page-desc { color: #8a8a8a; font-size: 14px; margin-top: 4px; text-transform: uppercase; letter-spacing: 1px; }

        /* 각진 미니멀 카드 UI */
        .card-box {
            background: #ffffff;
            border-radius: 2px;
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

        /* 오렌지 배지 스타일 */
        .badge-luxury {
            font-size: 11px; font-weight: 700; padding: 4px 10px; border-radius: 0; border: 1px solid #eee; display: inline-block; text-transform: uppercase;
        }
        .st-request { border-color: #ff4e00; color: #ff4e00; background: #fffaf7; }    /* 요청/접수 */
        .st-done { border-color: #1a1c1e; color: #1a1c1e; background: #f9fafb; }       /* 처리완료 */
        .st-wait { border-color: #ddd; color: #888; background: #fff; }              /* 대기 */

        /* 텍스트 강조 */
        .claim-date { font-family: 'Inter', sans-serif; font-weight: 600; color: #ff4e00; }
        .order-link { color: #1a1c1e; font-weight: 700; text-decoration: underline; text-underline-offset: 3px; }
        .order-link:hover { color: #ff4e00; }
        
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
                    <h3 class="page-title">취소/반품 관리</h3>
                    <p class="page-desc">Claim & Return Management Protocol</p>
                </div>

                <div class="card-box">
                    <form class="search-grid">
                        <div>
                            <label class="form-label">접수 기간 (Claim Date)</label>
                            <div class="d-flex align-items-center">
                                <input type="date" class="form-control" value="2026-01-01">
                                <span class="mx-2 text-muted">~</span>
                                <input type="date" class="form-control" value="2026-01-08">
                            </div>
                        </div>
                        <div>
                            <label class="form-label">청구 유형</label>
                            <select class="form-select">
                                <option>전체 유형</option>
                                <option>취소 (Cancel)</option>
                                <option>반품 (Return)</option>
                                <option>교환 (Exchange)</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label">처리 상태</label>
                            <select class="form-select">
                                <option>전체 상태</option>
                                <option>접수 대기</option>
                                <option>처리 중</option>
                                <option>완료</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label">상세 검색 (Search)</label>
                            <input type="text" class="form-control" placeholder="주문번호 또는 ID">
                        </div>
                        <div>
                            <button class="btn-orange-main">SEARCH</button>
                        </div>
                    </form>
                </div>

                <div class="card-box">
                    <div class="list-header">
                        <div class="count-info">미처리 요청 <b>2</b>건 / 전체 3건</div>
                        <div class="action-group">
                            <button class="btn">상태 일괄승인</button>
                            <button class="btn">반려 처리</button>
                            <button class="btn">EXCEL DOWNLOAD</button>
                        </div>
                    </div>

                    <table class="table">
                        <thead>
                            <tr>
                                <th style="width: 40px;"><input type="checkbox" class="form-check-input"></th>
                                <th>접수일</th>
                                <th>유형</th>
                                <th>주문번호</th>
                                <th style="width: 25%;">상품명</th>
                                <th>신청자(ID)</th>
                                <th>사유</th>
                                <th>현재상태</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td><span class="claim-date">2026.01.08</span></td>
                                <td><span class="badge-luxury">반품</span></td>
                                <td><a href="#" class="order-link">260105001</a></td>
                                <td class="text-start fw-bold">기본 라운드 티셔츠 외 1건</td>
                                <td>홍길동<br><span class="text-muted small" style="font-weight:400;">(user_01)</span></td>
                                <td class="text-muted">사이즈 불일치</td>
                                <td><span class="badge-luxury st-request">접수 대기</span></td>
                                <td><button class="btn btn-sm btn-dark px-3" style="border-radius:0;">승인</button></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td class="text-muted">2026.01.07</td>
                                <td><span class="badge-luxury">취소</span></td>
                                <td><a href="#" class="order-link">260104088</a></td>
                                <td class="text-start fw-bold">와이드 데님 팬츠</td>
                                <td>칼바람나락<br><span class="text-muted small" style="font-weight:400;">(user_02)</span></td>
                                <td class="text-muted">단순 변심</td>
                                <td><span class="badge-luxury st-done">환불 완료</span></td>
                                <td><button class="btn btn-sm btn-light border px-3" style="border-radius:0;">상세</button></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td class="text-muted">2026.01.05</td>
                                <td><span class="badge-luxury">교환</span></td>
                                <td><a href="#" class="order-link">260102112</a></td>
                                <td class="text-start fw-bold">소가죽 벨트</td>
                                <td>협곡<br><span class="text-muted small" style="font-weight:400;">(user_03)</span></td>
                                <td class="text-muted">상품 불량</td>
                                <td><span class="badge-luxury st-wait">수거중</span></td>
                                <td><button class="btn btn-sm btn-light border px-3" style="border-radius:0;">상세</button></td>
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