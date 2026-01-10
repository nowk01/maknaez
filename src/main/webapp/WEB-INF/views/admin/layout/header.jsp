<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>

<jsp:useBean id="now" class="java.util.Date" />

<style>
    /* [HEADER THEME: Invisible Luxury] */
    :root {
        --hdr-bg: rgba(255, 255, 255, 0.85); /* 더 투명하게 */
        --hdr-glass: blur(12px);
        --hdr-border: 1px solid rgba(0,0,0,0.05);
    }

    .top-navbar {
        height: 70px;
        padding: 0 30px;
        display: grid;
        grid-template-columns: 1fr 2fr 1fr; /* 좌:중:우 = 1:2:1 (검색창 완벽 중앙 정렬) */
        align-items: center;
        background-color: var(--hdr-bg);
        backdrop-filter: var(--hdr-glass);
        border-bottom: var(--hdr-border);
        position: sticky;
        top: 0;
        z-index: 1000;
    }

    /* 1. 좌측 (메뉴 토글 + 타이틀) */
    .nav-left { display: flex; align-items: center; gap: 15px; }
    #sidebar-toggle {
        background: none; border: none; font-size: 1.2rem; color: #888;
        cursor: pointer; transition: color 0.2s; padding: 5px;
    }
    #sidebar-toggle:hover { color: #000; }
    
    .page-now {
        font-family: 'Pretendard', sans-serif;
        font-size: 1rem; font-weight: 700; color: #333;
        letter-spacing: -0.01em;
    }

    /* 2. 중앙 (검색창) - 위치 딱 잡음 */
    .nav-center { display: flex; justify-content: center; }
    .search-pill {
        width: 100%; max-width: 400px;
        background: #f4f5f7;
        border-radius: 20px; /* 둥근 캡슐형 (요즘 스타일) */
        padding: 8px 20px;
        display: flex; align-items: center;
        transition: all 0.2s;
        border: 1px solid transparent;
    }
    .search-pill:focus-within {
        background: #fff;
        border-color: #ddd;
        box-shadow: 0 4px 12px rgba(0,0,0,0.05);
    }
    .search-pill input {
        border: none; background: transparent; width: 100%; outline: none;
        font-size: 0.9rem; margin-left: 10px;
    }
    .search-pill i { color: #aaa; }

    /* 3. 우측 (툴 + 프로필) */
    .nav-right { display: flex; align-items: center; justify-content: flex-end; gap: 20px; }

    .icon-btn {
        position: relative; color: #555; font-size: 1.1rem; cursor: pointer;
        width: 36px; height: 36px; border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        transition: background 0.2s;
    }
    .icon-btn:hover { background: rgba(0,0,0,0.05); color: #000; }
    
    .noti-dot {
        position: absolute; top: 8px; right: 8px;
        width: 5px; height: 5px; background: #ff4e00; border-radius: 50%;
        box-shadow: 0 0 0 1.5px #fff;
    }

    /* 프로필 & 온라인 상태 */
    .profile-box {
        display: flex; align-items: center; gap: 10px;
        padding-left: 20px; margin-left: 10px;
        border-left: 1px solid #eee;
    }
    .user-avatar {
        width: 34px; height: 34px;
        background: #333; color: #fff;
        border-radius: 10px; /* 살짝 둥근 사각형 */
        display: flex; align-items: center; justify-content: center;
        font-weight: 700; font-size: 0.85rem;
        position: relative;
    }
    
    /* 헤더 온라인 상태 표시 (User Status) */
    .user-status {
        position: absolute; bottom: -3px; right: -3px;
        width: 10px; height: 10px;
        background: #00c853; /* 초록불 */
        border: 2px solid #fff;
        border-radius: 50%;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .user-info { text-align: right; line-height: 1.2; }
    .u-name { font-size: 0.85rem; font-weight: 700; color: #333; }
    .u-role { font-size: 0.7rem; color: #999; font-weight: 500; }

</style>

<nav class="top-navbar">
    <div class="nav-left">
        <button id="sidebar-toggle"><i class="fas fa-bars"></i></button>
        <span class="page-now">Dashboard</span>
    </div>

    <div class="nav-center">
        <div class="search-pill d-none d-md-flex">
            <i class="fas fa-search"></i>
            <input type="text" placeholder="검색어를 입력하세요...">
        </div>
    </div>

    <div class="nav-right">
        <div class="icon-btn">
            <i class="far fa-bell"></i>
            <span class="noti-dot"></span>
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