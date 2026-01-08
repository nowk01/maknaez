<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>카테고리 관리 - MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    
    <style>
        /* [공통 레이아웃 스타일] */
        body { background-color: #f4f6f9; }
        
        .card-box {
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
            padding: 20px;
            margin-bottom: 20px;
            border: none;
            height: 100%; /* 높이 꽉 채우기 */
        }

        /* [왼쪽: 카테고리 트리 스타일] */
        .category-tree {
            list-style: none;
            padding-left: 0;
        }
        .category-tree ul {
            list-style: none;
            padding-left: 20px; /* 들여쓰기 */
            margin-top: 5px;
        }
        .tree-item {
            padding: 8px 12px;
            cursor: pointer;
            border-radius: 4px;
            transition: background-color 0.2s;
            display: flex;
            align-items: center;
            font-size: 14px;
            color: #333;
        }
        .tree-item:hover {
            background-color: #f1f3f5;
        }
        .tree-item.active {
            background-color: #e7f5ff;
            color: #1971c2;
            font-weight: 600;
        }
        .tree-icon {
            margin-right: 8px;
            color: #adb5bd;
        }
        .tree-item.active .tree-icon {
            color: #1971c2;
        }

        /* [오른쪽: 폼 스타일] */
        .form-label {
            font-weight: 600;
            font-size: 13px;
            color: #555;
            margin-bottom: 5px;
        }
        .form-control, .form-select {
            font-size: 14px;
        }
        .btn-save {
            background-color: #0d6efd;
            color: white;
        }
        .btn-delete {
            background-color: #dc3545;
            color: white;
        }
        .btn-add-sub {
            background-color: #198754;
            color: white;
        }
    </style>
</head>
<body>

    <div id="wrapper">
        
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

        <div id="page-content-wrapper">
            
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                
                <h3 class="fw-bold mb-4">카테고리 관리</h3>

                <div class="row g-4">
                    
                    <div class="col-lg-4">
                        <div class="card-box" style="min-height: 500px;">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="fw-bold m-0">카테고리 목록</h5>
                                <button class="btn btn-sm btn-outline-secondary" onclick="resetForm()">+ 최상위 추가</button>
                            </div>
                            
                            <hr class="text-secondary opacity-25">

                            <ul class="category-tree">
                                
                                <li>
                                    <div class="tree-item" onclick="selectCategory(1, 'OUTER', 'TOP', 'Y')">
                                        <i class="fas fa-folder tree-icon"></i> OUTER
                                    </div>
                                    <ul>
                                        <li>
                                            <div class="tree-item" onclick="selectCategory(11, 'Jacket', 'OUTER', 'Y')">
                                                <i class="fas fa-angle-right tree-icon"></i> Jacket
                                            </div>
                                        </li>
                                        <li>
                                            <div class="tree-item" onclick="selectCategory(12, 'Coat', 'OUTER', 'Y')">
                                                <i class="fas fa-angle-right tree-icon"></i> Coat
                                            </div>
                                        </li>
                                    </ul>
                                </li>

                                <li>
                                    <div class="tree-item" onclick="selectCategory(2, 'TOP', 'TOP', 'Y')">
                                        <i class="fas fa-folder tree-icon"></i> TOP
                                    </div>
                                    <ul>
                                        <li>
                                            <div class="tree-item" onclick="selectCategory(21, 'T-Shirt', 'TOP', 'Y')">
                                                <i class="fas fa-angle-right tree-icon"></i> T-Shirt
                                            </div>
                                        </li>
                                        <li>
                                            <div class="tree-item" onclick="selectCategory(22, 'Shirt', 'TOP', 'N')">
                                                <i class="fas fa-angle-right tree-icon"></i> Shirt
                                            </div>
                                        </li>
                                    </ul>
                                </li>
                                
                                <li>
                                    <div class="tree-item" onclick="selectCategory(3, 'BOTTOM', 'TOP', 'Y')">
                                        <i class="fas fa-folder tree-icon"></i> BOTTOM
                                    </div>
                                </li>
                            </ul>
                            </div>
                    </div>

                    <div class="col-lg-8">
                        <div class="card-box" style="min-height: 500px;">
                            <h5 class="fw-bold mb-3 border-bottom pb-3">카테고리 상세 정보</h5>
                            
                            <form action="" method="post">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label">카테고리 번호</label>
                                        <input type="text" class="form-control" id="cateNo" placeholder="자동 생성" readonly>
                                    </div>
                                    
                                    <div class="col-md-6">
                                        <label class="form-label">상위 카테고리</label>
                                        <select class="form-select" id="parentCate">
                                            <option value="0">없음 (최상위 카테고리)</option>
                                            <option value="1">OUTER</option>
                                            <option value="2">TOP</option>
                                            <option value="3">BOTTOM</option>
                                        </select>
                                    </div>

                                    <div class="col-12">
                                        <label class="form-label">카테고리명 <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="cateName" placeholder="예: 자켓, 티셔츠">
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label">노출 여부</label>
                                        <div class="d-flex gap-3 mt-1">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="displayYn" id="displayY" value="Y" checked>
                                                <label class="form-check-label" for="displayY">노출함</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="displayYn" id="displayN" value="N">
                                                <label class="form-check-label" for="displayN">숨김</label>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label">순서 (Sort Order)</label>
                                        <input type="number" class="form-control" id="sortOrder" value="1">
                                    </div>
                                </div>

                                <hr class="my-4">

                                <div class="d-flex justify-content-end gap-2">
                                    <button type="button" class="btn btn-danger btn-delete">삭제</button>
                                    <button type="button" class="btn btn-add-sub" onclick="setParent()">+ 하위 카테고리 추가</button>
                                    <button type="submit" class="btn btn-save">저장</button>
                                </div>
                            </form>

                        </div>
                    </div>
                </div> </div> </div> </div> <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />

    <script>
        // 카테고리 클릭 시 우측 폼에 데이터 채우기 (시각적 예시)
        function selectCategory(no, name, parentCode, display) {
            // 1. 활성화 표시 (CSS)
            document.querySelectorAll('.tree-item').forEach(el => el.classList.remove('active'));
            event.currentTarget.classList.add('active');

            // 2. 우측 폼 데이터 바인딩
            document.getElementById('cateNo').value = no;
            document.getElementById('cateName').value = name;
            
            // 상위 카테고리 선택 로직 (예시)
            const parentSelect = document.getElementById('parentCate');
            // 예제 단순화를 위해 상위가 있으면 1, 없으면 0으로 대충 매핑
            if(no > 10) parentSelect.value = Math.floor(no/10); 
            else parentSelect.value = "0";

            if (display === 'N') document.getElementById('displayN').checked = true;
            else document.getElementById('displayY').checked = true;
        }

        // 초기화 (최상위 추가)
        function resetForm() {
            document.querySelectorAll('.tree-item').forEach(el => el.classList.remove('active'));
            document.getElementById('cateNo').value = '';
            document.getElementById('cateName').value = '';
            document.getElementById('parentCate').value = '0';
            document.getElementById('displayY').checked = true;
            document.getElementById('cateName').focus();
        }

        // 하위 카테고리 추가 모드
        function setParent() {
            let currentNo = document.getElementById('cateNo').value;
            let currentName = document.getElementById('cateName').value;
            
            if(!currentNo) {
                alert("상위 카테고리를 먼저 선택해주세요.");
                return;
            }

            // 폼 초기화하되, 상위 카테고리는 현재 선택된 것으로 고정
            let parentVal = currentNo; // 실제로는 DB ID를 써야 함
            
            document.getElementById('cateNo').value = ''; // 신규 생성이므로 번호 비움
            document.getElementById('cateName').value = '';
            document.getElementById('parentCate').value = parentVal; // 상위 카테고리 고정 (Select box에 해당 값이 있어야 함)
            document.getElementById('cateName').focus();
        }
    </script>

</body>
</html>