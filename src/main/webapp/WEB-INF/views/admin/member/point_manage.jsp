<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마일리지 관리 | MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_point.css">
</head>
<body>
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                <div class="page-header">
                    <h3 class="page-title">포인트 관리</h3>
                    <p class="page-desc">회원별 적립금 현황을 조회하고 상세 내역을 관리합니다.</p>
                </div>

                <div class="card-box mb-4">
                    <h5 class="fw-bold mb-3"><i class="fas fa-filter me-1"></i> 통합 검색</h5>
                    
                    <form name="searchForm" action="${pageContext.request.contextPath}/admin/member/point_manage" method="get">
                        <div class="row g-3">
                            <div class="col-md-5">
                                <label class="form-label fw-bold small text-muted">최근 처리일 (조회 기간)</label>
                                <div class="input-group">
                                    <input type="date" name="startDate" value="${startDate}" class="form-control">
                                    <span class="input-group-text bg-white">~</span>
                                    <input type="date" name="endDate" value="${endDate}" class="form-control">
                                </div>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label fw-bold small text-muted">보유 포인트 (범위)</label>
                                <div class="input-group">
                                    <input type="number" name="minPoint" value="${minPoint}" class="form-control" placeholder="최소 포인트">
                                    <span class="input-group-text bg-white">~</span>
                                    <input type="number" name="maxPoint" value="${maxPoint}" class="form-control" placeholder="최대 포인트">
                                </div>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label fw-bold small text-muted">회원 검색</label>
                                <div class="input-group">
                                    <select name="condition" class="form-select" style="max-width: 80px;">
                                    	<option value="all" ${condition == 'all' ? 'selected' : ''}>전체</option>
                                        <option value="userId" ${condition=="userId"?"selected":""}>아이디</option>
                                        <option value="userName" ${condition=="userName"?"selected":""}>이름</option>
                                    </select>
                                    <input type="text" name="keyword" value="${keyword}" class="form-control" placeholder="검색어">
                                </div>
                            </div>
                            
                            <div class="col-12 text-end mt-3">
                                <button type="button" class="btn btn-secondary me-1" onclick="location.href='${pageContext.request.contextPath}/admin/member/point_manage'">
                                    <i class="fas fa-sync-alt"></i> 초기화
                                </button>
                                <button type="button" class="btn btn-dark px-4" onclick="searchList()">
                                    <i class="fas fa-search"></i> 검색 조회
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="card-box">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <span class="fw-bold text-dark fs-5">회원 목록</span>
                            <span class="text-muted ms-2 small">총 <span class="text-primary fw-bold">${dataCount}</span>명</span>
                        </div>
                        <div>
				            <button type="button" class="btn btn-outline-primary btn-sm me-1" onclick="openPointModal('적립')">
				                <i class="fas fa-plus-circle"></i> 일괄 적립
				            </button>
				            <button type="button" class="btn btn-outline-danger btn-sm" onclick="openPointModal('차감')">
				                <i class="fas fa-minus-circle"></i> 일괄 차감
				            </button>
				        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr class="text-center">
	                                <th width="5%">
				                        <input type="checkbox" id="chkAll" class="form-check-input" onclick="checkAll(this)">
				                    </th>
                                    <th width="8%">번호</th>
                                    <th width="15%">아이디</th>
                                    <th width="15%">회원명</th>
                                    <th width="20%">현재 포인트</th>
                                    <th width="20%">최근 처리일</th>
                                    <th width="15%">최근 변동</th>
                                    <th width="7%">관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="dto" items="${list}">
                                    <tr class="text-center">
                                    	<td>
				                            <input type="checkbox" name="memberIdxs" value="${dto.memberIdx}" class="form-check-input chk-item">
				                            <input type="hidden" id="point_${dto.memberIdx}" value="${dto.currentPoint}">
				                        </td>
                                        <td>${dto.memberIdx}</td>
                                        <td id="id_${dto.memberIdx}">${dto.userId}</td>
                                        <td id="name_${dto.memberIdx}">${dto.userName}</td>
                                        <td class="text-end pe-5 fw-bold text-primary">
                                            <fmt:formatNumber value="${dto.currentPoint}"/> P
                                        </td>
                                        <td class="text-muted small">
                                            ${not empty dto.lastPointDate ? dto.lastPointDate : '-'}
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${dto.lastPointType == '적립'}">
                                                    <span class="badge bg-primary bg-opacity-10 text-primary">적립</span>
                                                </c:when>
                                                <c:when test="${dto.lastPointType == '차감'}">
                                                    <span class="badge bg-danger bg-opacity-10 text-danger">차감</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary bg-opacity-10 text-secondary">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/member/point_history?memberIdx=${dto.memberIdx}&userId=${dto.userId}" 
                                               class="btn btn-sm btn-outline-dark" style="white-space: nowrap">
                                                내역
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${dataCount == 0}">
                                    <tr><td colspan="7" class="text-center p-5 text-muted">검색된 회원 정보가 없습니다.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <div class="mt-4 d-flex justify-content-center">
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
    
   <div class="modal fade" id="pointModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" id="pointModalLabel">포인트 관리</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form name="pointForm">
                    <input type="hidden" name="mode" id="modalMode"> <div class="mb-3">
                        <label class="form-label fw-bold">선택된 회원</label>
                        <div id="selectedMembers" class="p-2 bg-light border rounded text-muted small" style="max-height: 100px; overflow-y: auto;">
                            </div>
                        <div class="text-end mt-1">
                            <span class="text-primary fw-bold" id="selectedCount">0</span>명 선택됨
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">처리 사유</label>
                        <select name="reasonSelect" class="form-select mb-2" onchange="changeReason(this)">
                            <option value="">직접 입력</option>
                            <option value="이벤트 당첨">이벤트 당첨</option>
                            <option value="관리자 직권 적립">관리자 직권 적립</option>
                            <option value="관리자 직권 차감">관리자 직권 차감</option>
                            <option value="기타 보상">기타 보상</option>
                        </select>
                        <input type="text" name="reason" class="form-control" placeholder="사유를 입력하세요 (예: 이벤트 참여 보상)">
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">변동 포인트</label>
                        <div class="input-group">
                            <input type="number" name="point_amount" class="form-control text-end" placeholder="0">
                            <span class="input-group-text">P</span>
                        </div>
                        <div class="form-text" id="pointHelp">적립 시 양수, 차감 시 양수로 입력하세요.</div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="submitPointUpdate()">확인</button>
            </div>
        </div>
    </div>
</div>
    
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    
    <script type="text/javascript">
    function searchList() {
        const f = document.searchForm;
        f.submit();
    }
 	// 1. 전체 선택/해제 기능
    function checkAll(checkbox) {
        const items = document.querySelectorAll('.chk-item');
        items.forEach(item => {
            item.checked = checkbox.checked;
        });
    }

    // 2. 모달 열기 (선택된 회원 확인)
    function openPointModal(mode) {
        const checkedItems = document.querySelectorAll('.chk-item:checked');
        if (checkedItems.length === 0) {
            alert("처리가 필요한 회원을 선택해주세요.");
            return;
        }

        // 모달 UI 세팅
        const modalTitle = document.getElementById("pointModalLabel");
        const modalMode = document.getElementById("modalMode");
        const confirmBtn = document.querySelector("#pointModal .btn-primary");
        const pointHelp = document.getElementById("pointHelp");

        modalMode.value = mode; // '적립' or '차감'

        if (mode === '적립') {
            modalTitle.innerText = "포인트 일괄 [적립]";
            modalTitle.className = "modal-title fw-bold text-primary";
            confirmBtn.className = "btn btn-primary";
            confirmBtn.innerText = "적립하기";
            pointHelp.innerText = "입력한 금액만큼 포인트가 더해집니다.";
        } else {
            modalTitle.innerText = "포인트 일괄 [차감]";
            modalTitle.className = "modal-title fw-bold text-danger";
            confirmBtn.className = "btn btn-danger";
            confirmBtn.innerText = "차감하기";
            pointHelp.innerText = "입력한 금액만큼 포인트가 차감됩니다.";
        }

        // 선택된 회원 리스트 표시 Logic
        const selectedDiv = document.getElementById("selectedMembers");
        const countSpan = document.getElementById("selectedCount");
        selectedDiv.innerHTML = "";
        
        let html = "";
        checkedItems.forEach(item => {
            const memberIdx = item.value;
            const userId = document.getElementById("id_" + memberIdx).innerText;
            const userName = document.getElementById("name_" + memberIdx).innerText;
            const curPoint = document.getElementById("point_" + memberIdx).value; // 히든값 가져오기

            html += `<div><span class="fw-bold">\${userId}</span> (\${userName}) - 현재: \${curPoint} P</div>`;
        });
        
        selectedDiv.innerHTML = html;
        countSpan.innerText = checkedItems.length;

        // 모달 띄우기 (Bootstrap 5 API)
        const modal = new bootstrap.Modal(document.getElementById('pointModal'));
        modal.show();
    }

    // 3. 사유 선택 시 입력창 자동 완성
    function changeReason(select) {
        const input = document.querySelector("input[name=reason]");
        if (select.value) {
            input.value = select.value;
        } else {
            input.value = "";
            input.focus();
        }
    }

    function submitPointUpdate() {
        const f = document.pointForm;
        const mode = f.mode.value;
        const reason = f.reason.value;
        let amount = f.point_amount.value;

        // 1. 유효성 검사
        if (!reason) {
            alert("사유를 입력해주세요.");
            f.reason.focus();
            return;
        }
        if (!amount || amount <= 0) {
            alert("유효한 포인트 금액을 입력해주세요.");
            f.point_amount.focus();
            return;
        }

        // 2. 선택된 회원 ID 수집
        const checkedItems = document.querySelectorAll('.chk-item:checked');
        let memberIdxList = [];
        checkedItems.forEach(item => memberIdxList.push(item.value));

        if(memberIdxList.length === 0) {
            alert("선택된 회원이 없습니다.");
            return;
        }

        // 3. 배열을 콤마 구분 문자열로 변환 (예: "10,25,33")
        // ajaxRequest 사용 시 배열 처리를 단순화하기 위함
        const memberIdxsStr = memberIdxList.join(",");

        // 4. 요청 파라미터 구성
        const url = "${pageContext.request.contextPath}/admin/member/updatePoint";
        const query = {
            memberIdxs: memberIdxsStr, // 문자열로 전송
            mode: mode,
            amount: amount,
            reason: reason
        };

        // 5. ajaxRequest 함수 호출 (util-jquery.js 활용)
        const fn = function(data) {
            if (data.state === "true") {
                alert("성공적으로 처리되었습니다.");
                location.reload(); 
            } else {
                alert("처리에 실패했습니다. " + (data.message ? data.message : ""));
            }
        };

        // ajaxRequest(url, method, requestParams, responseType, callback)
        ajaxRequest(url, "post", query, "json", fn);
    }
    </script>
</body>
</html>