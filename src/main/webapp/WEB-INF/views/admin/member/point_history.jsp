<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>포인트 상세 내역 | MAKNAEZ ADMIN</title>
<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />

<link rel="stylesheet"
   href="${pageContext.request.contextPath}/dist/css/admin_point_history.css">
</head>
<body>
   <div id="wrapper">
      <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
      <div id="page-content-wrapper">
         <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

         <div class="content-container">
            <div class="page-header d-flex justify-content-between align-items-end">
               <div>
                  <h3 class="page-title">
                     <span class="text-orange">${userId}</span> 님 상세 내역
                  </h3>
                  <p class="page-desc">Member Point Usage & History Tracking</p>
               </div>
               <button type="button" class="btn-detail-sm"
                  onclick="location.href='${pageContext.request.contextPath}/admin/member/point_manage'">
                  <i class="fas fa-list me-1"></i> 목록으로
               </button>
            </div>

            <div class="card-box search-filter-card mb-4">
               <form name="historySearchForm"
                  action="${pageContext.request.contextPath}/admin/member/point_history"
                  method="get">
                  <input type="hidden" name="memberIdx" value="${memberIdx}">
                  <input type="hidden" name="userId" value="${userId}">

                  <div class="row align-items-center g-3">
                     <div class="col-md-5">
                        <label class="search-label">기간 조회</label>
                        <div class="input-group">
                           <input type="date" name="startDate" class="form-control"
                              value="${startDate}"> <span
                              class="input-group-text bg-white">~</span> <input type="date"
                              name="endDate" class="form-control" value="${endDate}">
                        </div>
                     </div>

                     <div class="col-md-4">
                        <label class="search-label">사유 검색</label>
                        <div class="input-group">
                           <input type="text" name="reason" class="form-control"
                              placeholder="검색어 입력" value="${reason}">
                           <button type="button" class="btn btn-dark"
                              onclick="searchHistory()">SEARCH</button>
                        </div>
                     </div>

                     <div class="col-md-3 text-end">
                        <label class="search-label">포인트 직권 관리</label>
                        <button type="button" class="action-btn btn-success"
                           onclick="openPointModal('적립')" title="적립">
                           <i class="fas fa-plus"></i>
                        </button>

                        <button type="button" class="action-btn btn-danger"
                           onclick="openPointModal('차감')" title="차감">
                           <i class="fas fa-minus"></i>
                        </button>

                        <button type="button" class="btn btn-outline-secondary ms-2"
                           style="height: 42px; border-radius: 0;"
                           onclick="location.href='${pageContext.request.contextPath}/admin/member/point_history?memberIdx=${memberIdx}&userId=${userId}'">
                           <i class="fas fa-sync-alt"></i>
                        </button>
                     </div>
                  </div>
               </form>
            </div>

            <div class="card-box">
               <div class="d-flex justify-content-between align-items-center mb-4">
                  <h5 class="fw-bold m-0">포인트 히스토리</h5>
                  <small class="text-muted">Total: <b class="text-orange">${dataCount}</b>
                     records
                  </small>
               </div>
               
               <table class="table table-hover align-middle table-history">
                  <thead>
                     <tr class="text-center">
                        <th width="80">번호</th>
                        <th width="150">주문 코드</th>
                        <th class="text-start">내용 (사유)</th>
                        <th width="150">변동 포인트</th>
                        <th width="150">잔여 포인트</th>
                        <th width="180">처리 일자</th>
                     </tr>
                  </thead>

                  <tbody>
                     <c:forEach var="dto" items="${list}" varStatus="status">
                        <tr class="text-center">
                           <td class="text-muted small">${dataCount - (page-1)*10 - status.index}</td>
                           <td class="order-code">${not empty dto.order_id ? dto.order_id : '-'}</td>
                           <td class="text-start fw-bold">${dto.reason}</td>
                           <td><c:choose>
                                 <c:when test="${dto.point_amount > 0}">
                                    <span class="point-plus">+<fmt:formatNumber
                                          value="${dto.point_amount}" /></span>
                                 </c:when>
                                 <c:otherwise>
                                    <span class="point-minus"><fmt:formatNumber
                                          value="${dto.point_amount}" /></span>

                                 </c:otherwise>
                              </c:choose></td>
                           <td class="text-muted"><fmt:formatNumber
                                 value="${dto.rem_point}" /> P</td>
                           <td class="small">${dto.reg_date}</td>
                        </tr>
                     </c:forEach>

                     <c:if test="${dataCount == 0}">
                        <tr>
                           <td colspan="6" class="p-5 text-muted">포인트 내역이 존재하지 않습니다.</td>
                        </tr>
                     </c:if>
                  </tbody>
               </table>

               <div class="mt-4 d-flex justify-content-center">
                  <ul class="pagination">${paging}
                  </ul>
               </div>
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
                  <input type="hidden" name="mode" id="modalMode"> <input
                     type="hidden" name="memberIdxs" value="${memberIdx}">
                  <div class="mb-4">
                     <label class="form-label fw-bold">대상 회원</label>
                     <div class="p-3 bg-light border-dashed text-dark">
                        <i class="fas fa-user me-2"></i> <span class="fw-bold">${userId}</span>
                        님
                     </div>
                  </div>

                  <div class="mb-4">
                     <label class="form-label fw-bold">처리 사유</label> <select
                        name="reasonSelect" class="form-select mb-2"
                        onchange="changeReason(this)">
                        <option value="">사유 선택</option>
                        <option value="direct">직접 입력</option>
                        <option value="이벤트 당첨">이벤트 당첨</option>
                        <option value="관리자 직권 적립">관리자 직권 적립</option>
                        <option value="관리자 직권 차감">관리자 직권 차감</option>
                        <option value="기타 보상">기타 보상</option>
                     </select> <input type="text" name="reason" class="form-control"
                        placeholder="사유를 입력하세요" readonly>
                  </div>

                  <div class="mb-2">
                     <label class="form-label fw-bold">변동 포인트</label>
                     <div class="input-group">
                        <input type="number" name="point_amount"
                           class="form-control text-end fw-bold" placeholder="0">
                        <span class="input-group-text bg-dark text-white border-dark">P</span>
                     </div>
                  </div>
               </form>
            </div>
            
            <div class="modal-footer border-0 p-4 pt-0">
               <button type="button" class="btn btn-secondary w-25"
                  data-bs-dismiss="modal">취소</button>
               <button type="button" class="btn btn-primary flex-grow-1 fw-bold"
                  id="modalConfirmBtn" onclick="submitPointUpdate()">확인</button>
            </div>
         </div>
      </div>
   </div>

   <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
   <script
      src="${pageContext.request.contextPath}/dist/js/admin_point_history.js"></script>

</body>

</html>