<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원등급 | MAKNAEZ</title>

<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage.css">

<style>
    /* [Salomon Tech-Mix Theme] */
    .main-content { flex: 1; padding-left: 60px; font-family: 'Inter', 'Pretendard', sans-serif; color: #000; }
    
    .membership-header { margin-bottom: 40px; border-bottom: 2px solid #000; padding-bottom: 10px; display: flex; justify-content: space-between; align-items: flex-end; }
    .membership-header h3 { font-size: 28px; font-weight: 900; text-transform: uppercase; letter-spacing: -1.5px; margin: 0; }
    .membership-header .serial { font-size: 10px; font-family: monospace; color: #aaa; }

    /* 현재 등급 히어로 섹션 */
    .grade-display { display: flex; gap: 2px; margin-bottom: 60px; background: #000; border: 1px solid #000; }
    
    .current-rank-box { background: #000; color: #fff; padding: 50px; flex: 1.5; }
    .current-rank-box .label { font-size: 11px; text-transform: uppercase; letter-spacing: 3px; opacity: 0.5; display: block; margin-bottom: 15px; }
    .current-rank-box .tier-name { font-size: 72px; font-weight: 950; text-transform: uppercase; line-height: 0.8; letter-spacing: -3px; }
    
    /* 스펙 스타일 정보창 (우측 블랙박스) */
    .rank-spec-box { background: #000; color: #fff; padding: 50px; flex: 1; border-left: 1px solid rgba(255,255,255,0.1); display: flex; flex-direction: column; justify-content: space-between; }
    .spec-item { display: flex; justify-content: space-between; border-bottom: 1px solid rgba(255,255,255,0.1); padding: 10px 0; font-size: 13px; }
    .spec-item span:first-child { font-weight: 700; text-transform: uppercase; color: #666; font-size: 10px; letter-spacing: 1px; }
    
    /* 진행도 바 */
    .gauge-wrapper { margin-top: 25px; }
    .gauge-bg { height: 2px; background: rgba(255,255,255,0.2); width: 100%; position: relative; margin-top: 10px; }
    .gauge-fill { 
        height: 2px; background: #fff; position: absolute; top: 0; left: 0;
        width: ${sessionScope.member.userLevel >= 50 ? '100%' : (sessionScope.member.userLevel >= 40 ? '80%' : (sessionScope.member.userLevel >= 30 ? '60%' : (sessionScope.member.userLevel >= 20 ? '40%' : '20%')))};
    }

    /* 혜택 그리드 섹션 */
    .section-title { font-size: 14px; font-weight: 900; text-transform: uppercase; margin-bottom: 30px; letter-spacing: 1px; }
    .benefit-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1px; background: #eee; border: 1px solid #eee; margin-bottom: 80px; }
    .benefit-item { background: #fff; padding: 40px 30px; min-height: 200px; display: flex; flex-direction: column; }
    .benefit-item .top-tag { font-size: 10px; font-weight: 900; color: #aaa; text-transform: uppercase; margin-bottom: 15px; }
    .benefit-item h5 { font-size: 16px; font-weight: 900; text-transform: uppercase; margin: 0 0 10px 0; }
    .benefit-item p { font-size: 13px; color: #666; line-height: 1.6; margin: 0; flex-grow: 1; }
    .benefit-item .status { font-size: 10px; font-weight: 900; margin-top: 25px; text-transform: uppercase; padding: 5px 10px; border: 1px solid #000; width: fit-content; }

    /* 정책 테이블 */
    .tier-table { width: 100%; border-collapse: collapse; }
    .tier-table th { text-align: left; font-size: 11px; text-transform: uppercase; color: #999; padding: 15px 10px; border-bottom: 2px solid #000; }
    .tier-table td { padding: 30px 10px; border-bottom: 1px solid #eee; font-size: 14px; }
    .tier-table .rank-name { font-weight: 950; text-transform: uppercase; font-size: 18px; }
    .current-rank { background: #f9f9f9; }
    .tag-me { font-size: 9px; background: #000; color: #fff; padding: 3px 8px; margin-left: 10px; vertical-align: middle; }
</style>
</head>

<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="mypage-container">
    <aside class="sidebar">
        <h2>마이페이지</h2>
        <div class="menu-group">
            <span class="menu-title">구매내역</span>
            <ul>
                <li><a href="${pageContext.request.contextPath}/member/mypage/orderList">주문/배송조회</a></li>
                <li><a href="${pageContext.request.contextPath}/member/mypage/cancelList">취소상품조회</a></li>
            </ul>
        </div>
        <div class="menu-group">
            <span class="menu-title">혜택내역</span>
            <ul>
                <li><a href="${pageContext.request.contextPath}/member/mypage/review">상품 리뷰</a></li>
                <li><a href="${pageContext.request.contextPath}/member/mypage/membership">포인트/쿠폰</a></li>
            </ul>
        </div>
        <div class="menu-group">
            <span class="menu-title">상품내역</span>
            <ul>
                <li><a href="${pageContext.request.contextPath}/member/mypage/wishList">관심 상품</a></li>
            </ul>
        </div>
        <div class="menu-group">
            <span class="menu-title">회원정보</span>
            <ul>
                <li><a href="${pageContext.request.contextPath}/member/mypage/myInfo">내 정보 관리</a></li>
                <li><a href="${pageContext.request.contextPath}/member/mypage/addr">배송지 관리</a></li>
                <li><a href="${pageContext.request.contextPath}/member/mypage/level_benefit" class="active">회원등급</a></li>
            </ul>
        </div>
        <div class="menu-group">
             <ul>
                <li><a href="${pageContext.request.contextPath}/member/logout" style="color:#999;">로그아웃</a></li>
             </ul>
        </div>
    </aside>

    <main class="main-content">
        <div class="membership-header">
            <h3>Membership</h3>
            <span class="serial">MK-TR-2026-V1</span>
        </div>

        <div class="grade-display">
            <div class="current-rank-box">
                <span class="label">Current Achievement</span>
                <div class="tier-name">
                    <c:choose>
                        <c:when test="${sessionScope.member.userLevel == 99}">MASTER</c:when>
                        <c:when test="${sessionScope.member.userLevel >= 51}">ADMIN</c:when>
                        <c:when test="${sessionScope.member.userLevel >= 41}">Platinum</c:when>
                        <c:when test="${sessionScope.member.userLevel >= 31}">Gold</c:when>
                        <c:when test="${sessionScope.member.userLevel >= 21}">Silver</c:when>
                        <c:when test="${sessionScope.member.userLevel >= 11}">Bronze</c:when>
                        <c:otherwise>Iron</c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <div class="rank-spec-box">
                <div>
                    <div class="spec-item"><span>User</span><span>${not empty sessionScope.member.userName ? sessionScope.member.userName : 'GUEST'}님</span></div>
                    <div class="spec-item"><span>Status</span><span>Active Member</span></div>
                </div>
                <div class="gauge-wrapper">
                    <div class="spec-item" style="border:none; padding-bottom:0;"><span>Progression</span><span>Next Rank</span></div>
                    <div class="gauge-bg">
                        <div class="gauge-fill"></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="section-title">Service Privileges</div>
        <div class="benefit-grid">
            <div class="benefit-item">
                <span class="top-tag">Accrual</span>
                <h5>Reward Points</h5>
                <p>구매 확정 시 등급별 포인트가 즉시 지급되어 다음 쇼핑에 사용 가능합니다.</p>
                <span class="status">Activated</span>
            </div>
            <div class="benefit-item">
                <span class="top-tag">Package</span>
                <h5>Priority Box</h5>
                <p>GOLD 랭크 이상 회원님을 위한 무채색 프리미엄 전용 패키징 서비스.</p>
                <span class="status" style="border-color:#ccc; color:#ccc;">Coming Soon</span>
            </div>
            <div class="benefit-item">
                <span class="top-tag">Event</span>
                <h5>Raffle Entry</h5>
                <p>PLATINUM 전용 한정판 드로우 및 시크릿 래플 응모권 자동 발급.</p>
                <span class="status" style="border-color:#ccc; color:#ccc;">Policy Planning</span>
            </div>
        </div>

        <div class="section-title">Ranking Policy</div>
        <table class="tier-table">
            <thead>
                <tr>
                    <th style="width: 25%;">Tier Rank</th>
                    <th style="width: 45%;">Qualification</th>
                    <th style="width: 30%;">Reward Benefits</th>
                </tr>
            </thead>
            <tbody>
                <tr class="${sessionScope.member.userLevel >= 1 && sessionScope.member.userLevel <= 10 ? 'current-rank' : ''}">
                    <td class="rank-name">Iron <c:if test="${sessionScope.member.userLevel >= 1 && sessionScope.member.userLevel <= 10}"><span class="tag-me">YOU</span></c:if></td>
                    <td>Lv.1 ~ 10</td>
                    <td>1% Point</td>
                </tr>
                <tr class="${sessionScope.member.userLevel >= 11 && sessionScope.member.userLevel <= 20 ? 'current-rank' : ''}">
                    <td class="rank-name">Bronze <c:if test="${sessionScope.member.userLevel >= 11 && sessionScope.member.userLevel <= 20}"><span class="tag-me">YOU</span></c:if></td>
                    <td>Lv.11 ~ 20</td>
                    <td>1.5% Point</td>
                </tr>
                <tr class="${sessionScope.member.userLevel >= 21 && sessionScope.member.userLevel <= 30 ? 'current-rank' : ''}">
                    <td class="rank-name">Silver <c:if test="${sessionScope.member.userLevel >= 21 && sessionScope.member.userLevel <= 30}"><span class="tag-me">YOU</span></c:if></td>
                    <td>Lv.21 ~ 30</td>
                    <td>2% Point</td>
                </tr>
                <tr class="${sessionScope.member.userLevel >= 31 && sessionScope.member.userLevel <= 40 ? 'current-rank' : ''}">
                    <td class="rank-name">Gold <c:if test="${sessionScope.member.userLevel >= 31 && sessionScope.member.userLevel <= 40}"><span class="tag-me">YOU</span></c:if></td>
                    <td>Lv.31 ~ 40</td>
                    <td>3% Point + Special Pack</td>
                </tr>
                <tr class="${sessionScope.member.userLevel >= 41 && sessionScope.member.userLevel <= 50 ? 'current-rank' : ''}">
                    <td class="rank-name">Platinum <c:if test="${sessionScope.member.userLevel >= 41 && sessionScope.member.userLevel <= 50}"><span class="tag-me">YOU</span></c:if></td>
                    <td>Lv.41 ~ 50</td>
                    <td>5% Point + Raffle Ticket</td>
                </tr>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
<jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />

</body>
</html>