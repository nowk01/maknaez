<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<jsp:useBean id="now" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 등록</title>
    
    <script>
        const contextPath = "${pageContext.request.contextPath}";
    </script>
    
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_product_write.css?v=6.2">
    
    <script type="text/javascript" src="${pageContext.request.contextPath}/dist/vendor/se2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
</head>
<body>
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />
            <div class="content-container">
   
            <form id="productForm" action="${pageContext.request.contextPath}/admin/product/write_ok" method="post" enctype="multipart/form-data">
                
                <div class="card-box">
                    <h5 class="section-title"><span class="section-num">01.</span> 카테고리 선택</h5>
                    <select class="form-select" name="cateCode" required>
                        <option value="">:: 카테고리를 선택하세요 ::</option>
                        <c:forEach var="vo" items="${categoryList}">
                            <option value="${vo.cateCode}">${vo.cateName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="card-box">
                    <h5 class="section-title"><span class="section-num">02.</span> 기본 정보</h5>
                    <div class="row">
                        <div class="col-8">
                            <label class="form-label">상품명</label>
                            <input type="text" name="prodName" class="form-control" placeholder="상품명 입력">
                        </div>
                        <div class="col-4">
                            <label class="form-label">가격</label>
                            <input type="number" name="price" class="form-control" value="0">
                        </div>
                    </div>
                    <div class="mt-3">
                        <label class="form-label">색상</label>
                        <select name="colorCode" id="colorInput" class="form-select">
                            <option value="BK">BK (Black)</option>
                            <option value="WH">WH (White)</option>
                            <option value="GY">GY (Grey)</option>
                            <option value="NV">NV (Navy)</option>
                        </select>
                    </div>
                </div>

                <div class="card-box">
                    <div class="d-flex justify-content-between mb-3">
                        <h5 class="section-title mb-0"><span class="section-num">03.</span> 옵션 설정</h5>
                        <button type="button" class="btn btn-dark btn-sm" onclick="generateOptions()">+ 사이즈 생성</button>
                    </div>
                    <table class="table option-table">
                        <thead><tr><th>색상</th><th>사이즈</th><th>재고</th></tr></thead>
                        <tbody id="optionTbody"></tbody>
                    </table>
                </div>

                <div class="card-box">
                    <h5 class="section-title"><span class="section-num">04.</span> 이미지</h5>
                    <div class="img-grid">
                        <div class="img-upload-box main" id="box0" onclick="openFile('f0')">
                            <span>대표 이미지</span>
                            <input type="file" id="f0" name="thumbnailFile" style="display:none" accept="image/*" onchange="previewImage(this, 'box0')">
                        </div>
                        
                        <c:forEach var="i" begin="1" end="5">
                            <div class="img-upload-box" id="box${i}" onclick="openFile('f${i}')">
                                <span>추가 ${i}</span>
                                <input type="file" id="f${i}" name="imgs" style="display:none" accept="image/*" onchange="previewImage(this, 'box${i}')">
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div class="card-box">
                    <h5 class="section-title"><span class="section-num">05.</span> 상세 설명</h5>
                    <textarea name="description" id="prodDesc" style="width:100%; height:400px; display:none;"></textarea>
                </div>

                <div class="btn-footer">
                    <button type="button" class="btn btn-dark" onclick="history.back()">취소</button>
                    <button type="button" class="btn btn-orange" onclick="submitProduct()">저장</button>
                </div>
            </form>
            
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    
    <script src="${pageContext.request.contextPath}/dist/js/admin_product_write.js"></script>
</body>
</html>