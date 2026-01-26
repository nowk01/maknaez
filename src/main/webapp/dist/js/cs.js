function deleteBoard(num, query) {
	if (confirm('게시글을 삭제하시겠습니까?')) {
		// contextPath는 JSP에서 전역변수로 선언 필요
		location.href = contextPath + '/cs/delete?num=' + num + '&' + query;
	}
}

function searchList() {
	const f = document.searchForm;
	if (f) {
		f.submit();
	}
}

function searchEnter(event) {
	if (event.key === 'Enter') {
		searchList();
	}
}
function deleteBoard(num, query) {
	if (confirm('게시글을 삭제하시겠습니까?')) {
		location.href = contextPath + '/cs/delete?num=' + num + '&' + query;
	}
}

function searchList() {
	const f = document.searchForm;
	if (f) {
		f.submit();
	}
}

function searchEnter(event) {
	if (event.key === 'Enter') {
		searchList();
	}
}


function deleteBoard(num, query) {
	if (confirm('정말 삭제하시겠습니까? 복구할 수 없습니다.')) {
		location.href = contextPath + '/cs/delete?num=' + num + '&' + query;
	}
}

function searchList() {
	const f = document.searchForm;
	if (f) {
		f.submit();
	}
}

function searchEnter(event) {
	if (event.key === 'Enter') {
		searchList();
	}
}

window.onpageshow = function(event) {
    if (event.persisted || (window.performance && window.performance.navigation.type === 2)) {
        window.location.reload();
    }
};
function toggleFaq(element) {
	const item = element.parentElement;

	if (item.classList.contains('active')) {
		item.classList.remove('active');
	} else {
		document.querySelectorAll('.faq-item').forEach(i => i.classList.remove('active'));
		item.classList.add('active');
	}
}

function filterFaq(category) {
	location.href = contextPath + '/cs/faq?category=' + category;
}

function filterFaq(category) {
	const buttons = document.querySelectorAll('.tab-btn');
	buttons.forEach(btn => btn.classList.remove('active'));

	event.currentTarget.classList.add('active');
	const items = document.querySelectorAll('.faq-item');

	items.forEach(item => {
		const itemCate = item.getAttribute('data-cate');

		if (category === 'all' || itemCate === category) {
			item.style.display = 'block'; 
		} else {
			item.style.display = 'none';  
		}
	});
}

function toggleFaq(element) {
	const faqItem = element.parentElement;
	faqItem.classList.toggle('active');
}

function toggleFaq(element) {
    const faqItem = element.closest('.faq-item');
    
    faqItem.classList.toggle('active');
    
   
}



