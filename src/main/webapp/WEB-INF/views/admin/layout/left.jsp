<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<nav id="sidebar-wrapper">
    <div class="sidebar-heading">MAKNAEZ ADMIN</div>
    <div class="list-group list-group-flush mt-3">
        <a href="" class="list-group-item active-menu">
            <i class="fas fa-home me-2"></i> 홈 대시보드
        </a>

        <div class="px-3 pt-4 pb-2 text-uppercase small" style="color: #6c757d;">관리 메뉴</div>

        <a class="list-group-item" data-bs-toggle="collapse" href="#menu-member" role="button">
            <i class="fas fa-users me-2"></i> 회원 관리
            <i class="fas fa-chevron-right menu-arrow"></i>
        </a>
        <div class="collapse" id="menu-member">
            <div class="list-group list-group-flush submenu">
                <a href="${pageContext.request.contextPath}/admin/member/member_list" class="list-group-item">회원 조회</a>
                <a href="#" class="list-group-item">마일리지 관리</a>
                <a href="#" class="list-group-item">휴면 회원 관리</a>
            </div>
        </div>

        <a class="list-group-item" data-bs-toggle="collapse" href="#menu-order" role="button">
            <i class="fas fa-shopping-cart me-2"></i> 주문/배송 관리
            <i class="fas fa-chevron-right menu-arrow"></i>
        </a>
        <div class="collapse" id="menu-order">
            <div class="list-group list-group-flush submenu">
                <a href="#" class="list-group-item">통합 주문 검색</a>
                <a href="#" class="list-group-item">견적서 관리</a>
                <a href="#" class="list-group-item">취소/반품 관리</a>
            </div>
        </div>

        <a class="list-group-item" data-bs-toggle="collapse" href="#menu-product" role="button">
            <i class="fas fa-gift me-2"></i> 상품 관리
            <i class="fas fa-chevron-right menu-arrow"></i>
        </a>
        <div class="collapse" id="menu-product">
            <div class="list-group list-group-flush submenu">
                <a href="#" class="list-group-item">상품 목록/등록/수정</a>
                <a href="#" class="list-group-item">카테고리 관리</a>
                <a href="#" class="list-group-item">재고 관리</a>
            </div>
        </div>

        <a class="list-group-item" data-bs-toggle="collapse" href="#menu-stats" role="button">
            <i class="fas fa-chart-bar me-2"></i> 통계/정산
            <i class="fas fa-chevron-right menu-arrow"></i>
        </a>
        <div class="collapse" id="menu-stats">
            <div class="list-group list-group-flush submenu">
                <a href="#" class="list-group-item">월/일/상품별 매출</a>
                <a href="#" class="list-group-item">연령/성별 통계</a>
                <a href="#" class="list-group-item">방문자 수 조회</a>
            </div>
        </div>

        <a class="list-group-item" data-bs-toggle="collapse" href="#menu-board" role="button">
            <i class="fas fa-headset me-2"></i> 게시판/고객관리
            <i class="fas fa-chevron-right menu-arrow"></i>
        </a>
        <div class="collapse" id="menu-board">
            <div class="list-group list-group-flush submenu">
                <a href="#" class="list-group-item">공지사항 관리</a>
                <a href="#" class="list-group-item">1:1 문의</a>
                <a href="#" class="list-group-item">Q&A</a>
                <a href="#" class="list-group-item">리뷰 관리</a>
            </div>
        </div>
    </div>
</nav>