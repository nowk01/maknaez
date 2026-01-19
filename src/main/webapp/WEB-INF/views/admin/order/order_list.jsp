<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 내역 관리 - MAKNAEZ ADMIN</title>
<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/admin_order_list.css">
</head>
<body>

	<div id="wrapper">
		<jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

		<div id="page-content-wrapper">
			<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

			<div class="content-container">

				<div class="page-header">
					<h3 class="page-title">주문 내역 관리</h3>
					<p class="page-desc">Integrated Order Search & Management</p>
				</div>

				<div class="card-box">
					<form name="searchForm" class="search-grid"
						onsubmit="return false;">
						<div>
							<label class="form-label">주문 기간</label>
							<div class="d-flex align-items-center">
								<input type="date" name="startDate" id="startDate"
									class="form-control" value="${startDate}"> <span
									class="mx-2 text-muted">~</span> <input type="date"
									name="endDate" id="endDate" class="form-control"
									value="${endDate}">
							</div>
						</div>
						<div>
							<label class="form-label">주문 상태</label> <select name="status"
								id="status" class="form-select">
								<option value="">전체 상태</option>
								<option value="결제완료" ${status=='결제완료'?'selected':''}>결제완료</option>
								<option value="배송중" ${status=='배송중'?'selected':''}>배송중</option>
								<option value="배송완료" ${status=='배송완료'?'selected':''}>배송완료</option>
								<option value="주문취소" ${status=='주문취소'?'selected':''}>주문취소</option>
							</select>
						</div>
						<div>
							<label class="form-label">정렬 기준</label> <select name="sortKey"
								id="sortKey" class="form-select">
								<option value="orderDate" ${sortKey=='orderDate'?'selected':''}>최신순</option>
								<option value="totalAmount"
									${sortKey=='totalAmount'?'selected':''}>금액순</option>
							</select>
						</div>
						<div>
							<label class="form-label">통합 검색</label> <input type="text"
								name="searchValue" id="searchValue" class="form-control"
								placeholder="주문번호, 이름, 상품명" value="${searchValue}">
						</div>
						<div>
							<button type="button" class="btn-orange-main"
								onclick="searchList()">SEARCH</button>
						</div>
					</form>
				</div>

				<div class="card-box">
					<div class="list-header">
						<div class="count-info">
							Showing <b>${dataCount}</b> orders results
						</div>
						<div class="action-group">
							<button type="button" class="btn btn-outline-dark"
								onclick="bulkTrackingUpdate()">송장번호 일괄등록</button>
							<button type="button" class="btn btn-dark"
								onclick="excelDownload()">EXCEL 다운로드</button>
						</div>
					</div>

					<table class="table">
						<thead>
							<tr>
								<th style="width: 40px;"><input type="checkbox"
									id="checkAll" class="form-check-input"></th>
								<th>주문번호</th>
								<th>주문일시</th>
								<th>주문자(연락처)</th>
								<th style="width: 25%;">상품정보</th>
								<th>결제금액</th>
								<th>현재상태</th>
								<th>관리</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="dto" items="${list}">
								<tr>
									<td><input type="checkbox" class="form-check-input"
										name="orderNums" value="${dto.orderNum}"></td>
									<td><a
										href="${pageContext.request.contextPath}/admin/order/estimate_write?orderNum=${dto.orderNum}"
										class="order-no"> ${dto.orderNum} </a></td>
									<td class="text-muted" style="font-size: 13px;">
										${dto.orderDate}</td>
									<td class="fw-bold">${dto.userName}<br> <span
										class="text-muted small" style="font-weight: 400;"> <c:choose>
												<c:when test="${not empty dto.tel}">${dto.tel}</c:when>
												<c:otherwise>(No.${dto.memberIdx})</c:otherwise>
											</c:choose>
									</span>
									</td>
									<td class="text-start"><span class="fw-bold">${dto.productName}</span><br>
										<span class="text-muted small">옵션: ${dto.pdSize} /
											${dto.qty}개</span></td>
									<td class="price-text"><fmt:formatNumber
											value="${dto.totalAmount}" type="number" />원</td>
									<td><c:choose>
											<c:when test="${dto.orderState == '결제완료'}">
												<span class="badge-luxury st-paid">결제완료</span>
											</c:when>
											<c:when
												test="${dto.orderState == '배송중' || dto.orderState == '배송완료'}">
												<span class="badge-luxury st-ship">${dto.orderState}</span>
											</c:when>
											<c:otherwise>
												<span class="badge-luxury st-cancel">${dto.orderState}</span>
											</c:otherwise>
										</c:choose></td>
									<td>
										<button type="button" class="btn btn-sm btn-light border-0"
											title="거래명세서 보기"
											onclick="location.href='${pageContext.request.contextPath}/admin/order/estimate_write?orderNum=${dto.orderNum}'">
											<i class="fas fa-file-alt text-muted"></i>
										</button>
									</td>
								</tr>
							</c:forEach>
							<c:if test="${empty list}">
								<tr>
									<td colspan="8" class="text-center py-5 text-muted">주문 내역이
										없습니다.</td>
								</tr>
							</c:if>
						</tbody>
					</table>

					<div class="mt-5 d-flex justify-content-center">
						<c:if test="${dataCount != 0}">
							${paging}
						</c:if>
					</div>
				</div>
			</div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
	<script type="text/javascript">
		var orderDataCount = "${dataCount}";
	</script>
	<script>
    const contextPath = "${pageContext.request.contextPath}";
	</script>
	<script
		src="${pageContext.request.contextPath}/dist/js/admin_order_list.js"></script>
		
</body>
</html>