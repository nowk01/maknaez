<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>카테고리 관리 | MAKNAEZ Admin</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_category.css?v=7.0">
</head>
<body>
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                <div class="page-header d-flex justify-content-between align-items-center">
                    <div>
                        <h3 class="page-title">카테고리 관리</h3>
                        <p class="page-desc">상품 분류 체계를 관리하는 페이지입니다.</p>
                    </div>
                </div>

                <div class="row g-4">
                    <div class="col-lg-4">
                        <div class="card-box h-100">
                            <div class="card-header-custom">
                                <span>Categories</span>
                                <button type="button" class="btn btn-sm btn-dark" onclick="resetForm()">
                                    <i class="bi bi-plus-lg"></i> 대분류 추가
                                </button>
                            </div>
                            
                            <div class="card-body-custom p-0">
                                <div class="category-tree-container" id="categoryAccordion">
                                    <div class="text-center py-5 text-muted">
                                        <div class="spinner-border text-warning mb-2" role="status"></div>
                                        <p>카테고리 정보를 불러오는 중...</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-8">
                        <div class="card-box h-100">
                            <div class="card-header-custom">
                                <span>상세 설정 (Detail Configuration)</span>
                                <span id="currentPath" class="badge bg-secondary fw-normal">선택된 카테고리 없음</span>
                            </div>
                            <div class="card-body-custom">
                                <form id="categoryForm" name="categoryForm">
								    <input type="hidden" id="mode" name="mode" value="insert">
								    <input type="hidden" id="originParentCode" value=""> 
								
								    <div class="row mb-4">
								        <div class="col-12">
								            <h6 class="form-section-title">기본 정보</h6>
								        </div>
								        
								        <div class="col-md-6 mb-3">
								            <label for="cateCode" class="form-label fw-bold">카테고리 코드 <span class="text-danger">*</span></label>
								            <input type="text" class="form-control" id="cateCode" name="cateCode" placeholder="예: MEN, MEN_TOP" style="font-family: monospace; font-weight: 700;">
								            <div class="form-text text-muted" id="codeHelpText">
								                영문 대문자와 숫자, 언더바(_)만 사용 가능합니다.
								            </div>
								        </div>
								
								        <div class="col-md-6 mb-3">
									        <label for="cateParent" class="form-label">상위 카테고리</label>
									        <select class="form-select" id="cateParent" name="cateParent" onchange="onChangeParent()">
									            <option value="">최상위 (ROOT)</option>
									            </select>
									    </div>
									    
									    <div class="col-md-6 mb-3">
									        <label for="cateCode" class="form-label fw-bold">카테고리 코드 <span class="text-danger">*</span></label>
									        <input type="text" class="form-control" id="cateCode" name="cateCode" 
									               placeholder="예: MEN" style="font-family: monospace; font-weight: 700;">
									        <div class="form-text text-muted" id="codeHelpText">
									            영문 대문자 입력 (상위 카테고리 선택 시 접두어 자동 완성)
									        </div>
									    </div>
								
								        <div class="col-md-12 mb-3">
								            <label for="cateName" class="form-label fw-bold text-dark">카테고리 이름 <span class="text-danger">*</span></label>
								            <input type="text" class="form-control" id="cateName" name="cateName" placeholder="한글 카테고리명 입력 (예: 상의)">
								        </div>
								    </div>
								
								    <div class="row mb-4">
								        <div class="col-12">
								            <h6 class="form-section-title">노출 및 정렬 설정</h6>
								        </div>
								        <div class="col-md-6 mb-3">
								            <label class="form-label">노출 여부</label>
								            <div class="d-flex gap-3 mt-1">
								                <div class="form-check">
								                    <input class="form-check-input" type="radio" name="status" id="displayY" value="1" checked>
								                    <label class="form-check-label" for="status">노출함 (Display)</label>
								                </div>
								                <div class="form-check">
								                    <input class="form-check-input" type="radio" name="status" id="displayN" value="0">
								                    <label class="form-check-label" for="status">숨김 (Hidden)</label>
								                </div>
								            </div>
								        </div>
								        <div class="col-md-6 mb-3">
								            <label for="orderNo" class="form-label">정렬 순서</label>
								            <input type="number" class="form-control" id="orderNo" name="orderNo" value="1" min="1">
								        </div>
								        <input type="hidden" id="depth" name="depth" value="1">
								    </div>
								
								    <div class="btn-group-custom">
								        <button type="button" class="btn btn-custom btn-delete" id="btnDelete" onclick="deleteCategoryFunc()" style="display:none;">
								            <i class="bi bi-trash"></i> 삭제
								        </button>
								        <button type="button" class="btn btn-custom btn-add" id="btnSubAdd" onclick="prepareSubAdd()" style="display:none;">
								            <i class="bi bi-arrow-return-right"></i> 하위 분류 추가
								        </button>
								        <button type="button" class="btn btn-custom btn-save" onclick="submitCategory()">
								            <i class="bi bi-check-lg"></i> 저장하기
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
    
    <script>
        // 클릭 시 우측 상단 배지에 경로 표시를 위한 간단한 헬퍼
        function updatePathBadge(pathText) {
            const badge = document.getElementById('currentPath');
            if(badge) {
                badge.innerText = pathText;
                badge.className = 'badge bg-orange text-white fw-normal'; // bg-orange는 css에 정의 필요 혹은 style로 처리
                badge.style.backgroundColor = '#ff4e00';
            }
        }
        
        // 기존 resetForm 함수를 오버라이딩하거나 보조할 수 있습니다.
        // admin_category.js 로드 후 실행됨
        $(document).ready(function() {
            // 초기화 시 뱃지 리셋
            $('#currentPath').text('신규 대분류 등록 모드');
            $('#currentPath').css('background-color', '#6c757d');
        });
    </script>
</body>
</html>