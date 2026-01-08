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
        /* [공통 스타일] 기존 페이지들과 통일 */
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
            white-space: nowrap;
        }
        .table td {
            vertical-align: middle;
            text-align: center;
            font-size: 14px;
        }

        /* 버튼 스타일 */
        .btn-excel {
            background-color: #206bc4;
            border-color: #206bc4;
            color: white;
            font-size: 13px;
            font-weight: 500;
        }

        /* [견적서 관리 전용 상태 배지] */
        .badge-status {
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
        }
        /* 견적 대기 (노란색 배경 / 진한 글씨) */
        .status-waiting { background-color: #fff3cd; color: #d63384; } 
        /* 발송 완료 (파란색) */
        .status-sent { background-color: #e7f5ff; color: #1c7ed6; } 
        /* 주문 확정 (초록색) */
        .status-confirmed { background-color: #e6fcf5; color: #0ca678; } 
        /* 취소/반려 (회색) */
        .status-cancel { background-color: #f1f3f5; color: #868e96; }
    </style>
</head>
<body>

    <div id="wrapper">
        
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

        <div id="page-content-wrapper">
            
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                
                <h3 class="fw-bold mb-4">견적서 관리</h3>

                <div class="card-box">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="search-label">요청 일자</label>
                            <div class="input-group">
                                <input type="date" class="form-control" value="2026-01-01">
                                <span class="input-group-text">~</span>
                                <input type="date" class="form-control" value="2026-01-08">
                            </div>
                        </div>
                        
                        <div class="col-md-3">
                            <label class="search-label">진행 상태</label>
                            <select class="form-select">
                                <option selected>전체 상태</option>
                                <option value="WAITING">견적 대기</option>
                                <option value="SENT">발송 완료</option>
                                <option value="CONFIRMED">주문 확정</option>
                                <option value="CANCEL">취소/반려</option>
                            </select>
                        </div>
                        
                        <div class="col-md-5">
                            <label class="search-label">통합 검색</label>
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="요청자명, 연락처, 상품명">
                                <button class="btn btn-outline-secondary" type="button">🔍</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-box">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h5 class="fw-bold m-0 d-inline-block me-2">견적 요청 목록</h5>
                            <span class="text-muted small">총 4건</span>
                        </div>
                        <div>
                            <button class="btn btn-outline-dark btn-sm me-1">선택 삭제</button>
                            <button class="btn btn-excel">엑셀 다운로드</button>
                        </div>
                    </div>

                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th style="width: 40px;"><input type="checkbox" class="form-check-input"></th>
                                <th>번호</th>
                                <th>요청자</th>
                                <th>연락처</th>
                                <th>상품명 / 요청내용</th>
                                <th>희망수량</th>
                                <th>요청일</th>
                                <th>상태</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td>4</td>
                                <td>김철수 (user_05)</td>
                                <td>010-1234-5678</td>
                                <td class="text-start">사무용 의자 대량 구매 견적 요청합니다.</td>
                                <td>50개</td>
                                <td>2026-01-08</td>
                                <td><span class="badge-status status-waiting">견적 대기</span></td>
                                <td>
                                    <button class="btn btn-sm btn-light border" title="견적서 작성">✏️</button>
                                </td>
                            </tr>
                            
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td>3</td>
                                <td>박민지 (company_a)</td>
                                <td>010-9876-5432</td>
                                <td class="text-start">신입사원 웰컴키트 제작 건</td>
                                <td>100세트</td>
                                <td>2026-01-07</td>
                                <td><span class="badge-status status-sent">발송 완료</span></td>
                                <td>
                                    <button class="btn btn-sm btn-light border" title="상세보기">📄</button>
                                </td>
                            </tr>

                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td>2</td>
                                <td>최현우 (gym_master)</td>
                                <td>010-5555-7777</td>
                                <td class="text-start">헬스장 덤벨 세트 견적 문의</td>
                                <td>20세트</td>
                                <td>2026-01-05</td>
                                <td><span class="badge-status status-confirmed">주문 확정</span></td>
                                <td>
                                    <button class="btn btn-sm btn-light border" title="상세보기">📄</button>
                                </td>
                            </tr>

                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td>1</td>
                                <td>이영희 (guest)</td>
                                <td>010-1111-2222</td>
                                <td class="text-start">단순 가격 문의 (취소됨)</td>
                                <td>1개</td>
                                <td>2026-01-01</td>
                                <td><span class="badge-status status-cancel">취소</span></td>
                                <td>
                                    <button class="btn btn-sm btn-light border" title="상세보기">📄</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <nav aria-label="Page navigation" class="mt-4">
                        <ul class="pagination justify-content-center">
                            <li class="page-item disabled"><a class="page-link" href="#">&lt;</a></li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">&gt;</a></li>
                        </ul>
                    </nav>

                </div> </div> </div> </div> <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />

</body>
</html>