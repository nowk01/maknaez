document.addEventListener("DOMContentLoaded", function() {
    const f = document.noticeForm;
    
    if(f) {
        f.onsubmit = function(e) {
            e.preventDefault();
            if(typeof oEditors !== "undefined" && oEditors.getById["content"]) {
                oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);
            }

            if(!f.subject.value.trim()) {
                alert("제목을 입력해 주세요.");
                f.subject.focus();
                return false;
            }
			
            let contentValue = f.content.value;
            let checkValue = contentValue.replace(/<p><br><\/p>/gi, '').replace(/<p>&nbsp;<\/p>/gi, '').trim();

            if(!checkValue || checkValue === "" || checkValue === '<p>&nbsp;</p>') {
                alert("내용을 입력해 주세요.");
                if(typeof oEditors !== "undefined" && oEditors.getById["content"]) {
                    oEditors.getById["content"].exec("FOCUS");
                }
                return false;
            }
            
            if(confirm("공지사항을 등록하시겠습니까?")) {
                f.submit(); 
            }
        };
    }
});