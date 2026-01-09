/*
 * 고객센터(CS) 공통 스크립트
 */

// 게시글 삭제 시 확인 창
function deleteBoard(num, query) {
	if (confirm('게시글을 삭제하시겠습니까?')) {
		// contextPath는 JSP에서 전역변수로 선언 필요
		location.href = contextPath + '/cs/delete?num=' + num + '&' + query;
	}
}

// 검색 폼 전송
function searchList() {
	const f = document.searchForm;
	if (f) {
		f.submit();
	}
}

// 엔터키 입력 시 검색 실행
function searchEnter(event) {
	if (event.key === 'Enter') {
		searchList();
	}
}

/*
 * 고객센터(CS) 공통 스크립트
 */

// 게시글 삭제 시 확인 창
function deleteBoard(num, query) {
	if (confirm('게시글을 삭제하시겠습니까?')) {
		location.href = contextPath + '/cs/delete?num=' + num + '&' + query;
	}
}

// 검색 폼 전송
function searchList() {
	const f = document.searchForm;
	if (f) {
		f.submit();
	}
}

// 엔터키 입력 시 검색 실행
function searchEnter(event) {
	if (event.key === 'Enter') {
		searchList();
	}
}

/*
 * 고객센터(CS) 공통 스크립트
 */

// 게시글 삭제 시 확인 창
function deleteBoard(num, query) {
	if (confirm('정말 삭제하시겠습니까? 복구할 수 없습니다.')) {
		location.href = contextPath + '/cs/delete?num=' + num + '&' + query;
	}
}

// 검색 폼 전송
function searchList() {
	const f = document.searchForm;
	if (f) {
		f.submit();
	}
}

// 엔터키 입력 시 검색 실행
function searchEnter(event) {
	if (event.key === 'Enter') {
		searchList();
	}
}

/* ===========================
   FAQ 아코디언 토글
   =========================== */
function toggleFaq(element) {
	const item = element.parentElement;

	// 이미 열려있으면 닫기
	if (item.classList.contains('active')) {
		item.classList.remove('active');
	} else {
		// 다른 것들은 모두 닫고 현재 것만 열기
		document.querySelectorAll('.faq-item').forEach(i => i.classList.remove('active'));
		item.classList.add('active');
	}
}

/* ===========================
   FAQ 카테고리 필터링
   =========================== */
function filterFaq(category) {
	location.href = contextPath + '/cs/faq?category=' + category;
}

function filterFaq(category) {
	// 1. 모든 버튼에서 active 클래스 제거하고 클릭된 버튼에만 추가
	const buttons = document.querySelectorAll('.tab-btn');
	buttons.forEach(btn => btn.classList.remove('active'));

	// 클릭된 버튼 강조 (이벤트 타겟 찾기)
	event.currentTarget.classList.add('active');

	// 2. 리스트 필터링 처리
	const items = document.querySelectorAll('.faq-item');

	items.forEach(item => {
		const itemCate = item.getAttribute('data-cate');

		if (category === 'all' || itemCate === category) {
			item.style.display = 'block'; // 보이기
		} else {
			item.style.display = 'none';  // 숨기기
		}
	});
}

// 질문 열고 닫기 (기존 동일)
function toggleFaq(element) {
	const faqItem = element.parentElement;
	faqItem.classList.toggle('active');
}

function toggleFaq(element) {
    const faqItem = element.closest('.faq-item');
    
    faqItem.classList.toggle('active');
    
   
}



