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
        body { 
            background-color: #f9fbfd; 
            color: #2d3748; 
            font-family: 'Pretendard', -apple-system, sans-serif;
            letter-spacing: -0.03em;
        }
        
        .content-container { padding: 40px; }
        
        .page-header { margin-bottom: 30px; }
        .page-title { font-weight: 800; font-size: 26px; color: #1a202c; margin-bottom: 6px; }
        .page-desc { color: #718096; font-size: 14px; }

        .card-box {
            background: #ffffff;
            border-radius: 12px;
            border: 1px solid rgba(0,0,0,0.03);
            box-shadow: 0 4px 20px rgba(0,0,0,0.02);
            padding: 30px;
            margin-bottom: 25px;
        }

        .search-grid { display: grid; grid-template-columns: repeat(3, 1fr) auto; gap: 20px; align-items: end; }
        .form-label { font-weight: 700; color: #4a5568; font-size: 13px; margin-bottom: 10px; display: block; }
        .form-control, .form-select {
            border-radius: 8px; border: 1px solid #e2e8f0; height: 42px; font-size: 14px; padding: 0 15px; 
            transition: 0.2s ease-in-out; background-color: #f8fafc;
        }
        .form-control:focus, .form-select:focus {
            background-color: #fff; border-color: #1a202c; box-shadow: 0 0 0 3px rgba(0,0,0,0.05);
        }
        .btn-search-main {
            background: #1a202c; color: #fff; border: none; border-radius: 8px; padding: 0 30px; 
            font-weight: 700; font-size: 14px; height: 42px; transition: 0.3s;
        }
        .btn-search-main:hover { background: #000; transform: translateY(-1px); }

        .list-ctrl { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .stat-text { font-size: 14px; color: #718096; }
        .stat-text b { color: #1a202c; font-weight: 800; }
        
        .btn-group-custom .btn { 
            font-size: 12.5px; font-weight: 600; padding: 8px 16px; border-radius: 8px; margin-left: 6px; 
            border: 1px solid #e2e8f0; background: #fff; color: #4a5568; transition: 0.2s;
        }
        .btn-group-custom .btn:hover { border-color: #1a202c; color: #1a202c; background: #f8fafc; }

        .custom-table { width: 100%; border-collapse: separate; border-spacing: 0; }
        .custom-table thead th {
            background: #f8fafc; color: #4a5568; font-weight: 700; font-size: 13px; 
            padding: 16px; border-bottom: 1px solid #edf2f7; text-align: center;
        }
        .custom-table tbody td {
            padding: 18px 16px; vertical-align: middle; border-bottom: 1px solid #edf2f7; 
            text-align: center; font-size: 14.5px; color: #2d3748;
        }
        .custom-table tbody tr:hover td { background-color: #f9fafb; }

        .k-badge {
            font-size: 11.5px; font-weight: 700; padding: 4px 12px; border-radius: 30px; display: inline-block;
        }
        .k-badge.plus { background-color: #ebf8ff; color: #2a4365; border: 1px solid #bee3f8; }    /* 적립 */
        .k-badge.minus { background-color: #fff5f5; color: #c53030; border: 1px solid #feb2b2; }   /* 차감 */

        .point-text { font-family: 'Inter', sans-serif; font-weight: 700; }
        .plus-val { color: #2b6cb0; }
        .minus-val { color: #c53030; }

        .pagination { gap: 8px; }
        .pagination .page-link { 
            border: none; color: #a0aec0; font-size: 14px; padding: 8px 16px; 
            font-weight: 600; border-radius: 8px !important;
        }
        .pagination .page-item.active .page-link { background: #1a202c; color: #fff; }
    </style>
</head>
<body>

    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                
                <div class="page-header">
                    <h3 class="page-title">마일리지 관리</h3>
                    <p class="page-desc">회원별 적립금 지급 및 차감 내역을 관리합니다.</p>
                </div>

                <div class="card-box">
                    <form class="search-grid">
                        <div>
                            <label class="form-label">조회 기간</label>
                            <div class="d-flex align-items-center">
                                <input type="date" class="form-control" value="2025-01-01">
                                <span class="mx-2 text-muted">~</span>
                                <input type="date" class="form-control" value="2026-01-11">
                            </div>
                        </div>
                        <div>
                            <label class="form-label">구분 (Type)</label>
                            <select class="form-select">
                                <option>전체 내역</option>
                                <option>포인트 적립 (+)</option>
                                <option>포인트 차감 (-)</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label">회원 검색 (Search)</label>
                            <input type="text" class="form-control" placeholder="아이디 또는 회원명 입력">
                        </div>
                        <div>
                            <button class="btn-search-main">검색</button>
                        </div>
                    </form>
                </div>

                <div class="card-box">
                    <div class="list-ctrl">
                        <div class="stat-text">검색 결과 <b>3</b>건의 내역이 있습니다.</div>
                        <div class="btn-group-custom">
                            <button class="btn"><i class="fas fa-plus-circle me-1"></i>일괄 적립</button>
                            <button class="btn"><i class="fas fa-minus-circle me-1"></i>일괄 차감</button>
                            <button class="btn"><i class="fas fa-file-excel me-1"></i>엑셀 다운로드</button>
                        </div>
                    </div>

                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th style="width: 50px;"><input type="checkbox" class="form-check-input"></th>
                                <th style="width: 80px;">번호</th>
                                <th>아이디</th>
                                <th>회원명</th>
                                <th>적립/차감 사유</th>
                                <th class="text-end">변동 금액</th>
                                <th>처리일</th>
                                <th>상태</th>
                                <th style="width: 80px;">관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td class="text-muted">3</td>
                                <td class="fw-bold">op.gg</td>
                                <td>칼바람나락</td>
                                <td class="text-start">신규 가입 환영 포인트</td>
                                <td class="text-end point-text plus-val">+3,000 P</td>
                                <td class="text-muted" style="font-size:13px;">2025.12.10</td>
                                <td><span class="k-badge plus">적립완료</span></td>
                                <td><i class="fas fa-search-plus text-muted" style="cursor: pointer;"></i></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td class="text-muted">2</td>
                                <td class="fw-bold">plz_lol</td>
                                <td>증강살려</td>
                                <td class="text-start">상품 구매 마일리지 적립 (ORD-20250101)</td>
                                <td class="text-end point-text plus-val">+450 P</td>
                                <td class="text-muted" style="font-size:13px;">2025.11.20</td>
                                <td><span class="k-badge plus">적립완료</span></td>
                                <td><i class="fas fa-search-plus text-muted" style="cursor: pointer;"></i></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td class="text-muted">1</td>
                                <td class="fw-bold">faker_good</td>
                                <td>협곡</td>
                                <td class="text-start">포인트 유효기간 만료 소멸</td>
                                <td class="text-end point-text minus-val">-1,200 P</td>
                                <td class="text-muted" style="font-size:13px;">2025.10.03</td>
                                <td><span class="k-badge minus">차감완료</span></td>
                                <td><i class="fas fa-search-plus text-muted" style="cursor: pointer;"></i></td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="mt-5 d-flex justify-content-center">
                        <ul class="pagination">
                            <li class="page-item"><a class="page-link" href="#"><i class="fas fa-chevron-left"></i></a></li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">2</a></li>
                            <li class="page-item"><a class="page-link" href="#"><i class="fas fa-chevron-right"></i></a></li>
                        </ul>
                    </div>
                </div>

            </div>
        </div>
    </div> 
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
</body>
</html>