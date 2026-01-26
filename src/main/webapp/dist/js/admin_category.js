$(document).ready(function() {
	loadCategoryList();
	
	$('#cateParent').on('change', onChangeParent);
});

let categoryList = [];

function loadCategoryList() {
	let url = "category_list";

	ajaxRequest(url, "get", null, "json", function(data) {
		if (data && data.list) {
			categoryList = data.list;
			renderCategoryTree(data.list);  
			renderParentOptions(data.list); 
		}
	});
}

function renderCategoryTree(list) {
	const $container = $('#categoryAccordion');
	$container.empty();

	const parents = list.filter(item => item.depth === 1);

	if (parents.length === 0) {
		$container.html('<div class="text-center py-5 text-muted">등록된 카테고리가 없습니다.<br>신규 대분류를 등록해주세요.</div>');
		return;
	}

	parents.forEach((parent, index) => {
		const children = list.filter(item => item.cateParent === parent.cateCode);

		const collapseId = `collapse${index}`;
		const headerId = `heading${index}`;
		const parentBadge = (parent.status == 0)
			? '<span class="badge bg-secondary ms-2 rounded-pill" style="font-size:0.7em;">숨김</span>'
			: '';

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

function renderParentOptions(list) {
	const $select = $('#cateParent');
	const currentVal = $select.val(); 

	$select.empty();
	$select.append('<option value="" data-depth="0">최상위 (ROOT)</option>');
	
	const candidates = list.filter(item => item.depth < 3);
	
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

function onChangeParent() {
	const $selected = $('#cateParent option:selected');
	const parentCode = $selected.val();
	const parentDepth = parseInt($selected.data('depth')) || 0;

	if ($('#mode').val() === 'update') return;

	if (!parentCode) {
		$('#cateCode').val('');
		$('#depth').val(1);
		$('#codeHelpText').text('대분류 코드는 영문 대문자로 입력하세요. (예: MEN)');
	} else {
		const prefix = parentCode + "_";
		$('#cateCode').val(prefix);
		$('#depth').val(parentDepth + 1);
		$('#codeHelpText').text(`'${prefix}' 뒤에 상세 코드를 입력하세요.`);
	}

	$('#cateCode').focus();
}

function resetForm() {
	$('#mode').val('insert');
	$('#originCateCode').val('');

	$('#cateParent').prop('disabled', false).val('');
	$('#cateCode').prop('readonly', false).removeClass('bg-light').val('');
	$('#codeHelpText').text('신규 코드를 입력하세요. (예: MEN)');
	$('#codeHelpText').removeClass('text-danger').addClass('text-muted');
	
	$('#cateName').val('');
	$('#orderNo').val('1');
	$('#depth').val('1');
	$('#displayY').prop('checked', true);

	$('#btnDelete').hide();
	$('#btnSubAdd').hide(); 

	$('#cateCode').focus();
}

function viewCategory(code, name, parent, depth, orderNo, status) {
	$('#mode').val('update');
	$('#originCateCode').val(code);

	$('#cateParent').val(parent || ''); 
	$('#cateCode').val(code);
	$('#cateName').val(name);
	$('#depth').val(depth);
	$('#orderNo').val(orderNo);

	if (String(status) === '1' || status === 'Y') {
		$('#displayY').prop('checked', true);
	} else {
		$('#displayN').prop('checked', true);
	}

	const hasChildren = categoryList.some(item => item.cateParent === code);

	if (hasChildren) {
		$('#cateCode').prop('readonly', true).addClass('bg-light');
		$('#codeHelpText').text('⛔ 하위 카테고리가 존재하여 코드를 변경할 수 없습니다.');
		$('#codeHelpText').removeClass('text-muted').addClass('text-danger');
	} else {
		$('#cateCode').prop('readonly', false).removeClass('bg-light');
		$('#codeHelpText').text('✏️ 코드를 수정할 수 있습니다. (연결된 상품 정보도 함께 업데이트됩니다.)');
		$('#codeHelpText').removeClass('text-danger').addClass('text-muted');
	}

	$('#cateParent').prop('disabled', true);

	$('#btnDelete').show();

	if (depth < 3) {
		$('#btnSubAdd').show();
	} else {
		$('#btnSubAdd').hide();
	}
}

function prepareSubAdd() {
	const currentCode = $('#cateCode').val(); 
	const currentName = $('#cateName').val();

	resetForm();
	
	$('#cateParent').val(currentCode);

	onChangeParent();

	if (typeof updatePathBadge === 'function') updatePathBadge(currentName + ' > 하위 분류 등록');
}

function updatePathBadge(pathText) {
	const badge = document.getElementById('currentPath');
	if (badge) {
		badge.innerText = pathText;
	}
}

$(document).ready(function() {
	$('#currentPath').text('READY (New Mode)');
});

$(document).ready(function() {
	$('#currentPath').text('READY / INSERT MODE');
});

function submitCategory() {
	const mode = $('#mode').val();
	const code = $('#cateCode').val();
	const name = $('#cateName').val();
	const parentCode = $('#cateParent').val();

	if (!code) {
		alert("카테고리 코드를 입력하세요.");
		$('#cateCode').focus();
		return;
	}

	const codeRegex = /^[A-Z0-9_]+$/;
	if (!codeRegex.test(code)) {
		alert("카테고리 코드는 영문 대문자, 숫자, 언더바(_)만 사용 가능합니다.");
		$('#cateCode').focus();
		return;
	}

	if (!name) {
		alert("카테고리 이름을 입력하세요.");
		$('#cateName').focus();
		return;
	}

	if (mode === 'insert' && parentCode) {
		if (!code.startsWith(parentCode + "_")) {
			alert(`하위 카테고리 코드는 상위코드('${parentCode}_')로 시작해야 합니다.`);
			$('#cateCode').focus();
			return;
		}
	}

	let url = mode === 'insert' ? "category_insert" : "category_update";
	const formData = $('#categoryForm').serialize();

	ajaxRequest(url, "post", formData, "json", function(data) {
		if (data && data.state === "true") {
			alert("저장되었습니다.");
			loadCategoryList(); 
			if (mode === 'insert') resetForm(); 
		} else {
			alert(data.message || "처리 중 오류가 발생했습니다.");
		}
	});
}

function deleteCategoryFunc() {
	const code = $('#cateCode').val();
	if (!code) return;

	if (!confirm("정말 삭제하시겠습니까?\n하위 카테고리가 있거나 상품이 연결된 경우 삭제되지 않을 수 있습니다.")) {
		return;
	}

	const url = "category_delete";
	const params = "cateCode=" + code;

	ajaxRequest(url, "post", params, "json", function(data) {
		if (data && data.state === "true") {
			alert("삭제되었습니다.");
			loadCategoryList();
			resetForm();
		} else {
			alert(data.message || "삭제 실패: 하위 분류가 존재하거나 사용 중인 코드입니다.");
		}
	});


}