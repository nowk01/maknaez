<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>견적서 관리 - MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_estimate_list.css">
</head>
<body>
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                <div class="page-header">
                    <h3 class="page-title">견적서 관리</h3>
                    <p class="page-desc">Shoes B2B & Bulk Order Management</p>
                </div>

                <div class="card-box">
                    <form class="search-grid" name="estimateSearchForm" method="get" action="${pageContext.request.contextPath}/admin/order/estimate_list">
                        <div>
                            <label class="form-label" style="font-size:12px;">요청 기간</label>
                            <input type="date" name="startDate" class="form-control" value="${startDate}">
                        </div>
                        <div>
                            <label class="form-label" style="font-size:12px;">진행 상태</label>
                            <select name="status" class="form-select">
                                <option value="">전체 상태</option>
                                <option value="견적 대기" ${status=='견적 대기'?'selected':''}>견적 대기</option>
                                <option value="발송 완료" ${status=='발송 완료'?'selected':''}>발송 완료</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label" style="font-size:12px;">상세 검색</label>
                            <input type="text" name="searchValue" class="form-control" placeholder="요청자명, 연락처, 상품명 입력" value="${searchValue}">
                        </div>
                        <div><button type="submit" class="btn-search">SEARCH</button></div>
                    </form>
                </div>

                <div class="card-box">
                    <div class="list-header">
                        <div style="font-size:14px; font-weight:600;">
                            미처리 요청 <b style="color:#ff4e00;">${waitingCount}</b>건 / 전체 ${dataCount}건
                        </div>
                        <div class="action-group">
                            <button type="button" class="btn-ctrl" onclick="deleteSelected()">선택 삭제</button>
                            <button type="button" class="btn-ctrl" onclick="downloadExcel()">EXCEL DOWNLOAD</button>
                        </div>
                    </div>

                    <table class="table">
                        <thead>
                            <tr>
                                <th style="width: 40px;"><input type="checkbox" id="checkAll"></th>
                                <th>번호</th><th>요청자(ID)</th><th>연락처</th><th style="width: 30%;">상품명 / 요청내용</th><th>수량</th><th>요청일</th><th>상태</th><th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="dto" items="${list}" varStatus="status">
                                <tr>
                                    <td><input type="checkbox" name="nums" value="${dto.estimateIdx}"></td>
                                    <td class="text-muted">${dataCount - (page-1)*10 - status.index}</td>
                                    <td><span style="font-weight:700;">${dto.userName}</span><br><small class="text-muted">(${dto.userId})</small></td>
                                    <td style="color:#888;">${dto.tel}</td>
                                    <td style="text-align:left; font-weight:600; color:#555;">${dto.content}</td>
                                    <td style="font-weight:800;">${dto.qty}개</td>
                                    <td style="color:#888;">${dto.regDate}</td>
                                    <td>
                                        <span class="badge-luxury ${dto.status == '견적 대기' ? 'st-waiting' : ''}">
                                            ${dto.status}
                                        </span>
                                    </td>
                                    <td>
                                        <button type="button" class="btn btn-sm ${dto.status == '견적 대기' ? 'btn-dark' : 'btn-light border'}" 
                                                style="border-radius:0; padding: 5px 15px;" 
                                                onclick="openEstimateWrite('${dto.orderNum}')">
                                            ${dto.status == '견적 대기' ? '작성' : '상세'}
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty list}">
                                <tr><td colspan="9" style="padding:100px 0;">요청된 견적 내역이 없습니다.</td></tr>
                            </c:if>
                        </tbody>
                    </table>

                    <div class="pagination">
                        ${paging}
                    </div>
                </div> 
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <script>
        // 주문번호로 견적서 작성창 열기 (기존 디자인 유지)
        function openEstimateWrite(orderNum) {
            let targetOrderNum = orderNum;
            
            // 만약 데이터에 주문번호가 없다면 직접 입력받음
            if(!targetOrderNum || targetOrderNum === 'null') {
                targetOrderNum = prompt("조회할 주문번호를 입력하세요.");
            }
            
            if(targetOrderNum) {
                // 이전에 컨트롤러에 만든 estimate_write 경로로 이동
                const url = "${pageContext.request.contextPath}/admin/order/estimate_write?orderNum=" + targetOrderNum;
                // 팝업창으로 띄우거나 현재창 이동 (디자인에 맞춰 선택)
                location.href = url;
            }
        }

        // 체크박스 전체 선택 로직
        document.getElementById('checkAll').addEventListener('change', function() {
            const checkboxes = document.querySelectorAll('input[name="nums"]');
            checkboxes.forEach(cb => cb.checked = this.checked);
        });
    </script>
</body>
</html>