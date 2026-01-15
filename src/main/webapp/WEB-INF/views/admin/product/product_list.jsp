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
        // JS 파일에서 사용할 Context Path 전역 변수 설정
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
                    <p class="page-desc">Product List & Inventory Configuration</p>
                </div>

                <div class="card-box mb-4">
                    <div class="mb-4 pb-2" style="border-bottom: 1px solid #f8f8f8;">
                        <h5 style="font-size: 12px; font-weight: 800; color: #ccc; letter-spacing: 0.1em;">SEARCH FILTER</h5>
                    </div>
                    
                    <form class="row g-3" name="searchForm" action="${pageContext.request.contextPath}/admin/product/product_list" method="get">
                        <div class="col-md-3">
                            <label class="form-label">Category</label>
                            <select name="category" class="form-select">
                                <option value="">ALL CATEGORIES</option>
                                <c:forEach var="parent" items="${parentCats}">
                                    <option value="${parent.cateCode}" ${param.category == parent.cateCode ? "selected" : ""}>
                                        ${parent.cateName}
                                    </option>
                                    
                                    <c:if test="${not empty childCatsMap[parent.cateCode]}">
                                        <c:forEach var="child" items="${childCatsMap[parent.cateCode]}">
                                            <option value="${child.cateCode}" ${param.category == child.cateCode ? "selected" : ""}>
                                                &nbsp;&nbsp;└ ${child.cateName}
                                            </option>
                                        </c:forEach>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label">Search Keyword</label>
                            <input type="hidden" name="searchKey" value="prodName">
                            <input type="text" name="searchValue" class="form-control" placeholder="상품명을 입력하세요" value="${searchValue}">
                        </div>
                        
                        <div class="col-md-3 d-flex align-items-end">
                            <button type="submit" class="btn btn-luxury btn-dark-sub w-100">SEARCH</button>
                        </div>
                    </form>
                </div>

                <div class="card-box">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 style="font-size: 12px; font-weight: 800; color: #ccc; letter-spacing: 0.1em;">PRODUCT LIST</h5>
                        <button class="btn btn-luxury btn-orange-main" style="width:140px; height:40px;" onclick="location.href='${pageContext.request.contextPath}/admin/product/product_write'">+ NEW PRODUCT</button>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th style="width: 40px;"><input type="checkbox" id="checkAll"></th>
                                    <th style="width: 80px;">Image</th>
                                    <th>Product Name</th>
                                    <th>Category</th>
                                    <th>Price</th>
                                    <th>Display</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="dto" items="${list}">
                                    <tr>
                                        <td><input type="checkbox" name="prodIds" value="${dto.prodId}"></td>
                                        <td>
                                            <div class="prod-thumb">
                                                <c:if test="${not empty dto.thumbnail}">
                                                    <img src="${pageContext.request.contextPath}/uploads/product/${dto.thumbnail}" 
                                                         style="width:50px; height:50px; object-fit:cover; border-radius:4px;">
                                                </c:if>
                                                <c:if test="${empty dto.thumbnail}">
                                                    <span style="display:inline-block; width:50px; height:50px; background:#eee; border-radius:4px;"></span>
                                                </c:if>
                                            </div>
                                        </td>
                                        <td style="font-weight: 700; color: #333;">${dto.prodName}</td>
                                        <td style="color: #666;">${dto.cateName}</td>
                                        <td><fmt:formatNumber value="${dto.price}" type="currency" currencySymbol="₩"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${dto.isDisplayed == 1}">
                                                    <span class="badge bg-success" style="font-weight:400;">진열중</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary" style="font-weight:400;">숨김</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                                
                                <c:if test="${dataCount == 0}">
                                    <tr>
                                        <td colspan="6" class="text-center p-5">등록된 상품이 없습니다.</td>
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
                        <button type="button" class="btn btn-luxury btn-dark-sub" onclick="excelDownload()">EXCEL DOWNLOAD</button>
                        <button type="button" class="btn btn-luxury btn-orange-main" onclick="updateProductStatus()">SAVE CHANGES</button>
                    </div>
                </div> 
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <script src="${pageContext.request.contextPath}/dist/js/admin_product.js"></script>
</body>
</html>