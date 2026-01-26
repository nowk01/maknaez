let currentInquiryNum = 0;

function getContextPath() {
	const hostIndex = location.href.indexOf(location.host) + location.host.length;
	const contextPath = location.href.substring(hostIndex, location.href.indexOf('/', hostIndex + 1));
	return contextPath === '/admin' || contextPath === '/cs' ? '' : contextPath;
}

function searchList() {
	document.searchForm.submit();
}

function openChat(num, element) {
	currentInquiryNum = num;
	const cp = getContextPath();

	const items = document.querySelectorAll('.inquiry-item');
	items.forEach(el => el.classList.remove('active'));
	if (element) {
		element.classList.add('active');
	}

	const emptyState = document.getElementById('emptyState');
	if (emptyState) emptyState.style.display = 'none';

	const chatView = document.getElementById('chatView');
	if (chatView) {
		chatView.classList.remove('d-none');
		chatView.style.display = 'flex'; 
	}

	const chatBody = document.getElementById('chatBody');
	const replyArea = document.getElementById('replyContent');
	chatBody.innerHTML = '<div class="text-center py-5"><div class="spinner-border text-primary"></div></div>';
	replyArea.value = "";
	replyArea.disabled = false;
	replyArea.placeholder = "답변 내용을 입력하세요...";


	$.ajax({
		type: "GET",
		url: cp + "/admin/cs/inquiry_detail",
		data: { num: num },
		dataType: "json",
		success: function(data) {
			chatBody.innerHTML = ""; 

			if (data.status === "success") {
				document.getElementById('chatTitle').innerText = data.subject;
				document.getElementById('chatUser').innerText = data.userName + " (" + data.reg_date + ")";

				let userHtml = `
				            <div class="message-row user">
				                <div class="message-bubble">
				                    ${data.content.replace(/\n/g, "<br>")}
				                    
				                    ${data.saveFilename ? `
				                        <div class="file-attachment" style="margin-top: 15px; padding: 10px; background: rgba(0,0,0,0.05); border-radius: 8px;">
				                            <div style="font-size: 12px; color: #666; margin-bottom: 5px;">첨부파일</div>
				                            ${/\.(jpg|jpeg|png|gif)$/i.test(data.saveFilename) ?
							`<img src="${cp}/uploads/board/${data.saveFilename}" style="max-width: 100%; border-radius: 5px; cursor: pointer;" onclick="window.open(this.src)">` :
							`<i class="bi bi-file-earmark-arrow-down"></i>`
						}
				                            <div style="margin-top: 5px;">
				                                <a href="${cp}/uploads/board/${data.saveFilename}" download="${data.originalFilename}" style="text-decoration: none; font-size: 13px; color: #007bff;">
				                                    <i class="bi bi-download"></i> ${data.originalFilename}
				                                </a>
				                            </div>
				                        </div>
				                    ` : ''}
				                </div>
				                <span class="message-time">${data.reg_date}</span>
				            </div>`;

				chatBody.insertAdjacentHTML('beforeend', userHtml);

				// [관리자 답변 출력]
				if (data.replyContent && data.replyContent.trim() !== "") {
					let adminHtml = `
                        <div class="message-row admin">
                            <span class="message-time">${data.replyDate || ''}</span>
                            <div class="message-bubble">${data.replyContent.replace(/\n/g, "<br>")}</div>
                        </div>`;
					chatBody.insertAdjacentHTML('beforeend', adminHtml);
					replyArea.placeholder = "이전 답변이 존재합니다. 수정 시 내용을 입력하세요.";
				}

				setTimeout(() => {
					chatBody.scrollTop = chatBody.scrollHeight;
				}, 100);

			} else if (data.status === "permission_denied") {
				alert("관리자 권한이 만료되었습니다. 다시 로그인해주세요.");
				location.href = cp + "/member/login";
			}
		},
		error: function() {
			alert("상세 데이터를 불러오지 못했습니다. 경로를 확인하세요.");
		}
	});
}

// 답변 등록 
function sendReply() {
	const replyContent = document.getElementById('replyContent').value.trim();
	const cp = getContextPath();

	if (!currentInquiryNum) {
		alert("선택된 문의가 없습니다.");
		return;
	}

	if (!replyContent) {
		alert("답변 내용을 입력해주세요.");
		return;
	}

	if (!confirm("답변을 등록(수정)하시겠습니까?")) return;

	$.ajax({
		type: "POST",
		url: cp + "/admin/cs/inquiry_reply",
		data: { num: currentInquiryNum, replyContent: replyContent },
		dataType: "json",
		success: function(data) {
			if (data.status === "success") {
				alert("답변이 정상적으로 처리되었습니다.");
				location.reload();
			} else {
				alert("답변 등록 실패: " + data.status);
			}
		},
		error: function() {
			alert("통신 오류가 발생했습니다.");
		}
	});
}