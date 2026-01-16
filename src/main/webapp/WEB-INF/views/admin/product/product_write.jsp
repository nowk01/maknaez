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
                        
                        <div class="mb-3">
                            <label class="form-label">성별(구분)</label>
                            <div class="pt-2">
                                <label class="me-3"><input type="radio" name="gender" value="M" checked> 남성(M)</label>
                                <label class="me-3"><input type="radio" name="gender" value="F"> 여성(W)</label>
                                <label><input type="radio" name="gender" value="U"> 공용(U)</label>
                            </div>
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
                        
                        <div class="img-grid">
                            <div class="img-upload-box main-img" id="box0" onclick="openFile('f0')">
                                <span>대표 이미지</span>
                                <input type="file" id="f0" name="thumbnailFile" style="display:none" accept="image/*" onchange="previewImage(this, 'box0')">
                                
                                <c:if test="${mode=='update' && not empty dto.thumbnail}">
                                    <img src="${pageContext.request.contextPath}/uploads/product/${dto.thumbnail}" class="existing-img">
                                </c:if>
                            </div>
                            
                            <c:forEach var="i" begin="1" end="5">
                                <div class="img-upload-box" id="box${i}" onclick="openFile('f${i}')">
                                    <span>추가 ${i}</span>
                                    <input type="file" id="f${i}" name="imgs" style="display:none" accept="image/*" onchange="previewImage(this, 'box${i}')">
                                    
                                    <c:if test="${mode=='update' && not empty dto.listFile && dto.listFile.size() >= i}">
                                        <c:set var="fileName" value="${dto.listFile[i-1].fileName}" />
                                        <img src="${pageContext.request.contextPath}/uploads/product/${fileName}" class="existing-img">
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                        
                        <div class="mt-2">
                            <small class="text-danger" style="font-size: 12px;">* 이미지를 클릭하면 수정(재업로드)할 수 있습니다.</small>
                        </div>  
                    </div>

                    <div class="card-box">
                        <h5 class="section-title"><span class="section-num">04.</span> 옵션 및 재고 관리</h5>
                        
                        <div class="mb-3">
                            <label class="form-label">색상 코드 (예: BK, WH, RED)</label>
                            <div class="d-flex gap-2 align-items-center">
                                <input type="text" id="colorInput" name="colorCode" class="form-control" 
                                       style="width: 200px;" value="${dto.colorCode}" placeholder="색상코드 입력">
                                
                                <button type="button" class="btn btn-dark" onclick="generateOptions()">
                                    사이즈 옵션 생성
                                </button>
                            </div>
                            <div class="form-text text-muted mt-1">
                                * 색상 코드를 입력하고 생성 버튼을 누르면 225~300mm 사이즈가 자동 생성됩니다.
                            </div>
                        </div>

                        <table class="table table-bordered text-center mt-3">
                            <thead class="table-light">
                                <tr>
                                    <th width="20%">색상</th>
                                    <th width="30%">사이즈</th>
                                    <th width="30%">재고수량</th>
                                    <th width="20%">관리</th>
                                </tr>
                            </thead>
                            <tbody id="optionTbody">
                                <c:if test="${mode=='update' && not empty dto.sizes}">
                                    <c:forEach var="i" begin="0" end="${dto.sizes.size()-1}">
                                        <tr>
                                            <td style="font-weight:800; vertical-align:middle;">${dto.colorCode}</td>
                                            <td style="font-weight:700; color:#666; vertical-align:middle;">
                                                ${dto.sizes[i]} mm
                                                <input type="hidden" name="sizes" value="${dto.sizes[i]}">
                                                <input type="hidden" name="pdSize" value="${dto.sizes[i]}">
                                            </td>
                                            <td style="vertical-align:middle;">
                                                <input type="number" class="form-control input-stock" name="stocks" 
                                                       value="${dto.stocks[i]}" min="0" style="width:100px; margin:0 auto;">
                                            </td>
                                            <td style="vertical-align:middle;">
                                                <button type="button" style="border:none; background:none; font-weight:bold; cursor:pointer;" 
                                                        onclick="removeOptionRow(this)">X</button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:if>
                            </tbody>
                        </table>
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