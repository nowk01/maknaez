<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 조회 - MAKNAEZ ADMIN</title>
<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_member_list.css">
</head>
<body>

	<div id="wrapper">
		<jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
		<div id="page-content-wrapper">
			<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

			<div class="content-container">
				
				<%-- 헤더 영역: 26px 규격 및 세로바 포인트 --%>
				<div class="page-header">
					<h3 class="page-title">회원 조회</h3>
					<p class="page-desc">Member Account Configuration & Management</p>
				</div>

				<%-- 검색 필터 영역: 각진 네모 스타일 --%>
				<div class="card-box">
					<form name="searchForm" class="search-grid" onsubmit="return false;">
						<div>
							<label class="form-label">가입 기간</label>
							<div class="input-group">
								<input type="date" class="form-control" name="startDate" id="startDate" value="${startDate}"> 
								<span class="input-group-text">~</span> 
								<input type="date" class="form-control" name="endDate" id="endDate" value="${endDate}">
							</div>
						</div>
						<div>
							<label class="form-label">회원 등급</label> 
							<select class="form-select" name="userLevel" id="userLevel">
								<option value="전체 등급" ${userLevel == '전체 등급' ? 'selected' : ''}>전체 등급</option>
								<option value="IRON" ${userLevel == 'IRON' ? 'selected' : ''}>아이언 (Lv.1~10)</option>
								<option value="BRONZE" ${userLevel == 'BRONZE' ? 'selected' : ''}>브론즈 (Lv.11~20)</option>
								<option value="SILVER" ${userLevel == 'SILVER' ? 'selected' : ''}>실버 (Lv.21~30)</option>
								<option value="GOLD" ${userLevel == 'GOLD' ? 'selected' : ''}>골드 (Lv.31~40)</option>
								<option value="PLATINUM" ${userLevel == 'PLATINUM' ? 'selected' : ''}>플레티넘 (Lv.41~50)</option>
								<option value="ADMIN" ${userLevel == 'ADMIN' ? 'selected' : ''}>관리자 (Lv.51~)</option>
								<option value="99" ${userLevel == '99' ? 'selected' : ''}>최고 관리자 (Lv.99)</option>
							</select>
						</div>
						<div>
							<label class="form-label">회원 검색</label>
							<div class="input-group">
								<select class="form-select" style="max-width: 100px;" name="searchKey" id="searchKey">
									<option value="all" ${searchKey == 'all' ? 'selected' : ''}>전체</option>
									<option value="userId" ${searchKey == 'userId' ? 'selected' : ''}>아이디</option>
									<option value="userName" ${searchKey == 'userName' ? 'selected' : ''}>이름</option>
								</select> 
								<input type="text" class="form-control" name="searchValue" id="searchValue" placeholder="검색어 입력" value="${searchValue}">
							</div>
						</div>
						<div>
							<button class="btn-search-main" type="button" onclick="searchList()">SEARCH</button>
						</div>
					</form>
				</div>

				<%-- 회원 목록 영역 --%>
				<div class="card-box">
					<div class="list-ctrl">
						<div class="stat-text">조회된 회원 <b>${dataCount}</b>명</div>
						<div class="btn-group-custom">
							<button type="button" class="btn" onclick="openMemberModal('add')">회원 추가</button>
							<button type="button" class="btn" onclick="deleteList();">선택 삭제</button>
						</div>
					</div>

					<table class="custom-table">
						<thead>
							<tr>
								<th width="45"><input type="checkbox" id="chkAll" onclick="checkAll();"></th>
								<th>ID</th>
								<th>이름</th>
								<th>이메일</th>
								<th>등급</th>
								<th>가입일</th>
								<th>상태</th>
								<th width="100">관리</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<c:when test="${empty list}">
									<tr><td colspan="8" class="text-center py-5 text-muted">등록된 회원이 없습니다.</td></tr>
								</c:when>
								<c:otherwise>
									<c:forEach var="dto" items="${list}">
										<tr>
											<td><input type="checkbox" name="chk" value="${dto.memberIdx}"></td>
											<td class="fw-bold">${dto.userId}</td>
											<td>${dto.userName}</td>
											<td>${dto.email}</td>
											<td>
												<c:choose>
													<c:when test="${dto.userLevel >= 99}"><span class="k-badge level-99">최고관리자</span></c:when>
													<c:when test="${dto.userLevel >= 51}"><span class="k-badge level-admin">관리자</span></c:when>
													<c:otherwise><span class="k-badge level-user">Lv.${dto.userLevel}</span></c:otherwise>
												</c:choose>
											</td>
											<td>${dto.register_date}</td>
											<td>
												<c:choose>
													<c:when test="${dto.enabled == 1}"><span style="color:#2f855a; font-weight:700;">정상</span></c:when>
													<c:otherwise><span class="k-badge dormant">잠금/휴면</span></c:otherwise>
												</c:choose>
											</td>
											<td>
												<%-- 아이콘 대신 텍스트 수정 버튼 --%>
												<button type="button" class="btn-sm-action" onclick="openMemberModal('update', '${dto.memberIdx}');">수정</button>
											</td>
										</tr>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>
					
					<%-- 페이징 --%>
					<div class="page-navigation-wrap">${paging}</div>
				</div>
			</div>
		</div>
	</div>

	<%-- 회원 모달 (3번/4번 이미지 스타일 박스 적용) --%>
	<div class="modal fade" id="memberModal" tabindex="-1" aria-hidden="true">
		<div class="modal-dialog modal-lg modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="memberModalLabel">MEMBER CONFIGURATION</h5>
					<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<form name="memberForm" id="memberForm">
						<input type="hidden" name="memberIdx" id="modalMemberIdx" value="0"> 
						<input type="hidden" name="mode" id="modalMode" value="add">

						<div class="modal-section-card">
							<div class="card-tag">ACCOUNT</div>
							<div class="row g-4">
								<div class="col-md-6">
									<label class="modal-label">아이디</label> 
									<input type="text" class="form-control modal-input" name="userId" id="userId" required>
								</div>
								<div class="col-md-6">
									<label class="modal-label">비밀번호</label> 
									<input type="password" class="form-control modal-input" name="userPwd" id="userPwd">
								</div>
								<div class="col-md-6">
									<label class="modal-label">이름</label> 
									<input type="text" class="form-control modal-input" name="userName" id="userName" required>
								</div>
								<div class="col-md-6">
									<label class="modal-label">닉네임</label> 
									<input type="text" class="form-control modal-input" name="nickName" id="nickName" required>
								</div>
							</div>
						</div>

						<div class="modal-section-card">
							<div class="card-tag">PERSONAL</div>
							<div class="row g-4">
								<div class="col-md-6">
									<label class="modal-label">이메일</label> 
									<input type="email" class="form-control modal-input" name="email" id="email">
								</div>
								<div class="col-md-6">
									<label class="modal-label">전화번호</label> 
									<input type="text" class="form-control modal-input" name="tel" id="tel">
								</div>
								<div class="col-md-4">
									<label class="modal-label">성별</label> 
									<select class="form-select modal-input" name="gender" id="gender">
										<option value="">선택</option>
										<option value="0">남자</option>
										<option value="1">여자</option>
									</select>
								</div>
								<div class="col-md-4">
									<label class="modal-label">생년월일</label> 
									<input type="date" class="form-control modal-input" name="birth" id="birth" required>
								</div>
								<div class="col-md-4">
									<label class="modal-label">회원 등급</label> 
									<select class="form-select modal-input" name="userLevel" id="modalUserLevel">
										<option value="1">Lv.1 (IRON)</option>
										<option value="51">Lv.51 (ADMIN)</option>
										<option value="99">Lv.99 (MASTER)</option>
									</select>
								</div>
							</div>
						</div>

						<div class="modal-section-card" id="enabledDiv" style="display: none;">
							<div class="card-tag">STATUS</div>
							<select class="form-select modal-input" name="enabled" id="enabled">
								<option value="1">정상 사용 (ACTIVE)</option>
								<option value="0">잠금/휴면 (BLOCKED)</option>
							</select>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-modal-close" data-bs-dismiss="modal">닫기</button>
					<button type="button" class="btn btn-orange-main" onclick="submitMember()" style="border:none; color:#fff; font-weight:800; padding:10px 25px; cursor:pointer;">저장하기</button>
				</div>
			</div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
	<script>const contextPath = "${pageContext.request.contextPath}";</script>
	<script src="${pageContext.request.contextPath}/dist/js/admin_member_list.js"></script>
</body>
</html>