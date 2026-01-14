<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>

<jsp:useBean id="now" class="java.util.Date" />

<style>
    /* [1. 기본 설정 및 변수] */
    :root {
        --sb-width: 260px; /* 사이드바 너비 */
        --hdr-height: 70px; /* 헤더 높이 */
        --hdr-bg: rgba(255, 255, 255, 0.95);
        --hdr-border: 1px solid #e1e1e1;
    }

    html, body {
        margin: 0 !important;
        padding: 0;
        width: 100%;
        overflow-x: hidden;
    }

    body {
        /* 헤더 높이만큼 상단 여백 */
        padding-top: var(--hdr-height) !important;
        /* 기본 상태: 사이드바 너비만큼 본문도 밀어줌 (본문 내용 침범 방지) */
        padding-left: var(--sb-width); 
        background-color: #f5f6f8;
        transition: padding-left 0.3s ease; /* 부드러운 애니메이션 */
    }

    /* [핵심] 사이드바가 숨겨졌을 때 (header-wide 클래스) */
    body.header-wide {
        padding-left: 0 !important; /* 본문 여백 제거 */
    }

    /* [2. 상단 헤더 (네비게이션 바)] */
    .top-navbar {
        height: var(--hdr-height);
        position: fixed !important;
        top: 0 !important;
        
        /* [중요] 기본 상태: 왼쪽을 사이드바만큼 비워둠 (침범 절대 불가) */
        left: var(--sb-width) !important;
        width: calc(100% - var(--sb-width)) !important;
        
        background-color: var(--hdr-bg);
        border-bottom: var(--hdr-border);
        z-index: 1000;
        
        display: flex;
        align-items: center;
        justify-content: space-between; /* 양 끝 배분 */
        padding: 0 30px;
        box-sizing: border-box;
        
        transition: left 0.3s ease, width 0.3s ease; /* 애니메이션 동기화 */
    }

    /* 사이드바 숨김 상태일 때 헤더 스타일 변경 */
    body.header-wide .top-navbar {
        left: 0 !important; /* 왼쪽 딱 붙이기 */
        width: 100% !important; /* 전체 너비 사용 */
    }

    /* [3. 좌측 영역 (버튼 + 타이틀)] */
    .nav-left {
        display: flex;
        align-items: center;
        gap: 15px;
        z-index: 20; /* 검색창보다 위에 오도록 */
    }
    #sidebar-toggle {
        background: none; border: none; font-size: 1.2rem; color: #555;
        cursor: pointer; padding: 5px; transition: color 0.2s;
    }
    #sidebar-toggle:hover { color: #000; }
    
    .page-now {
        font-family: 'Pretendard', sans-serif;
        font-size: 1rem; font-weight: 700; color: #333;
        white-space: nowrap;
    }

    /* [4. 중앙 영역 (검색창) - 절대 위치로 강제 중앙 정렬] */
    .nav-center {
        position: absolute;
        left: 50%;
        top: 50%;
        transform: translate(-50%, -50%); /* 정확한 정중앙 좌표 계산 */
        z-index: 10;
        width: auto;
    }

    .search-pill {
        width: 380px; max-width: 400px; height: 42px;
        background: #f4f5f7; border-radius: 20px; padding: 0 20px;
        display: flex; align-items: center; border: 1px solid transparent;
        transition: all 0.2s;
    }
    .search-pill:focus-within {
        background: #fff; border-color: #ddd; box-shadow: 0 4px 12px rgba(0,0,0,0.05);
    }
    .search-pill input {
        border: none; background: transparent; width: 100%; height: 100%;
        outline: none; font-size: 0.9rem; margin-left: 10px;
    }

    /* [5. 우측 영역 (아이콘 + 프로필)] */
    .nav-right {
        display: flex; align-items: center; gap: 20px;
        z-index: 20; /* 검색창보다 위에 오도록 */
    }

    .icon-btn {
        position: relative; width: 36px; height: 36px;
        display: flex; align-items: center; justify-content: center;
        color: #555; font-size: 1.1rem; cursor: pointer; border-radius: 50%;
        transition: background 0.2s;
    }
    .icon-btn:hover { background: rgba(0,0,0,0.05); color: #000; }
    
    .noti-dot {
        position: absolute; top: 8px; right: 8px; width: 5px; height: 5px;
        background: #ff4e00; border-radius: 50%; box-shadow: 0 0 0 1.5px #fff;
    }

    /* 프로필 */
    .profile-box {
        display: flex; align-items: center; gap: 10px;
        padding-left: 20px; margin-left: 10px; border-left: 1px solid #eee;
    }
    .user-avatar {
        width: 34px; height: 34px; background: #333; color: #fff;
        border-radius: 10px; display: flex; align-items: center; justify-content: center;
        font-weight: 700; font-size: 0.85rem; position: relative;
    }
    .user-status {
        position: absolute; bottom: -3px; right: -3px; width: 10px; height: 10px;
        background: #00c853; border: 2px solid #fff; border-radius: 50%;
    }
    .user-info { text-align: right; line-height: 1.2; }
    .u-name { font-size: 0.85rem; font-weight: 700; color: #333; }
    .u-role { font-size: 0.7rem; color: #999; font-weight: 500; }

    /* [6. 알림 드롭다운] */
    .notification-wrapper { position: relative; }
    .noti-dropdown {
        display: none; position: absolute; top: 50px; right: -10px; width: 320px;
        background: #fff; border-radius: 16px; box-shadow: 0 10px 40px rgba(0,0,0,0.1);
        border: 1px solid #f0f0f0; z-index: 2000; overflow: hidden;
        animation: slideDown 0.2s ease-out;
    }
    .noti-dropdown.active { display: block; }
    
    .noti-header {
        padding: 15px 20px; background: #fafbfc; border-bottom: 1px solid #f0f0f0;
        display: flex; justify-content: space-between; align-items: center;
    }
    .noti-header span { font-weight: 700; font-size: 0.95rem; }
    .noti-header a { font-size: 0.75rem; color: #888; text-decoration: none; }
    
    .noti-body { max-height: 300px; overflow-y: auto; }
    .noti-item {
        padding: 15px 20px; display: flex; gap: 15px; border-bottom: 1px solid #f5f5f5;
        cursor: pointer; transition: background 0.1s;
    }
    .noti-item:hover { background: #f9f9f9; }
    .noti-item.unread { background: #fffcfa; }
    .noti-item.unread .msg { font-weight: 600; color: #000; }
    
    .noti-icon {
        width: 36px; height: 36px; border-radius: 50%; flex-shrink: 0;
        display: flex; align-items: center; justify-content: center; color: #fff; font-size: 0.9rem;
    }
    .bg-order { background: #333; } .bg-inquiry { background: #ff4e00; } .bg-system { background: #888; }
    
    .noti-text { flex-grow: 1; }
    .noti-text .msg { font-size: 0.85rem; color: #444; margin: 0 0 4px 0; line-height: 1.3; }
    .noti-text .time { font-size: 0.7rem; color: #aaa; display: block; }
    
    .noti-footer {
        padding: 12px; text-align: center; background: #fafbfc; border-top: 1px solid #f0f0f0;
    }
    .noti-footer a { font-size: 0.8rem; color: #555; text-decoration: none; font-weight: 600; }

    @keyframes slideDown {
        from { opacity: 0; transform: translateY(-10px); }
        to { opacity: 1; transform: translateY(0); }
    }
</style>

<nav class="top-navbar">
    <div class="nav-left">
        <button id="sidebar-toggle"><i class="fas fa-bars"></i></button>
        <span class="page-now">Dashboard</span>
    </div>

    <div class="nav-center">
        <div class="search-pill d-none d-md-flex">
            <i class="fas fa-search" style="color: #aaa;"></i>
            <input type="text" placeholder="검색어를 입력하세요...">
        </div>
    </div>

    <div class="nav-right">
        <div class="notification-wrapper">
            <div class="icon-btn" id="notiBtn">
                <i class="far fa-bell"></i>
                <span class="noti-dot"></span>
            </div>
            
            <div class="noti-dropdown" id="notiDropdown">
                <div class="noti-header">
                    <span>알림</span>
                    <a href="#">모두 읽음</a>
                </div>
                <div class="noti-body">
                    <div class="noti-item unread">
                        <div class="noti-icon bg-order"><i class="fas fa-shopping-bag"></i></div>
                        <div class="noti-text">
                            <p class="msg">새로운 주문이 접수되었습니다.</p>
                            <span class="time">방금 전</span>
                        </div>
                    </div>
                    <div class="noti-item unread">
                        <div class="noti-icon bg-inquiry"><i class="fas fa-comment-dots"></i></div>
                        <div class="noti-text">
                            <p class="msg">1:1 문의가 등록되었습니다.</p>
                            <span class="time">10분 전</span>
                        </div>
                    </div>
                    <div class="noti-item">
                        <div class="noti-icon bg-system"><i class="fas fa-cog"></i></div>
                        <div class="noti-text">
                            <p class="msg">서버 점검 완료</p>
                            <span class="time">1시간 전</span>
                        </div>
                    </div>
                </div>
                <div class="noti-footer">
                    <a href="#">전체 알림 보기</a>
                </div>
            </div>
        </div>

        <div class="profile-box">
            <div class="user-info d-none d-lg-block">
                <div class="u-name">${sessionScope.member.userName}</div>
                <div class="u-role">Master Admin</div>
            </div>
            <div class="user-avatar">
                ${fn:substring(sessionScope.member.userName, 0, 1)}
                <div class="user-status"></div>
            </div>
        </div>
    </div>
</nav>

<script>
$(function() {
    // 1. 사이드바 토글 (간소화된 버전)
    // CSS에 body.header-wide 관련 설정을 다 해뒀으므로 클래스만 껐다 켜면 됩니다.
    $('#sidebar-toggle').on('click', function() {
        $('body').toggleClass('header-wide');
    });

    // 2. 알림창 토글
    $('#notiBtn').on('click', function(e) {
        e.stopPropagation(); // 이벤트 버블링 막기
        $('#notiDropdown').toggleClass('active');
    });

    // 3. 외부 클릭 시 알림창 닫기
    $(document).on('click', function(e) {
        if (!$(e.target).closest('.notification-wrapper').length) {
            $('#notiDropdown').removeClass('active');
        }
    });
    
    // 4. 알림 클릭 시 '읽음' 처리 (unread 클래스 제거)
    $('.noti-item').on('click', function() {
        $(this).removeClass('unread');
    });
});
</script>