<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>내 정보 관리 | 쇼핑몰</title>

<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/mypage.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/my_info.css">

<script type="text/javascript">
	function updateMember() {
		const f = document.memberForm;

		// 1. 이름 병합: 성 + 이름 -> hidden 필드 'userName'에 할당
		const lastName = document.getElementById("last_name_customer").value
				.trim();
		const firstName = document.getElementById("first_name_customer").value
				.trim();

		if (!lastName || !firstName) {
			alert("이름을 모두 입력해주세요.");
			return;
		}
		f.userName.value = lastName + firstName; //

		// 2. 이메일 분리: 화면의 한 줄 입력을 email1, email2로 쪼개기 (백엔드 구조에 맞춤)
		const emailFull = document.getElementById("email_customer").value
				.trim();
		if (emailFull.includes("@")) {
			const parts = emailFull.split("@");
			f.email1.value = parts[0]; //
			f.email2.value = parts[1]; //
		} else {
			alert("올바른 이메일 형식을 입력해주세요.");
			return;
		}

		// 3. 비밀번호 확인: 컨트롤러에서 업데이트를 위해 필수적으로 체크함
		if (!f.userPwd.value) {
			alert("정보 수정을 위해 현재 비밀번호를 입력해주세요.");
			f.userPwd.focus();
			return;
		}

		// 4. 전송
		f.action = "${pageContext.request.contextPath}/member/update";
		f.submit();
	}

	function sendOTP() {
		document.getElementById("otp_sent_msg").classList.remove("hidden");
		document.getElementById("otp_input_row").classList.remove("hidden");
		alert("인증번호가 발송되었습니다.");
	}
</script>
</head>
<body>

	<jsp:include page="/WEB-INF/views/layout/header.jsp" />

	<div class="mypage-container">

		<aside class="sidebar">
			<h2>마이페이지</h2>
			<div class="menu-group">
				<span class="menu-title">구매내역</span>
				<ul>
					<li><a
						href="${pageContext.request.contextPath}/member/mypage/orderList">주문/배송조회</a></li>
					<li><a
						href="${pageContext.request.contextPath}/member/mypage/cancelList">취소조회</a></li>
				</ul>
			</div>
			<div class="menu-group">
				<span class="menu-title">혜택내역</span>
				<ul>
					<li><a
						href="${pageContext.request.contextPath}/member/mypage/review">상품
							리뷰</a></li>
					<li><a href="#">포인트/쿠폰</a></li>
				</ul>
			</div>
			<div class="menu-group">
				<span class="menu-title">상품내역</span>
				<ul>
					<li><a
						href="${pageContext.request.contextPath}/member/mypage/wishList">관심
							상품</a></li>
				</ul>
			</div>
			<div class="menu-group">
				<span class="menu-title">회원정보</span>
				<ul>
					<li><a
						href="${pageContext.request.contextPath}/member/mypage/myInfo"
						class="active">내 정보 관리</a></li>
					<li><a href="${pageContext.request.contextPath}/member/mypage/addr">배송지 관리</a></li>
					<li><a href="${pageContext.request.contextPath}/member/mypage/membership">회원등급</a></li>
				</ul>
			</div>
			<div class="menu-group">
				<ul>
					<li><a href="${pageContext.request.contextPath}/member/logout"
						style="color: #999;">로그아웃</a></li>
				</ul>
			</div>
		</aside>

		<main class="main-content">

			<h2 class="feature-header">내 정보 관리</h2>

			<div id="customer_detail"
				class="group sm-salomon__details cc-animate-init -in cc-animate-complete">

				<div class="customer__detailsForm">
					<form name="memberForm" method="post">
						<!-- 기존 hidden -->
						<input type="hidden" name="userName"> <input type="hidden"
							name="userId" value="${dto.userId}">

						<!-- ★ 추가: 이메일 분리용 hidden -->
						<input type="hidden" name="email1"> <input type="hidden"
							name="email2">

						<div class="input-row">
							<label class="info-label">아이디</label> <input type="text"
								value="${sessionScope.member.userId}" readonly>
						</div>

						<label class="info-label">이름</label>
						<div class="divided">
							<c:set var="uName" value="${sessionScope.member.userName}" />
							<input class="divided__input" type="text" placeholder="성"
								id="last_name_customer" value="${fn:substring(uName, 0, 1)}">
							<input class="divided__input" type="text" placeholder="이름"
								id="first_name_customer"
								value="${fn:substring(uName, 1, fn:length(uName))}" required>
						</div>

						<div class="input-row">
							<label class="info-label">생년월일</label> <input type="text"
								value="${dto.birth}" readonly> <input type="hidden"
								name="birth" value="${dto.birth}">
						</div>

						<div class="input-row">
							<label class="info-label">이메일주소</label>
							<!-- name="email" 없음 → JS에서 hidden(email1, email2)로 분해 -->
							<input aria-label="이메일" placeholder="이메일" type="email"
								id="email_customer" value="${dto.email}" size="40">
						</div>

						<div class="input-row">
							<label class="info-label">휴대폰번호</label>
							<div class="phone-field">
								<input type="tel" name="tel" value="${dto.tel}" maxlength="11"
									placeholder="01012341234">
								<button class="phone-field__send-code" type="button"
									onclick="sendOTP();">업데이트</button>
							</div>
							<div id="otp_sent_msg" class="otp-text hidden">인증번호가
								전송되었습니다.</div>
							<div class="phone-field hidden" id="otp_input_row"
								style="margin-top: 10px;">
								<input type="text" class="phone-field__input-code"
									placeholder="인증번호">
								<button class="phone-field__send-code" type="button">확인</button>
							</div>
						</div>

						<div class="input-row password-wrap">
							<label class="info-label">비밀번호</label>
							<div class="phone-field">
								<input type="password" name="userPwd"
									placeholder="현재 비밀번호를 입력하세요">
								<button type="button" class="btn" onclick="location.href='#';">재설정</button>
							</div>
						</div>

						<div class="input-row">
							<label class="info-label">성별</label>
							<div class="pretty-select">
								<select name="gender" id="gender_customer">
									<option value="0" ${dto.gender == 0 ? 'selected' : ''}>남성</option>
									<option value="1" ${dto.gender == 1 ? 'selected' : ''}>여성</option>
								</select>
								<svg fill="#000000" viewBox="0 0 24 24">
                <path
										d="M7.41 7.84L12 12.42l4.59-4.58L18 9.25l-6 6-6-6z" />
            </svg>
							</div>
						</div>

						<div class="checkbox-row">
							<input type="checkbox" id="email_consent" name="receiveEmail"
								value="1" ${dto.receiveEmail == 1 ? 'checked' : ''}> <label
								for="email_consent">이메일 수신에 동의합니다</label>
						</div>

						<div class="checkbox-row">
							<input type="checkbox" id="sms_consent" checked> <label
								for="sms_consent">SMS 수신에 동의합니다.</label>
						</div>

						<div class="wide-action">
							<button type="button" class="as-salomon__submit"
								onclick="updateMember();">저장</button>
						</div>
					</form>

				</div>
			</div>
		</main>
	</div>

	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
	<jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />

</body>
</html>