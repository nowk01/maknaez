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
                    <form class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label">Category</label>
                            <select class="form-select">
                                <option value="">전체 보기</option>
                                <option>SNEAKERS</option>
                                <option>BOOTS</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Search Keyword</label>
                            <input type="text" class="form-control" placeholder="상품명 또는 상품코드 입력">
                        </div>
                        <div class="col-md-3 d-flex align-items-end">
                            <button type="button" class="btn btn-luxury btn-dark-sub w-100">SEARCH</button>
                        </div>
                    </form>
                </div>

                <div class="card-box">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 style="font-size: 12px; font-weight: 800; color: #ccc; letter-spacing: 0.1em;">PRODUCT LIST</h5>
                        <button class="btn btn-luxury btn-orange-main" style="width:140px; height:40px;" onclick="location.href='product_write'">+ NEW PRODUCT</button>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th style="width: 40px;"><input type="checkbox" id="checkAll"></th>
                                    <th>Image</th>
                                    <th>Product Name</th>
                                    <th>Category</th>
                                    <th>Price</th>
                                    <th>Stock</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><input type="checkbox"></td>
                                    <td><div class="prod-thumb"></div></td>
                                    <td style="font-weight: 700; color: #000;">Classic Walker Boots</td>
                                    <td>BOOTS</td>
                                    <td>₩189,000</td>
                                    <td>42</td>
                                    <td><span class="badge-sale">ON SALE</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="btn-group-custom">
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