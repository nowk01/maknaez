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

    body {
        padding-top: var(--hdr-height) !important;
        padding-left: var(--sb-width); 
        background-color: #f5f6f8;
        transition: padding-left 0.3s ease;
    }

    body.header-wide { padding-left: 0 !important; }

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

    body.header-wide .top-navbar { left: 0 !important; width: 100% !important; }

    .nav-left { display: flex; align-items: center; gap: 15px; }
    #sidebar-toggle { background: none; border: none; font-size: 1.2rem; color: #555; cursor: pointer; }
    .page-now { font-weight: 700; color: #333; }

    /* 우측 영역 */
    .nav-right { display: flex; align-items: center; gap: 15px; }

    /* 알림 아이콘 */
    .icon-btn {
        position: relative; width: 40px; height: 40px;
        display: flex; align-items: center; justify-content: center;
        color: #555; font-size: 1.2rem; cursor: pointer; border-radius: 50%;
    }
    .icon-btn:hover { background: rgba(0,0,0,0.05); }
    
    /* 실시간 알림 점 */
    #alarm-dot {
        position: absolute; top: 10px; right: 10px; width: 8px; height: 8px;
        background: #ff4e00; border-radius: 50%; border: 2px solid #fff;
    }

    /* 프로필 & 드롭다운 상자 */
    .profile-wrapper { position: relative; }
    .profile-box {
        display: flex; align-items: center; gap: 12px;
        padding: 5px 10px; cursor: pointer; border-radius: 8px;
        transition: background 0.2s;
    }
    .profile-box:hover { background: rgba(0,0,0,0.03); }
    
    .user-avatar {
        width: 36px; height: 36px; background: #333; color: #fff;
        border-radius: 10px; display: flex; align-items: center; justify-content: center;
        font-weight: 700; font-size: 0.9rem; position: relative;
    }
    /* 디코 스타일 온오프 점 */
    .user-status {
        position: absolute; bottom: -3px; right: -3px; width: 10px; height: 10px;
        background: #23a55a; border: 2px solid #fff; border-radius: 50%;
    }

    /* [드롭다운 디자인] */
    .admin-dropdown {
        display: none; position: absolute; top: 55px; right: 0; width: 220px;
        background: #fff; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        border: 1px solid #eee; z-index: 2000; padding: 8px 0;
        animation: slideDown 0.2s ease-out;
    }
    .admin-dropdown.active { display: block; }
    
    .dropdown-info { padding: 12px 20px; border-bottom: 1px solid #f5f5f5; margin-bottom: 5px; }
    .dropdown-info strong { display: block; font-size: 0.9rem; }
    .dropdown-info span { font-size: 0.75rem; color: #999; }

    .admin-dropdown a {
        display: flex; align-items: center; gap: 10px;
        padding: 10px 20px; color: #444; text-decoration: none; font-size: 0.85rem;
    }
    .admin-dropdown a i { font-size: 1rem; color: #777; width: 20px; }
    .admin-dropdown a:hover { background: #f9f9f9; color: #000; }
    .admin-dropdown a.logout-item { color: #ff4e00; font-weight: 600; border-top: 1px solid #f5f5f5; margin-top: 5px; }

    @keyframes slideDown {
        from { opacity: 0; transform: translateY(-10px); }
        to { opacity: 1; transform: translateY(0); }
    }
</style>

<nav class="top-navbar">
    <div class="nav-left">
        <button id="sidebar-toggle"><i class="fas fa-bars"></i></button>
        <span class="page-now">MAKNAEZ Admin</span>
    </div>

    <div class="nav-right">
        <div class="icon-btn" onclick="location.href='${pageContext.request.contextPath}/admin/orderManage/list'">
            <i class="far fa-bell"></i>
            <span id="alarm-dot" style="display:none;"></span>
        </div>
        
        <div class="profile-wrapper">
            <div class="profile-box" id="profileBtn">
                <div class="user-avatar">
                    ${fn:substring(sessionScope.member.userName, 0, 1)}
                    <div class="user-status"></div> </div>
                <div class="user-info d-none d-lg-block">
                    <div class="u-name" style="font-size: 0.85rem; font-weight: 700;">${sessionScope.member.userName}님</div>
                    <div class="u-role" style="font-size: 0.7rem; color: #999;">Administrator <i class="fas fa-chevron-down" style="font-size: 0.6rem;"></i></div>
                </div>
            </div>

            <div class="admin-dropdown" id="adminMenu">
                <div class="dropdown-info">
                    <strong>${sessionScope.member.userName}</strong>
                    <span>Master Admin</span>
                </div>
                <a href="${pageContext.request.contextPath}/member/mypage/myInfo"><i class="fas fa-user-cog"></i> 계정 설정</a>
                <a href="https://mail.google.com" target="_blank"><i class="fas fa-envelope"></i> 업무 메일함</a>
                <a href="${pageContext.request.contextPath}/"><i class="fas fa-shopping-cart"></i> 소비자 페이지</a>
                <a href="${pageContext.request.contextPath}/admin/logout" class="logout-item"><i class="fas fa-sign-out-alt"></i> 로그아웃</a>
            </div>
        </div>
    </div>
</nav>

<script>
$(function() {
    // 1. 사이드바 토글
    $('#sidebar-toggle').on('click', function() {
        $('body').toggleClass('header-wide');
    });

    // 2. 프로필 드롭다운 토글
    $('#profileBtn').on('click', function(e) {
        e.stopPropagation();
        $('#adminMenu').toggleClass('active');
    });

    // 3. 외부 클릭 시 닫기
    $(document).on('click', function(e) {
        if (!$(e.target).closest('.profile-wrapper').length) {
            $('#adminMenu').removeClass('active');
        }
    });

    // 4. [핵심] AJAX 알람 실시간 체크 (강사님 요청 사항)
    function checkNewOrder() {
        // 실제 컨트롤러 매핑 주소로 변경 필요
        fetch("${pageContext.request.contextPath}/admin/checkAlarmCount")
            .then(res => res.json())
            .then(data => {
                // data.newOrderCount가 0보다 크면 빨간 점 보여주기
                if(data.newOrderCount > 0) {
                    $('#alarm-dot').fadeIn();
                } else {
                    $('#alarm-dot').hide();
                }
            })
            .catch(err => console.log("알람 체크 실패"));
    }

    // 30초마다 체크
    setInterval(checkNewOrder, 30000);
    checkNewOrder(); // 페이지 로드 시 즉시 실행
});
</script>