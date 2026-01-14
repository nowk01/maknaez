<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Management | MAKNAEZ</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_category.css?v=6.0">
</head>
<body>
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                <div class="page-header mb-4">
                    <h3 class="page-title">카테고리 관리</h3>
                    								<!-- OR 상품 카테고리 체계를 관리합니다. -->
                    <p class="page-desc text-muted">Shoes Category Hierarchy Management</p>
                </div>

                <div class="row g-4">
                    <div class="col-lg-5">
                        <div class="card shadow-sm h-100">
                            <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Categories</h5>
                                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="resetForm()">Root Add</button>
                            </div>
                            <div class="card-body scrollable-tree">
                                <div class="accordion" id="categoryAccordion">
                                    </div>
                            </div>
                        </div>
                    </div> 

                    <div class="col-lg-7">
                        <div class="card shadow-sm h-100">
                            <div class="card-header bg-white">
                                <h5 class="mb-0">Detail Information</h5>
                            </div>
                            <div class="card-body">
                                <form id="categoryForm" name="categoryForm">
                                    <input type="hidden" id="mode" name="mode" value="insert">
                                    
                                    <div class="mb-3">
                                        <label class="form-label text-muted">Category Code</label>
                                        <input type="text" class="form-control" id="cateCode" name="cateCode" readonly placeholder="자동 생성됩니다.">
                                    </div>
                                    
                                    <input type="hidden" id="cateParent" name="cateParent">
                                    <div class="mb-3">
                                        <label class="form-label text-muted">Parent Category</label>
                                        <input type="text" class="form-control" id="parentName" readonly placeholder="Root (대분류)">
                                    </div>
                                    
                                    <input type="hidden" id="depth" name="depth" value="1">

                                    <div class="mb-3">
                                        <label class="form-label fw-bold">카테고리명 (Name)</label>
                                        <input type="text" class="form-control" id="cateName" name="cateName" placeholder="카테고리 이름을 입력하세요">
                                    </div>

                                    <div class="row mb-4">
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">노출 여부 (Status)</label>
                                            <div class="d-flex gap-3 mt-1">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="status" id="displayY" value="1" checked>
                                                    <label class="form-check-label" for="displayY">Show (1)</label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="status" id="displayN" value="0">
                                                    <label class="form-check-label" for="displayN">Hidden (0)</label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">정렬 순서 (Order)</label>
                                            <input type="number" class="form-control" id="orderNo" name="orderNo" value="1">
                                        </div>
                                    </div>

                                    <div class="d-flex justify-content-end gap-2">
                                        <button type="button" class="btn btn-danger" id="btnDelete" onclick="deleteCategoryFunc()" style="display:none;">DELETE</button>
                                        <button type="button" class="btn btn-secondary" id="btnSubAdd" onclick="prepareSubAdd()" style="display:none;">SUB ADD</button>
                                        <button type="button" class="btn btn-primary" onclick="submitCategory()">SAVE CHANGES</button>
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