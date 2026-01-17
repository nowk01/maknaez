<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>취소/반품 관리 - MAKNAEZ ADMIN</title>
<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_claim_list.css">
</head>
<body>
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                <div class="page-header">
                    <h3 class="page-title">취소/반품 관리</h3>
                    <p class="page-desc">Shoes Claim & Exchange Protocol</p>
                </div>

                <div class="card-box">
                    <form class="search-grid">
                        <div>
                            <label class="form-label">접수 기간</label> <input type="date" class="form-control" value="2026-01-01">
                        </div>
                        <div>
                            <label class="form-label">청구 유형</label> <select class="form-select">
                                <option>전체 유형</option>
                                <option>취소</option>
                                <option>반품</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label">처리 상태</label> <select class="form-select">
                                <option>전체 상태</option>
                                <option>접수 대기</option>
                                <option>완료</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label">상세 검색</label> <input type="text" class="form-control" placeholder="주문번호 또는 ID">
                        </div>
                        <div>
                            <button type="button" class="btn-search">SEARCH</button>
                        </div>
                    </form>
                </div>

                <div class="card-box">
                    <div class="list-header">
                        <div style="font-size: 14px; font-weight: 600;">
                            전체 <b style="color: #ff4e00;">${dataCount}</b>건
                        </div>
                        <div class="action-group">
                            <button type="button" class="btn-ctrl" onclick="approveClaim()">선택 일괄승인</button>
                            <button type="button" class="btn-ctrl" onclick="excelDownload()">EXCEL DOWNLOAD</button>
                        </div>
                    </div>

                    <table class="table">
                        <colgroup>
                            <col style="width: 5%;">
                            <col style="width: 10%;">
                            <col style="width: 8%;">
                            <col style="width: 12%;">
                            <col style="width: auto;">
                            <col style="width: 10%;">
                            <col style="width: 15%;">
                            <col style="width: 8%;">
                            <col style="width: 8%;">
                        </colgroup>
                        <thead>
                            <tr>
                                <th><input type="checkbox" id="checkAll"></th>
                                <th>접수일</th>
                                <th>유형</th>
                                <th>주문번호</th>
                                <th class="text-start">상품명</th>
                                <th>신청자</th>
                                <th>사유</th>
                                <th>상태</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="dto" items="${list}">
                                <tr>
                                    <td><input type="checkbox" name="chk" value="${dto.orderNum}"></td>
                                    <td class="date-text">${dto.orderDate}</td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${fn:contains(dto.orderState, '취소')}">
                                                <span class="badge-luxury st-label">취소</span>
                                            </c:when>
                                            <c:when test="${fn:contains(dto.orderState, '반품')}">
                                                <span class="badge-luxury st-label">반품</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-luxury st-label">${dto.orderState}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td><a href="#" class="order-link">${dto.orderNum}</a></td>

                                    <td class="text-start fw-bold">
                                        <img src="${pageContext.request.contextPath}/uploads/product/${dto.thumbNail}"
                                            width="30" height="30" style="margin-right: 5px; vertical-align: middle;">
                                        ${dto.productName} 
                                        <span style="font-size: 11px; color: #888;">[${dto.pdSize}]</span>
                                    </td>

                                    <td>${dto.userName}</td>
                                    <td class="text-muted">고객 요청</td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${dto.orderState == '취소완료' || dto.orderState == '반품완료' || dto.orderState == '환불완료' || dto.orderState == '교환완료'}">
                                                <span class="badge-luxury st-complete">처리완료</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-luxury st-wait">접수대기</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${dto.orderState != '취소완료' && dto.orderState != '반품완료' && dto.orderState != '환불완료' && dto.orderState != '교환완료'}">
                                                <button type="button" class="btn-approve"
                                                    onclick="openApproveModal(
                                                        '${dto.orderNum}', 
                                                        '${fn:contains(dto.orderState, '취소') ? '취소' : '반품'}', 
                                                        '${dto.productName}', 
                                                        '${dto.qty}', 
                                                        '${pageContext.request.contextPath}/admin/order/approve?orderNum=${dto.orderNum}&claimType=${fn:contains(dto.orderState, '취소') ? '취소' : '반품'}&productNum=${dto.productNum}&pdSize=${dto.pdSize}&qty=${dto.qty}'
                                                    )">
                                                    승인
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="button" class="btn-completed" disabled>완료</button>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty list}">
                                <tr>
                                    <td colspan="9" style="text-align: center; padding: 50px;">접수된 요청이 없습니다.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>

                    <div class="pagination">${paging}</div>
                </div>
            </div>
        </div>
    </div>

    <div id="approveModal" class="modal-overlay">
        <div class="modal-window">
            <h3 class="modal-title">요청 승인 확인</h3>
            <div class="modal-info">
                <span><b>주문번호:</b> <span id="m_orderNum"></span></span> 
                <span><b>신청유형:</b> <span id="m_type" style="font-weight: bold;"></span></span>
                <span><b>상품정보:</b> <span id="m_product"></span></span> 
                <span><b>복구수량:</b> <span id="m_qty"></span>개</span>
                <hr style="margin: 10px 0; border: 0; border-top: 1px dashed #ddd;">
                <p style="font-size: 12px; color: #888;">
                    </p>
            </div>
            <div class="modal-btn-group">
                <button type="button" class="modal-btn btn-cancel" onclick="closeModal()">취소</button>
                <button type="button" id="realApproveBtn" class="modal-btn btn-confirm">승인하기</button>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <script src="${pageContext.request.contextPath}/dist/js/admin_claim_list.js"></script>
</body>
</html>