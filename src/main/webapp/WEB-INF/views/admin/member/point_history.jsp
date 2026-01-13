<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>포인트 상세 내역 | MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_point.css">
</head>
<body>
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                <div class="page-header d-flex justify-content-between align-items-center">
                    <div>
                        <h3 class="page-title">[<span class="text-primary">${userId}</span>] 님 포인트 내역</h3>
                        <p class="page-desc">해당 회원의 포인트 적립 및 사용 내역입니다.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/member/point_manage" class="btn btn-outline-secondary">
                        <i class="fas fa-list me-1"></i> 목록으로
                    </a>
                </div>

                <div class="card-box">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div class="total-count">
                            총 <span class="text-primary fw-bold"><fmt:formatNumber value="${dataCount}"/></span>건의 내역이 있습니다.
                        </div>
                    </div>

                    <table class="table table-hover text-center align-middle">
                        <thead class="table-light">
                            <tr>
                                <th width="10%">번호</th>
                                <th width="15%">주문 코드</th>
                                <th width="30%">내용 (사유)</th>
                                <th width="15%">변동 포인트</th>
                                <th width="15%">남은 포인트</th>
                                <th width="15%">처리 일자</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="dto" items="${list}" varStatus="status">
                                <tr>
                                    <td>${dataCount - (page-1)*10 - status.index}</td>
                                    <td>
                                        ${not empty dto.order_id ? dto.order_id : '-'}
                                    </td>
                                    <td class="text-start ps-4">${dto.reason}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${dto.point_amount > 0}">
                                                <span class="text-primary fw-bold">+<fmt:formatNumber value="${dto.point_amount}"/></span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-danger fw-bold"><fmt:formatNumber value="${dto.point_amount}"/></span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end pe-4 text-muted">
                                        <fmt:formatNumber value="${dto.rem_point}"/> P
                                    </td>
                                    <td>${dto.reg_date}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${dataCount == 0}">
                                <tr><td colspan="6" class="p-4">포인트 내역이 존재하지 않습니다.</td></tr>
                            </c:if>
                        </tbody>
                    </table>

                    <div class="mt-3 d-flex justify-content-center">
                        <nav>
                            <ul class="pagination">
                                ${paging}
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
</body>
</html>