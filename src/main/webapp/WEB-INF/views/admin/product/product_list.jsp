<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Product List | MAKNAEZ</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_product.css?v=1.0">
    <script>
        const cp = "${pageContext.request.contextPath}";
    </script>
</head>
<body>
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                <div class="page-header">
                    <h3 class="page-title">상품 목록 관리</h3>
                    <p class=\"page-desc\">Product List & Inventory Configuration</p>
                </div>

                <div class="card-box mb-4">
                    <div class="mb-4 pb-2" style="border-bottom: 1px solid #f8f8f8;">
                        <form name="searchForm" action="${pageContext.request.contextPath}/admin/product/product_list" method="get">
                            <div class="d-flex align-items-center gap-2">
                                <select name="category" class="form-select" style="width: 150px;">
                                    <option value="">:: 카테고리 ::</option>
                                    <c:forEach var="cat" items="${categoryList}">
                                        <option value="${cat.cateCode}" ${category == cat.cateCode ? "selected" : ""}>${cat.cateName}</option>
                                    </c:forEach>
                                </select>

                                <select name="schType" class="form-select" style="width: 120px;">
                                    <option value="all" ${schType=="all"?"selected":""}>전체</option>
                                    <option value="name" ${schType=="name"?"selected":""}>상품명</option>
                                    <option value="code" ${schType=="code"?"selected":""}>상품코드</option>
                                </select>
                                <input type="text" name="kwd" value="${kwd}" class="form-control" style="width: 250px;" placeholder="검색어를 입력하세요">
                                <button type="button" class="btn btn-dark" onclick="searchList()">검색</button>
                            </div>
                        </form>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead>
                                <tr>
                                    <th style="width: 5%;"><input type="checkbox" id="checkAll"></th>
					                <th style="width: 5%;">No</th>
					                <th style="width: 10%;">이미지</th> <th style="width: 20%;">분류 (Depth)</th>
					                <th style="width: 25%;">상품명</th>
					                <th style="width: 15%;">판매가</th>
					                <th style="width: 10%;">상태</th>
					                <th style="width: 10%;">관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="dto" items="${list}" varStatus="status">
					                <tr>
					                    <td><input type="checkbox" name="prodIds" value="${dto.prodId}"></td>
					                    <td>${dataCount - (page-1)*10 - status.index}</td>
					                    
					                    <td>
					                        <c:if test="${not empty dto.thumbnail}">
					                            <img src="${pageContext.request.contextPath}/uploads/product/${dto.thumbnail}" 
					                                 width="50" height="50" style="object-fit:cover; border-radius:4px; border:1px solid #eee;">
					                        </c:if>
					                        <c:if test="${empty dto.thumbnail}">
					                            <span class="text-muted" style="font-size:0.8rem;">No Image</span>
					                        </c:if>
					                    </td>
					                    
					                    <td class="text-start">
					                        <span class="badge bg-secondary me-1" style="font-weight:normal;">${dto.cateParent}</span>
					                        <i class="bi bi-chevron-right text-muted" style="font-size:10px;"></i>
					                        <span class="ms-1">${dto.cateName}</span>
					                    </td>
					                    
					                    <td class="text-start fw-bold">${dto.prodName}</td>
					                    <td><fmt:formatNumber value="${dto.price}" pattern="#,###"/>원</td>
					                    
					                    <td>
					                        <c:choose>
					                            <c:when test="${dto.isDisplayed == 1}"><span class="badge bg-success">진열중</span></c:when>
					                            <c:otherwise><span class="badge bg-danger">숨김</span></c:otherwise>
					                        </c:choose>
					                    </td>
					                    
					                    <td>
					                        <button type="button" class="btn btn-sm btn-outline-dark" 
					                                onclick="location.href='${pageContext.request.contextPath}/admin/product/update?prodId=${dto.prodId}&page=${page}'">
					                            Changes
					                        </button>
					                    </td>
					                </tr>
					            </c:forEach>
                                
                                <c:if test="${dataCount == 0}">
                                    <tr>
                                        <td colspan="7" class="text-center p-5">등록된 상품이 없습니다.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                    
                    <div class="page-navigation d-flex justify-content-center mt-4">
                        ${paging}
                    </div>

                    <div class="btn-group-custom mt-3">
					    <button type="button" class="btn btn-luxury btn-delete-sub" onclick="deleteSelected()">DELETE</button>
					    <button type="button" class="btn btn-luxury btn-dark-sub" 
					            onclick="location.href='${pageContext.request.contextPath}/admin/product/product_write'">
					        PRODUCT REGISTRATION
					    </button>
					</div>
                </div> 
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <script src="${pageContext.request.contextPath}/dist/js/admin_product.js"></script>
    <script>
        function searchList() {
            const f = document.searchForm;
            f.submit();
        }
    </script>
</body>
</html>