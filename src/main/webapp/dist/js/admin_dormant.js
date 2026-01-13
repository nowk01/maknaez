document.addEventListener("DOMContentLoaded", function() {
    // 전체 선택 기능
    const checkAll = document.getElementById('checkAll');
    if(checkAll) {
        checkAll.addEventListener('change', function() {
            const items = document.querySelectorAll('.chk-item');
            items.forEach(item => item.checked = this.checked);
        });
    }
});

function searchList() {
        const f = document.searchForm;
        
        // 날짜 유효성 검사
        if(f.startDate.value && f.endDate.value && f.startDate.value > f.endDate.value) {
            alert("종료일은 시작일보다 늦어야 합니다.");
            return;
        }
        
        f.submit();
    }
    
    $(function() {

        $("#checkAll").click(function() {
            if($(this).is(":checked")) {
                $("input[name=memberIdxs]").prop("checked", true);
            } else {
                $("input[name=memberIdxs]").prop("checked", false);
            }
        });

        $("#btnRestoreSelected").click(function() {
            let cnt = $("input[name=memberIdxs]:checked").length;

            if (cnt === 0) {
                alert("복구할 회원을 선택해주세요.");
                return;
            }

            if (!confirm("선택한 " + cnt + "명의 회원을 복구하시겠습니까?")) {
                return;
            }

            // 체크된 회원들의 memberIdxs 값을 쿼리 스트링으로 변환
            const query = $("input[name=memberIdxs]:checked").serialize();

            $.ajax({
                type: "POST",
                url: "releaseDormantList", // Controller URL
                data: query,
                dataType: "json",
                success: function(data) {
                    if (data.state === "true") {
                        alert("총 " + data.count + "명이 정상적으로 복구되었습니다.");
                        location.reload();
                    } else {
                        alert(data.message);
                    }
                },
                error: function(e) {
                    console.log(e);
                    alert("처리 중 에러가 발생했습니다.");
                }
            });
        });

        $("#btnDeleteSelected").click(function() {
            let cnt = $("input[name=memberIdxs]:checked").length;

            if (cnt === 0) {
                alert("삭제할 회원을 선택해주세요.");
                return;
            }

            if (!confirm("선택한 " + cnt + "명의 회원을 '영구 삭제' 하시겠습니까?\n삭제된 데이터는 복구할 수 없습니다.")) {
                return;
            }

            const query = $("input[name=memberIdxs]:checked").serialize();

            $.ajax({
                type: "POST",
                url: "deleteList", // Controller URL
                data: query,
                dataType: "json",
                success: function(data) {
                    if (data.state === "true") {
                        alert("선택한 회원이 삭제되었습니다.");
                        location.reload();
                    } else {
                        alert("삭제 실패: " + (data.message || "참조 데이터 오류"));
                    }
                },
                error: function() {
                    alert("서버 통신 에러");
                }
            });
        });
        
        $(".btn-restore").click(function() {
            let memberIdx = $(this).data("idx");
            
            // 버튼이 속한 행(tr)에서 회원의 이름 찾기 (4번째 td)
            let userName = $(this).closest("tr").find("td:eq(3)").text(); 

            if (!confirm("'" + userName + "' 회원을 복구하시겠습니까?")) return;

            $.ajax({
                type: "POST",
                url: "releaseDormantList",
                data: { memberIdxs: memberIdx },
                dataType: "json",
                success: function(data) {
                    if (data.state === "true") {
                        alert("복구되었습니다.");
                        location.reload();
                    } else {
                        alert("실패했습니다.");
                    }
                },
                error: function() { alert("에러 발생"); }
            });
        });
        
        // 기존 JS에 삭제 버튼에 대한 이벤트가 없어 추가해 드립니다.
        // 만약 버튼에 .btn-delete 클래스가 없다면 HTML에서 추가해야 합니다. (위 코드에는 없음, 버튼 생성 시 필요시 추가)
    });