<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>

<main class="container-fluid px-4">
    <h1 class="mt-4">회원 마일리지 관리</h1>
    <ol class="breadcrumb mb-4">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin">Dashboard</a></li>
        <li class="breadcrumb-item active">마일리지 내역 조회</li>
    </ol>

    <div class="card mb-4">
        <div class="card-header">
            <i class="fas fa-filter me-1"></i> 검색 필터
        </div>
        <div class="card-body">
            <form name="searchForm" action="${pageContext.request.contextPath}/admin/point/list" method="get" class="row gx-3 gy-2 align-items-center">
                <input type="hidden" name="memberIdx" value="${memberIdx}">
                
                <div class="col-md-3">
                    <label class="visually-hidden" for="startDate">시작일</label>
                    <div class="input-group">
                        <span class="input-group-text">기간</span>
                        <input type="date" class="form-control" id="startDate" name="startDate" value="${startDate}">
                    </div>
                </div>
                <div class="col-auto">~</div>
                <div class="col-md-3">
                    <label class="visually-hidden" for="endDate">종료일</label>
                    <input type="date" class="form-control" id="endDate" name="endDate" value="${endDate}">
                </div>

                <div class="col-md-3">
                    <label class="visually-hidden" for="kwd">검색어</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-search"></i></span>
                        <input type="text" class="form-control" id="kwd" name="kwd" value="${kwd}" placeholder="사유 입력(예: 구매 적립)">
                    </div>
                </div>

                <div class="col-auto">
                    <button type="button" class="btn btn-primary" onclick="searchList()">조회</button>
                    <button type="button" class="btn btn-outline-secondary" onclick="location.href='${pageContext.request.contextPath}/admin/point/list?memberIdx=${memberIdx}'">초기화</button>
                </div>
            </form>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header">
            <i class="fas fa-table me-1"></i> 
            <span class="fw-bold text-primary">${targetUserId}</span> 님의 마일리지 기록
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover text-center align-middle">
                    <thead class="table-light">
                        <tr>
                            <th scope="col" width="8%">번호</th> <th scope="col" width="10%">아이디</th>
                            <th scope="col" width="10%">회원명</th>
                            <th scope="col">사유</th>
                            <th scope="col" width="10%">변동 금액</th>
                            <th scope="col" width="10%">남은 금액</th>
                            <th scope="col" width="15%">처리일</th>
                            <th scope="col" width="8%">상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty list}">
                            <tr>
                                <td colspan="8" class="py-4 text-muted">마일리지 내역이 존재하지 않습니다.</td>
                            </tr>
                        </c:if>

                        <c:forEach var="dto" items="${list}">
                            <tr>
                                <td>${dto.pmId}</td>
                                <td>${dto.userId}</td>
                                <td>${dto.userName}</td>
                                <td class="text-start ps-3">${dto.description}</td>
                                
                                <td class="${dto.amount >= 0 ? 'text-primary fw-bold' : 'text-danger fw-bold'}">
                                    ${dto.amount >= 0 ? '+' : ''}<fmt:formatNumber value="${dto.amount}" pattern="#,###"/>
                                </td>
                                
                                <td><fmt:formatNumber value="${dto.balance}" pattern="#,###"/></td>
                                <td>${dto.regDate}</td>
                                
                                <td>
                                    <c:choose>
                                        <c:when test="${dto.status == '지급'}">
                                            <span class="badge bg-success">지급</span>
                                        </c:when>
                                        <c:when test="${dto.status == '사용'}">
                                            <span class="badge bg-warning text-dark">사용</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">${dto.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="mt-3 d-flex justify-content-center">
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        ${dataCount == 0 ? "" : paging}
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</main>

<script type="text/javascript">
    function searchList() {
        const f = document.searchForm;
        f.submit();
    }
</script>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp"/>