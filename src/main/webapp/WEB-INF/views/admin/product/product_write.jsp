<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${mode=='update' ? '상품 수정' : '상품 등록'}</title>
    
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
                
                <div class="page-header">
                    <h3 class="page-title">${mode=='update' ? '상품 정보 수정' : '상품 등록'}</h3>
                </div>
   
                <form id="productForm" method="post" enctype="multipart/form-data" 
                      action="${pageContext.request.contextPath}/admin/product/${mode=='update' ? 'updateSubmit' : 'writeSubmit'}">
                    
                    <input type="hidden" name="mode" value="${mode}">
                    <c:if test="${mode=='update'}">
                        <input type="hidden" name="prodId" value="${dto.prodId}">
                        <input type="hidden" name="page" value="${page}">
                    </c:if>

                    <div class="card-box">
                        <h5 class="section-title"><span class="section-num">01.</span> 카테고리 선택</h5>
                        <select name="cateCode" class="form-select">
                            <option value="">카테고리 선택</option>
                            <c:forEach var="cat" items="${categoryList}">
                                <option value="${cat.cateCode}" ${dto.cateCode == cat.cateCode ? "selected" : ""}>
                                    [${cat.cateParent}] ${cat.cateName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="card-box">
                        <h5 class="section-title"><span class="section-num">02.</span> 상품 기본 정보</h5>
                        <div class="mb-3">
                            <label class="form-label">상품명</label>
                            <input type="text" name="prodName" class="form-control" value="${dto.prodName}">
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">판매가</label>
                                <input type="number" name="base_price" class="form-control" value="${dto.price}">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">진열 상태</label>
                            <div class="pt-2">
                                <label class="me-3">
                                    <input type="radio" name="isDisplayed" value="1" ${mode=='write' || dto.isDisplayed==1 ? "checked":""}> 진열함
                                </label>
                                <label>
                                    <input type="radio" name="isDisplayed" value="0" ${mode=='update' && dto.isDisplayed==0 ? "checked":""}> 숨김
                                </label>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card-box">
                        <h5 class="section-title"><span class="section-num">03.</span> 상품 이미지 등록</h5>
                        <div class="d-flex flex-wrap gap-3">
                            <div class="img-upload-box main-img" id="box0" onclick="openFile('f0')">
                                <span>대표 이미지</span>
                                <input type="file" id="f0" name="thumbnailFile" style="display:none" accept="image/*" onchange="previewImage(this, 'box0')">
					            <c:if test="${mode=='update' && not empty dto.thumbnail}">
					                <img src="${pageContext.request.contextPath}/uploads/product/${dto.thumbnail}" 
					                     class="existing-img"
					                     style="position:absolute; top:0; left:0; width:100%; height:100%; object-fit:cover; z-index:1;">
					            </c:if>
                            </div>
                            
                            <c:forEach var="i" begin="1" end="5">
					            <div class="img-upload-box" id="box${i}" onclick="openFile('f${i}')"
					                 style="position: relative; overflow: hidden;">
					                 
					                <span>추가 ${i}</span>
					                <input type="file" id="f${i}" name="imgs" style="display:none" accept="image/*" onchange="previewImage(this, 'box${i}')">
					                
					                <c:if test="${mode=='update' && not empty dto.listFile && dto.listFile.size() >= i}">
					                    <c:set var="fileName" value="${dto.listFile[i-1].fileName}" /> <img src="${pageContext.request.contextPath}/uploads/product/${fileName}" 
					                         class="existing-img"
					                         style="position:absolute; top:0; left:0; width:100%; height:100%; object-fit:cover; z-index:1;">
					                </c:if>
					            </div>
					        </c:forEach>
                        </div>
                        
                        <div class="mt-2">
					        <small class="text-danger">* 이미지를 수정하려면 박스를 클릭하여 새 파일을 선택하세요.</small>
					    </div>	
                    </div>

                    <div class="card-box">
                        <h5 class="section-title"><span class="section-num">05.</span> 상세 설명</h5>
                        <textarea name="prodDesc" id="prodDesc" style="width:100%; height:400px; display:none;">${dto.description}</textarea>
                    </div>

                    <div class="btn-footer">
                        <button type="button" class="btn btn-dark" onclick="history.back()">취소</button>
                        <button type="button" class="btn btn-orange" onclick="submitProduct()">
                            ${mode=='update' ? '수정 완료' : '등록 완료'}
                        </button>
                    </div>
                </form>
            
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <script src="${pageContext.request.contextPath}/dist/js/admin_product_write.js"></script>
</body>
</html>