<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>휴면 회원 관리 | MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_dormant.css">
</head>
<body>
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                <div class="page-header">
                    <h3 class="page-title">휴면 회원 관리</h3>
                    <p class="page-desc">장기 미접속 회원 리스트를 관리하고 복구/삭제를 처리합니다.</p>
                </div>

                <div class="card-box">
                    <form name="searchForm" class="search-grid" onsubmit="return false;">
                        <div>
                            <label class="form-label">휴면 전환일</label>
                            <div class="d-flex align-items-center">
                                <input type="date" class="form-control" value="2025-01-01">
                                <span class="mx-2 text-muted">~</span>
                                <input type="date" class="form-control" value="2026-01-11">
                            </div>
                        </div>
                        <div>
                            <label class="form-label">정렬 기준</label>
                            <select class="form-select">
                                <option>최근 휴면 순</option>
                                <option>미접속 기간 긴 순</option>
                                <option>이름 순</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label">회원 검색</label>
                            <input type="text" class="form-control" placeholder="아이디 또는 회원명 입력">
                        </div>
                        <div>
                            <button type="button" class="btn-search-main" onclick="searchList()">검색</button>
                        </div>
                    </form>
                </div>

                <div class="card-box">
                    <div class="list-ctrl">
                        <div class="stat-text">휴면 대상자 <b>3</b>명이 조회되었습니다.</div>
                        <div class="btn-group-custom">
                            <button type="button" id="btnRestoreSelected" class="btn">
				                <i class="fas fa-user-check me-1"></i>선택 복구
				            </button>
				            
				            <button type="button" id="btnDeleteSelected" class="btn" style="color: #ff4e00;">
				                <i class="fas fa-user-slash me-1"></i>선택 삭제
				            </button>
				            
				            <button type="button" class="btn">
				                <i class="fas fa-envelope me-1"></i>안내 메일 발송
				            </button>
                        </div>
                    </div>

                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th style="width: 50px;"><input type="checkbox" id="checkAll"></th>
                                <th style="width: 80px;">번호</th>
                                <th>아이디</th>
                                <th>회원명</th>
                                <th>마지막 로그인</th>
                                <th>미접속 일수</th>
                                <th>휴면 전환일</th>
                                <th>상태</th>
                                <th style="width: 100px;">관리</th>
                            </tr>
                        </thead>
                        <tbody>
		                    <c:choose>
		                        <c:when test="${not empty list}">
		                            <c:forEach var="dto" items="${list}" varStatus="status">
		                                <tr>
		                                    <td>
		                                        <input type="checkbox" name="memberIdxs" value="${dto.memberIdx}" class="chk-item form-check-input">
		                                    </td>
		                                    <td class="text-muted">${count - status.index}</td>
		                                    
		                                    <td class="fw-bold">${dto.userId}</td>
		                                    
		                                    <td>${dto.userName}</td>
		                                    
		                                    <td>
		                                        <c:choose>
		                                            <c:when test="${not empty dto.lastLoginDate}">
		                                                <fmt:formatDate value="${dto.lastLoginDate}" pattern="yyyy.MM.dd HH:mm"/>
		                                            </c:when>
		                                            <c:otherwise><span class="text-muted">-</span></c:otherwise>
		                                        </c:choose>
		                                    </td>
		                                    
		                                    <td style="color: #ff4e00; font-weight: 700;">
		                                        ${dto.dormantDays}일 경과
		                                    </td>
		                                    
		                                    <td><span class="badge bg-secondary">휴면</span></td>
		                                    
		                                    <td>
		                                        <button type="button" class="btn btn-sm btn-outline-primary btn-restore" data-idx="${dto.memberIdx}">
		                                            복구
		                                        </button>
		                                    </td>
		                                </tr>
		                            </c:forEach>
		                        </c:when>
		                        <c:otherwise>
		                            <tr>
		                                <td colspan="8" class="text-center py-5">
		                                    휴면 상태인 회원이 없습니다.
		                                </td>
		                            </tr>
		                        </c:otherwise>
		                    </c:choose>
		                </tbody>
                    </table>

                    <div class="mt-5 d-flex justify-content-center">
                        <nav>
                            <ul class="pagination" style="display:flex; list-style:none; gap:10px;">
                                <li style="padding:8px 15px; background:#111; color:#fff; border-radius:2px; cursor:pointer;">1</li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div> 
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <script src="${pageContext.request.contextPath}/dist/js/admin_dormant.js"></script>
    
    <script type="text/javascript">
    $(function() {

        // 1. 전체 선택 / 해제
        // (헤더 체크박스 id="chkAll" 이라고 가정)
        $("#chkAll").click(function() {
            if($(this).is(":checked")) {
                $("input[name=memberIdxs]").prop("checked", true);
            } else {
                $("input[name=memberIdxs]").prop("checked", false);
            }
        });

        // ============================================================
        // 2. [선택 복구] 버튼 기능
        // ============================================================
        $("#btnRestoreSelected").click(function() {
            let cnt = $("input[name=memberIdxs]:checked").length;

            if (cnt === 0) {
                alert("복구할 회원을 선택해주세요.");
                return;
            }

            if (!confirm("선택한 " + cnt + "명의 회원을 복구하시겠습니까?")) {
                return;
            }

            // 체크된 회원들의 memberIdxs 값을 쿼리 스트링으로 변환
            const query = $("input[name=memberIdxs]:checked").serialize();

            $.ajax({
                type: "POST",
                url: "releaseDormantList", // Controller URL
                data: query,
                dataType: "json",
                success: function(data) {
                    if (data.state === "true") {
                        alert("총 " + data.count + "명이 정상적으로 복구되었습니다.");
                        location.reload();
                    } else {
                        alert(data.message);
                    }
                },
                error: function(e) {
                    console.log(e);
                    alert("처리 중 에러가 발생했습니다.");
                }
            });
        });

        // ============================================================
        // 3. [선택 삭제] 버튼 기능
        // ============================================================
        $("#btnDeleteSelected").click(function() {
            let cnt = $("input[name=memberIdxs]:checked").length;

            if (cnt === 0) {
                alert("삭제할 회원을 선택해주세요.");
                return;
            }

            if (!confirm("선택한 " + cnt + "명의 회원을 '영구 삭제' 하시겠습니까?\n삭제된 데이터는 복구할 수 없습니다.")) {
                return;
            }

            const query = $("input[name=memberIdxs]:checked").serialize();

            $.ajax({
                type: "POST",
                url: "deleteList", // Controller URL
                data: query,
                dataType: "json",
                success: function(data) {
                    if (data.state === "true") {
                        alert("선택한 회원이 삭제되었습니다.");
                        location.reload();
                    } else {
                        alert("삭제 실패: " + (data.message || "참조 데이터 오류"));
                    }
                },
                error: function() {
                    alert("서버 통신 에러");
                }
            });
        });

        // ============================================================
        // 4. 리스트 내부 개별 [복구] 버튼 (옵션)
        // ============================================================
        $(".btn-restore").click(function() {
            let memberIdx = $(this).data("idx");
            
            // 버튼이 속한 행(tr)에서 회원의 이름 찾기 (3번째 td라고 가정)
            let userName = $(this).closest("tr").find("td:eq(3)").text(); 

            if (!confirm("'" + userName + "' 회원을 복구하시겠습니까?")) return;

            $.ajax({
                type: "POST",
                url: "releaseDormantList",
                data: { memberIdxs: memberIdx },
                dataType: "json",
                success: function(data) {
                    if (data.state === "true") {
                        alert("복구되었습니다.");
                        location.reload();
                    } else {
                        alert("실패했습니다.");
                    }
                },
                error: function() { alert("에러 발생"); }
            });
        });
        
         // ============================================================
        // 5. 리스트 내부 개별 [삭제] 버튼 (옵션)
        // ============================================================
        $(".btn-delete").click(function() {
            let memberIdx = $(this).data("idx");
            let userName = $(this).closest("tr").find("td:eq(3)").text(); 

            if (!confirm("'" + userName + "' 회원을 정말 삭제하시겠습니까?")) return;

            $.ajax({
                type: "POST",
                url: "deleteList",
                data: { memberIdxs: memberIdx },
                dataType: "json",
                success: function(data) {
                    if (data.state === "true") {
                        alert("삭제되었습니다.");
                        location.reload();
                    } else {
                        alert("실패했습니다.");
                    }
                },
                error: function() { alert("에러 발생"); }
            });
        });

    });
    </script>
</body>
</html>