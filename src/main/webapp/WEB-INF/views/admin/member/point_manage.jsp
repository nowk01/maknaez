<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마일리지 관리 | MAKNAEZ ADMIN</title>
<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/admin_point.css">
</head>
<body>
	<div id="wrapper">
		<jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
		<div id="page-content-wrapper">
			<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

			<div class="content-container">
				<div class="page-header">
					<h3 class="page-title">포인트 관리</h3>
					<p class="page-desc">Member Point & Mileage System Management</p>
				</div>

				<div class="card-box mb-4">
					<h5 class="fw-bold mb-4 d-flex align-items-center">
						<span
							class="bg-dark text-white rounded-circle me-2 d-flex align-items-center justify-content-center"
							style="width: 24px; height: 24px;"> <i
							class="fas fa-search" style="font-size: 11px;"></i>
						</span> 통합 검색 조건
					</h5>

					<form name="searchForm"
						action="${pageContext.request.contextPath}/admin/member/point_manage"
						method="get">
						<div class="row g-3 align-items-end">
							<div class="col-md-4">
								<label class="search-label">조회 기간 (최근 처리일)</label>
								<div class="input-group input-group-sm">
									<input type="date" name="startDate" value="${startDate}"
										class="form-control"> <span
										class="input-group-text bg-light">~</span> <input type="date"
										name="endDate" value="${endDate}" class="form-control">
								</div>
							</div>

							<div class="col-md-3">
								<label class="search-label">보유 포인트 범위</label>
								<div class="input-group input-group-sm">
									<input type="number" name="minPoint" value="${minPoint}"
										class="form-control" placeholder="0"> <span
										class="input-group-text bg-light">~</span> <input
										type="number" name="maxPoint" value="${maxPoint}"
										class="form-control" placeholder="Max">
								</div>
							</div>

							<div class="col-md-3">
								<label class="search-label">회원 검색</label>
								<div class="input-group input-group-sm">
									<select name="condition" class="form-select"
										style="max-width: 90px;">
										<option value="all" ${condition == 'all' ? 'selected' : ''}>전체</option>
										<option value="userId" ${condition=="userId"?"selected":""}>아이디</option>
										<option value="userName"
											${condition=="userName"?"selected":""}>이름</option>
									</select> <input type="text" name="keyword" value="${keyword}"
										class="form-control" placeholder="검색어 입력">
								</div>
							</div>

							<div class="col-md-2 d-grid">
								<button type="button" class="btn btn-dark btn-sm fw-bold"
									onclick="searchList()">SEARCH</button>
							</div>

							<div class="col-12 text-center mt-3 border-top pt-3">
								<button type="button"
									class="btn btn-outline-secondary btn-sm px-4"
									onclick="location.href='${pageContext.request.contextPath}/admin/member/point_manage'">
									<i class="fas fa-sync-alt me-1"></i> 필터 초기화
								</button>
							</div>
						</div>
					</form>
				</div>

				<div class="card-box">
					<div class="d-flex justify-content-between align-items-center mb-4">
						<div>
							<h5 class="fw-bold m-0">회원별 포인트 현황</h5>
							<small class="text-muted">Total: <b class="text-orange">${dataCount}</b>
								members
							</small>
						</div>
						<div class="btn-group-premium">
							<button type="button" class="btn-ctrl btn-plus"
								onclick="openPointModal('적립')">
								<i class="fas fa-plus-circle me-1"></i> 일괄 적립
							</button>
							<button type="button" class="btn-ctrl btn-minus"
								onclick="openPointModal('차감')">
								<i class="fas fa-minus-circle me-1"></i> 일괄 차감
							</button>
						</div>
					</div>

					<div class="table-responsive">
						<table class="table table-hover align-middle">
							<thead>
								<tr class="text-center">
									<th width="50"><input type="checkbox" id="chkAll"
										class="form-check-input" onclick="checkAll(this)"></th>
									<th width="80">번호</th>
									<th width="150">아이디</th>
									<th width="150">회원명</th>
									<th>현재 포인트</th>
									<th width="200">최근 처리일</th>
									<th width="120">최근 변동</th>
									<th width="100">관리</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="dto" items="${list}">
									<tr class="text-center">
										<td><input type="checkbox" name="memberIdxs"
											value="${dto.memberIdx}" class="form-check-input chk-item">
											<input type="hidden" id="point_${dto.memberIdx}"
											value="${dto.currentPoint}"></td>
										<td class="text-muted small">${dto.memberIdx}</td>
										<td id="id_${dto.memberIdx}" class="fw-bold">${dto.userId}</td>
										<td id="name_${dto.memberIdx}">${dto.userName}</td>
										<td class="text-end pe-5 fw-bold text-orange"><fmt:formatNumber
												value="${dto.currentPoint}" /> P</td>
										<td class="text-muted small">${not empty dto.lastPointDate ? dto.lastPointDate : '-'}
										</td>
										<td><c:choose>
												<c:when test="${dto.lastPointType == '적립'}">
													<span class="badge-luxury st-plus">적립</span>
												</c:when>
												<c:when test="${dto.lastPointType == '차감'}">
													<span class="badge-luxury st-minus">차감</span>
												</c:when>
												<c:otherwise>
													<span class="badge-luxury">-</span>
												</c:otherwise>
											</c:choose></td>
										<td><a
											href="${pageContext.request.contextPath}/admin/member/point_history?memberIdx=${dto.memberIdx}&userId=${dto.userId}"
											class="btn-detail-sm">내역</a></td>
									</tr>
								</c:forEach>
								<c:if test="${dataCount == 0}">
									<tr>
										<td colspan="8" class="text-center p-5 text-muted">검색된 회원
											정보가 없습니다.</td>
									</tr>
								</c:if>
							</tbody>
						</table>
					</div>

					<div
						class="mt-4 d-flex justify-content-center custom-paging-wrapper">
						${paging}</div>
				</div>
			</div>
		</div>
	</div>

	<div class="modal fade" id="pointModal" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title fw-bold" id="pointModalLabel">포인트 관리</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body p-4">
					<form name="pointForm">
						<input type="hidden" name="mode" id="modalMode">
						<div class="mb-4">
							<label class="form-label fw-bold">선택된 회원 리스트</label>
							<div id="selectedMembers"
								class="p-3 bg-light border-dashed text-muted small"
								style="max-height: 120px; overflow-y: auto;"></div>
							<div class="text-end mt-2">
								<span class="text-orange fw-bold" id="selectedCount">0</span>명
								선택됨
							</div>
						</div>

						<div class="mb-4">
							<label class="form-label fw-bold">처리 사유</label> <select
								name="reasonSelect" class="form-select mb-2"
								onchange="changeReason(this)">
								<option value="">직접 입력</option>
								<option value="이벤트 당첨">이벤트 당첨</option>
								<option value="관리자 직권 적립">관리자 직권 적립</option>
								<option value="관리자 직권 차감">관리자 직권 차감</option>
								<option value="기타 보상">기타 보상</option>
							</select> <input type="text" name="reason" class="form-control"
								placeholder="사유를 입력하세요">
						</div>

						<div class="mb-2">
							<label class="form-label fw-bold">변동 포인트 설정</label>
							<div class="input-group">
								<input type="number" name="point_amount"
									class="form-control text-end fw-bold" placeholder="0">
								<span class="input-group-text bg-dark text-white border-dark">P</span>
							</div>
							<div class="form-text mt-2" id="pointHelp">적립/차감 시 모두 양수로
								입력하세요.</div>
						</div>
					</form>
				</div>
				<div class="modal-footer border-0 p-4 pt-0">
					<button type="button" class="btn btn-secondary w-25"
						data-bs-dismiss="modal">취소</button>
					<button type="button" class="btn btn-primary flex-grow-1 fw-bold"
						onclick="submitPointUpdate()">확인</button>
				</div>
			</div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
	<script src="${pageContext.request.contextPath}/dist/js/admin_point.js"></script>
</body>
</html>