/**
 * MAKNAEZ Admin Category Logic
 * - Dependent on util-jquery.js (ajaxRequest)
 * - Features: Manual Code Input, Hierarchical Dropdown, Auto Prefixing
 */

$(document).ready(function() {
    // 1. 초기 데이터 로드
    loadCategoryList();
    
    // 2. 상위 카테고리 변경 시 이벤트 바인딩
    $('#cateParent').on('change', onChangeParent);
});

// 전역 변수: 카테고리 데이터 캐싱
let categoryList = [];

// [READ] 카테고리 목록 불러오기 (트리 & 드롭다운 갱신)
function loadCategoryList() {
    let url = "category_list";
    
    ajaxRequest(url, "get", null, "json", function(data) {
        if (data && data.list) {
            categoryList = data.list;
            renderCategoryTree(data.list);  // 좌측 트리 그리기
            renderParentOptions(data.list); // 우측 드롭다운 채우기
        }
    });
}

// [UI] Accordion Tree 렌더링 (좌측)
// [UI] Accordion Tree 렌더링 (좌측) - 숨김 배지 기능 추가됨
function renderCategoryTree(list) {
    const $container = $('#categoryAccordion');
    $container.empty();

    // 1. 대분류(Depth 1) 필터링
    const parents = list.filter(item => item.depth === 1);

    if (parents.length === 0) {
        $container.html('<div class="text-center py-5 text-muted">등록된 카테고리가 없습니다.<br>신규 대분류를 등록해주세요.</div>');
        return;
    }

    parents.forEach((parent, index) => {
        // 2. 자식(Depth 2) 필터링
        const children = list.filter(item => item.cateParent === parent.cateCode);
        
        // ID 생성
        const collapseId = `collapse${index}`;
        const headerId = `heading${index}`;

        // ★ [NEW] 대분류 숨김 배지 로직
        // status가 0이면 회색 배지 표시
        const parentBadge = (parent.status == 0) 
            ? '<span class="badge bg-secondary ms-2 rounded-pill" style="font-size:0.7em;">숨김</span>' 
            : '';

        // HTML 조립
        let html = `
            <div class="accordion-item">
                <h2 class="accordion-header" id="${headerId}">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" 
                            data-bs-target="#${collapseId}" aria-expanded="false" aria-controls="${collapseId}"
                            onclick="viewCategory('${parent.cateCode}', '${parent.cateName}', '', 1, ${parent.orderNo}, '${parent.status}')">
                        <span class="fw-bold me-2">${parent.cateName}</span> 
                        <span class="text-muted" style="font-size:0.85em;">(${parent.cateCode})</span>
                        ${parentBadge} </button>
                </h2>
                <div id="${collapseId}" class="accordion-collapse collapse" aria-labelledby="${headerId}" data-bs-parent="#categoryAccordion">
                    <div class="accordion-body p-0">
                        <div class="list-group list-group-flush">`;

        if (children.length > 0) {
            children.forEach(child => {
                // ★ [NEW] 하위분류 숨김 배지 로직
                const childBadge = (child.status == 0) 
                    ? '<span class="badge bg-secondary me-2 rounded-pill" style="font-size:0.7em;">숨김</span>' 
                    : '';

                html += `
                    <button type="button" class="list-group-item list-group-item-action d-flex align-items-center" 
                        onclick="viewCategory('${child.cateCode}', '${child.cateName}', '${parent.cateCode}', ${child.depth}, ${child.orderNo}, '${child.status}')">
                        <i class="bi bi-arrow-return-right text-muted me-2 small"></i>
                        <span>${child.cateName}</span>
                        
                        <span class="ms-auto d-flex align-items-center">
                            ${childBadge} <span class="text-muted small" style="font-size:0.8em;">${child.cateCode}</span>
                        </span>
                    </button>`;
            });
        } else {
            html += `<div class="p-3 text-center text-muted small bg-light">하위 카테고리가 없습니다.</div>`;
        }

        html += `       </div>
                    </div>
                </div>
            </div>`;
        
        $container.append(html);
    });
}

// [UI] 상위 카테고리 드롭다운 옵션 생성 (우측 폼)
function renderParentOptions(list) {
    const $select = $('#cateParent');
    const currentVal = $select.val(); // 현재 선택값 임시 저장 (필요 시 복원)
    
    $select.empty();
    
    // 1. 최상위(ROOT) 옵션
    $select.append('<option value="" data-depth="0">최상위 (ROOT)</option>');

    // 2. 부모가 될 수 있는 카테고리만 추가 (Depth 1, 2만 허용한다고 가정)
    // Depth가 3인 항목은 하위를 가질 수 없으면 제외
    const candidates = list.filter(item => item.depth < 3);

    // 정렬: 대분류 코드순
    candidates.sort((a, b) => a.cateCode.localeCompare(b.cateCode));

    candidates.forEach(item => {
        let prefix = "";
        let displayName = item.cateName;
        
        // Depth 시각화
        if (item.depth === 2) {
            prefix = "&nbsp;&nbsp;&nbsp;&nbsp;└ ";
        }
        
        $select.append(`<option value="${item.cateCode}" data-depth="${item.depth}">
            ${prefix}${displayName} (${item.cateCode})
        </option>`);
    });
}

// [Event] 상위 카테고리 변경 시 동작 (핵심 로직)
function onChangeParent() {
    const $selected = $('#cateParent option:selected');
    const parentCode = $selected.val();
    const parentDepth = parseInt($selected.data('depth')) || 0;

    // 모드가 'update'일 때는 코드 자동 변경 막기 (안전장치)
    if ($('#mode').val() === 'update') return;

    if (!parentCode) {
        // [ROOT 선택 시]
        $('#cateCode').val('');
        $('#depth').val(1);
        $('#codeHelpText').text('대분류 코드는 영문 대문자로 입력하세요. (예: MEN)');
    } else {
        // [하위 선택 시] 접두어 자동 입력
        const prefix = parentCode + "_";
        $('#cateCode').val(prefix);
        $('#depth').val(parentDepth + 1);
        $('#codeHelpText').text(`'${prefix}' 뒤에 상세 코드를 입력하세요.`);
    }
    
    // 입력 편의를 위해 포커스 이동
    $('#cateCode').focus();
}

// [Action] 신규 등록 모드 초기화 (Reset)
function resetForm() {
    $('#mode').val('insert');
    $('#originCateCode').val('');

	$('#cateParent').prop('disabled', false).val('');
    $('#cateCode').prop('readonly', false).removeClass('bg-light').val('');
    $('#codeHelpText').text('신규 코드를 입력하세요. (예: MEN)');
    $('#codeHelpText').removeClass('text-danger').addClass('text-muted');
    
    // 3. 나머지 필드 초기화
    $('#cateName').val('');
    $('#orderNo').val('1');
    $('#depth').val('1');
    $('#displayY').prop('checked', true);
    
    // 4. 버튼 제어
    $('#btnDelete').hide();
    $('#btnSubAdd').hide(); // 신규 등록 중에는 하위추가 버튼 불필요
    
    $('#cateCode').focus();
}

// [Action] 트리 클릭 시 상세 정보 보기
function viewCategory(code, name, parent, depth, orderNo, status) {
    $('#mode').val('update');
    $('#originCateCode').val(code);

    // 1. 값 바인딩
    $('#cateParent').val(parent || ''); // 부모 선택
    $('#cateCode').val(code);
    $('#cateName').val(name);
    $('#depth').val(depth);
    $('#orderNo').val(orderNo);
    
    // Status (Display)
    if (String(status) === '1' || status === 'Y') {
        $('#displayY').prop('checked', true);
    } else {
        $('#displayN').prop('checked', true);
    }

	const hasChildren = categoryList.some(item => item.cateParent === code);

    if (hasChildren) {
        // 자식이 있으면 -> 코드 수정 불가 (Readonly)
        $('#cateCode').prop('readonly', true).addClass('bg-light');
        $('#codeHelpText').text('⛔ 하위 카테고리가 존재하여 코드를 변경할 수 없습니다.');
        $('#codeHelpText').removeClass('text-muted').addClass('text-danger');
    } else {
        // 자식이 없으면 -> 코드 수정 가능 (Editable)
        $('#cateCode').prop('readonly', false).removeClass('bg-light');
        $('#codeHelpText').text('✏️ 코드를 수정할 수 있습니다. (연결된 상품 정보도 함께 업데이트됩니다)');
        $('#codeHelpText').removeClass('text-danger').addClass('text-muted');
    }

    // 3. 상위 카테고리는 구조 꼬임 방지를 위해 항상 비활성
    $('#cateParent').prop('disabled', true);
    
    // 3. 버튼 노출
    $('#btnDelete').show();
    
    // 하위 분류 추가 버튼은 Depth가 깊지 않을 때만 노출 (예: 3단계 미만일 때만)
    if (depth < 3) {
        $('#btnSubAdd').show();
    } else {
        $('#btnSubAdd').hide();
    }
}

// [Action] 하위 분류 추가 준비 (상세보기 상태에서 '하위 분류 추가' 버튼 클릭)
function prepareSubAdd() {
    const currentCode = $('#cateCode').val(); // 현재 보고 있는 카테고리 (부모가 될 코드)
    const currentName = $('#cateName').val();
    
    // 1. 폼 리셋 (Insert 모드)
    resetForm();
    
    // 2. 드롭다운에서 현재 코드를 부모로 선택
    $('#cateParent').val(currentCode);
    
    // 3. 변경 이벤트 강제 발생 -> 코드 접두어(MEN_) 자동 생성
    onChangeParent();
    
    if(typeof updatePathBadge === 'function') updatePathBadge(currentName + ' > 하위 분류 등록');
}

// [CUD] 저장 (Insert / Update)
function submitCategory() {
    const mode = $('#mode').val();
    const code = $('#cateCode').val();
    const name = $('#cateName').val();
    const parentCode = $('#cateParent').val();
    
    // 1. 유효성 검사
    if(!code) {
        alert("카테고리 코드를 입력하세요.");
        $('#cateCode').focus();
        return;
    }
    
    // 코드 형식 검사 (영문 대문자, 숫자, 언더바)
    const codeRegex = /^[A-Z0-9_]+$/;
    if(!codeRegex.test(code)) {
        alert("카테고리 코드는 영문 대문자, 숫자, 언더바(_)만 사용 가능합니다.");
        $('#cateCode').focus();
        return;
    }

    if(!name) {
        alert("카테고리 이름을 입력하세요.");
        $('#cateName').focus();
        return;
    }

    // Insert 시 접두어 검증 (사용자가 실수로 지웠을 경우 대비)
    if(mode === 'insert' && parentCode) {
        if(!code.startsWith(parentCode + "_")) {
            alert(`하위 카테고리 코드는 상위코드('${parentCode}_')로 시작해야 합니다.`);
            $('#cateCode').focus();
            return;
        }
    }

    // 2. 전송 준비
    let url = mode === 'insert' ? "category_insert" : "category_update";
    
    // 주의: disabled된 select(cateParent)는 serialize()에 포함되지 않음.
    // Insert시는 enabled이므로 전송됨. Update시는 disabled이므로 전송 안 됨 (Backend에서 수정 안 하면 OK).
    const formData = $('#categoryForm').serialize();

    ajaxRequest(url, "post", formData, "json", function(data) {
        if(data && data.state === "true") {
            alert("저장되었습니다.");
            loadCategoryList(); // 트리 및 목록 갱신
            if(mode === 'insert') resetForm(); // 입력창 초기화
        } else {
            alert(data.message || "처리 중 오류가 발생했습니다.");
        }
    });
}

// [CUD] 삭제
function deleteCategoryFunc() {
    const code = $('#cateCode').val();
    if(!code) return;

    if(!confirm("정말 삭제하시겠습니까?\n하위 카테고리가 있거나 상품이 연결된 경우 삭제되지 않을 수 있습니다.")) {
        return;
    }

    const url = "category_delete";
    // post body에 cateCode 전달
    const params = "cateCode=" + code;

    ajaxRequest(url, "post", params, "json", function(data) {
        if(data && data.state === "true") {
            alert("삭제되었습니다.");
            loadCategoryList();
            resetForm();
        } else {
            alert(data.message || "삭제 실패: 하위 분류가 존재하거나 사용 중인 코드입니다.");
        }
    });
}