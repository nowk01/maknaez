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
							    <label class="search-label">회원 등급 검색</label>
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
                    <div style="float: right;">
				        <button type="button" class="btn btn-primary" onclick="openMemberModal('add')">
				            <i class="bi bi-person-plus"></i> 회원 추가
				        </button>
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
											        <%-- 99 이상: 최고 관리자 --%>
											        <c:when test="${dto.userLevel >= 99}">
											            <span class="badge bg-danger">최고관리자</span>
											        </c:when>
											        
											        <%-- 51 ~ 98: 관리자 --%>
											        <c:when test="${dto.userLevel >= 51}">
											            <span class="badge bg-primary">관리자</span>
											        </c:when>
											        
											        <%-- 41 ~ 50: 플레티넘 --%>
											        <c:when test="${dto.userLevel >= 41}">
											            <span class="badge bg-info text-dark">플레티넘</span>
											        </c:when>
											        
											        <%-- 31 ~ 40: 골드 --%>
											        <c:when test="${dto.userLevel >= 31}">
											            <span class="badge bg-warning text-dark">골드</span>
											        </c:when>
											        
											        <%-- 21 ~ 30: 실버 --%>
											        <c:when test="${dto.userLevel >= 21}">
											            <span class="badge" style="background-color: #c0c0c0; color: #000;">실버</span>
											        </c:when>
											        
											        <%-- 11 ~ 20: 브론즈 --%>
											        <c:when test="${dto.userLevel >= 11}">
											            <span class="badge" style="background-color: #cd7f32; color: #fff;">브론즈</span>
											        </c:when>
											        
											        <%-- 1 ~ 10: 아이언 (그 외) --%>
											        <c:otherwise>
											            <span class="badge bg-secondary">아이언</span>
											        </c:otherwise>
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
									            <button type="button" class="btn btn-sm btn-light border" title="상세보기"
									                    onclick="openMemberModal('update', '${dto.memberIdx}');">
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
    
    <div class="modal fade" id="memberModal" tabindex="-1" aria-labelledby="memberModalLabel" aria-hidden="true">
	    <div class="modal-dialog modal-lg">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="memberModalLabel">회원 관리</h5>
	                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	            </div>
	            <div class="modal-body">
	                <form name="memberForm" id="memberForm">
	                    <input type="hidden" name="memberIdx" id="modalMemberIdx" value="0">
	                    <input type="hidden" name="mode" id="modalMode" value="add">
	
	                    <div class="row mb-3">
	                        <div class="col-md-6">
	                            <label for="userId" class="form-label">아이디</label>
	                            <input type="text" class="form-control" name="userId" id="userId" required>
	                        </div>
	                        <div class="col-md-6">
	                            <label for="userPwd" class="form-label">비밀번호</label>
	                            <input type="password" class="form-control" name="userPwd" id="userPwd">
	                            <small class="text-muted" style="font-size:12px;">※ 수정 시 입력하면 비밀번호가 변경됩니다.</small>
	                        </div>
	                    </div>
	                    
	                    <div class="row mb-3">
	                        <div class="col-md-6">
	                            <label for="userName" class="form-label">이름</label>
	                            <input type="text" class="form-control" name="userName" id="userName" required>
	                        </div>
	                        <div class="col-md-6">
	                            <label for="birth" class="form-label">생년월일</label>
	                            <input type="date" class="form-control" name="birth" id="birth" required>
	                        </div>
	                    </div>
	
	                    <div class="row mb-3">
	                        <div class="col-md-6">
	                            <label for="email" class="form-label">이메일</label>
	                            <input type="email" class="form-control" name="email" id="email">
	                        </div>
	                        <div class="col-md-6">
	                            <label for="tel" class="form-label">전화번호</label>
	                            <input type="text" class="form-control" name="tel" id="tel">
	                        </div>
	                    </div>
	
	                    <div class="mb-3">
	                         <label for="modalUserLevel" class="form-label">회원 등급</label>
	                         <select class="form-select" name="userLevel" id="modalUserLevel">
	                             <option value="1">아이언 (Lv.1)</option>
	                             <option value="11">브론즈 (Lv.11)</option>
	                             <option value="21">실버 (Lv.21)</option>
	                             <option value="31">골드 (Lv.31)</option>
	                             <option value="41">플레티넘 (Lv.41)</option>
	                             <option value="51">관리자 (Lv.51)</option>
	                             <option value="99">최고관리자 (Lv.99)</option>
	                         </select>
	                    </div>
	                </form>
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
	                <button type="button" class="btn btn-primary" onclick="submitMember()">저장</button>
	            </div>
	        </div>
	    </div>
	</div>
	    
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />

	<script type="text/javascript">
        // 검색 기능
        function searchList() {
            const f = document.searchForm;
            let startDate = document.getElementById("startDate").value;
            let endDate = document.getElementById("endDate").value;
            let userLevel = document.getElementById("userLevel").value;
            let searchKey = document.getElementById("searchKey").value;
            let searchValue = document.getElementById("searchValue").value;

            let url = "${pageContext.request.contextPath}/admin/member/member_list";
            let query = "page=1";
            
            if(startDate && endDate) {
                query += "&startDate=" + startDate + "&endDate=" + endDate;
            }
            
            if(userLevel !== "전체 등급") {
                query += "&userLevel=" + encodeURIComponent(userLevel);
            }
            
            if(searchValue) {
                query += "&searchKey=" + searchKey + "&searchValue=" + encodeURIComponent(searchValue);
            }
            
            location.href = url + "?" + query;
        }
        
     	// 모달 열기 (모드에 따라 처리)
        function openMemberModal(mode, memberIdx) {
            // 1. 모달 인스턴스 가져오기
            let modalEl = document.getElementById('memberModal');
            let myModal = bootstrap.Modal.getInstance(modalEl);
            if (!myModal) {
                myModal = new bootstrap.Modal(modalEl);
            }

            const form = document.getElementById("memberForm");
            
            // 2. 폼 초기화
            form.reset();
            document.getElementById("modalMode").value = mode;

            // 3. 모드별 처리
            if (mode === 'add') {
                // [회원 추가 모드]
                document.getElementById("memberModalLabel").innerText = "회원 추가";
                document.getElementById("userId").readOnly = false; // 아이디 입력 가능
                document.getElementById("modalMemberIdx").value = "0";
                
                myModal.show(); // 빈 모달 바로 열기

            } else if (mode === 'update') {
                // [회원 수정 모드]
                document.getElementById("memberModalLabel").innerText = "회원 상세/수정";
                document.getElementById("userId").readOnly = true; // 아이디 수정 불가
                document.getElementById("modalMemberIdx").value = memberIdx;

                // AJAX로 회원 상세 정보 가져오기
                let url = "${pageContext.request.contextPath}/admin/member/detail";
                let query = "memberIdx=" + memberIdx;

                const fn = function(data) {
                    if(data.state === "true") {
                        let dto = data.dto;
                        
                        // --- [핵심] 기존 정보 입력하기 ---
                        $("#userId").val(dto.userId);
                        $("#userName").val(dto.userName);
                        $("#email").val(dto.email);
                        $("#tel").val(dto.tel);
                        $("#modalUserLevel").val(dto.userLevel);

                        // **날짜 포맷 처리 (가장 중요)**
                        // DB에서 "2024-01-01 10:30:00" 처럼 올 경우 앞 10자리만 잘라서 넣어야 함
                        if(dto.birth) {
                            // 문자열인 경우 앞에서 10자리만 추출 (YYYY-MM-DD)
                            let birthStr = dto.birth.substring(0, 10);
                            $("#birth").val(birthStr);
                        }

                        // 데이터 세팅 후 모달 열기
                        myModal.show();
                    } else {
                        alert("회원 정보를 불러올 수 없습니다.");
                    }
                };

                ajaxRequest(url, "GET", query, "json", fn);
            }
        }

        // 회원 저장 (추가 또는 수정)
        function submitMember() {
            const f = document.getElementById("memberForm");
            let mode = f.mode.value;
            
            // 유효성 검사
            if(!f.userId.value) { alert("아이디를 입력하세요."); f.userId.focus(); return; }
            if(!f.userName.value) { alert("이름을 입력하세요."); f.userName.focus(); return; }
            if(!f.birth.value) { alert("생년월일을 입력하세요."); f.birth.focus(); return; }

            let url = "${pageContext.request.contextPath}/admin/member/" + (mode === "add" ? "write" : "update");
            
            // jQuery serialize()를 사용하여 폼 데이터 직렬화 (readonly 필드도 포함됨)
            let query = $(f).serialize(); 

            // 콜백 함수 정의
            const fn = function(data) {
                if(data.state === "true") {
                    alert("처리가 완료되었습니다.");
                    location.reload(); // 성공 시 리스트 갱신
                } else {
                    alert("작업에 실패했습니다.");
                }
            };

            // util-jquery.js의 ajaxRequest 사용
            // ajaxRequest(url, method, query, responseType, callback)
            ajaxRequest(url, "POST", query, "json", fn);
        }
    </script>
    
    
</body>
</html>