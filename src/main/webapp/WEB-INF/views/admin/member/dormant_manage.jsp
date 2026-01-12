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
                    <form name="searchForm" action="${pageContext.request.contextPath}/admin/member/dormant_manage" method="get" class="search-grid">
                        <div>
                            <label class="form-label">휴면 전환일</label>
                            <div class="d-flex align-items-center">
                                <input type="date" name="startDate" class="form-control" value="${startDate}">
                                <span class="mx-2 text-muted">~</span>
                                <input type="date" name="endDate" class="form-control" value="${endDate}">
                            </div>
                        </div>
                        <div>
                            <label class="form-label">정렬 기준</label>
                            <select name="sortType" class="form-select" onchange="searchList()">
                                <option value="latestDormant" ${sortType == 'latestDormant' ? 'selected' : ''}>최근 휴면 순</option>
                                <option value="longestInactive" ${sortType == 'longestInactive' ? 'selected' : ''}>미접속 기간 긴 순</option>
                                <option value="nameOrder" ${sortType == 'nameOrder' ? 'selected' : ''}>이름 순</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label">회원 검색</label>
                            <input type="text" name="keyword" class="form-control" placeholder="아이디 또는 회원명 입력" value="${keyword}">
                        </div>
                        <div>
                            <button type="button" class="btn-search-main" onclick="searchList()">SEARCH</button>
                        </div>
                    </form>
                </div>

                <div class="card-box">
                    <div class="list-ctrl">
                        <div class="stat-text">휴면 대상자 <b>${dataCount}</b>명이 조회되었습니다.</div>
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
                                            <td class="text-muted">${dataCount - (page-1) * size - status.index}</td>
                                            
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
                                            
                                            <td><span class="badge bg-secondary">${dto.modify_date}</span></td>
                                            <td><button class="btn-sm-action btn-restore" data-idx="${dto.memberIdx}">복구</button></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" class="text-center py-5">
                                            검색 결과가 없습니다.
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>

                    <div class="mt-5 d-flex justify-content-center">
                        <nav>
                             <div class="page-navigation">
                                ${paging}
                             </div>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div> 
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <script src="${pageContext.request.contextPath}/dist/js/admin_dormant.js"></script>
    
    <script type="text/javascript">
    function searchList() {
        const f = document.searchForm;
        
        // 날짜 유효성 검사
        if(f.startDate.value && f.endDate.value && f.startDate.value > f.endDate.value) {
            alert("종료일은 시작일보다 늦어야 합니다.");
            return;
        }
        
        f.submit();
    }
    
    $(function() {

        $("#checkAll").click(function() {
            if($(this).is(":checked")) {
                $("input[name=memberIdxs]").prop("checked", true);
            } else {
                $("input[name=memberIdxs]").prop("checked", false);
            }
        });

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
        
        $(".btn-restore").click(function() {
            let memberIdx = $(this).data("idx");
            
            // 버튼이 속한 행(tr)에서 회원의 이름 찾기 (4번째 td)
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
        
        // 기존 JS에 삭제 버튼에 대한 이벤트가 없어 추가해 드립니다.
        // 만약 버튼에 .btn-delete 클래스가 없다면 HTML에서 추가해야 합니다. (위 코드에는 없음, 버튼 생성 시 필요시 추가)
    });
    </script>
</body>
</html>