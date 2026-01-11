<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>STOCK MANAGEMENT | MAKNAEZ</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_stock.css?v=1.0">
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
                    <form class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label">카테고리</label>
                            <select class="form-select">
                                <option>전체 카테고리</option>
                                <option>SNEAKERS</option>
                                <option>BOOTS</option>
                            </select>
                        </div>
                        <div class="col-md-7">
                            <label class="form-label">상품명 검색</label>
                            <input type="text" class="form-control" placeholder="상품명 또는 모델 코드를 입력하세요">
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button type="button" class="btn btn-luxury btn-dark w-100" style="height:52px;">SEARCH</button>
                        </div>
                    </form>
                </div>

                <div class="card-box">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 style="font-size:13px; font-weight:800; color:#bbb; letter-spacing:0.1em;">INVENTORY LIST</h5>
                        <div style="font-size:12px; color:#ff4e00; font-weight:700;">* 재고 5개 미만 품목 자동 강조</div>
                    </div>

                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th style="width:25%;">상품명 (Product)</th>
                                    <th style="width:15%;">색상 (Color)</th>
                                    <th style="width:15%;">사이즈 (Size)</th>
                                    <th style="width:20%;">현재 재고 (Stock)</th>
                                    <th style="width:15%;">상태 (Status)</th>
                                    <th style="width:10%;">수정</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td style="text-align:left; font-weight:800;">Court Classic Low-V1</td>
                                    <td style="color:#666;">Triple White</td>
                                    <td>265 mm</td>
                                    <td><input type="number" class="form-control input-stock-edit" value="45"></td>
                                    <td><span class="badge-status bg-onsale">정상판매</span></td>
                                    <td><button class="btn btn-sm text-dark"><i class="fas fa-save"></i></button></td>
                                </tr>
                                <tr>
                                    <td style="text-align:left; font-weight:800;">Retro High 2026</td>
                                    <td style="color:#666;">Midnight Black</td>
                                    <td>240 mm</td>
                                    <td><input type="number" class="form-control input-stock-edit text-danger-custom" value="3"></td>
                                    <td><span class="badge-status" style="background:#fff4f0; color:#ff4e00; border:1px solid #ff4e00;">품절임박</span></td>
                                    <td><button class="btn btn-sm text-dark"><i class="fas fa-save"></i></button></td>
                                </tr>
                                <tr>
                                    <td style="text-align:left; font-weight:800;">Walker Boots Brown</td>
                                    <td style="color:#666;">Dark Tan</td>
                                    <td>280 mm</td>
                                    <td><input type="number" class="form-control input-stock-edit" value="0"></td>
                                    <td><span class="badge-status bg-soldout">일시품절</span></td>
                                    <td><button class="btn btn-sm text-dark"><i class="fas fa-save"></i></button></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="btn-group-custom">
                        <button type="button" class="btn btn-luxury btn-dark" onclick="downloadStockExcel()">EXCEL DOWNLOAD</button>
                        <button type="button" class="btn btn-luxury btn-orange" onclick="updateAllStock()">SAVE CHANGES</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <script src="${pageContext.request.contextPath}/dist/js/admin_stock.js"></script>
</body>
</html>