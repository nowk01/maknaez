<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Archivo:ital,wght@0,800;0,900;1,800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    /* [BRAND VARIABLES] */
    :root {
        --admin-bg: #050505;
        --admin-surface: #111111;
        --admin-text: #888888;
        --admin-active: #ffffff;
        --brand-accent: #ff4e00;
        --border-color: #222222;
        --sb-width: 260px; /* 사이드바 너비 변수 */
    }

    /* =========================================
       ★ [핵심 수정] 레이아웃 깨짐 방지 코드 ★
       ========================================= */
    
    /* 1. 본문 전체를 오른쪽으로 밈 */
    body {
        padding-left: var(--sb-width) !important;
        margin: 0;
        overflow-x: hidden;
    }

    /* 2. 헤더 위치 보정 */
    header, nav.navbar, .header-navbar, .fixed-top {
        left: var(--sb-width) !important;
        width: calc(100% - var(--sb-width)) !important;
        z-index: 900;
    }

    /* 3. 메인 컨텐츠 여백 */
    .container, .container-fluid, #wrapper, main {
        padding-top: 30px !important;
    }
    
    /* 4. 푸터 위치 보정 */
    footer, .footer {
        width: 100% !important;
    }

    /* =========================================
       [기존 사이드바 스타일]
       ========================================= */

    #sidebar-wrapper {
        background-color: var(--admin-bg);
        height: 100vh;
        width: var(--sb-width);
        border-right: 1px solid var(--border-color);
        display: flex;
        flex-direction: column;
        font-family: 'Inter', sans-serif;
        position: fixed;
        left: 0;
        top: 0;
        z-index: 1000;
        transition: all 0.3s;
    }

    /* 2. 브랜드 로고 영역 */
    .brand-link {
        text-decoration: none;
        display: block;
        transition: opacity 0.2s;
        /* nav-link와 달리 배경색 변경 효과를 제거 */
    }
    .brand-link:hover {
        opacity: 0.8;
    }

    .sidebar-brand {
        padding: 40px 30px 20px;
        flex-shrink: 0;
    }
    .brand-text {
        font-family: 'Archivo', sans-serif;
        font-weight: 900;
        font-style: italic;
        font-size: 1.8rem;
        color: #fff;
        letter-spacing: -0.05em;
        line-height: 1;
        text-transform: uppercase;
    }
    .brand-sub {
        font-family: 'Inter', sans-serif;
        font-size: 0.7rem;
        color: var(--brand-accent);
        font-weight: 600;
        letter-spacing: 0.2em;
        margin-top: 5px;
        text-transform: uppercase;
        opacity: 0.9;
    }

    /* 3. 메뉴 리스트 */
    .sidebar-menu {
        flex-grow: 1;
        padding: 0 15px;
        overflow-y: auto;
    }
    
    .sidebar-menu::-webkit-scrollbar { width: 4px; }
    .sidebar-menu::-webkit-scrollbar-thumb { background: #333; border-radius: 2px; }
    .sidebar-menu::-webkit-scrollbar-track { background: transparent; }

    .menu-header {
        font-family: 'Archivo', sans-serif;
        font-size: 0.75rem;
        color: #444;
        margin: 25px 0 10px 15px;
        font-weight: 800;
        text-transform: uppercase;
        letter-spacing: 0.05em;
    }

    /* 4. 메뉴 아이템 스타일 */
    .nav-link {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 12px 15px;
        color: var(--admin-text);
        text-decoration: none;
        font-size: 0.9rem;
        font-weight: 500;
        transition: all 0.2s ease;
        border-radius: 4px;
        margin-bottom: 2px;
        border-left: 3px solid transparent;
        cursor: pointer;
    }

    .nav-link i.menu-icon {
        width: 24px;
        font-size: 1.1rem;
        margin-right: 10px;
        text-align: center;
        transition: color 0.2s;
    }

    .nav-link:hover {
        color: #fff;
        background-color: var(--admin-surface);
    }
    .nav-link:hover i.menu-icon {
        color: #fff;
    }

    /* Active State */
    .nav-link.active-menu, 
    .nav-link[aria-expanded="true"] {
        color: #fff;
        background-color: rgba(255, 78, 0, 0.05);
        border-left: 3px solid var(--brand-accent);
    }
    
    .nav-link.active-menu i.menu-icon,
    .nav-link[aria-expanded="true"] i.menu-icon {
        color: var(--brand-accent);
    }

    /* 5. 서브메뉴 */
    .submenu {
        padding-left: 15px;
        margin-top: 2px;
        margin-bottom: 10px;
        position: relative;
    }
    
    .submenu::before {
        content: '';
        position: absolute;
        left: 30px;
        top: 0;
        bottom: 0;
        width: 1px;
        background-color: #222;
    }

    .submenu-item {
        display: block;
        padding: 8px 0 8px 38px;
        color: #666;
        font-size: 0.85rem;
        text-decoration: none;
        transition: all 0.2s;
        position: relative;
    }

    .submenu-item:hover {
        color: #fff;
    }
    .submenu-item:hover::before {
        background-color: var(--brand-accent);
    }
    
    .submenu-item::before {
        content: '';
        position: absolute;
        left: 15px;
        top: 50%;
        width: 4px;
        height: 1px;
        background-color: #444;
        transition: background-color 0.2s;
    }

    /* 선택된 서브메뉴 스타일 */
    .submenu-item.active-sub {
        color: #fff;
        font-weight: 700;
    }
    .submenu-item.active-sub::before {
        background-color: var(--brand-accent);
        width: 8px;
    }

    .menu-arrow {
        font-size: 0.7rem;
        transition: transform 0.3s;
        opacity: 0.5;
    }
    [aria-expanded="true"] .menu-arrow {
        transform: rotate(90deg);
        color: var(--brand-accent);
        opacity: 1;
    }

    /* 6. 사이드바 푸터 */
    .sidebar-footer {
        padding: 20px;
        border-top: 1px solid var(--border-color);
        background-color: var(--admin-bg);
        flex-shrink: 0;
    }

    .admin-profile {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-bottom: 15px;
    }

    .admin-avatar {
        width: 40px;
        height: 40px;
        background: #222;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--brand-accent);
        font-size: 1.2rem;
        border: 1px solid #333;
    }

    .admin-info {
        flex: 1;
        overflow: hidden;
    }

    .admin-name {
        color: #fff;
        font-size: 0.9rem;
        font-weight: 600;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .admin-role {
        color: #666;
        font-size: 0.75rem;
        margin-top: 2px;
    }

    .btn-logout {
        width: 100%;
        padding: 10px;
        background-color: var(--admin-surface);
        border: 1px solid #333;
        color: var(--admin-text);
        font-size: 0.8rem;
        border-radius: 4px;
        cursor: pointer;
        transition: all 0.2s;
        text-align: center;
        text-decoration: none;
        display: block;
    }

    .btn-logout:hover {
        background-color: #222;
        color: #fff;
        border-color: #444;
    }
    
    .btn-logout i {
        margin-right: 5px;
    }

</style>

<nav id="sidebar-wrapper">
    <a href="${pageContext.request.contextPath}/admin" class="brand-link">
        <div class="sidebar-brand">
            <div class="brand-text">MAKNAEZ</div>
            <div class="brand-sub">ADMINISTRATOR</div>
        </div>
    </a>

    <div class="sidebar-menu">
        <div class="menu-header">Overview</div>
        <a href="${pageContext.request.contextPath}/admin" class="nav-link">
            <div class="d-flex align-items-center">
                <i class="fas fa-chart-pie menu-icon"></i>
                <span>DASHBOARD</span>
            </div>
        </a>

        <div class="menu-header">Management</div>

        <a class="nav-link" data-bs-toggle="collapse" href="#menu-member" role="button" aria-expanded="false">
            <div class="d-flex align-items-center">
                <i class="fas fa-users menu-icon"></i>
                <span>MEMBERS</span>
            </div>
            <i class="fas fa-chevron-right menu-arrow"></i>
        </a>
        <div class="collapse" id="menu-member">
            <div class="submenu">
                <a href="${pageContext.request.contextPath}/admin/member/member_list" class="submenu-item">회원 조회 (List)</a>
                <a href="${pageContext.request.contextPath}/admin/member/point_manage" class="submenu-item">마일리지 (Points)</a>
                <a href="${pageContext.request.contextPath}/admin/member/dormant_manage" class="submenu-item">휴면 관리 (Sleep)</a>
            </div>
        </div>

        <a class="nav-link" data-bs-toggle="collapse" href="#menu-order" role="button" aria-expanded="false">
            <div class="d-flex align-items-center">
                <i class="fas fa-box-open menu-icon"></i>
                <span>ORDERS</span>
            </div>
            <i class="fas fa-chevron-right menu-arrow"></i>
        </a>
        <div class="collapse" id="menu-order">
            <div class="submenu">
                <a href="${pageContext.request.contextPath}/admin/order/order_list" class="submenu-item">주문 조회 (All)</a>
                <a href="${pageContext.request.contextPath}/admin/order/estimate_list" class="submenu-item">거래명세서 (Estimate)</a>
                <a href="${pageContext.request.contextPath}/admin/order/claim_list" class="submenu-item">취소/반품 (Claim)</a>
            </div>
        </div>

        <a class="nav-link" data-bs-toggle="collapse" href="#menu-product" role="button" aria-expanded="false">
            <div class="d-flex align-items-center">
                <i class="fas fa-tag menu-icon"></i>
                <span>PRODUCTS</span>
            </div>
            <i class="fas fa-chevron-right menu-arrow"></i>
        </a>
        <div class="collapse" id="menu-product">
            <div class="submenu">
                <a href="${pageContext.request.contextPath}/admin/product/product_list" class="submenu-item">상품 목록 (List)</a>
                <a href="${pageContext.request.contextPath}/admin/product/category_manage" class="submenu-item">카테고리 (Category)</a>
                <a href="${pageContext.request.contextPath}/admin/product/stock_list" class="submenu-item">재고 관리 (Stock)</a>
            </div>
        </div>

        <div class="menu-header">Data & Support</div>

        <a class="nav-link" data-bs-toggle="collapse" href="#menu-stats" role="button" aria-expanded="false">
            <div class="d-flex align-items-center">
                <i class="fas fa-chart-line menu-icon"></i>
                <span>ANALYTICS</span>
            </div>
            <i class="fas fa-chevron-right menu-arrow"></i>
        </a>
        <div class="collapse" id="menu-stats">
            <div class="submenu">
                <a href="${pageContext.request.contextPath}/admin/stats/sales_stats" class="submenu-item">매출 분석 (Sales)</a>
                <a href="${pageContext.request.contextPath}/admin/stats/customer_stats" class="submenu-item">고객 통계 (User)</a>
                <a href="${pageContext.request.contextPath}/admin/stats/visitor_stats" class="submenu-item">트래픽 (Traffic)</a>
            </div>
        </div>

        <a class="nav-link" data-bs-toggle="collapse" href="#menu-board" role="button" aria-expanded="false">
            <div class="d-flex align-items-center">
                <i class="fas fa-headset menu-icon"></i>
                <span>SUPPORT</span>
            </div>
            <i class="fas fa-chevron-right menu-arrow"></i>
        </a>
        <div class="collapse" id="menu-board">
            <div class="submenu">
                <a href="${pageContext.request.contextPath}/admin/cs/notice_list" class="submenu-item">공지사항 (Notice)</a>
                <a href="${pageContext.request.contextPath}/admin/cs/inquiry_list" class="submenu-item">1:1 문의 (Inquiry)</a>
                <a href="${pageContext.request.contextPath}/admin/cs/review_list" class="submenu-item">리뷰 관리 (Review)</a>
            </div>
        </div>
        
        <div style="height: 30px;"></div>
    </div>
    
    <div class="sidebar-footer">
        <div class="admin-profile">
            <div class="admin-avatar">
                <i class="fas fa-user-astronaut"></i>
            </div>
            <div class="admin-info">
                <div class="admin-name">${sessionScope.member.userName}</div>
                <div class="admin-role">Super Manager</div>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/admin/logout" class="btn-logout">
            <i class="fas fa-sign-out-alt"></i> 로그아웃
        </a>
    </div>
</nav>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const currentPath = window.location.pathname;
    
    // 1. 서브메뉴 활성화
    const subItems = document.querySelectorAll('.submenu-item');
    subItems.forEach(item => {
        const linkPath = item.getAttribute('href');
        if (linkPath && currentPath.includes(linkPath) && linkPath !== '#') {
            item.classList.add('active-sub');
            const parentCollapse = item.closest('.collapse');
            if (parentCollapse) {
                parentCollapse.classList.add('show');
                const collapseId = parentCollapse.getAttribute('id');
                const toggleBtn = document.querySelector('a.nav-link[href="#' + collapseId + '"]');
                if (toggleBtn) {
                    toggleBtn.classList.add('active-menu');
                    toggleBtn.setAttribute('aria-expanded', 'true');
                }
            }
        }
    });

    // 2. 단독 메뉴(대시보드 등) 활성화
    // 로고에는 nav-link 클래스가 없으므로 이 로직에 걸리지 않음!
    const navLinks = document.querySelectorAll('.nav-link:not([data-bs-toggle])');
    navLinks.forEach(link => {
        const linkPath = link.getAttribute('href');
        if (linkPath && currentPath === linkPath) {
            link.classList.add('active-menu');
        }
    });
});
</script>