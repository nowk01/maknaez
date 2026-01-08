<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>휴면 회원 관리 - MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    
    <style>
        /* [공통 스타일] 레이아웃 통일 */
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

        /* 배지 스타일 */
        .badge-status { padding: 5px 10px; border-radius: 4px; font-size: 12px; font-weight: 500; }
        .status-dormant { background-color: #fff4e6; color: #f76707; } /* 휴면: 주황 */
        .status-mail-sent { background-color: #e7f5ff; color: #1c7ed6; } /* 메일발송됨: 파랑 */
        .status-mail-wait { background-color: #f8f9fa; color: #868e96; border: 1px solid #dee2e6; } /* 대기: 회색 */

        /* 버튼 스타일 */
        .btn-restore {
            background-color: #20c997; /* 복구: 민트/초록 계열 */
            border-color: #20c997;
            color: white;
            font-size: 13px;
        }
        .btn-delete {
            background-color: #fa5252; /* 삭제: 빨강 */
            border-color: #fa5252;
            color: white;
            font-size: 13px;
        }
        .btn-mail {
            background-color: #4dabf7; /* 메일: 밝은 파랑 */
            border-color: #4dabf7;
            color: white;
            font-size: 13px;
        }
    </style>
</head>
<body>

    <div id="wrapper">
        
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

        <div id="page-content-wrapper">
            
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                
                <h3 class="fw-bold mb-4">휴면 회원 관리</h3>

                <div class="card-box">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="search-label">휴면 전환일</label>
                            <div class="input-group">
                                <input type="date" class="form-control" value="2025-01-01">
                                <span class="input-group-text">~</span>
                                <input type="date" class="form-control" value="2026-01-08">
                            </div>
                        </div>
                        
                        <div class="col-md-3">
                            <label class="search-label">메일 발송 여부</label>
                            <select class="form-select">
                                <option selected>전체</option>
                                <option value="Y">발송 완료</option>
                                <option value="N">미발송</option>
                            </select>
                        </div>
                        
                        <div class="col-md-5">
                            <label class="search-label">검색어</label>
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="이름, ID, 이메일 검색">
                                <button class="btn btn-outline-secondary" type="button">🔍</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-box">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h5 class="fw-bold m-0 d-inline-block me-2">휴면 계정 목록</h5>
                            <span class="text-muted small">총 3건</span>
                        </div>
                        <div class="btn-group" role="group">
                            <button class="btn btn-restore">🔄 선택 복구</button>
                            <button class="btn btn-mail">📧 안내메일 발송</button>
                            <button class="btn btn-delete">🗑️ 영구 삭제</button>
                        </div>
                    </div>

                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th style="width: 50px;"><input type="checkbox" class="form-check-input"></th>
                                <th>번호</th>
                                <th>ID</th>
                                <th>이름</th>
                                <th>마지막 로그인</th>
                                <th>휴면 전환일</th>
                                <th>상태</th>
                                <th>메일</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td>3</td>
                                <td>sleeping_lion</td>
                                <td>사자후</td>
                                <td>2024-12-10</td>
                                <td>2025-12-10</td>
                                <td><span class="badge-status status-dormant">휴면</span></td>
                                <td><span class="badge-status status-mail-sent">발송됨</span></td>
                                <td>
                                    <button class="btn btn-sm btn-light border" title="상세보기">📝</button>
                                </td>
                            </tr>
                            
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td>2</td>
                                <td>ghost_user</td>
                                <td>유령회원</td>
                                <td>2024-05-20</td>
                                <td>2025-05-20</td>
                                <td><span class="badge-status status-dormant">휴면</span></td>
                                <td><span class="badge-status status-mail-wait">미발송</span></td>
                                <td>
                                    <button class="btn btn-sm btn-light border" title="상세보기">📝</button>
                                </td>
                            </tr>

                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td>1</td>
                                <td>user_03</td>
                                <td>현곡</td>
                                <td>2025-01-03</td>
                                <td>2026-01-03</td>
                                <td><span class="badge-status status-dormant">휴면</span></td>
                                <td><span class="badge-status status-mail-sent">발송됨</span></td>
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
                            <li class="page-item"><a class="page-link" href="#">&gt;</a></li>
                        </ul>
                    </nav>

                </div> </div> </div> </div> <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />

</body>
</html>