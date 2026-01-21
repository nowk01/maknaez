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

	function searchList() {
	    const f = document.searchForm;
	    if(!f.kwd.value.trim()) {
	        alert("검색어를 입력하세요.");
	        f.kwd.focus();
	        return;
	    }
	    f.submit();
	}

	document.addEventListener("DOMContentLoaded", function() {
	    const kwdInput = document.querySelector("input[name='kwd']");
	    if(kwdInput) {
	        kwdInput.addEventListener("keypress", function(e) {
	            if (e.key === "Enter") {
	                e.preventDefault();
	                document.searchForm.submit();
	            }
	        });
	    }

	    const checkAll = document.getElementById("checkAll");
	    if(checkAll) {
	        checkAll.addEventListener("change", function() {
	            const chks = document.querySelectorAll("input[name='nums']");
	            chks.forEach(chk => chk.checked = this.checked);
	        });
	    }
	});
	
	
	window.onpageshow = function(event) {
	    if (event.persisted || (window.performance && window.performance.navigation.type === 2)) {
	        window.location.reload();
	    }
	};
});

