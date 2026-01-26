<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>

<style>
:root {
	--sb-width: 260px;
	--hdr-height: 70px;
	--hdr-bg: rgba(255, 255, 255, 0.95);
	--hdr-border: 1px solid #e1e1e1;
}

html, body {
	margin: 0;
	padding: 0;
	width: 100%;
	overflow-x: hidden;
}

body {
	padding-top: var(--hdr-height) !important;
	padding-left: var(--sb-width);
	background-color: #f5f6f8;
	transition: padding-left 0.3s ease;
}

body.header-wide {
	padding-left: 0 !important;
}

.top-navbar {
	height: var(--hdr-height);
	position: fixed !important;
	top: 0 !important;
	left: var(--sb-width) !important;
	width: calc(100% - var(--sb-width)) !important;
	background-color: var(--hdr-bg);
	border-bottom: var(--hdr-border);
	z-index: 1000;
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 0 30px;
	box-sizing: border-box;
	transition: left 0.3s ease, width 0.3s ease;
}

body.header-wide .top-navbar {
	left: 0 !important;
	width: 100% !important;
}

.nav-left {
	display: flex;
	align-items: center;
	gap: 15px;
	z-index: 20;
}

#sidebar-toggle {
	background: none;
	border: none;
	font-size: 1.2rem;
	color: #555;
	cursor: pointer;
	padding: 5px;
}

.page-now {
	font-size: 1rem;
	font-weight: 700;
	color: #333;
	white-space: nowrap;
}

.nav-right {
	display: flex;
	align-items: center;
	gap: 20px;
	z-index: 20;
}

.notification-wrapper {
	position: relative;
}

.icon-btn {
	position: relative;
	width: 36px;
	height: 36px;
	display: flex;
	align-items: center;
	justify-content: center;
	color: #555;
	font-size: 1.1rem;
	cursor: pointer;
	border-radius: 50%;
	transition: background 0.2s;
}

.icon-btn:hover {
	background: rgba(0, 0, 0, 0.05);
	color: #000;
}

#alarm-dot {
	position: absolute;
	top: 8px;
	right: 8px;
	width: 6px;
	height: 6px;
	background: #ff4e00;
	border-radius: 50%;
	box-shadow: 0 0 0 1.5px #fff;
}

.noti-dropdown {
	display: none;
	position: absolute;
	top: 50px;
	right: -10px;
	width: 320px;
	background: #fff;
	border-radius: 16px;
	box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
	border: 1px solid #f0f0f0;
	z-index: 2000;
	overflow: hidden;
	animation: slideDown 0.2s ease-out;
}

.noti-dropdown.active {
	display: block;
}

.noti-header {
	padding: 15px 20px;
	background: #fafbfc;
	border-bottom: 1px solid #f0f0f0;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.noti-header span {
	font-weight: 700;
	font-size: 0.95rem;
}

.noti-body {
	max-height: 300px;
	overflow-y: auto;
}

.noti-item {
	padding: 15px 20px;
	display: flex;
	gap: 15px;
	border-bottom: 1px solid #f5f5f5;
	cursor: pointer;
}

.noti-item:hover {
	background: #f9f9f9;
}

.noti-item.unread {
	background: #fffcfa;
}

.noti-icon {
	width: 36px;
	height: 36px;
	border-radius: 50%;
	flex-shrink: 0;
	display: flex;
	align-items: center;
	justify-content: center;
	color: #fff;
	font-size: 0.9rem;
}

.bg-order {
	background: #333;
}

.bg-inquiry {
	background: #ff4e00;
}

.noti-text .msg {
	font-size: 0.85rem;
	color: #444;
	margin: 0 0 4px 0;
	line-height: 1.3;
}

.noti-text .time {
	font-size: 0.7rem;
	color: #aaa;
	display: block;
}

.profile-wrapper {
	position: relative;
}

.profile-box {
	display: flex;
	align-items: center;
	gap: 10px;
	padding-left: 20px;
	margin-left: 10px;
	border-left: 1px solid #eee;
	cursor: pointer;
}

.user-avatar {
	width: 34px;
	height: 34px;
	background: #333;
	color: #fff;
	border-radius: 10px;
	display: flex;
	align-items: center;
	justify-content: center;
	font-weight: 700;
	font-size: 0.85rem;
	position: relative;
}

.user-status.offline {
    background: #ff0000;
}

.user-status {
	position: absolute;
	bottom: -3px;
	right: -3px;
	width: 10px;
	height: 10px;
	background: #23a55a;
	border: 2px solid #fff;
	border-radius: 50%;
}

.user-info {
	text-align: right;
	line-height: 1.2;
}

.u-name {
	font-size: 0.85rem;
	font-weight: 700;
	color: #333;
}

.u-role {
	font-size: 0.7rem;
	color: #999;
	font-weight: 500;
}

.admin-dropdown {
	display: none;
	position: absolute;
	top: 55px;
	right: 0;
	width: 220px;
	background: #fff;
	border-radius: 12px;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
	border: 1px solid #eee;
	z-index: 2000;
	padding: 8px 0;
	animation: slideDown 0.2s ease-out;
}

.admin-dropdown.active {
	display: block;
}

.dropdown-info {
	padding: 12px 20px;
	border-bottom: 1px solid #f5f5f5;
	margin-bottom: 5px;
}

.dropdown-info strong {
	display: block;
	font-size: 0.9rem;
}

.dropdown-info span {
	font-size: 0.75rem;
	color: #999;
}

.admin-dropdown a {
	display: flex;
	align-items: center;
	gap: 10px;
	padding: 10px 20px;
	color: #444;
	text-decoration: none;
	font-size: 0.85rem;
}

.admin-dropdown a:hover {
	background: #f9f9f9;
	color: #000;
}

.logout-item {
	color: #ff4e00 !important;
	font-weight: 600;
	border-top: 1px solid #f5f5f5;
	margin-top: 5px;
}

@keyframes slideDown {from { opacity:0;
	transform: translateY(-10px);
}

to {
	opacity: 1;
	transform: translateY(0);
}
}
</style>

<nav class="top-navbar">
	<div class="nav-left">
		<button id="sidebar-toggle">
			<i class="fas fa-bars"></i>
		</button>
		<span class="page-now">MAKNAEZ Admin</span>
	</div>

	<div class="nav-right">
		<div class="notification-wrapper">
			<div class="icon-btn" id="notiBtn">
				<i class="far fa-bell"></i> <span id="alarm-dot"
					style="display: none;"></span>
			</div>

			<div class="noti-dropdown" id="notiDropdown">
				<div class="noti-header">
					<span>알림</span> <a href="#"
						style="font-size: 0.75rem; color: #888; text-decoration: none;">모두
						읽음</a>
				</div>
				<div class="noti-body" id="alertListContainer">
					<div style="padding: 20px; text-align: center; color: #999;">Loading...</div>
				</div>
				<div class="noti-footer"
					style="padding: 12px; text-align: center; background: #fafbfc; border-top: 1px solid #f0f0f0;">
					<a href="${pageContext.request.contextPath}/admin/alert/history"
						style="font-size: 0.8rem; color: #555; text-decoration: none; font-weight: 600;">
						전체 알람 보기 </a>
				</div>
			</div>
		</div>

		<div class="profile-wrapper">
			<div class="profile-box" id="profileBtn">
				<div class="user-info d-none d-lg-block">
					<div class="u-name">${sessionScope.member.userName}님</div>
					<div class="u-role">
						Administrator <i class="fas fa-chevron-down"
							style="font-size: 0.6rem;"></i>
					</div>
				</div>
				<div class="user-avatar">
					${fn:substring(sessionScope.member.userName, 0, 1)}
					<div class="user-status" id="header-user-status"></div>
				</div>
			</div>

			<div class="admin-dropdown" id="adminMenu">
				<div class="dropdown-info">
					<strong>${sessionScope.member.userName}</strong> <span>Master
						Admin</span>
				</div>
				<a href="${pageContext.request.contextPath}/admin/member/profile"><i
					class="fas fa-user-cog"></i> 계정 설정</a> <a
					href="https://mail.google.com" target="_blank"><i
					class="fas fa-envelope"></i> 업무 메일함</a> <a
					href="${pageContext.request.contextPath}/"><i
					class="fas fa-shopping-cart"></i> 소비자 페이지</a> <a
					href="${pageContext.request.contextPath}/admin/logout"
					class="logout-item"><i class="fas fa-sign-out-alt"></i> 로그아웃</a>
			</div>
		</div>
	</div>
</nav>

<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />
