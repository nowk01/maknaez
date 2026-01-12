/**
 * MAKNAEZ ADMIN - MEMBER MANAGEMENT JS
 */

function checkAll() {
    const chkAll = document.getElementById("chkAll");
    const chks = document.getElementsByName("chk");
    for (let chk of chks) {
        chk.checked = chkAll.checked;
    }
}

// 검색 기능 (백엔드 연동)
function searchList() {
    let startDate = document.getElementById("startDate").value;
    let endDate = document.getElementById("endDate").value;
    let userLevel = document.getElementById("userLevel").value;
    let searchKey = document.getElementById("searchKey").value;
    let searchValue = document.getElementById("searchValue").value;

    let url = contextPath + "/admin/member/member_list";
    let query = "page=1";

    if (startDate && endDate) query += "&startDate=" + startDate + "&endDate=" + endDate;
    if (userLevel !== "전체 등급") query += "&userLevel=" + encodeURIComponent(userLevel);
    if (searchValue) query += "&searchKey=" + searchKey + "&searchValue=" + encodeURIComponent(searchValue);

    location.href = url + "?" + query;
}

// 모달 제어
function openMemberModal(mode, memberIdx) {
    let modalEl = document.getElementById('memberModal');
    let myModal = bootstrap.Modal.getOrCreateInstance(modalEl);
    const form = document.getElementById("memberForm");
    form.reset();
    document.getElementById("modalMode").value = mode;

    if (mode === 'add') {
        document.getElementById("memberModalLabel").innerText = "회원 추가 (NEW MEMBER)";
        document.getElementById("userId").readOnly = false;
        document.getElementById("enabledDiv").style.display = "none";
        myModal.show();
    } else {
        document.getElementById("memberModalLabel").innerText = "회원 상세/수정 (DETAIL)";
        document.getElementById("userId").readOnly = true;
        document.getElementById("enabledDiv").style.display = "block";

        let url = contextPath + "/admin/member/detail";
        ajaxRequest(url, "GET", "memberIdx=" + memberIdx, "json", function(data) {
            if (data.state === "true") {
                let d = data.dto;
                $("#modalMemberIdx").val(d.memberIdx);
                $("#userId").val(d.userId);
                $("#userName").val(d.userName);
                $("#nickName").val(d.nickName);
                $("#email").val(d.email);
                $("#gender").val(d.gender);
                $("#tel").val(d.tel);
                $("#modalUserLevel").val(d.userLevel);
                $("#enabled").val(d.enabled);
                if (d.birth) $("#birth").val(d.birth.substring(0, 10));
                myModal.show();
            }
        });
    }
}

// 저장 실행
function submitMember() {
    const f = document.getElementById("memberForm");
    let mode = f.modalMode.value;
    let url = contextPath + "/admin/member/" + (mode === "add" ? "write" : "update");
    
    ajaxRequest(url, "POST", $(f).serialize(), "json", function(data) {
        if (data.state === "true") {
            alert("처리가 완료되었습니다.");
            location.reload();
        } else {
            alert("작업에 실패했습니다.");
        }
    });
}

// 선택 삭제 (배열 전송 최적화)
function deleteList() {
    let memberIdxs = [];
    $("input[name=chk]:checked").each(function() {
        memberIdxs.push($(this).val());
    });

    if (memberIdxs.length === 0) {
        alert("삭제할 회원을 선택하세요.");
        return;
    }

    if (!confirm("선택한 " + memberIdxs.length + "명의 회원을 정말 삭제하시겠습니까?")) return;

    let url = contextPath + "/admin/member/deleteList";
    
    // jQuery traditional: true를 사용해 배열을 백엔드 String[] memberIdxs로 정확히 전달
    $.ajax({
        type: "POST",
        url: url,
        data: { memberIdxs: memberIdxs },
        traditional: true,
        dataType: "json",
        success: function(data) {
            if (data.state === "true") {
                alert("성공적으로 삭제되었습니다.");
                location.reload();
            }
        }
    });
}