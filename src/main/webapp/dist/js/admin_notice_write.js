document.addEventListener("DOMContentLoaded", function() {
    const f = document.noticeForm;
    
    if(f) {
        f.onsubmit = function(e) {
            // 기본 제출 막기 (유효성 검사 후 제출하기 위함)
            e.preventDefault();

            // 1. 스마트 에디터의 내용을 textarea(content)에 동기화
            // JSP에서 정의한 oEditors 객체가 있는지 확인 후 업데이트 실행
            if(typeof oEditors !== "undefined" && oEditors.getById["content"]) {
                oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);
            }

            // 2. 제목 유효성 검사
            if(!f.subject.value.trim()) {
                alert("제목을 입력해 주세요.");
                f.subject.focus();
                return false;
            }
            
            // 3. 내용 유효성 검사
            // 에디터 특성상 공백이나 의미 없는 태그(<p><br></p> 등)만 남는 경우를 체크
            let contentValue = f.content.value;
            let checkValue = contentValue.replace(/<p><br><\/p>/gi, '').replace(/<p>&nbsp;<\/p>/gi, '').trim();

            if(!checkValue || checkValue === "" || checkValue === '<p>&nbsp;</p>') {
                alert("내용을 입력해 주세요.");
                // 에디터로 포커스 이동 (선택 사항)
                if(typeof oEditors !== "undefined" && oEditors.getById["content"]) {
                    oEditors.getById["content"].exec("FOCUS");
                }
                return false;
            }
            
            // 4. 최종 확인 및 전송
            if(confirm("공지사항을 등록하시겠습니까?")) {
                f.submit(); // 컨트롤러(/admin/cs/notice_write)로 전송
            }
        };
    }
});