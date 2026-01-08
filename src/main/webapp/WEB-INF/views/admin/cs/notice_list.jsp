<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항 관리 - MAKNAEZ ADMIN</title>
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
            /* height: 100%; 제거됨 (높이 자동 조절) */
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
        .table-hover tbody tr:hover {
            background-color: #f1f3f5;
        }

        /* 공지사항 전용 스타일 */
        .notice-title {
            text-align: left;
            padding-left: 10px;
        }
        .notice-title a {
            text-decoration: none;
            color: #333;
            font-weight: 500;
        }
        .notice-title a:hover {
            color: #0d6efd;
            text-decoration: underline;
        }

        /* 중요(필독) 배지 */
        .badge-important {
            background-color: #ffe3e3;
            color: #e03131;
            font-size: 11px;
            padding: 4px 8px;
            border-radius: 4px;
            font-weight: 600;
        }
        
        /* 상단 고정 게시물 배경 강조 */
        .tr-pinned {
            background-color: #fff9db !important; /* 연한 노랑 */
        }
        
        /* [추가] 게시 상태 토글 스위치 커스텀 */
        .form-switch .form-check-input {
            width: 3em; /* 스위치 너비 키움 */
            height: 1.5em; /* 스위치 높이 키움 */
            cursor: pointer;
        }
        .form-switch .form-check-input:checked {
            background-color: #0d6efd;
            border-color: #0d6efd;
        }
        .switch-label {
            font-size: 12px;
            font-weight: 600;
            display: block;
            margin-top: 2px;
            width: 40px; /* 라벨 너비 고정 (텍스트 흔들림 방지) */
            margin: 0 auto;
        }
        .text-on { color: #0d6efd; }
        .text-off { color: #adb5bd; }
    </style>
</head>
<body>

    <div id="wrapper">
        
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

        <div id="page-content-wrapper">
            
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                
                <h3 class="fw-bold mb-4">공지사항 관리</h3>

                <div class="card-box">
                    <div class="row g-3">
                        <div class="col-md-2">
                            <label class="search-label">검색 조건</label>
                            <select class="form-select">
                                <option value="all">제목 + 내용</option>
                                <option value="title">제목</option>
                                <option value="content">내용</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="search-label">검색어</label>
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="검색어를 입력하세요">
                                <button class="btn btn-outline-secondary" type="button">🔍</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <label class="search-label">게시 상태</label>
                            <select class="form-select">
                                <option value="">전체</option>
                                <option value="Y">공개 (게시중)</option>
                                <option value="N">비공개 (숨김)</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="card-box">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <button class="btn btn-danger btn-sm me-1" onclick="alert('선택한 항목을 삭제합니다.')">선택 삭제</button>
                        </div>
                        <div>
                            <button class="btn btn-primary btn-sm" onclick="location.href='${pageContext.request.contextPath}/admin/cs/notice_write'">
                                <i class="fas fa-pen me-1"></i> 공지사항 등록
                            </button>
                        </div>
                    </div>

                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th width="40"><input type="checkbox" class="form-check-input"></th>
                                <th width="60">번호</th>
                                <th width="90">게시 상태</th> <th>제목</th>
                                <th width="100">작성자</th>
                                <th width="120">작성일</th>
                                <th width="70">조회</th>
                                <th width="90">관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr class="tr-pinned">
                                <td><input type="checkbox" class="form-check-input" disabled></td>
                                <td><span class="badge-important">필독</span></td>
                                <td>
                                    <div class="form-check form-switch d-flex justify-content-center align-items-center flex-column p-0 m-0">
                                        <input class="form-check-input ms-0" type="checkbox" checked onchange="toggleStatus(this)">
                                        <span class="switch-label text-on">공개</span>
                                    </div>
                                </td>
                                <td class="notice-title">
                                    <a href="#">[중요] 설 연휴 배송 및 고객센터 휴무 안내</a>
                                    <i class="fas fa-paperclip text-muted ms-2 small"></i>
                                </td>
                                <td>관리자</td>
                                <td>2026-01-05</td>
                                <td>1,254</td>
                                <td>
                                    <button class="btn btn-sm btn-light border" title="수정">✏️</button>
                                    <button class="btn btn-sm btn-light border text-danger" title="삭제">🗑️</button>
                                </td>
                            </tr>
                            
                            <tr class="tr-pinned">
                                <td><input type="checkbox" class="form-check-input" disabled></td>
                                <td><span class="badge-important">필독</span></td>
                                <td>
                                    <div class="form-check form-switch d-flex justify-content-center align-items-center flex-column p-0 m-0">
                                        <input class="form-check-input ms-0" type="checkbox" checked onchange="toggleStatus(this)">
                                        <span class="switch-label text-on">공개</span>
                                    </div>
                                </td>
                                <td class="notice-title">
                                    <a href="#">개인정보 처리방침 변경 안내 (2026.01.01 시행)</a>
                                </td>
                                <td>관리자</td>
                                <td>2025-12-28</td>
                                <td>3,402</td>
                                <td>
                                    <button class="btn btn-sm btn-light border" title="수정">✏️</button>
                                    <button class="btn btn-sm btn-light border text-danger" title="삭제">🗑️</button>
                                </td>
                            </tr>

                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td>15</td>
                                <td>
                                    <div class="form-check form-switch d-flex justify-content-center align-items-center flex-column p-0 m-0">
                                        <input class="form-check-input ms-0" type="checkbox" onchange="toggleStatus(this)">
                                        <span class="switch-label text-off">비공개</span>
                                    </div>
                                </td>
                                <td class="notice-title">
                                    <a href="#" class="text-secondary opacity-75">시스템 정기 점검 안내 (1/10 02:00 ~ 06:00) [임시저장]</a>
                                </td>
                                <td>관리자</td>
                                <td>2026-01-08</td>
                                <td>0</td>
                                <td>
                                    <button class="btn btn-sm btn-light border" title="수정">✏️</button>
                                    <button class="btn btn-sm btn-light border text-danger" title="삭제">🗑️</button>
                                </td>
                            </tr>

                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td>14</td>
                                <td>
                                    <div class="form-check form-switch d-flex justify-content-center align-items-center flex-column p-0 m-0">
                                        <input class="form-check-input ms-0" type="checkbox" checked onchange="toggleStatus(this)">
                                        <span class="switch-label text-on">공개</span>
                                    </div>
                                </td>
                                <td class="notice-title">
                                    <a href="#">신규 회원 가입 혜택 변경 안내</a>
                                </td>
                                <td>관리자</td>
                                <td>2026-01-07</td>
                                <td>112</td>
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
                            <li class="page-item"><a class="page-link" href="#">&gt;</a></li>
                        </ul>
                    </nav>

                </div> </div> </div> </div> <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />

    <script>
        function toggleStatus(checkbox) {
            const label = checkbox.nextElementSibling; // 바로 뒤의 span 태그 (공개/비공개 텍스트)
            
            if (checkbox.checked) {
                // 체크됨: 비공개 -> 공개로 변경
                label.textContent = "공개";
                label.classList.remove("text-off");
                label.classList.add("text-on");
                
                // 여기서 AJAX 등을 호출하여 실제 DB 상태 변경
                // console.log("게시글 상태 변경: 공개(Y)");
            } else {
                // 체크 해제됨: 공개 -> 비공개로 변경
                label.textContent = "비공개";
                label.classList.remove("text-on");
                label.classList.add("text-off");

                // console.log("게시글 상태 변경: 비공개(N)");
            }
        }
    </script>

</body>
</html>