/**
 * MAKNAEZ Admin Category Logic
 * - Dependent on util-jquery.js (ajaxRequest)
 */

$(document).ready(function() {
    loadCategoryList();
});

// 전역 변수: 카테고리 데이터 저장
let categoryList = [];

// [READ] 카테고리 목록 불러오기
function loadCategoryList() {
    let url = "category_list";
    
    // ajaxRequest(url, method, params, dataType, callback)
    ajaxRequest(url, "get", null, "json", function(data) {
        if (data && data.list) {
            categoryList = data.list;
            renderCategoryTree(data.list);
        }
    });
}

// [UI] Accordion Tree 렌더링
function renderCategoryTree(list) {
    const $container = $('#categoryAccordion');
    $container.empty();

    // 1. 대분류(Depth 1) 필터링
    const parents = list.filter(item => item.depth === 1);

    parents.forEach((parent, index) => {
        // 자식(Depth 2) 필터링
        const children = list.filter(item => item.cateParent === parent.cateCode);
        
        // Collapse ID 생성
        const collapseId = `collapse${index}`;
        const headerId = `heading${index}`;

        let html = `
            <div class="accordion-item">
                <h2 class="accordion-header" id="${headerId}">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" 
                            data-bs-target="#${collapseId}" aria-expanded="false" aria-controls="${collapseId}"
                            onclick="selectParent('${parent.cateCode}')">
                        <span class="fw-bold me-2">${parent.cateName}</span>
                        <small class="text-muted" style="font-size:0.8em;">(${parent.cateCode})</small>
                    </button>
                </h2>
                <div id="${collapseId}" class="accordion-collapse collapse" aria-labelledby="${headerId}" data-bs-parent="#categoryAccordion">
                    <div class="accordion-body p-0">
                        <div class="list-group list-group-flush">`;

        // 자식 아이템 렌더링
        if(children.length > 0) {
            children.forEach(child => {
                let statusBadge = child.status === 0 ? '<span class="badge bg-secondary ms-auto">Hidden</span>' : '';
                html += `
                    <a href="javascript:void(0);" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center"
                       onclick="selectChild('${child.cateCode}', this)">
                        <span>${child.cateName}</span>
                        ${statusBadge}
                    </a>`;
            });
        } else {
            html += `<div class="p-3 text-muted small text-center">하위 카테고리가 없습니다.</div>`;
        }

        html += `   </div>
                    </div>
                </div>
            </div>`;

        $container.append(html);
    });
}

// [Event] 대분류 선택 시
function selectParent(code) {
    // UI 초기화
    $('.list-group-item').removeClass('active');
    
    const item = categoryList.find(c => c.cateCode === code);
    if(item) fillForm(item);
}

// [Event] 중분류 선택 시
function selectChild(code, element) {
    // Highlight 처리
    $('.list-group-item').removeClass('active');
    $(element).addClass('active');

    const item = categoryList.find(c => c.cateCode === code);
    if(item) fillForm(item);
}

// [Form] 폼 데이터 채우기
function fillForm(item) {
    // 여기가 문제의 ID들을 찾는 부분입니다. JSP와 ID가 일치해야 합니다.
    $('#mode').val('update');
    $('#cateCode').val(item.cateCode);
    $('#cateName').val(item.cateName);
    $('#orderNo').val(item.orderNo);
    $('#depth').val(item.depth);
    
    // Parent 설정
    $('#cateParent').val(item.cateParent || '');
    if(item.depth === 2) {
        // 부모 이름 찾기
        const parentItem = categoryList.find(c => c.cateCode === item.cateParent);
        $('#parentName').val(parentItem ? parentItem.cateName : item.cateParent);
    } else {
        $('#parentName').val("Root (대분류)");
    }

    // Status Radio
    if (item.status === 1) $('#displayY').prop('checked', true);
    else $('#displayN').prop('checked', true);

    // 버튼 제어
    $('#btnDelete').show();
    if(item.depth === 1) {
        $('#btnSubAdd').show();
    } else {
        $('#btnSubAdd').hide();
    }
}

// [Form] 초기화 (Root 추가 모드)
function resetForm() {
    $('#categoryForm')[0].reset();
    $('.list-group-item').removeClass('active');
    
    $('#mode').val('insert');
    $('#cateCode').val(''); // 자동생성
    $('#cateParent').val('');
    $('#parentName').val('Root (대분류)');
    $('#depth').val('1');
    $('#displayY').prop('checked', true);
    
    $('#btnDelete').hide();
    $('#btnSubAdd').hide();
    $('#cateName').focus();
}

// [Form] 하위 카테고리 추가 준비 (Sub Add)
function prepareSubAdd() {
    const parentCode = $('#cateCode').val();
    const parentName = $('#cateName').val();

    if(!parentCode) {
        alert("상위 카테고리를 먼저 선택하세요.");
        return;
    }

    // 폼 클리어하지만 부모 정보는 유지
    $('#mode').val('insert');
    $('#cateCode').val('');
    $('#cateName').val('');
    $('#cateParent').val(parentCode); // 현재 선택된 코드를 부모로 설정
    $('#parentName').val(parentName);
    $('#depth').val('2'); // Depth는 2로 고정
    $('#orderNo').val('1');
    $('#displayY').prop('checked', true);

    // 버튼 숨김
    $('#btnDelete').hide();
    $('#btnSubAdd').hide();
    $('#cateName').focus();
}

// [CUD] 저장 (Insert / Update)
function submitCategory() {
    const name = $('#cateName').val();
    if(!name) {
        alert("카테고리 이름을 입력하세요.");
        return;
    }

    const mode = $('#mode').val();
    let url = mode === 'insert' ? "category_insert" : "category_update";
    
    // form 데이터를 객체나 QueryString으로 변환
    const formData = $('#categoryForm').serialize();

    ajaxRequest(url, "post", formData, "json", function(data) {
        if(data && data.state === "true") {
            alert("저장되었습니다.");
            loadCategoryList(); // 트리 새로고침
            if(mode === 'insert') resetForm();
        } else {
            alert("처리 중 오류가 발생했습니다.");
        }
    });
}

// [CUD] 삭제
function deleteCategoryFunc() {
    const code = $('#cateCode').val();
    if(!code) return;

    if(!confirm("정말 삭제하시겠습니까? 하위 카테고리가 있으면 삭제되지 않습니다.")) return;

    let url = "category_delete";
    let params = { cateCode: code };

    ajaxRequest(url, "post", params, "json", function(data) {
        if(data && data.state === "true") {
            alert("삭제되었습니다.");
            resetForm();
            loadCategoryList();
        } else {
            alert(data.message || "삭제 실패. 하위 카테고리를 확인하세요.");
        }
    });
}