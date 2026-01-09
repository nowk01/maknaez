/*
 * 고객센터(CS) 공통 스크립트
 */

// 게시글 삭제 시 확인 창
function deleteBoard(num, query) {
    if(confirm('게시글을 삭제하시겠습니까?')) {
        // contextPath는 JSP에서 전역변수로 선언 필요
        location.href = contextPath + '/cs/delete?num=' + num + '&' + query;
    }
}

// 검색 폼 전송
function searchList() {
    const f = document.searchForm;
    if(f) {
        f.submit();
    }
}

// 엔터키 입력 시 검색 실행
function searchEnter(event) {
    if(event.key === 'Enter') {
        searchList();
    }
}