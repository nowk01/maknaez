<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 목록 관리 | MAKNAEZ</title>
<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/admin_product.css?v=1.0">
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
					<p class="page-desc">Product List & Search Configuration</p>
				</div>
				<div class="search-premium-card">
					<form name="searchForm"
						action="${pageContext.request.contextPath}/admin/product/product_list"
						method="get">
						<div class="search-main-row">
							<div class="search-group-input">
								<span class="search-label">카테고리</span> <select name="category"
									class="form-select premium-select">
									<option value="">전체 카테고리</option>
									<c:forEach var="cat" items="${categoryList}">
										<option value="${cat.cateCode}"
											${category == cat.cateCode ? "selected" : ""}>${cat.cateName}</option>
									</c:forEach>
								</select> <span class="search-label">구분</span> <select name="schType"
									class="form-select premium-select">
									<option value="all" ${schType=="all"?"selected":""}>전체검색</option>
									<option value="name" ${schType=="name"?"selected":""}>상품명</option>
									<option value="code" ${schType=="code"?"selected":""}>상품코드</option>
								</select> <span class="search-label">검색</span> <input type="text"
									name="kwd" value="${kwd}" class="form-control premium-input"
									placeholder="검색어를 입력해 주세요">
							</div>

							<button type="button" class="btn-search-wide"
								onclick="searchList()">SEARCH</button>
						</div>
					</form>
				</div>

				<div class="list-premium-card">
					<div class="list-header-action">
						<button type="button" class="btn-luxury-action btn-delete"
							onclick="deleteSelected()">DELETE</button>
						<button type="button" class="btn-luxury-action btn-register"
							onclick="location.href='${pageContext.request.contextPath}/admin/product/product_write'">PRODUCT
							REGISTRATION</button>
					</div>
					<div class="table-responsive">
						<table class="table table-hover align-middle">
							<thead>
								<tr>
									<th style="width: 5%;"><input type="checkbox"
										id="checkAll"></th>
									<th style="width: 5%;">No</th>
									<th style="width: 10%;">이미지</th>
									<th style="width: 20%;">분류</th>
									<th style="width: 25%;">상품명</th>
									<th style="width: 15%;">판매가</th>
									<th style="width: 10%;">상태</th>
									<th style="width: 10%;">관리</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="dto" items="${list}">
									<tr>
										<td><input type="checkbox" name="prodIds"
											value="${dto.prodId}"></td>
										<td>${dto.prodId}</td>
										<td><img
											src="${pageContext.request.contextPath}/uploads/product/${dto.thumbnail}"
											width="60" height="60"
											style="object-fit: cover; border: 1px solid #f0f0f0; border-radius: 0;">
										</td>
										<td class="text-start"><span
											class="badge bg-secondary-flat">${dto.cateParent}</span> <i
											class="bi bi-chevron-right mx-1"
											style="font-size: 10px; color: #ddd;"></i> <span
											class="cate-sub-text">${dto.cateName}</span></td>
										<td class="text-start fw-bold">${dto.prodName}</td>
										<td class="price-text"><fmt:formatNumber
												value="${dto.price}" pattern="#,###" />원</td>
										<td><span
											class="badge-status ${dto.isDisplayed == 1 ? 'status-active' : 'status-hidden'}">
												${dto.isDisplayed == 1 ? '진열중' : '숨김'} </span></td>
										<td>
											<button type="button" class="btn-edit-sm"
												onclick="location.href='${pageContext.request.contextPath}/admin/product/update?prodId=${dto.prodId}&page=${page}'">Changes</button>
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

					<div class="pagination">${paging}</div>

				</div>
			</div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
	<script
		src="${pageContext.request.contextPath}/dist/js/admin_product.js"></script>
	<script>
		function searchList() {
			const f = document.searchForm;
			f.submit();
		}
	</script>
</body>
</html>