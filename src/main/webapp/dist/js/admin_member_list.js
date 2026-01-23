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


function openMemberModal(mode, memberIdx) {
    // 1. 모달 및 폼 엘리먼트 준비 
    const modalEl = document.getElementById('memberModal');
    const myModal = bootstrap.Modal.getOrCreateInstance(modalEl);
    const form = document.getElementById("memberForm");

    // 폼 초기화 
    form.reset();
    document.getElementById("modalMode").value = "update";

    // 2. 서버 데이터 요청 ($.ajax 사용으로 안정성 확보) 
    $.ajax({
        url: contextPath + "/admin/member/detail",
        type: "GET",
        data: { memberIdx: memberIdx }, // 서버 컨트롤러에서 memberIdx로 받도록 설정 확인 필요
        dataType: "json",
        success: function(data) {
            // 서버 응답 상태 확인 
            if (data && (data.state === "true" || data.state === true)) {
                const d = data.dto;
                
                // 3. 쿼리 결과(MemberDTO) 데이터를 폼에 바인딩 [cite: 1, 3]
                document.getElementById("modalMemberIdx").value = d.memberIdx;
                document.getElementById("userId").value = d.userId;
				document.getElementById("userPwd").value = d.userPwd;
                document.getElementById("userName").value = d.userName;
                document.getElementById("nickName").value = d.nickName || "";
                document.getElementById("email").value = d.email || "";
                document.getElementById("tel").value = d.tel || "";
                document.getElementById("enabled").value = d.enabled;
				
				let levelValue = "1"; // 기본값 IRON
				const level = d.userLevel;

				if (level >= 99) {
				    levelValue = "99"; // MASTER
				} else if (level >= 51) {
				    levelValue = "51"; // ADMIN
				} else if (level >= 41) {
				    levelValue = "41"; // PLATINUM
				} else if (level >= 31) {
				    levelValue = "31"; // GOLD
				} else if (level >= 21) {
				    levelValue = "21"; // SILVER
				} else if (level >= 11) {
				    levelValue = "11"; // BRONZE
				} else {
				    levelValue = "1";  // IRON
				}
				
				document.getElementById("modalUserLevel").value = levelValue;
				
                // 성별 세팅 (0: 남자, 1: 여자) 
                if (d.gender !== undefined) {
                    document.getElementById("gender").value = d.gender;
                }

                // 생년월일 세팅 (findById 쿼리에서 TO_CHAR로 변환된 값 활용) [cite: 1, 3]
                if (d.birth) {
                    // YYYY-MM-DD 형식으로 정확히 들어오는지 확인 후 삽입
                    document.getElementById("birth").value = d.birth;
                }

                // 4. 데이터 로드 완료 후 모달 표시 
                myModal.show();
            } else {
                alert("회원 정보를 불러오는 데 실패했습니다.");
            }
        },
        error: function(xhr, status, error) {
            console.error("Detail AJAX Error:", error);
            alert("서버와 통신 중 오류가 발생했습니다. 관리자에게 문의하세요.");
        }
    });
}
function submitMember() {
	const f = document.getElementById("memberForm");
	// birth 필드 체크 추가
	if (!f.userName.value || !f.birth.value) {
		alert("이름과 생년월일은 필수 입력 항목입니다.");
		return;
	}

	let url = contextPath + "/admin/member/update";
	ajaxRequest(url, "POST", $(f).serialize(), "json", function(data) {
		if (data.state === "true") {
			alert("수정이 완료되었습니다.");
			location.reload();
		} else {
			alert("작업에 실패했습니다.");
		}
	});
}

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