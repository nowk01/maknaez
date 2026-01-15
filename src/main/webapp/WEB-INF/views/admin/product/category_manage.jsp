<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카테고리 관리 | MAKNAEZ Admin</title>
<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/admin_category.css?v=9.5">
</head>
<body>
	<div id="wrapper">
		<jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

		<div id="page-content-wrapper">
			<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

			<div class="content-container">
				
				<div class="page-header">
					<div>
						<h3 class="page-title">카테고리 관리</h3>
						<p class="page-desc">System Configuration / Product Classification</p>
					</div>
				</div>

				<div class="row g-4">
					<div class="col-lg-4">
						<div class="card-box">
							<div class="card-box-header">
								<span>DIRECTORY</span>
								<button type="button" class="btn-header-sm" onclick="resetForm()">+ ADD ROOT</button>
							</div>

							<div class="category-tree-container" id="categoryAccordion">
								<div class="text-center py-5 text-muted">
									<div class="spinner-border spinner-border-sm text-dark mb-2" role="status"></div>
									<p>LOADING DATA...</p>
								</div>
							</div>
						</div>
					</div>

					<div class="col-lg-8">
						<div class="card-box">
							<div class="card-box-header">
								<span>CONTROL PANEL</span> 
								<span id="currentPath" class="badge bg-dark rounded-0">ROOT MODE</span>
							</div>
							
							<div>
								<form id="categoryForm" name="categoryForm">
									<input type="hidden" id="mode" name="mode" value="insert">
									<input type="hidden" id="originCateCode" name="originCateCode" value=""> 
									<input type="hidden" id="depth" name="depth" value="1">

									<div class="row mb-4">
										<div class="col-12">
											<span class="form-section-title">01. Basic Information</span>
										</div>

										<div class="col-md-12 mb-4">
											<label for="cateParent" class="form-label">Parent Category</label> 
											<select class="form-select" id="cateParent" name="cateParent" onchange="onChangeParent()">
												<option value="">ROOT (최상위)</option>
											</select>
										</div>

										<div class="col-md-6 mb-4">
											<label for="cateCode" class="form-label">Category Code <span class="text-danger">*</span></label> 
											<input type="text" class="form-control" id="cateCode" name="cateCode" 
												   placeholder="EX: MEN_TOP" style="font-family: monospace; font-weight: 700;">
											<div class="form-text" id="codeHelpText"> 영문 대문자, 숫자, 언더바(_)만 사용 가능</div>
										</div>

										<div class="col-md-6 mb-4">
											<label for="cateName" class="form-label">Category Name <span class="text-danger">*</span></label> 
											<input type="text" class="form-control" id="cateName" name="cateName" placeholder="카테고리명 입력">
										</div>
									</div>

									<div class="row mb-2">
										<div class="col-12">
											<span class="form-section-title">02. Display & Sort</span>
										</div>
										<div class="col-md-6 mb-3">
											<label class="form-label">Visibility Status</label>
											<div class="d-flex align-items-center mt-2">
												<div class="form-check me-4">
													<input class="form-check-input" type="radio" name="status" id="displayY" value="1" checked> 
													<label class="form-check-label fw-bold" for="displayY">SHOW</label>
												</div>
												<div class="form-check">
													<input class="form-check-input" type="radio" name="status" id="displayN" value="0"> 
													<label class="form-check-label fw-bold" for="displayN">HIDE</label>
												</div>
											</div>
										</div>
										<div class="col-md-6 mb-3">
											<label for="orderNo" class="form-label">Sort Order</label> 
											<input type="number" class="form-control" id="orderNo" name="orderNo" value="1" min="1">
										</div>
									</div>

									<div class="btn-group-bottom">
										<button type="button" class="btn-sub-action" id="btnDelete" onclick="deleteCategoryFunc()" style="display: none;">
											DELETE
										</button>
										<button type="button" class="btn-sub-action" id="btnSubAdd" onclick="prepareSubAdd()" style="display: none;">
											+ SUB CATEGORY
										</button>
										<button type="button" class="btn-save-main" onclick="submitCategory()">
											SAVE CHANGES
										</button>
									</div>
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
	<script src="${pageContext.request.contextPath}/dist/js/admin_category.js"></script>
</body>
</html>