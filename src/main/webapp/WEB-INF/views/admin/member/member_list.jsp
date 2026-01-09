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
        .status-block { background-color: #ffe3e3; color: #fa5252; }
        
        /* 페이징 영역 스타일 */
        .page-navigation-wrap {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
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
                    <form name="searchForm" onsubmit="return false;">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="search-label">가입 기간</label>
                                <div class="input-group">
                                    <input type="date" class="form-control" name="startDate" id="startDate" value="${startDate}">
                                    <span class="input-group-text">~</span>
                                    <input type="date" class="form-control" name="endDate" id="endDate" value="${endDate}">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <label class="search-label">회원 등급</label>
                                <select class="form-select" name="userLevel" id="userLevel">
                                    <option value="전체 등급" ${userLevel == '전체 등급' ? 'selected' : ''}>전체 등급</option>
                                    <option value="1" ${userLevel == '1' ? 'selected' : ''}>일반 회원 (Lv.1)</option>
                                    <option value="51" ${userLevel == '51' ? 'selected' : ''}>관리자 (Lv.51)</option>
                                    <option value="99" ${userLevel == '99' ? 'selected' : ''}>최고 관리자 (Lv.99)</option>
                                </select>
                            </div>
                            <div class="col-md-5">
                                <label class="search-label">검색어</label>
                                <div class="input-group">
                                    <select class="form-select" style="max-width: 120px;" name="searchKey" id="searchKey">
                                        <option value="all" ${searchKey == 'all' ? 'selected' : ''}>전체</option>
                                        <option value="userId" ${searchKey == 'userId' ? 'selected' : ''}>아이디</option>
                                        <option value="userName" ${searchKey == 'userName' ? 'selected' : ''}>이름</option>
                                        <option value="email" ${searchKey == 'email' ? 'selected' : ''}>이메일</option>
                                    </select>
                                    <input type="text" class="form-control" name="searchValue" id="searchValue" 
                                           placeholder="검색어 입력" value="${searchValue}">
                                    <button class="btn btn-outline-secondary" type="button" onclick="searchList()">🔍</button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="card-box">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold m-0">회원 목록 <span class="text-muted fs-6">(${dataCount}명)</span></h5>
                        </div>

                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>이름</th>
                                <th>이메일</th>
                                <th>등급</th>
                                <th>가입일</th>
                                <th>상태</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty list}">
                                    <tr>
                                        <td colspan="7" class="text-center p-5 text-muted">
                                            등록된 회원이 없거나 검색 결과가 없습니다.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="dto" items="${list}" varStatus="status">
                                        <tr>
                                            <td>${dto.userId}</td>
                                            <td>${dto.userName}</td>
                                            <td>${dto.email}</td>
                                            
                                            <%-- 회원 등급 표시 --%>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${dto.userLevel >= 99}"><span class="badge bg-danger">최고관리자</span></c:when>
                                                    <c:when test="${dto.userLevel >= 51}"><span class="badge bg-primary">관리자</span></c:when>
                                                    <c:otherwise><span class="badge bg-secondary">일반회원</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            
                                            <td>${dto.register_date}</td>
                                            
                                            <%-- 계정 상태 표시 (enabled: 1=정상, 0=잠금/휴면) --%>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${dto.enabled == 1}">
                                                        <span class="badge-status status-normal">정상</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-status status-block">잠금/휴면</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            
                                            <%-- 관리 버튼 (상세보기) --%>
                                            <td>
                                                <button class="btn btn-sm btn-light border" title="상세보기"
                                                        onclick="location.href='${pageContext.request.contextPath}/admin/member/detail?memberIdx=${dto.memberIdx}'">
                                                    📝
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                    
                    <div class="page-navigation-wrap">
                        ${paging} 
                    </div>
                </div>

            </div> 
        </div> 
    </div> 
    
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />

    <script type="text/javascript">
        function searchList() {
            const f = document.searchForm;
            
            let startDate = document.getElementById("startDate").value;
            let endDate = document.getElementById("endDate").value;
            let userLevel = document.getElementById("userLevel").value;
            let searchKey = document.getElementById("searchKey").value;
            let searchValue = document.getElementById("searchValue").value;

            // 기본 URL
            let url = "${pageContext.request.contextPath}/admin/member/member_list";
            
            // 파라미터 조합 (검색어 인코딩 필수)
            let query = "page=1"; // 검색 시 무조건 1페이지로 이동
            
            if(startDate && endDate) {
                query += "&startDate=" + startDate + "&endDate=" + endDate;
            }
            
            if(userLevel !== "전체 등급") {
                query += "&userLevel=" + encodeURIComponent(userLevel);
            }
            
            if(searchValue) {
                query += "&searchKey=" + searchKey + "&searchValue=" + encodeURIComponent(searchValue);
            }
            
            // 페이지 이동
            location.href = url + "?" + query;
        }
    </script>
</body>
</html>