<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>STOCK MANAGEMENT | MAKNAEZ</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_stock.css?v=2.0">
    <script>const cp = "${pageContext.request.contextPath}";</script>
</head>
<body>
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                <div class="page-header">
                    <h3 class="page-title">재고 현황 관리</h3>
                    <p class="page-desc">Manage footwear inventory by color and size variants</p>
                </div>

                <div class="card-box mb-4">
                    <form class="row g-3" name="searchForm" action="${pageContext.request.contextPath}/admin/product/stock_list" method="get">
                        <div class="col-md-3">
                            <label class="form-label">카테고리</label>
                            <select class="form-select" name="cateCode">
                                <option value="">전체 카테고리</option>
                                <c:forEach var="vo" items="${categoryList}">
                                    <option value="${vo.cateCode}" ${cateCode == vo.cateCode ? "selected" : ""}>
                                        ${vo.cateName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">상품명 검색</label>
                            <div class="input-group">
                                <input type="text" class="form-control" name="keyword" value="${keyword}" placeholder="상품명 검색...">
                                <button class="btn btn-dark" type="button" onclick="searchList()">SEARCH</button>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="card-box">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th width="80" class="text-center">
                                        No / <input type="checkbox" id="checkAll" class="form-check-input" style="vertical-align:middle;">
                                    </th>
                                    <th width="120" class="text-center">카테고리</th>
                                    <th class="text-center">상품명</th>
                                    <th width="100" class="text-center">사이즈</th>
                                    <th width="100" class="text-center">재고</th>
                                    <th width="100" class="text-center">상태</th>
                                    <th width="150" class="text-center">최근 재고 변동일</th>
                                    <th width="80" class="text-center">수정</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="dto" items="${list}" varStatus="status">
                                    <tr>
                                        <td class="text-center">
                                            ${dataCount - (page-1) * 10 - status.index}
                                            <input type="hidden" name="prodId" value="${dto.prodId}">
                                            <input type="checkbox" name="optIds" value="${dto.optId}" class="form-check-input ms-2">
                                        </td>
                                        
                                        <td class="text-center text-muted small">${dto.cateName}</td>
                                        
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="${pageContext.request.contextPath}/uploads/product/${dto.thumbnail}" 
                                                     class="rounded me-2 border" style="width: 40px; height: 40px; object-fit: cover;">
                                                <span class="fw-bold text-dark">${dto.prodName}</span>
                                            </div>
                                        </td>
                                        
                                        <td class="text-center fw-bold text-secondary">${dto.prodSize} mm</td>
                                        
                                        <td class="text-center fw-bold ${dto.stockQty == 0 ? 'text-danger' : ''}">
                                            <fmt:formatNumber value="${dto.stockQty}"/>
                                        </td>
                                        
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${dto.stockQty == 0}">
                                                    <span class="badge bg-secondary">일시품절</span>
                                                </c:when>
                                                <c:when test="${dto.stockQty < 10}">
                                                    <span class="badge bg-danger">품절임박</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-success">정상판매</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        
                                        <td class="text-center small text-muted">
                                            ${not empty dto.regDate ? dto.regDate.substring(0, 10) : '-'}
                                        </td>
                                        
                                        <td class="text-center">
                                            <button type="button" class="btn btn-sm btn-outline-dark" 
                                                    onclick="openStockModal('${dto.prodId}', '${dto.optId}', '${dto.prodName}', '${dto.prodSize}', '${dto.stockQty}')">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                
                                <c:if test="${dataCount == 0}">
                                    <tr><td colspan="8" class="text-center p-5">등록된 재고 데이터가 없습니다.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                    
                    <div class="page-navigation d-flex justify-content-center mt-4">
                        ${paging}
                    </div>

                    <div class="btn-group-custom mt-3 text-end">
                        <button type="button" class="btn btn-luxury btn-orange" onclick="openBulkStockModal()">SAVE CHANGES</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="stockModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 2px;">
                <div class="modal-header" style="border-bottom: 3px solid #ff4e00;">
                    <h5 class="modal-title fw-bold" id="modalTitle">재고 관리</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label text-muted small fw-bold">제품명 / 사이즈</label>
                        <input type="text" id="modalProdName" class="form-control" readonly style="background:#f8f9fa;">
                    </div>
                    
                    <div class="mb-3" id="currentStockArea">
                        <label class="form-label text-muted small fw-bold">현재 남은 재고량</label>
                        <input type="text" id="modalCurrentStock" class="form-control fw-bold" readonly style="background:#f8f9fa;">
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-muted small fw-bold">변동 사유</label>
                            <select id="modalReason" class="form-select">
                                <option value="입고">입고 (Restock)</option>
                                <option value="반품">반품 입고 (Return)</option>
                                <option value="출고">기타 출고</option>
                                <option value="조정">재고 조정 (Adjustment)</option>
                                <option value="불량">불량 폐기 (Damaged)</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-muted small fw-bold">변동 수량</label>
                            <input type="number" id="modalChangeQty" class="form-control" placeholder="+/- 숫자 입력">
                            <div class="form-text" style="font-size:11px;">* 감소 시 -숫자 입력 (예: -5)</div>
                        </div>
                    </div>
                    
                    <input type="hidden" id="modalOptId">
					<input type="hidden" id="modalProdId"> 
					<input type="hidden" id="modalMode" value="single"> </div>
                <div class="modal-footer border-0 pt-0">
                    <button type="button" class="btn btn-dark w-100" onclick="updateStockSubmit()">저장 (Update)</button>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <script src="${pageContext.request.contextPath}/dist/js/admin_stock.js"></script>
    <script>
        function searchList() {
            const f = document.searchForm;
            f.submit();
        }
    </script>
</body>
</html>