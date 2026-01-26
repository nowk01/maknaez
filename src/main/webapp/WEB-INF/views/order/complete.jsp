<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>주문 완료 - Maknaez</title>

<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>

<style>
    @import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&family=Noto+Sans+KR:wght@300;400;500;700&display=swap');

    body { font-family: 'Noto Sans KR', sans-serif; color: #333; background-color: #f9f9f9; }
    .complete-wrap { max-width: 900px; margin: 0 auto; padding: 80px 20px; }
    
    .msg-section { text-align: center; margin-bottom: 60px; }
    .icon-box { margin-bottom: 25px; }
    .icon-box i { font-size: 4rem; color: #000; } 
    .check-icon { width: 80px; height: 80px; background: #000; color: #fff; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 2.5rem; margin-bottom: 20px; }
    
    .complete-title { font-family: 'Montserrat', sans-serif; font-weight: 700; font-size: 2.2rem; margin-bottom: 15px; color: #000; letter-spacing: -0.5px; }
    .complete-desc { font-size: 1.05rem; color: #666; margin-bottom: 10px; line-height: 1.6; }
    .order-num-highlight { font-family: 'Montserrat', sans-serif; font-weight: 600; color: #000; font-size: 1.1rem; margin-top: 10px; }

    .info-container { background: #fff; border: 1px solid #eee; border-radius: 8px; padding: 40px; margin-bottom: 30px; box-shadow: 0 5px 15px rgba(0,0,0,0.03); }
    .info-title { font-size: 1.2rem; font-weight: 700; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 2px solid #000; }
    
    .info-table { width: 100%; border-collapse: collapse; }
    .info-table th { width: 140px; padding: 12px 0; color: #555; font-weight: 500; text-align: left; vertical-align: top; }
    .info-table td { padding: 12px 0; color: #000; font-weight: 400; }
    
    .price-row th { color: #000; font-weight: 700; padding-top: 20px; border-top: 1px solid #eee; }
    .price-row td { color: #e02020; font-weight: 700; font-size: 1.2rem; padding-top: 20px; border-top: 1px solid #eee; font-family: 'Montserrat', sans-serif; }

    .btn-group-custom { display: flex; justify-content: center; gap: 15px; margin-top: 50px; }
    .btn-custom { padding: 15px 40px; font-size: 1rem; font-weight: 600; min-width: 180px; transition: 0.3s; border-radius: 4px; }
    
    .btn-home { background: #fff; color: #000; border: 1px solid #ccc; }
    .btn-home:hover { background: #f8f8f8; border-color: #bbb; }
    
    .btn-mypage { background: #000; color: #fff; border: 1px solid #000; }
    .btn-mypage:hover { background: #333; border-color: #333; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
</style>
</head>
<body>

<header>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<div class="complete-wrap">
    
    <div class="msg-section">
        <div class="check-icon">
            <i class="bi bi-check-lg"></i>
        </div>
        <div class="complete-title">ORDER COMPLETED</div>
        <div class="complete-desc">
            고객님의 주문이 정상적으로 완료되었습니다.<br>
            주문해주셔서 감사합니다.
        </div>
        <div class="order-num-highlight">
            주문번호 : <span>${orderId}</span>
        </div>
    </div>

    <div class="info-container">
        <div class="info-title">배송지 정보</div>
        <table class="info-table">
            <tr>
                <th>받는분</th>
                <td>${order.receiverName}</td>
            </tr>
            <tr>
                <th>연락처</th>
                <td>${order.receiverTel}</td>
            </tr>
            <tr>
                <th>주소</th>
                <td>
                    [${order.zip}]<br>${order.addr1}<br>${order.addr2}
                </td>
            </tr>
            <tr>
                <th>배송메모</th>
                <td>${order.memo}</td>
            </tr>
        </table>
    </div>

    <div class="info-container">
        <div class="info-title">결제 정보</div>
        <table class="info-table">
            <tr>
                <th>결제방법</th>
                <td>
                    <c:choose>
                        <c:when test="${payment.payMethod == 'card'}">신용카드</c:when>
                        <c:when test="${payment.payMethod == 'bank'}">무통장입금</c:when>
                        <c:otherwise>${payment.payMethod}</c:otherwise>
                    </c:choose>
                </td>
            </tr>
            
            <c:if test="${payment.payMethod == 'card'}">
                <tr>
                    <th>카드정보</th>
                    <td>${payment.cardName} (${payment.cardNum})</td>
                </tr>
            </c:if>
            
            <tr>
                <th>결제상태</th>
                <td>${payment.payStatus}</td>
            </tr>
            <tr class="price-row">
                <th>최종 결제금액</th>
                <td><fmt:formatNumber value="${payment.payAmount}" pattern="#,###"/>원</td>
            </tr>
        </table>
    </div>

    <div class="btn-group-custom">
        <button type="button" class="btn btn-custom btn-home" onclick="location.href='${pageContext.request.contextPath}/main'">쇼핑 계속하기</button>
        <button type="button" class="btn btn-custom btn-mypage" onclick="location.href='${pageContext.request.contextPath}/member/mypage/orderList'">주문내역 확인</button>
    </div>
</div>

<footer>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>

</body>
</html>