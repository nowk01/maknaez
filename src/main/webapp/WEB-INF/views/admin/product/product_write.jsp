<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<jsp:useBean id="now" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 등록 | MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_product_write.css?v=6.2">
</head>
<body>
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                <div class="page-header">
                    <h3 class="page-title">신규 상품 등록</h3>
                    <p style="color:#888; font-size:14px; margin-top:5px;">등록 일자: <fmt:formatDate value="${now}" pattern="yyyy-MM-dd" /></p>
                </div>

                <form id="productForm" action="product_write_ok" method="post" enctype="multipart/form-data">
                    
                    <div class="card-box">
                        <h5 class="section-title"><span class="section-num">01.</span> 상품 기본 정보 (Basic)</h5>
                        <div class="row g-5">
                            <div class="col-md-4">
                                <label class="form-label">카테고리 분류</label>
                                <select class="form-select" name="cateNo">
                                    <option value="1">SNEAKERS</option><option value="2">BOOTS</option>
                                </select>
                            </div>
                            <div class="col-md-8">
                                <label class="form-label">상품명 (Product Name) *</label>
                                <input type="text" class="form-control" name="pName" placeholder="공식 모델명 입력">
                            </div>
                            <div class="col-md-12">
                                <label class="form-label">상품 설명 (Description)</label>
                                <textarea class="form-control desc-area" name="content" placeholder="상품의 특징, 소재, 착화감 등을 자유롭게 적어주세요."></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="card-box">
                        <h5 class="section-title"><span class="section-num">02.</span> 옵션 및 재고 관리 (Stock)</h5>
                        <div class="row g-3 align-items-end mb-4">
                            <div class="col-md-5">
                                <label class="form-label">색상 입력 (Color)</label>
                                <input type="text" id="colorInput" class="form-control" placeholder="예: Triple White">
                            </div>
                            <div class="col-md-3">
                                <button type="button" class="btn btn-luxury btn-dark w-100" style="height:52px;" onclick="generateOptions()">+ 사이즈 생성</button>
                            </div>
                        </div>
                        <div class="table-responsive">
                            <table class="option-table">
                                <thead>
                                    <tr><th style="width:25%;">COLOR</th><th style="width:20%;">SIZE</th><th style="width:25%;">STOCK</th><th style="width:25%;">EXTRA</th><th style="width:5%;"></th></tr>
                                </thead>
                                <tbody id="optionTbody"></tbody>
                            </table>
                        </div>
                    </div>

                    <div class="card-box">
                        <h5 class="section-title"><span class="section-num">03.</span> 이미지 등록 (Assets)</h5>
                        <div class="img-grid">
                            <div class="img-upload-box main" onclick="openFile('f0')">
                                <i class="fas fa-star"></i><span>메인 썸네일</span>
                                <input type="file" id="f0" name="thumb" style="display:none">
                            </div>
                            <c:forEach var="i" begin="1" end="5">
                                <div class="img-upload-box" onclick="openFile('f${i}')">
                                    <i class="fas fa-plus"></i><span>추가 이미지 ${i}</span>
                                    <input type="file" id="f${i}" name="imgs" style="display:none">
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="card-box">
                        <h5 class="section-title"><span class="section-num">04.</span> 상세 페이지 (Detail)</h5>
                        <div class="img-upload-box" style="width:100%; height:150px;" onclick="openFile('fd')">
                            <i class="fas fa-file-alt"></i><span>상세 페이지 통이미지 업로드</span>
                            <input type="file" id="fd" name="detail" style="display:none">
                        </div>
                    </div>

                    <div class="btn-footer">
                        <button type="button" class="btn btn-luxury btn-dark" onclick="history.back()">CANCEL</button>
                        <button type="submit" class="btn btn-luxury btn-orange">SAVE PRODUCT</button>
                    </div>

                </form>
            </div>
        </div>
    </div>
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <script src="${pageContext.request.contextPath}/dist/js/admin_product_write.js"></script>
</body>
</html>