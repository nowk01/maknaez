<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>배송 조회 | MAKNAEZ</title>
<style>
    @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;700&display=swap');

    body {
        font-family: 'Noto Sans KR', sans-serif;
        background-color: #f4f4f4;
        margin: 0;
        padding: 20px;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
    }

    .tracking-card {
        background: #fff;
        width: 100%;
        max-width: 480px;
        border-radius: 0; 
        box-shadow: 0 10px 25px rgba(0,0,0,0.05);
        overflow: hidden;
        border: 1px solid #ddd;
    }

    .header {
        background: #000;
        color: #fff;
        padding: 25px;
        text-align: center;
    }

    .header h2 {
        margin: 0;
        font-size: 18px;
        font-weight: 700;
        letter-spacing: 1px;
        text-transform: uppercase;
    }

    .order-info {
        padding: 20px;
        border-bottom: 1px solid #eee;
        background: #fafafa;
        text-align: center;
    }

    .order-num {
        font-size: 14px;
        color: #888;
        margin-bottom: 5px;
    }

    .current-status {
        font-size: 24px;
        font-weight: 700;
        color: #000;
    }

    /* 타임라인 영역 */
    .timeline-wrapper {
        padding: 40px 30px;
    }

    .timeline {
        position: relative;
        padding-left: 20px;
    }

    /* 세로 줄 */
    .timeline::before {
        content: '';
        position: absolute;
        left: 6px;
        top: 5px;
        bottom: 5px;
        width: 2px;
        background: #e0e0e0;
    }

    .event {
        position: relative;
        margin-bottom: 40px;
        padding-left: 25px;
    }

    .event:last-child {
        margin-bottom: 0;
    }

    .event::after {
        content: '';
        position: absolute;
        left: -4px; 
        top: 0;
        width: 14px;
        height: 14px;
        border-radius: 50%;
        background: #fff;
        border: 4px solid #ddd;
        box-sizing: border-box;
        transition: all 0.3s ease;
    }

   
    .event.active::after {
        border-color: #000; 
        background: #000; 
        transform: scale(1.2); 
        box-shadow: 0 0 0 4px rgba(0,0,0,0.1);
    }

    .event.passed::after {
        border-color: #000;
        background: #fff;
    }

    .event-title {
        font-size: 16px;
        font-weight: 700;
        color: #aaa;
        margin-bottom: 6px;
    }

    .event.active .event-title, 
    .event.passed .event-title {
        color: #000;
    }

    .event-desc {
        font-size: 13px;
        color: #777;
        line-height: 1.5;
    }

    .event-time {
        font-size: 12px;
        color: #999;
        margin-top: 4px;
    }

    .btn-close {
        display: block;
        width: 100%;
        padding: 18px;
        background: #fff;
        border: none;
        border-top: 1px solid #eee;
        color: #333;
        font-size: 14px;
        font-weight: 700;
        cursor: pointer;
        text-transform: uppercase;
        transition: background 0.2s;
    }

    .btn-close:hover {
        background: #f9f9f9;
        color: #000;
    }
</style>
</head>
<body>

    <div class="tracking-card">
        <div class="header">
            <h2>Tracking Info</h2>
        </div>

        <div class="order-info">
            <div class="order-num">ORDER NO. ${param.orderNum}</div>
            <div class="current-status">${dto.orderState}</div>
        </div>

        <div class="timeline-wrapper">
            <div class="timeline">
                
                <div class="event passed">
                    <div class="event-title">결제 완료</div>
                    <div class="event-desc">주문이 정상적으로 접수되었습니다.</div>
                    <div class="event-time">${dto.orderDate}</div>
                </div>

                <c:choose>
                    <c:when test="${dto.orderState == '배송중'}">
                        <div class="event active">
                            <div class="event-title">배송중</div>
                            <div class="event-desc">상품이 터미널로 이동 중입니다.<br>잠시만 기다려주세요.</div>
                            <div class="event-time">처리 중</div>
                        </div>
                    </c:when>
                    <c:when test="${dto.orderState == '배송완료' || dto.orderState == '구매확정'}">
                        <div class="event passed">
                            <div class="event-title">배송중</div>
                            <div class="event-desc">배송이 시작되었습니다.</div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="event">
                            <div class="event-title">배송 준비</div>
                            <div class="event-desc">상품 준비 중입니다.</div>
                        </div>
                    </c:otherwise>
                </c:choose>

                <c:choose>
                    <c:when test="${dto.orderState == '배송완료' || dto.orderState == '구매확정'}">
                        <div class="event active">
                            <div class="event-title">배송 완료</div>
                            <div class="event-desc">고객님께 상품이 전달되었습니다.<br>상품을 확인해주세요.</div>
                            <div class="event-time">도착 완료</div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="event">
                            <div class="event-title">배송 완료</div>
                            <div class="event-desc">아직 도착하지 않았습니다.</div>
                        </div>
                    </c:otherwise>
                </c:choose>

            </div>
        </div>

        <button class="btn-close" onclick="window.close()">Close Window</button>
    </div>

</body>
</html>