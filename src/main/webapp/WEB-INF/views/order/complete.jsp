<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>주문 완료 - Maknaez</title>

<!-- 공통 리소스 -->
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>

<style>
    @import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&family=Noto+Sans+KR:wght@300;400;500;700&display=swap');

    body { font-family: 'Noto Sans KR', sans-serif; color: #000; }
    .complete-wrap { max-width: 800px; margin: 0 auto; padding: 100px 20px; text-align: center; }
    
    .icon-box { margin-bottom: 30px; }
    .icon-box i { font-size: 4rem; color: #000; } /* FontAwesome 체크 아이콘 */
    
    .complete-title { font-family: 'Montserrat', sans-serif; font-weight: 800; font-size: 2rem; margin-bottom: 15px; text-transform: uppercase; }
    .complete-desc { font-size: 1.1rem; color: #666; margin-bottom: 40px; line-height: 1.6; }
    
    .order-info-box { background: #f8f9fa; padding: 30px; border: 1px solid #ddd; margin-bottom: 40px; }
    .order-num-label { font-size: 0.9rem; color: #888; margin-bottom: 5px; }
    .order-num-val { font-size: 1.5rem; font-weight: 700; color: #000; font-family: 'Montserrat', sans-serif; }
    
    .btn-group-custom { display: flex; justify-content: center; gap: 15px; }
    .btn-custom { padding: 15px 30px; font-size: 1rem; font-weight: 600; min-width: 180px; transition: 0.3s; border: 1px solid #000; }
    
    .btn-home { background: #fff; color: #000; }
    .btn-home:hover { background: #f0f0f0; }
    
    .btn-mypage { background: #000; color: #fff; }
    .btn-mypage:hover { background: #333; transform: translateY(-2px); }
</style>
</head>
<body>

<header>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<div class="complete-wrap">
    <div class="icon-box">
        <div style="font-size: 4rem; color:#000;">✔</div>
    </div>

    <div class="complete-title">Order Completed</div>
    <div class="complete-desc">
        주문이 정상적으로 완료되었습니다.<br>
        주문 내역 및 배송 조회는 마이페이지에서 확인하실 수 있습니다.
    </div>

    <div class="order-info-box">
        <div class="order-num-label">ORDER NUMBER</div>
        <div class="order-num-val">${orderId}</div>
    </div>

    <div class="btn-group-custom">
        <button type="button" class="btn btn-custom btn-home" onclick="location.href='${pageContext.request.contextPath}/main'">메인으로</button>
        <button type="button" class="btn btn-custom btn-mypage" onclick="location.href='${pageContext.request.contextPath}/member/mypage/orderList'">주문내역 확인</button>
    </div>
</div>

<footer>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>

</body>
</html>