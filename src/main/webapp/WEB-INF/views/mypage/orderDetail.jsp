<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>주문상세 | 쇼핑몰</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage.css">
<style>
    /* 살로몬 주문상세 전용 스타일 - 기존 mypage.css와 충돌 방지 */
    .detail-container { max-width: 1000px; margin: 40px auto; padding: 0 20px; color: #000; }
    .detail-title { font-size: 28px; font-weight: 700; text-align: center; margin-bottom: 40px; text-transform: uppercase; }
    
    .detail-header-info { display: flex; gap: 20px; font-size: 14px; margin-bottom: 10px; color: #666; }
    .detail-header-info strong { color: #000; margin-right: 5px; }

    /* 섹션 공통 */
    .detail-section { margin-bottom: 50px; }
    .detail-section-title { font-size: 20px; font-weight: 700; margin-bottom: 15px; }
    
    /* 살로몬 특유의 굵은 헤더 라인 */
    .detail-table { width: 100%; border-collapse: collapse; border-top: 2px solid #000; }
    .detail-table th { background-color: #fff; padding: 20px 10px; font-size: 14px; color: #000; border-bottom: 1px solid #eee; text-align: center; }
    .detail-table td { padding: 20px 10px; border-bottom: 1px solid #eee; vertical-align: middle; font-size: 14px; }

    /* 상품 정보 열 */
    .prod-info-box { display: flex; align-items: center; gap: 20px; }
    .prod-info-box img { width: 100px; height: 100px; object-fit: cover; background: #f9f9f9; }
    .prod-details .name { font-weight: 700; font-size: 15px; display: block; margin-bottom: 5px; }
    .prod-details .opt { color: #888; font-size: 13px; }

    /* 배송지/결제 정보 그리드 (2열) */
    .info-grid { display: grid; grid-template-columns: 150px 1fr; border-top: 2px solid #000; }
    .info-grid-item { display: contents; }
    .info-grid-item .label { padding: 20px 0; font-weight: 700; font-size: 14px; border-bottom: 1px solid #eee; }
    .info-grid-item .value { padding: 20px 0; font-size: 14px; border-bottom: 1px solid #eee; color: #333; }

    /* 하단 버튼 */
    .detail-footer { text-align: center; margin-top: 60px; }
    .btn-list { 
        display: inline-block; background: #000; color: #fff; 
        padding: 15px 80px; font-size: 14px; font-weight: 700; 
        border-radius: 30px; text-decoration: none; transition: 0.3s;
    }
    .btn-list:hover { background: #333; }

    /* 강조 텍스트 (총 결제금액 등) */
    .highlight-price { font-size: 18px; font-weight: 900; }
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="detail-container">
    <h1 class="detail-title">주문상세</h1>

    <div class="detail-header-info">
        <span><strong>주문번호</strong> ${dto.orderNum}</span>
        <span>|</span>
        <span><strong>주문일</strong> ${dto.orderDate}</span>
    </div>

    <div class="detail-section">
        <table class="detail-table">
            <colgroup>
                <col style="width: 50%;">
                <col style="width: 25%;">
                <col style="width: 25%;">
            </colgroup>
            <thead>
                <tr>
                    <th>상품 정보</th>
                    <th>주문금액</th>
                    <th>주문상태</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <div class="prod-info-box">
                            <img src="${pageContext.request.contextPath}/uploads/product/${dto.thumbNail}" onerror="this.src='${pageContext.request.contextPath}/dist/images/no-image.png'">
                            <div class="prod-details">
                                <span class="name">${dto.productName}</span>
                                <span class="opt">컬러: ${dto.color} / 사이즈: ${dto.pdSize} / 수량: ${dto.qty}</span>
                            </div>
                        </div>
                    </td>
                    <td style="text-align: center;">
                        <strong><fmt:formatNumber value="${dto.totalAmount}" pattern="#,###" />원</strong>
                    </td>
                    <td style="text-align: center; color: #666;">
                        ${dto.orderState}
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="detail-section">
        <h2 class="detail-section-title">배송지 정보</h2>
        <div class="info-grid">
            <div class="info-grid-item">
                <div class="label">이름</div>
                <div class="value">${dto.userName}</div>
            </div>
            <div class="info-grid-item">
                <div class="label">이메일 주소</div>
                <div class="value">${dto.email}</div>
            </div>
            <div class="info-grid-item">
                <div class="label">휴대폰 번호</div>
                <div class="value">${dto.tel}</div>
            </div>
            <div class="info-grid-item">
                <div class="label">배송지 주소</div>
                <div class="value">[${dto.zip}] ${dto.addr1} ${dto.addr2}</div>
            </div>
        </div>
    </div>

    <div class="detail-section">
        <h2 class="detail-section-title">결제 정보</h2>
        <div class="info-grid">
            <div class="info-grid-item">
                <div class="label">결제방법</div>
                <div class="value">KG 이니시스 (카드결제)</div>
            </div>
            <div class="info-grid-item">
                <div class="label">총 결제금액</div>
                <div class="value highlight-price">
                    <fmt:formatNumber value="${dto.totalAmount}" pattern="#,###" />원
                </div>
            </div>
        </div>
    </div>

    <div class="detail-footer">
        <a href="${pageContext.request.contextPath}/member/mypage/orderList" class="btn-list">목록</a>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body>
</html>