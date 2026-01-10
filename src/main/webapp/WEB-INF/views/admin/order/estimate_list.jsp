<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>견적서 관리 - MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    
    <style>
        /* [Design Strategy] Orange Minimal Luxury - Estimate Version */
        body { 
            background-color: #fcfcfd; 
            color: #202224; 
            font-family: 'Pretendard', -apple-system, sans-serif;
            letter-spacing: -0.5px;
        }
        
        .content-container { padding: 40px; }
        
        /* 1번 스타일: 오렌지 포인트 왼쪽 보더 헤더 */
        .page-header { margin-bottom: 35px; border-left: 5px solid #ff4e00; padding-left: 20px; }
        .page-title { font-weight: 800; font-size: 26px; color: #1a1c1e; margin: 0; }
        .page-desc { color: #8a8a8a; font-size: 14px; margin-top: 4px; text-transform: uppercase; letter-spacing: 1px; }

        /* 각진 미니멀 카드 UI */
        .card-box {
            background: #ffffff;
            border-radius: 2px; /* 1번 사진의 샤프한 특징 */
            border: 1px solid #eee;
            box-shadow: 0 10px 30px rgba(0,0,0,0.02);
            padding: 30px;
            margin-bottom: 30px;
        }

        /* 오렌지 포인트 검색 폼 */
        .search-grid { display: grid; grid-template-columns: 1.2fr 0.8fr 1.5fr auto; gap: 15px; align-items: end; }
        .form-label { font-weight: 700; color: #333; font-size: 12px; margin-bottom: 10px; display: block; text-transform: uppercase; }
        .form-control, .form-select {
            border-radius: 0; border: none; border-bottom: 1px solid #ddd; height: 40px; font-size: 14px; padding: 0; transition: all 0.3s;
        }
        .form-control:focus, .form-select:focus {
            border-bottom: 2px solid #ff4e00; box-shadow: none;
        }
        .btn-orange-main {
            background: #ff4e00; color: #fff; border: none; padding: 0 35px; font-weight: 700; font-size: 13px; height: 40px; transition: 0.3s;
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

        /* 상태 배지 스타일 (1번 사진 무드) */
        .badge-luxury {
            font-size: 11px; font-weight: 700; padding: 4px 10px; border-radius: 0; border: 1px solid #eee; display: inline-block; text-transform: uppercase;
        }
        .st-waiting { border-color: #ff4e00; color: #ff4e00; background: #fffaf7; }    /* 견적 대기 */
        .st-confirmed { border-color: #1a1c1e; color: #1a1c1e; background: #f9fafb; }  /* 주문 확정 */
        .st-cancel { border-color: #eee; color: #bbb; background: #fff; }             /* 취소/반려 */

        /* 텍스트 강조 디테일 */
        .user-name { font-weight: 700; color: #1a1c1e; }
        .request-text { text-align: left !important; color: #555; line-height: 1.4; }
        .date-text { font-family: 'Inter', sans-serif; font-size: 13px; color: #888; }
        
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
                    <h3 class="page-title">견적서 관리</h3>
                    <p class="page-desc">Estimate Request & Business Proposal Management</p>
                </div>

                <div class="card-box">
                    <form class="search-grid">
                        <div>
                            <label class="form-label">요청 기간 (Request Period)</label>
                            <div class="d-flex align-items-center">
                                <input type="date" class="form-control" value="2026-01-01">
                                <span class="mx-2 text-muted">~</span>
                                <input type="date" class="form-control" value="2026-01-08">
                            </div>
                        </div>
                        <div>
                            <label class="form-label">진행 상태</label>
                            <select class="form-select">
                                <option>전체 상태</option>
                                <option>견적 대기</option>
                                <option>발송 완료</option>
                                <option>주문 확정</option>
                                <option>취소/반려</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label">상세 검색 (Search)</label>
                            <input type="text" class="form-control" placeholder="요청자명, 연락처, 상품명 입력">
                        </div>
                        <div>
                            <button class="btn-orange-main">SEARCH</button>
                        </div>
                    </form>
                </div>

                <div class="card-box">
                    <div class="list-header">
                        <div class="count-info">미처리 요청 <b>1</b>건 / 전체 4건</div>
                        <div class="action-group">
                            <button class="btn">선택 삭제</button>
                            <button class="btn">EXCEL DOWNLOAD</button>
                        </div>
                    </div>

                    <table class="table">
                        <thead>
                            <tr>
                                <th style="width: 40px;"><input type="checkbox" class="form-check-input"></th>
                                <th>번호</th>
                                <th>요청자(ID)</th>
                                <th>연락처</th>
                                <th style="width: 30%;">상품명 / 요청내용</th>
                                <th>수량</th>
                                <th>요청일</th>
                                <th>상태</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td class="text-muted">4</td>
                                <td><span class="user-name">증강살려</span><br><span class="text-muted small">(user_01)</span></td>
                                <td class="date-text">010-1234-5678</td>
                                <td class="request-text fw-bold">사무용 의자 대량 구매 견적 요청합니다.</td>
                                <td class="fw-bold">50개</td>
                                <td class="date-text">2026.01.08</td>
                                <td><span class="badge-luxury st-waiting">견적 대기</span></td>
                                <td><button class="btn btn-sm btn-dark px-3" style="border-radius:0;">작성</button></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td class="text-muted">3</td>
                                <td><span class="user-name">박민지</span><br><span class="text-muted small">(company_a)</span></td>
                                <td class="date-text">010-9876-5432</td>
                                <td class="request-text">신입사원 웰컴키트 제작 건</td>
                                <td class="fw-bold">100세트</td>
                                <td class="date-text">2026.01.07</td>
                                <td><span class="badge-luxury">발송 완료</span></td>
                                <td><button class="btn btn-sm btn-light border px-3" style="border-radius:0;">상세</button></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td class="text-muted">2</td>
                                <td><span class="user-name">칼바람나락</span><br><span class="text-muted small">(user_02)</span></td>
                                <td class="date-text">010-5555-7777</td>
                                <td class="request-text">헬스장 덤벨 세트 견적 문의</td>
                                <td class="fw-bold">20세트</td>
                                <td class="date-text">2026.01.05</td>
                                <td><span class="badge-luxury st-confirmed">주문 확정</span></td>
                                <td><button class="btn btn-sm btn-light border px-3" style="border-radius:0;">상세</button></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td class="text-muted">1</td>
                                <td><span class="user-name">협곡</span><br><span class="text-muted small">(user_03)</span></td>
                                <td class="date-text">010-1111-2222</td>
                                <td class="request-text" style="opacity:0.5;">단순 가격 문의 (취소됨)</td>
                                <td class="fw-bold" style="opacity:0.5;">1개</td>
                                <td class="date-text">2026.01.01</td>
                                <td><span class="badge-luxury st-cancel">취소</span></td>
                                <td><button class="btn btn-sm btn-light border px-3" style="border-radius:0;">기록</button></td>
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