<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>거래명세서 관리 - MAKNAEZ ADMIN</title>
<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/admin_estimate_list.css">
</head>
<body>
	<div id="wrapper">
		<jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
		<div id="page-content-wrapper">
			<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

			<div class="content-container">
				<div class="page-header">
					<h3 class="page-title">거래명세서 관리</h3>
					<p class="page-desc">Total Order & Transaction Management</p>
				</div>

				<div class="card-box">
					<form class="search-grid" name="estimateSearchForm" method="get"
						action="${pageContext.request.contextPath}/admin/order/estimate_list">
						<div>
							<label class="form-label" style="font-size: 12px;">주문 기간</label>
							<input type="date" name="startDate" class="form-control"
								value="${startDate}">
						</div>
						<div>
							<label class="form-label" style="font-size: 12px;">주문 상태</label>
							<select name="status" class="form-select">
								<option value="">전체 상태</option>
								<option value="결제완료" ${status=='결제완료'?'selected':''}>결제완료</option>
								<option value="배송중" ${status=='배송중'?'selected':''}>배송중</option>
								<option value="배송완료" ${status=='배송완료'?'selected':''}>배송완료</option>
							</select>
						</div>
						<div>
							<label class="form-label" style="font-size: 12px;">상세 검색</label>
							<input type="text" name="searchValue" class="form-control"
								placeholder="주문번호, 주문자명 입력" value="${searchValue}">
						</div>
						<div>
							<button type="submit" class="btn-search">SEARCH</button>
						</div>
					</form>
				</div>

				<div class="card-box">
					<div class="list-header">
						<div style="font-size: 14px; font-weight: 600;">
							신규 주문 <b style="color: #ff4e00;">${waitingCount}</b>건 / 전체
							${dataCount}건
						</div>
						<div class="action-group">
							<button type="button" class="btn-ctrl" onclick="deleteEstimate()">선택
								삭제</button>
							<button type="button" class="btn-ctrl" onclick="downloadExcel()">EXCEL
								DOWNLOAD</button>
						</div>
					</div>

					<table class="table">
						<thead>
							<tr>
								<th style="width: 40px;"><input type="checkbox"
									id="checkAll"></th>
								<th>주문번호</th>
								<th>주문자(ID)</th>
								<th>연락처</th>
								<th style="width: 30%;">주문 내역 요약</th>
								<th>총 수량</th>
								<th>주문일</th>
								<th>상태</th>
								<th>관리</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="dto" items="${list}" varStatus="status">
								<tr>
									<td><input type="checkbox" name="nums"
										value="${dto.orderNum}"></td>
									<td class="text-muted"
										style="font-family: 'Montserrat'; font-size: 12px;">${dto.orderNum}</td>
									<td><span style="font-weight: 700;">${dto.userName}</span><br>
										<small class="text-muted">(${dto.userId})</small></td>
									<td style="color: #888;">${dto.tel}</td>
									<td style="text-align: left; font-weight: 600; color: #555;">${dto.content}</td>
									<td style="font-weight: 800;">${dto.qty}개</td>
									<td style="color: #888;">${dto.regDate}</td>
									<td><span
										class="badge-luxury ${dto.status == '결제완료' ? 'st-waiting' : ''}">
											${dto.status} </span></td>
									<td>
										<button type="button" class="btn btn-sm btn-dark"
											style="border-radius: 0; padding: 5px 15px;"
											onclick="openEstimateWrite('${dto.orderNum}')">명세서</button>
									</td>
								</tr>
							</c:forEach>
							<c:if test="${empty list}">
								<tr>
									<td colspan="9" style="padding: 100px 0; text-align: center;">주문
										내역이 없습니다.</td>
								</tr>
							</c:if>
						</tbody>
					</table>

					<div class="pagination">${paging}</div>
				</div>
			</div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
	<script
		src="${pageContext.request.contextPath}/dist/js/admin_estimate_list.js"></script>

	<script>
	 	const contextPath = "${pageContext.request.contextPath}";
	 	
		function openEstimateWrite(orderNum) {
			if (!orderNum || orderNum === 'null' || orderNum === '') {
				alert("유효한 주문 번호가 없습니다.");
				return;
			}

			const cp = "${pageContext.request.contextPath}";
			location.href = cp + "/admin/order/estimate_write?orderNum="
					+ orderNum;
		}
	</script>

</body>
</html>