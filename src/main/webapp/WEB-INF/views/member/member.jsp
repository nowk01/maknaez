<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>회원가입 | MAKNAEZ</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/my_info.css">
<style>
.signup-container {
    max-width: 600px;
    margin: 120px auto 80px; 
    padding: 0 20px;
}

.form-group {
    margin-bottom: 25px;
}

.form-label {
	font-weight: 600;
	margin-bottom: 8px;
	display: block;
	font-size: 14px;
}

.input-control {
	width: 100%;
	height: 50px;
	border: 1px solid #ddd;
	padding: 0 15px;
	border-radius: 4px;
}

.email-group {
	display: flex;
	gap: 10px;
	align-items: center;
}

.btn-check {
	background: #000;
	color: #fff;
	border: none;
	padding: 0 20px;
	height: 50px;
	border-radius: 4px;
	cursor: pointer;
	white-space: nowrap;
}

.btn-submit {
	width: 100%;
	height: 55px;
	background: #000;
	color: #fff;
	border: none;
	border-radius: 30px;
	font-weight: 700;
	font-size: 16px;
	margin-top: 40px;
	cursor: pointer;
}

.msg-error {
	color: #e74c3c;
	font-size: 12px;
	margin-top: 5px;
	display: none;
}
/* 성별 라디오 버튼 스타일 */
.gender-group {
	display: flex;
	gap: 30px;
	align-items: center;
	padding-top: 5px;
}

.gender-item {
	display: flex;
	align-items: center;
	gap: 8px;
	cursor: pointer;
	font-weight: 400;
}

.gender-item input[type="radio"] {
	width: 18px;
	height: 18px;
	accent-color: #000;
}
</style>
</head>
<body>

	<jsp:include page="/WEB-INF/views/layout/header.jsp" />

	<div class="signup-container">
		<h2 class="text-center mb-5" style="font-weight: 700;">회원가입</h2>

		<form name="memberForm"
			action="${pageContext.request.contextPath}/member/account"
			method="post">

			<div class="form-group">
				<label class="form-label">아이디</label>
				<div class="d-flex gap-2">
					<input type="text" name="userId" id="userId" class="input-control"
						placeholder="아이디 입력" required>
					<button type="button" class="btn-check" onclick="checkId();">중복확인</button>
				</div>
				<p id="idMsg" class="msg-error"></p>
			</div>

			<div class="form-group">
				<label class="form-label">닉네임</label> <input type="text"
					name="nickName" id="nickName" class="input-control"
					placeholder="닉네임 입력" required>
			</div>

			<div class="form-group">
				<label class="form-label">비밀번호</label> <input type="password"
					name="userPwd" id="userPwd" class="input-control"
					placeholder="영문, 숫자 포함 8자 이상" required>
			</div>

			<div class="form-group">
				<label class="form-label">성별</label>
				<div class="gender-group">
					<label class="gender-item"> <input type="radio"
						name="gender" value="male" checked> 남성
					</label> <label class="gender-item"> <input type="radio"
						name="gender" value="female"> 여성
					</label>
				</div>
			</div>

			<div class="form-group">
				<label class="form-label">이름</label> <input type="text"
					name="userName" class="input-control" placeholder="이름을 입력하세요"
					required>
			</div>

			<div class="form-group">
				<label class="form-label">생년월일</label> <input type="text"
					name="birth" class="input-control" placeholder="예: 19990101"
					required>
			</div>

			<div class="form-group">
				<label class="form-label">이메일 주소</label>
				<div class="email-group">
					<input type="text" name="email1" class="input-control" required>
					<span>@</span> <input type="text" name="email2" id="email2"
						class="input-control" required> <select
						class="input-control"
						onchange="document.getElementById('email2').value=this.value;">
						<option value="">직접입력</option>
						<option value="naver.com">naver.com</option>
						<option value="gmail.com">gmail.com</option>
						<option value="daum.net">daum.net</option>
					</select>
				</div>
			</div>

			<div class="form-group">
				<label class="form-label">휴대전화</label> <input type="tel" name="tel"
					class="input-control" placeholder="'-' 제외하고 입력" required>
			</div>

			<div class="form-group">
				<label class="form-label">주소</label>
				<div class="d-flex gap-2 mb-2">
					<input type="text" name="zip" id="zip" class="input-control"
						readonly>
					<button type="button" class="btn-check" onclick="daumPostcode();">우편번호</button>
				</div>
				<input type="text" name="addr1" id="addr1"
					class="input-control mb-2" readonly placeholder="기본주소"> <input
					type="text" name="addr2" id="addr2" class="input-control"
					placeholder="상세주소 입력">
			</div>

			<button type="button" class="btn-submit" onclick="submitForm();">가입하기</button>

			<c:if test="${not empty message}">
				<p class="text-danger text-center mt-3">${message}</p>
			</c:if>
		</form>
	</div>

	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

	<script
		src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
    function checkId() {
        const userId = document.getElementById('userId').value;
        if(!userId) return;

        fetch('${pageContext.request.contextPath}/member/userIdCheck', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'userId=' + userId
        })
        .then(response => response.json())
        .then(data => {
            const msgEl = document.getElementById('idMsg');
            msgEl.style.display = 'block';
            if(data.passed === 'true') {
                msgEl.innerText = '사용 가능한 아이디입니다.';
                msgEl.style.color = '#2ecc71';
            } else {
                msgEl.innerText = '이미 사용 중인 아이디입니다.';
                msgEl.style.color = '#e74c3c';
            }
        });
    }

    function daumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                document.getElementById('zip').value = data.zonecode;
                document.getElementById('addr1').value = data.address;
                document.getElementById('addr2').focus();
            }
        }).open();
    }

    function submitForm() {
        const f = document.memberForm;
        if(!f.userId.value) return;
        f.submit();
    }
</script>

</body>
</html>