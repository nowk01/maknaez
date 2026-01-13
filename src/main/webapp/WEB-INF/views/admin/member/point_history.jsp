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
    <style>
        /* 추가 스타일: 검색창과 버튼 디자인 */
        .search-filter-card {
            background-color: #f8f9fa;
            border-radius: 4px;
        }
        .action-btn {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            margin-left: 5px;
            transition: all 0.2s;
        }
        .action-btn:hover {
            transform: scale(1.1);
        }
    </style>
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

                <div class="card p-4 mb-4 border-0 shadow-sm search-filter-card">
                    <form name="historySearchForm" action="${pageContext.request.contextPath}/admin/member/point_history" method="get">
                        <input type="hidden" name="memberIdx" value="${memberIdx}">
                        <input type="hidden" name="userId" value="${userId}">
                        
                        <div class="row align-items-center justify-content-between">
                            <div class="col-auto d-flex gap-2 align-items-center">
                                <div class="input-group">
                                    <span class="input-group-text bg-white"><i class="far fa-calendar-alt"></i></span>
                                    <input type="date" name="startDate" class="form-control" value="${startDate}">
                                    <span class="input-group-text bg-white">~</span>
                                    <input type="date" name="endDate" class="form-control" value="${endDate}">
                                </div>

                                <div class="input-group" style="width: 400px;">
                                    <span class="input-group-text bg-white"><i class="fas fa-search"></i></span>
                                    <input type="text" name="reason" class="form-control" placeholder="사유 입력 (예: 구매)" value="${reason}">
                                </div>
                                
                                <button type="button" class="btn btn-secondary" onclick="searchHistory()" style="white-space: nowrap">검색</button>
                                <button type="button" class="btn btn-outline-secondary" onclick="location.href='${pageContext.request.contextPath}/admin/member/point_history?memberIdx=${memberIdx}&userId=${userId}'">
                                    <i class="fas fa-sync-alt"></i>
                                </button>
                            </div>

                            <div class="col-auto">
                                <span class="me-2 fw-bold text-muted">포인트 관리</span>
                                <%-- 'plus'/'minus' 대신 '적립'/'차감'으로 통일 --%>
                                <button type="button" class="btn btn-success action-btn shadow-sm" onclick="openPointModal('적립')" title="포인트 적립">
                                    <i class="fas fa-plus"></i>
                                </button>
                                <button type="button" class="btn btn-danger action-btn shadow-sm" onclick="openPointModal('차감')" title="포인트 차감">
                                    <i class="fas fa-minus"></i>
                                </button>
                            </div>
                        </div>
                    </form>
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

    <%-- 모달 디자인 point_manage.jsp와 통일 --%>
    <div class="modal fade" id="pointModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold" id="pointModalLabel">포인트 관리</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form name="pointForm">
                        <input type="hidden" name="mode" id="modalMode">
                        <input type="hidden" name="memberIdxs" value="${memberIdx}"> <%-- 단일 회원이지만 이름 통일 --%>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">대상 회원</label>
                            <%-- point_manage 스타일의 박스 적용 --%>
                            <div class="p-2 bg-light border rounded text-muted small">
                                <div><span class="fw-bold text-dark">${userId}</span> 님 (현재 페이지 회원)</div>
                            </div>
                        </div>
    
                        <div class="mb-3">
                            <label class="form-label fw-bold">처리 사유</label>
                            <select name="reasonSelect" class="form-select mb-2" onchange="changeReason(this)">
                            	<option value="">사유를 선택하세요</option>
                            	<option value="direct">직접 입력</option>
                                <option value="이벤트 당첨">이벤트 당첨</option>
                                <option value="관리자 직권 적립">관리자 직권 적립</option>
                                <option value="관리자 직권 차감">관리자 직권 차감</option>
                                <option value="기타 보상">기타 보상</option>
                            </select>
                            <input type="text" name="reason" class="form-control" 
                               placeholder="사유를 '직접 입력'으로 선택 시 활성화됩니다." readonly>
                        </div>
    
                        <div class="mb-3">
                            <label class="form-label fw-bold">변동 포인트</label>
                            <div class="input-group">
                                <%-- name을 point_amount로 통일 --%>
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
        // 검색 유효성 검사 및 전송
        const searchHistory = () => {
            const f = document.historySearchForm;
            // 날짜 하나만 입력된 경우 체크
            if ((f.startDate.value && !f.endDate.value) || (!f.startDate.value && f.endDate.value)) {
                alert("시작일과 종료일을 모두 선택해주세요.");
                return;
            }
            f.submit();
        };

        // 1. 모달 열기 (point_manage.jsp와 로직 통일)
        function openPointModal(mode) {
            // 모달 UI 세팅
            const modalTitle = document.getElementById("pointModalLabel");
            const modalMode = document.getElementById("modalMode");
            const confirmBtn = document.querySelector("#pointModal .btn-primary");
            const pointHelp = document.getElementById("pointHelp");
            
            // 폼 초기화
            const f = document.pointForm;
            f.reset();

            modalMode.value = mode; // '적립' or '차감'

            if (mode === '적립') {
                modalTitle.innerText = "포인트 [적립]";
                modalTitle.className = "modal-title fw-bold text-primary";
                confirmBtn.className = "btn btn-primary";
                confirmBtn.innerText = "적립하기";
                pointHelp.innerText = "입력한 금액만큼 포인트가 더해집니다.";
            } else {
                modalTitle.innerText = "포인트 [차감]";
                modalTitle.className = "modal-title fw-bold text-danger";
                confirmBtn.className = "btn btn-danger";
                confirmBtn.innerText = "차감하기";
                pointHelp.innerText = "입력한 금액만큼 포인트가 차감됩니다.";
            }

            // 모달 띄우기
            const modal = new bootstrap.Modal(document.getElementById('pointModal'));
            modal.show();
        }

        // 2. 사유 선택 시 입력창 자동 완성
        function changeReason(select) {
		    // document 전체에서 찾지 않고, select 박스가 있는 그 폼(pointForm) 안에서만 input을 찾습니다.
		    const form = select.closest("form");
		    const input = form.querySelector("input[name=reason]");
		    
		    if (select.value === "direct") {
		        // '직접 입력' 선택 시: 잠금 해제, 값 초기화 및 포커스
		        input.readOnly = false;
		        input.value = ""; 
		        input.placeholder = "사유를 입력하세요 (예: 이벤트 참여 보상)";
		        input.focus();
		    } else {
		        // 그 외 선택 시: 잠금 설정 및 값 자동 입력
		        input.readOnly = true;
		        input.value = select.value; // 선택한 옵션 텍스트가 input에 들어감
		        input.placeholder = "사유를 '직접 입력'으로 선택 시 활성화됩니다.";
		    }
		}

        // 3. 포인트 업데이트 전송 (point_manage.jsp와 로직 통일)
        function submitPointUpdate() {
        const f = document.pointForm;
        
        // 폼 데이터 검증
        const reason = f.reason.value.trim();
        const amount = f.point_amount.value; // JSP name="point_amount"와 일치시킴

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

        if(!confirm("해당 내용을 반영하시겠습니까?")) {
            return;
        }

        // 1) URL 설정
        const url = "${pageContext.request.contextPath}/admin/member/updatePoint";
        
        // 2) 쿼리 스트링 구성 (serialize 사용)
        // pointForm 안에 memberIdxs(hidden), mode(hidden), point_amount, reason이 모두 포함되어 있어야 함
        const query = $(f).serialize();

        // 3) 콜백 함수 정의 (AJAX 성공 시 실행)
        const fn = function(data) {
            if(data.state === "true") {
                alert("처리가 완료되었습니다.");
                location.reload(); // 새로고침
            } else {
                const msg = data.message ? data.message : "처리에 실패했습니다.";
                alert(msg);
            }
        };

        // 4) util-jquery.js의 ajaxRequest 호출
        // ajaxRequest(url, method, requestParams, responseType, callback)
        ajaxRequest(url, "post", query, "json", fn);
    }
    </script>
</body>
</html>