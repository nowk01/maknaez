<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>CREATE ACCOUNT | MAKNAEZ</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<style>
/* 1. 글로벌 스타일: 살로몬 특유의 묵직하고 강렬한 무드 */
.signup-container {
	max-width: 440px;
	margin: 120px auto 100px;
	padding: 0 25px;
	font-family: 'Inter', 'Pretendard', sans-serif;
	color: #000;
}

.signup-header {
	margin-bottom: 60px;
	border-left: 6px solid #000; /* 살로몬 포인트 라인 */
	padding-left: 20px;
}

.signup-header h2 {
	font-size: 28px;
	font-weight: 900;
	letter-spacing: -0.5px;
	margin: 0;
	line-height: 1;
}

/* 2. 필드 레이아웃: 장식을 뺀 테크니컬 구조 */
.form-group {
	margin-bottom: 35px;
	position: relative;
}

.form-label {
	font-weight: 800;
	font-size: 11px;
	color: #000;
	margin-bottom: 12px;
	display: flex;
	align-items: center;
	gap: 8px;
}

.form-label::after {
	content: "";
	flex: 1;
	height: 1px;
	background: #eee;
}

/* 3. 입력창 스타일: 면이 아닌 선의 미학 */
.input-row {
	display: flex;
	align-items: center;
	gap: 0;
	border-bottom: 1px solid #e5e5e5;
	transition: all 0.3s;
}

.input-row:focus-within {
	border-bottom-color: #000;
}

.input-minimal {
	flex: 1;
	border: none;
	outline: none;
	padding: 12px 0;
	font-size: 15px;
	font-weight: 500;
	background: transparent;
	width: 100%;
	color: #000;
}

/* 4. 중복확인 / 주소검색 버튼: 살로몬의 유틸리티 버튼 감성 */
.btn-utility {
	background: #000;
	color: #fff;
	border: none;
	padding: 6px 14px;
	font-size: 11px;
	font-weight: 700;
	cursor: pointer;
	margin-left: 10px;
	border-radius: 0;
	white-space: nowrap;
	height: 30px;
	transition: background 0.2s;
}

.btn-utility:hover {
	background: #333;
}

/* 5. 전화번호: 3칸 분할 & 묵직한 하이픈 */
.tel-wrap {
	display: flex;
	align-items: center;
	width: 100%;
}

.tel-part {
	flex: 1;
	text-align: center;
	font-weight: 600;
}

.tel-sep {
	width: 20px;
	text-align: center;
	color: #ddd;
	font-weight: 300;
}

/* 6. 성별 선택: 강렬한 대비 */
.gender-wrap {
	display: flex;
	gap: 20px;
}

.gender-chip {
	flex: 1;
	position: relative;
}

.gender-chip input {
	position: absolute;
	opacity: 0;
}

.gender-chip label {
	display: block;
	border: 1px solid #e5e5e5;
	padding: 12px;
	text-align: center;
	font-size: 12px;
	font-weight: 700;
	cursor: pointer;
	transition: 0.2s;
}

.gender-chip input:checked+label {
	background: #000;
	color: #fff;
	border-color: #000;
}

/* 7. 최종 제출 버튼: 압도적 볼드함 */
.btn-submit-all {
	width: 100%;
	height: 65px;
	background: #000;
	color: #fff;
	border: none;
	font-size: 15px;
	font-weight: 900;
	letter-spacing: 2px;
	margin-top: 50px;
	cursor: pointer;
	text-transform: uppercase;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 15px;
}

.btn-submit-all:hover {
	background: #1a1a1a;
}

.status-msg {
	font-size: 10px;
	font-weight: 600;
	margin-top: 6px;
	position: absolute;
	display: none; /* 기본적으로 숨김 */
}
</style>
</head>
<body>

	<jsp:include page="/WEB-INF/views/layout/header.jsp" />

	<div class="signup-container">
		<div class="signup-header">
			<h2>계정 생성</h2>
			<p style="font-size: 12px; color: #888; margin-top: 8px;">SIGN UP
				FOR MAKNAEZ</p>
		</div>

		<form name="memberForm"
			action="${pageContext.request.contextPath}/member/account"
			method="post" enctype="multipart/form-data">

			<div class="form-group">
				<label class="form-label">아이디 ID</label>
				<div class="input-row">
					<input type="text" name="userId" id="userId" class="input-minimal"
						placeholder="아이디를 입력하세요" required="required">
					<button type="button" class="btn-utility" onclick="checkId();">중복확인</button>
				</div>
				<p id="idMsg" class="status-msg"></p>
			</div>

			<div class="form-group">
				<label class="form-label">비밀번호 PASSWORD</label>
				<div class="input-row">
					<input type="password" name="userPwd" class="input-minimal"
						placeholder="영문, 숫자 포함 8자 이상" required="required">
				</div>
			</div>

			<div class="form-group">
				<label class="form-label">성별 GENDER</label>
				<div class="gender-wrap">
					<div class="gender-chip">
						<input type="radio" name="gender" value="male" id="g-male"
							checked="checked"> <label for="g-male">남성 MALE</label>
					</div>
					<div class="gender-chip">
						<input type="radio" name="gender" value="female" id="g-female">
						<label for="g-female">여성 FEMALE</label>
					</div>
				</div>
			</div>

			<div class="form-group">
				<label class="form-label">이름 NAME / 닉네임 NICKNAME</label>
				<div class="input-row" style="margin-bottom: 15px;">
					<input type="text" name="userName" class="input-minimal"
						placeholder="실명을 입력하세요" required="required">
				</div>
				<div class="input-row">
					<input type="text" name="nickName" id="nickName"
						class="input-minimal" placeholder="닉네임을 입력하세요" required="required">
					<button type="button" class="btn-utility"
						onclick="checkNickName();">중복확인</button>
				</div>
				<p id="nickMsg" class="status-msg"></p>
			</div>

			<div class="form-group">
				<label class="form-label">생년월일 BIRTHDAY</label>
				<div class="input-row">
					<input type="text" name="birth" class="input-minimal"
						placeholder="YYYYMMDD (예: 19950101)" maxlength="8"
						required="required">
				</div>
			</div>

			<div class="form-group">
				<label class="form-label">이메일 EMAIL</label>
				<div style="display: flex; align-items: center;">
					<div class="input-row" style="flex: 1;">
						<input type="text" name="email1" class="input-minimal"
							required="required">
					</div>
					<span style="padding: 0 8px; font-size: 14px; color: #ddd;">@</span>
					<div class="input-row" style="flex: 1;">
						<input type="text" name="email2" id="email2" class="input-minimal"
							required="required">
					</div>
					<select class="input-minimal"
						style="width: 100px; flex: none; font-size: 11px; margin-left: 10px; border-bottom: 1px solid #e5e5e5;"
						onchange="document.getElementById('email2').value=this.value;">
						<option value="">직접입력</option>
						<option value="naver.com">naver.com</option>
						<option value="gmail.com">gmail.com</option>
					</select>
				</div>
			</div>

			<div class="form-group">
				<label class="form-label">휴대전화 PHONE</label>
				<div class="tel-wrap">
					<div class="input-row tel-part">
						<input type="text" name="tel1" class="input-minimal"
							style="text-align: center;" maxlength="3" value="010">
					</div>
					<span class="tel-sep">-</span>
					<div class="input-row tel-part">
						<input type="text" name="tel2" class="input-minimal"
							style="text-align: center;" maxlength="4">
					</div>
					<span class="tel-sep">-</span>
					<div class="input-row tel-part">
						<input type="text" name="tel3" class="input-minimal"
							style="text-align: center;" maxlength="4">
					</div>
				</div>
			</div>

			<div class="form-group">
				<label class="form-label">주소 ADDRESS</label>
				<div class="input-row" style="margin-bottom: 15px;">
					<input type="text" name="zip" id="zip" class="input-minimal"
						readonly="readonly" placeholder="우편번호">
					<button type="button" class="btn-utility" onclick="daumPostcode();">주소찾기</button>
				</div>
				<div class="input-row" style="margin-bottom: 15px;">
					<input type="text" name="addr1" id="addr1" class="input-minimal"
						readonly="readonly" placeholder="기본주소">
				</div>
				<div class="input-row">
					<input type="text" name="addr2" id="addr2" class="input-minimal"
						placeholder="상세주소 입력">
				</div>
			</div>

			<button type="button" class="btn-submit-all" onclick="submitForm();">
				회원가입 완료 CREATE ACCOUNT</button>
		</form>
	</div>

	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

	<script
		src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
    let isIdChecked = false;
    let isNickChecked = false;

    function checkId() {
        const userId = document.getElementById('userId').value;
        const msgEl = document.getElementById('idMsg');
        if(!userId || userId.trim().length < 4) { alert("아이디를 4자 이상 입력하세요."); return; }

        fetch('${pageContext.request.contextPath}/member/userIdCheck', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'userId=' + encodeURIComponent(userId)
        })
        .then(res => res.json())
        .then(data => {
            msgEl.style.display = 'block';
            if(data.passed === true || data.passed === 'true') {
                msgEl.innerText = "사용 가능한 아이디입니다.";
                msgEl.style.color = "blue";
                isIdChecked = true;
            } else {
                msgEl.innerText = "이미 사용중인 아이디입니다.";
                msgEl.style.color = "#ff4d4d";
                isIdChecked = false;
            }
        })
        .catch(err => {
            console.error(err);
            alert("아이디 중복확인 중 오류가 발생했습니다.");
        });
    }

    function checkNickName() {
        const nickNameEl = document.getElementById('nickName');
        const msgEl = document.getElementById('nickMsg');
        
        // 유효성 검사
        if(!nickNameEl.value || nickNameEl.value.trim().length < 2) { 
            alert("닉네임을 2자 이상 입력하세요."); 
            return; 
        }

        const nickName = nickNameEl.value.trim();

        // 서버 요청
        fetch('${pageContext.request.contextPath}/member/nickNameCheck', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'nickName=' + encodeURIComponent(nickName)
        })
        .then(res => res.json()) // 이제 서버가 JSON을 확실히 보내므로 바로 변환
        .then(data => {
            msgEl.style.display = 'block';
            
            // 서버에서 보낸 {"passed": true/false} 처리
            if(data.passed === true || data.passed === 'true') {
                msgEl.innerText = "사용 가능한 닉네임입니다.";
                msgEl.style.color = "blue"; 
                isNickChecked = true;
            } else {
                msgEl.innerText = "이미 사용중인 닉네임입니다.";
                msgEl.style.color = "#ff4d4d";
                isNickChecked = false;
            }
        })
        .catch(err => {
            console.error("닉네임 확인 에러:", err);
            alert("닉네임 중복확인 중 오류가 발생했습니다.");
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

        // 1. 아이디 및 닉네임 중복 확인 체크
        if(!isIdChecked) { alert("아이디 중복확인을 완료해주세요."); return; }
        if(!isNickChecked) { alert("닉네임 중복확인을 완료해주세요."); return; }
        
        // 2. 비밀번호 체크
        if(!f.userPwd.value.trim()) { alert("비밀번호를 입력하세요."); f.userPwd.focus(); return; }
        
        // 3. 성별 체크
        const gender = f.gender;
        let genderChecked = false;
        for(let i=0; i<gender.length; i++) {
            if(gender[i].checked) {
                genderChecked = true;
                break;
            }
        }

        if(!genderChecked) {
            alert("성별을 선택해주세요.");
            return;
        }

        // 4. 이름 체크
        if(!f.userName.value.trim()) { alert("이름을 입력하세요."); f.userName.focus(); return; }

        // 5. 생년월일 체크
        if(!f.birth.value.trim()) { 
            alert("생년월일을 입력하세요."); 
            f.birth.focus(); 
            return; 
        }
        if(f.birth.value.length !== 8) {
            alert("생년월일은 8자리 숫자로 입력해주세요. (예: 19950101)");
            f.birth.focus();
            return;
        }

        // 6. 이메일 체크
        if(!f.email1.value.trim() || !f.email2.value.trim()) {
            alert("이메일을 입력하세요.");
            f.email1.focus();
            return;
        }
        
    	// 7. 전화번호 체크 추가
        if(!f.tel1.value.trim() || !f.tel2.value.trim() || !f.tel3.value.trim()) {
            alert("전화번호를 모두 입력해주세요.");
            if(!f.tel1.value.trim()) f.tel1.focus();
            else if(!f.tel2.value.trim()) f.tel2.focus();
            else f.tel3.focus();
            return;
        }

        // 전화번호 자리수 체크
        if(f.tel2.value.length < 3 || f.tel3.value.length < 4) {
            alert("전화번호 형식이 올바르지 않습니다.");
            f.tel2.focus();
            return;
        }
        
        // 8. 주소 체크
        if(!f.zip.value || !f.addr1.value) {
    	alert("주소 찾기를 통해 주소를 입력해주세요.");
    	return;
		}
        
        f.submit();
    }
</script>
</body>
</html>