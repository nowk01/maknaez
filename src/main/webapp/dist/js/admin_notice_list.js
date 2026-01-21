document.addEventListener("DOMContentLoaded", function() {
    // 1. 전체 선택 기능
    const checkAll = document.getElementById('checkAll');
    if(checkAll) {
        checkAll.addEventListener('change', function() {
            document.querySelectorAll('.chk').forEach(cb => cb.checked = checkAll.checked);
        });
    }

    const btnDelete = document.getElementById('btnDeleteSelected');
    if(btnDelete) {
        btnDelete.addEventListener('click', function() {
            const selected = document.querySelectorAll('.chk:checked');
            if(selected.length === 0) {
                alert("삭제할 게시물을 선택하세요.");
                return;
            }
            
            if(confirm(`${selected.length}건의 공지사항을 삭제하시겠습니까?`)) {
                const num = selected[0].value; 
                location.href = `${window.location.origin}/maknaez/admin/cs/notice_delete?num=${num}`;
            }
        });
    }
	
	window.onpageshow = function(event) {
	    if (event.persisted || (window.performance && window.performance.navigation.type === 2)) {
	        window.location.reload();
	    }
	};
});

