<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>마이페이지 | 포인트/쿠폰</title>

<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage.css">

<style>
    /* 탭 스타일 */
    .benefit-tabs { display: flex; border-bottom: 1px solid #ddd; margin: 20px 0 30px; padding-left: 0; }
    .benefit-tabs li { list-style: none; margin-right: 30px; }
    .benefit-tabs li a { 
        display: block; padding: 10px 0; font-size: 16px; color: #999; text-decoration: none; 
        border-bottom: 2px solid transparent; transition: 0.2s; 
    }
    .benefit-tabs li.active a { color: #000; border-bottom: 2px solid #000; font-weight: bold; }

    /* 탭 콘텐츠 */
    .tab-pane { display: none; }
    .tab-pane.active { display: block; }

    /* 포인트 요약 박스 */
    .point-box { 
        background: #f8f8f8; padding: 30px; text-align: center; border-radius: 6px; margin-bottom: 30px; 
    }
    .point-box h3 { font-size: 15px; font-weight: normal; color: #555; margin-bottom: 10px; }
    .point-box .total { font-size: 30px; font-weight: bold; color: #222; }
    .point-box .unit { font-size: 16px; font-weight: normal; color: #666; }

    /* 테이블 스타일 */
    .list-table { width: 100%; border-collapse: collapse; border-top: 1px solid #333; }
    .list-table th { background: #fff; padding: 15px 0; border-bottom: 1px solid #ddd; font-weight: 500; color: #333; }
    .list-table td { padding: 15px 0; border-bottom: 1px solid #eee; text-align: center; font-size: 14px; color: #666; }
    .list-table td.left { text-align: left; padding-left: 15px; }

    .plus { color: #007bff; font-weight: bold; }
    .minus { color: #dc3545; font-weight: bold; }
    .no-data { text-align: center; padding: 50px 0; color: #999; }
</style>

<script>
    // 탭 전환 스크립트
    function selectTab(mode) {
        // 기존 활성 상태 제거
        document.querySelectorAll('.benefit-tabs li').forEach(li => li.classList.remove('active'));
        document.querySelectorAll('.tab-pane').forEach(div => div.classList.remove('active'));

        // 선택 탭 활성화
        document.getElementById('tab-' + mode).classList.add('active');
        document.getElementById('content-' + mode).classList.add('active');
        
        // URL 파라미터 업데이트 (새로고침 없이)
        const url = new URL(window.location);
        url.searchParams.set('mode', mode);
        window.history.pushState({}, '', url);
    }

    // 페이지 로드 시 초기 탭 설정
    window.addEventListener('DOMContentLoaded', () => {
        const urlParams = new URLSearchParams(window.location.search);
        const mode = urlParams.get('mode');
        
        // mode가 'coupon'이면 쿠폰 탭, 그 외에는 무조건 포인트 탭
        if(mode === 'coupon') selectTab('coupon');
        else selectTab('point');
    });
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
                <li><a href="${pageContext.request.contextPath}/member/mypage/orderList">주문/배송조회</a></li>
                <li><a href="${pageContext.request.contextPath}/member/mypage/cancelList">취소상품조회</a></li>
            </ul>
        </div>

        <div class="menu-group">
            <span class="menu-title">혜택내역</span>
            <ul>
                <li><a href="${pageContext.request.contextPath}/member/mypage/review">상품 리뷰</a></li>
                <li><a href="${pageContext.request.contextPath}/member/mypage/membership" class="active">포인트/쿠폰</a></li>
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
                <li><a href="${pageContext.request.contextPath}/member/mypage/membership">회원등급</a></li>
            </ul>
        </div>
        
        <div class="menu-group">
             <ul>
                <li><a href="${pageContext.request.contextPath}/member/logout" style="color:#999;">로그아웃</a></li>
             </ul>
        </div>
    </aside>

    <main class="main-content">
        <h1 class="page-title">포인트 / 쿠폰</h1>

        <ul class="benefit-tabs">
            <li id="tab-point" class="active"><a href="javascript:selectTab('point');">포인트 내역</a></li>
            <li id="tab-coupon"><a href="javascript:selectTab('coupon');">쿠폰함</a></li>
        </ul>

        <div id="content-point" class="tab-pane active">
            <div class="point-box">
                <h3>현재 사용 가능한 포인트</h3>
                <span class="total"><fmt:formatNumber value="${currentPoint}" pattern="#,###"/></span>
                <span class="unit">P</span>
            </div>

            <table class="list-table">
                <colgroup>
                    <col width="120">
                    <col width="*">
                    <col width="120">
                    <col width="100">
                </colgroup>
                <thead>
                    <tr>
                        <th>날짜</th>
                        <th>내용</th>
                        <th>포인트</th>
                        <th>구분</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="dto" items="${list}">
                        <tr>
                            <td>${dto.reg_date}</td>
                            <td class="left">${dto.reason}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${dto.point_amount > 0}">
                                        <span class="plus">+<fmt:formatNumber value="${dto.point_amount}"/></span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="minus"><fmt:formatNumber value="${dto.point_amount}"/></span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>완료</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${dataCount == 0}">
                        <tr>
                            <td colspan="4" class="no-data">포인트 내역이 없습니다.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
           
            <div style="text-align:center; margin-top:20px;">
                ${paging}
            </div>
        </div>

        <div id="content-coupon" class="tab-pane">
            <div class="no-data">
                <img src="${pageContext.request.contextPath}/dist/images/icon_coupon_empty.png" alt="" style="max-width: 64px; margin-bottom: 15px; opacity: 0.5;">
                <p>보유하신 쿠폰이 없습니다.</p>
            </div>
        </div>

    </main>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
<jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />

</body>
</html>