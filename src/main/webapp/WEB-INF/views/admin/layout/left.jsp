<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Archivo:ital,wght@0,800;0,900;1,800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">

<style>
    /* [BRAND VARIABLES] MAKNAEZ 시그니처 컬러 */
    :root {
        --admin-bg: #050505;       /* 딥 블랙 */
        --admin-surface: #111111;  /* 아주 어두운 회색 */
        --admin-text: #888888;     /* 비활성 텍스트 */
        --admin-active: #ffffff;   /* 활성 텍스트 */
        --brand-accent: #ff4e00;   /* MAKNAEZ 오렌지 */
        --border-color: #222222;
    }

    /* 1. 사이드바 전체 레이아웃 */
    #sidebar-wrapper {
        background-color: var(--admin-bg);
        min-height: 100vh;
        width: 260px;
        border-right: 1px solid var(--border-color);
        display: flex;
        flex-direction: column;
        font-family: 'Inter', sans-serif;
        z-index: 1000;
    }

    /* 2. 브랜드 로고 영역 (압도적인 존재감) */
    .sidebar-brand {
        padding: 40px 30px 20px;
        margin-bottom: 20px;
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
        color: var(--brand-accent); /* 오렌지 포인트 */
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

    /* 섹션 타이틀 (TECH 느낌) */
    .menu-header {
        font-family: 'Archivo', sans-serif;
        font-size: 0.75rem;
        color: #444; /* 아주 어둡게 처리해서 방해되지 않게 */
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
        border-left: 3px solid transparent; /* 활성화 표시바 공간 */
    }

    .nav-link i.menu-icon {
        width: 24px;
        font-size: 1.1rem;
        margin-right: 10px;
        text-align: center;
        transition: color 0.2s;
    }

    /* Hover Effect */
    .nav-link:hover {
        color: #fff;
        background-color: var(--admin-surface);
    }
    .nav-link:hover i.menu-icon {
        color: #fff;
    }

    /* ★ Active State (핵심 포인트) */
    .nav-link.active-menu, 
    .nav-link[aria-expanded="true"] {
        color: #fff;
        background-color: rgba(255, 78, 0, 0.05); /* 오렌지빛 아주 살짝 */
        border-left: 3px solid var(--brand-accent); /* 오렌지 라인 */
    }
    
    .nav-link.active-menu i.menu-icon,
    .nav-link[aria-expanded="true"] i.menu-icon {
        color: var(--brand-accent); /* 아이콘 오렌지색 */
    }

    /* 5. 서브메뉴 (Dropdown) */
    .submenu {
        padding-left: 15px; /* 들여쓰기 */
        margin-top: 2px;
        margin-bottom: 10px;
        position: relative;
    }
    
    /* 서브메뉴 가이드 라인 (Tech 감성) */
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
    
    /* 서브메뉴 활성화 시 */
    .submenu-item:hover::before {
        background-color: var(--brand-accent);
    }
    
    /* 서브메뉴 왼쪽 점 */
    .submenu-item::before {
        content: '';
        position: absolute;
        left: 15px;
        top: 50%;
        width: 4px;
        height: 1px; /* 둥근 점 대신 얇은 선으로 변경 (Tech 느낌) */
        background-color: #444;
        transition: background-color 0.2s;
    }

    /* 화살표 */
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

    /* 스크롤바 커스텀 */
    .sidebar-menu::-webkit-scrollbar { width: 4px; }
    .sidebar-menu::-webkit-scrollbar-thumb { background: #333; border-radius: 2px; }
    .sidebar-menu::-webkit-scrollbar-track { background: transparent; }
</style>

<nav id="sidebar-wrapper">
    <div class="sidebar-brand">
        <div class="brand-text">MAKNAEZ</div>
        <div class="brand-sub">ADMINISTRATOR</div>
    </div>

    <div class="sidebar-menu">
        <div class="menu-header">Overview</div>
        <a href="${pageContext.request.contextPath}/admin" class="nav-link active-menu">
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
                <a href="${pageContext.request.contextPath}/admin/order/estimate_list" class="submenu-item">견적서 (Estimate)</a>
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
    </div>
    
    <div style="height: 50px;"></div>
</nav>