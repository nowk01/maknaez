<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
</head>
<body>

<div id="wrapper">
    
    <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

    <div id="page-content-wrapper">
        
        <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

        <div class="content-container">

            <div id="member-section" class="d-none-custom">
                <h4 class="fw-bold mb-4">회원 조회</h4>
                <div class="card card-custom p-4 mb-4">
                    <div class="row g-3 align-items-end">
                        <div class="col-md-4">
                            <label class="form-label fw-bold small">가입 기간</label>
                            <div class="input-group">
                                <input type="text" class="form-control" value="2026-01-01">
                                <span class="input-group-text">~</span>
                                <input type="text" class="form-control" value="2026-01-05">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-bold small">회원 등급</label>
                            <select class="form-select">
                                <option>전체 등급</option>
                            </select>
                        </div>
                        <div class="col-md-5">
                            <label class="form-label fw-bold small">검색어</label>
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="이름, ID, 이메일">
                                <button class="btn btn-outline-secondary" type="button"><i class="fas fa-search"></i></button>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="card card-custom p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold m-0">회원 목록</h5>
                        <button class="btn btn-primary btn-sm">엑셀 다운로드</button>
                    </div>
                    <table class="table table-hover align-middle">
                        <thead class="table-light"><tr><th>ID</th><th>닉네임</th><th>등급</th><th>가입일</th><th>상태</th><th>관리</th></tr></thead>
                        <tbody>
                            <tr><td>user_01</td><td>증강살려</td><td><span class="badge bg-warning text-dark">GOLD</span></td><td>2026-01-01</td><td><span class="badge bg-success bg-opacity-10 text-success">정상</span></td><td><button class="btn btn-sm btn-light"><i class="far fa-edit"></i></button></td></tr>
                            <tr><td>user_02</td><td>환바람나락</td><td><span class="badge bg-secondary">SILVER</span></td><td>2026-01-02</td><td><span class="badge bg-success bg-opacity-10 text-success">정상</span></td><td><button class="btn btn-sm btn-light"><i class="far fa-edit"></i></button></td></tr>
                        </tbody>
                    </table>
                </div>
            </div>

        </div> <jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
        
    </div> </div> <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />

</body>
</html>