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
                <div class="page-header">
                    <h3 class="page-title">카테고리 관리</h3>
                    <p class="page-desc">Shoes Category Hierarchy Management</p>
                </div>

                <div class="row g-5">
                    <div class="col-lg-4">
                        <div class="card-box" style="min-height: 650px;">
                            <div class="d-flex justify-content-between align-items-center mb-5">
                                <h5 style="font-size: 12px; font-weight: 800; color: #ccc; letter-spacing: 0.1em;">STRUCTURE</h5>
                                <button class="btn btn-new-root" onclick="resetForm()">NEW ROOT</button>
                            </div>
                            
                            <ul class="category-tree">
                                <li>
                                    <div class="tree-item active" onclick="selectCategory(1, 'SNEAKERS', 'ROOT', 'Y')">
                                        <i class="fas fa-chevron-right tree-arrow"></i> SNEAKERS
                                    </div>
                                    <ul>
                                        <li><div class="tree-item" onclick="selectCategory(11, 'Running', 'SNEAKERS', 'Y')">Running</div></li>
                                        <li><div class="tree-item" onclick="selectCategory(12, 'Lifestyle', 'SNEAKERS', 'Y')">Lifestyle</div></li>
                                    </ul>
                                </li>
                                <li>
                                    <div class="tree-item" onclick="selectCategory(2, 'BOOTS', 'ROOT', 'Y')">
                                        <i class="fas fa-chevron-right tree-arrow"></i> BOOTS
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>

                    <div class="col-lg-8">
                        <div class="card-box" style="min-height: 650px;">
                            <div class="mb-5 pb-2" style="border-bottom: 1px solid #f8f8f8;">
                                <h5 style="font-size: 12px; font-weight: 800; color: #ccc; letter-spacing: 0.1em;">CONFIGURATION</h5>
                            </div>
                            
                            <form action="" method="post">
                                <div class="row g-4">
                                    <div class="col-md-6">
                                        <label class="form-label">Category ID</label>
                                        <input type="text" class="form-control" id="cateNo" readonly placeholder="Auto">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">상위 카테고리 (Parent)</label>
                                        <select class="form-select" id="parentCate">
                                            <option value="0">None (최상위)</option>
                                            <option value="1">SNEAKERS</option>
                                            <option value="2">BOOTS</option>
                                        </select>
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label">카테고리 명칭 (Name) *</label>
                                        <input type="text" class="form-control" id="cateName" placeholder="Enter name">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">노출 여부 (Status)</label>
                                        <div class="d-flex gap-5 mt-3">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="displayYn" id="displayY" checked>
                                                <label class="form-check-label" for="displayY">Visible</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="displayYn" id="displayN">
                                                <label class="form-check-label" for="displayN">Hidden</label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">정렬 순서 (Order)</label>
                                        <input type="number" class="form-control" id="sortOrder" value="1">
                                    </div>
                                </div>

                                <div class="btn-group-custom">
                                    <button type="button" class="btn btn-luxury btn-delete-sub">DELETE</button>
                                    <button type="button" class="btn btn-luxury btn-dark-sub" onclick="setParent()">SUB ADD</button>
                                    <button type="submit" class="btn btn-luxury btn-orange-main">SAVE CHANGES</button>
                                </div>
                            </form>
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