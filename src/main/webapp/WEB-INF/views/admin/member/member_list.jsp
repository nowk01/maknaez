<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 조회 - MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <style>
        /* 기존 스타일 유지 */
        body { background-color: #f4f6f9; }
        
        .card-box {
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
            padding: 20px;
            margin-bottom: 20px;
            border: none;
        }
        .search-label { font-weight: 600; font-size: 14px; color: #555; margin-bottom: 8px; display: block; }
        .table th { background-color: #f8f9fa; font-weight: 600; text-align: center; border-bottom: 2px solid #dee2e6; }
        .table td { vertical-align: middle; text-align: center; }
        .badge-status { padding: 5px 10px; border-radius: 4px; font-size: 12px; font-weight: 500; }
        .status-normal { background-color: #e6fcf5; color: #0ca678; }
        .status-dormant { background-color: #fff4e6; color: #f76707; }
        .btn-excel { background-color: #0d6efd; color: white; font-size: 14px; }
    </style>
</head>
<body>

    <div id="wrapper">
        
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

        <div id="page-content-wrapper">
            
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                
                <h3 class="fw-bold mb-4">회원 조회</h3>

                <div class="card-box">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="search-label">가입 기간</label>
                            <div class="input-group">
                                <input type="date" class="form-control" value="2026-01-01">
                                <span class="input-group-text">~</span>
                                <input type="date" class="form-control" value="2026-01-05">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="search-label">회원 등급</label>
                            <select class="form-select">
                                <option selected>전체 등급</option>
                                <option value="GOLD">GOLD</option>
                                <option value="SILVER">SILVER</option>
                                <option value="BRONZE">BRONZE</option>
                            </select>
                        </div>
                        <div class="col-md-5">
                            <label class="search-label">검색어</label>
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="이름, ID, 이메일">
                                <button class="btn btn-outline-secondary" type="button">🔍</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-box">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold m-0">회원 목록</h5>
                        <button class="btn btn-excel">엑셀 다운로드</button>
                    </div>

                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>닉네임</th>
                                <th>등급</th>
                                <th>가입일</th>
                                <th>상태</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>user_01</td>
                                <td>증강산려</td>
                                <td>GOLD</td>
                                <td>2026-01-01</td>
                                <td><span class="badge-status status-normal">정상</span></td>
                                <td><button class="btn btn-sm btn-light border">📝</button></td>
                            </tr>
                            <tr>
                                <td>user_02</td>
                                <td>칸바람나락</td>
                                <td>SILVER</td>
                                <td>2026-01-02</td>
                                <td><span class="badge-status status-normal">정상</span></td>
                                <td><button class="btn btn-sm btn-light border">📝</button></td>
                            </tr>
                            <tr>
                                <td>user_03</td>
                                <td>현곡</td>
                                <td>BRONZE</td>
                                <td>2026-01-03</td>
                                <td><span class="badge-status status-dormant">휴면</span></td>
                                <td><button class="btn btn-sm btn-light border">📝</button></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

            </div> </div> </div> <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />

</body>
</html>