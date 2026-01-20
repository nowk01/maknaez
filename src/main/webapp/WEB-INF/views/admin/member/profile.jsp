<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>System Control - Administrator Profile</title>
<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />

<style>
/* [System Control Panel 디자인 - 사용자님 Pick] */

/* 1. 기본 배경 및 폰트 */
body {
	background-color: #f5f6f8;
	color: #202224;
	font-family: 'Pretendard', sans-serif;
}

/* 2. 컨텐츠 컨테이너 (표준 레이아웃용 클래스) */
.content-container {
	padding: 50px 60px;
	min-height: 100vh;
	animation: fadeIn 0.5s ease-out;
}

@
keyframes fadeIn {from { opacity:0;
	transform: translateY(10px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}

/* 3. HUD 스타일 타이틀 */
.system-header {
	display: flex;
	align-items: center;
	margin-bottom: 30px;
	border-bottom: 1px solid #e0e0e0;
	padding-bottom: 20px;
}

.system-badge {
	background: #111;
	color: #ff4e00;
	font-size: 11px;
	font-weight: 800;
	padding: 5px 12px;
	letter-spacing: 1px;
	margin-right: 15px;
	text-transform: uppercase;
}

.system-title {
	font-size: 24px;
	font-weight: 800;
	color: #111;
	letter-spacing: -0.5px;
	margin-right: auto;
}

.system-status {
	font-size: 12px;
	font-family: 'Consolas', monospace;
	color: #666;
}

.status-dot {
	color: #23a55a;
	animation: blink 2s infinite;
}

.status-dot.offline { 
    color: #ff0000; 
    animation: none;
    text-shadow: 0 0 5px rgba(255, 0, 0, 0.5); 
}

@keyframes blink {
  0% {
    opacity: 1;
  }
  50% {
    opacity: 0.4;
  }
  100% {
    opacity: 1;
  }
}

/* 4. 마스터 카드 (상하 분할 디자인) */
.master-card {
	display: flex;
	flex-direction: column; /* 상하 배치 */
	background: #fff;
	box-shadow: 0 5px 30px rgba(0, 0, 0, 0.03);
	border: 1px solid #ebebeb;
	min-height: 600px;
}

/* [상단] 와이드 블랙 패널 */
.panel-dark {
	background: #1a1a1c;
	color: #fff;
	padding: 40px 50px;
	display: flex;
	justify-content: space-between;
	align-items: center;
	position: relative;
	overflow: hidden;
}
/* 오렌지 라인 포인트 */
.panel-dark::before {
	content: '';
	position: absolute;
	bottom: 0;
	left: 0;
	width: 100%;
	height: 4px;
	background: #ff4e00;
}

.profile-visual {
	display: flex;
	align-items: center;
	gap: 20px;
}

.img-box {
	width: 70px;
	height: 70px;
	background: #252526;
	border: 1px solid #333;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 30px;
	color: #fff;
}

.user-info {
	display: flex;
	flex-direction: column;
}

.user-id {
	font-size: 20px;
	font-weight: 700;
	color: #fff;
	margin-bottom: 3px;
}

.user-level {
	font-size: 11px;
	color: #ff4e00;
	font-weight: 800;
	letter-spacing: 1.5px;
	text-transform: uppercase;
}

/* 로그 영역 */
.log-area {
	text-align: right;
	border-left: 1px solid #333;
	padding-left: 40px;
}

.log-title {
	margin-bottom: 5px;
	font-weight: 700;
	color: #fff;
	text-transform: uppercase;
	font-size: 11px;
}

.log-row {
	font-size: 12px;
	color: #888;
	margin-bottom: 2px;
}

.log-data {
	color: #ccc;
	font-family: 'Consolas', monospace;
}

.log-status {
	margin-top: 5px;
	color: #23a55a;
	font-size: 12px;
	font-weight: 600;
}

/* [하단] 와이드 화이트 폼 */
.panel-light {
	flex: 1;
	padding: 60px 80px;
}

.form-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 50px;
	margin-bottom: 40px;
}

.input-wrap {
	display: flex;
	flex-direction: column;
	gap: 10px;
}

.label-st {
	font-size: 11px;
	font-weight: 800;
	color: #aaa;
	text-transform: uppercase;
	letter-spacing: 0.5px;
}

/* 인풋 디자인 (밑줄형 - 사용자 선호) */
.input-st {
	border: none;
	border-bottom: 1px solid #ddd;
	padding: 10px 0;
	font-size: 15px;
	color: #111;
	background: transparent;
	transition: 0.3s;
	border-radius: 0;
}

.input-st:focus {
	border-bottom-color: #ff4e00;
	outline: none;
}

.input-st.readonly {
	color: #bbb;
	border-bottom-color: #eee;
	cursor: not-allowed;
}

/* 버튼 영역 */
.btn-group-st {
	margin-top: 80px;
	display: flex;
	justify-content: flex-end;
	gap: 10px;
}

.btn-core {
	height: 45px;
	padding: 0 40px;
	font-size: 13px;
	font-weight: 700;
	cursor: pointer;
	border: none;
	text-transform: uppercase;
	transition: 0.2s;
}

.btn-save {
	background: #111;
	color: #fff;
}

.btn-save:hover {
	background: #ff4e00;
}

.btn-cancel {
	background: #fff;
	color: #999;
	border: 1px solid #ddd;
}

.btn-cancel:hover {
	color: #333;
	border-color: #999;
}
</style>
</head>
<body>

	<div id="wrapper">

		<jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

		<div id="page-content-wrapper">
			<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

			<div class="content-container">

				<div class="system-header">
					<span class="system-badge">System Config</span> <span
						class="system-title">Administrator Profile</span>
					<div class="system-status">
						SERVER CONNECTED <span class="status-dot">●</span>
					</div>
				</div>

				<div class="master-card">

					<div class="panel-dark">
						<div class="profile-visual">
							<div class="img-box">
								<i class="fas fa-user-astronaut"></i>
							</div>
							<div class="user-info">
								<div class="user-level">Master Admin</div>
								<div class="user-id">${sessionScope.member.userName}</div>
							</div>
						</div>

						<div class="log-area">
							<div class="log-title">System Status Monitor</div>
							<div class="log-row">
								Last Login Log: <span class="log-data" style="color: #ff4e00;">
									${sessionScope.lastLoginLog} </span>
							</div>
							<div class="log-row">
								Access IP: <span class="log-data" style="color: #23a55a;">
									${sessionScope.lastLoginIP} </span>
							</div>
							<div class="log-status">
								<i id="statusIcon" class="fas fa-satellite-dish status-dot"></i>
								<span id="networkStatus">Online</span>
							</div>
						</div>
					</div>

					<div class="panel-light">
						<form
							action="${pageContext.request.contextPath}/admin/member/updateProfile"
							method="post">

							<div class="form-grid">
								<div class="input-wrap">
									<label class="label-st">System Access ID</label> <input
										type="text" class="input-st readonly"
										value="${sessionScope.member.userId}" readonly>
								</div>
								<div class="input-wrap">
									<label class="label-st">Admin Name</label> <input type="text"
										name="userName" class="input-st"
										value="${sessionScope.member.userName}" required>
								</div>
								<div class="input-wrap">
									<label class="label-st">New Password</label> <input
										type="password" name="userPwd" class="input-st"
										placeholder="변경할 경우에만 입력하세요">
								</div>
								<div class="input-wrap">
									<label class="label-st">Emergency Contact</label> <input
										type="text" name="tel" class="input-st" value="${dto.tel}"
										placeholder="010-0000-0000">
								</div>
							</div>
							<div class="btn-group-st">
								<button type="button" class="btn-core btn-cancel"
									onclick="history.back();">Discard</button>
								<button type="submit" class="btn-core btn-save">Update
									System</button>
							</div>

						</form>
					</div>

				</div>
			</div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
	<script>
		$(document).ready(function() {
			const urlParams = new URLSearchParams(window.location.search);

			if (urlParams.get('result') === 'ok') {
				// 1. 알림창 띄우기
				alert("관리자 정보가 성공적으로 수정되었습니다.");

				// 2. 주소창에서 '?result=ok' 글씨 없애기 (새로고침 시 알림 반복 방지)
				const cleanUrl = window.location.pathname;
				window.history.replaceState({}, document.title, cleanUrl);
			}
		});

		function updateSystemClock() {
			const now = new Date();
			const year = now.getFullYear();
			const month = String(now.getMonth() + 1).padStart(2, '0');
			const day = String(now.getDate()).padStart(2, '0');
			const hours = String(now.getHours()).padStart(2, '0');
			const minutes = String(now.getMinutes()).padStart(2, '0');
			const seconds = String(now.getSeconds()).padStart(2, '0');

			const timeString = `${year}.${month}.${day} ${hours}:${minutes}:${seconds} (KST)`;

			const clockElement = document.getElementById('realTimeClock');
			if (clockElement) {
				clockElement.innerText = timeString;
			}
		}

		setInterval(updateSystemClock, 1000);
		updateSystemClock();

		function updateConnectionStatus() {
			const statusText = document.getElementById('networkStatus');
			const statusIcon = document.getElementById('statusIcon');

			if (!statusText || !statusIcon)
				return;

			if (navigator.onLine) {
				// 온라인 상태
				statusText.innerText = "System Online";
				statusText.style.color = "#23a55a"; // 초록색 텍스트
				statusIcon.className = "fas fa-satellite-dish status-dot"; // 초록불 깜빡임
			} else {
				// 오프라인 상태 (인터넷 끊김)
				statusText.innerText = "Connection Lost";
				statusText.style.color = "#ff0000"; // 빨간색 텍스트
				statusIcon.className = "fas fa-satellite-dish status-dot offline"; // 빨간불 정지
			}
		}

		// 상태가 바뀔 때마다 즉시 실행 (이벤트 리스너)
		window.addEventListener('online', updateConnectionStatus);
		window.addEventListener('offline', updateConnectionStatus);

		// 페이지 로드 시 최초 1회 실행
		updateConnectionStatus();
	</script>
</body>
</html>