<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/header.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/footer.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<div class="privacy-container">
    
    <div class="privacy-header">
        <div class="vertical-point"></div>

        <h1 class="page-title animate-up delay-1">PRIVACY POLICY</h1>
        <p class="page-desc animate-up delay-2">
            MAKNAEZ 서비스 이용을 위한<br>
            개인정보 처리방침입니다.
        </p>
    </div>

    <div class="privacy-body animate-up delay-3">
        
        <hr class="divider">

        <div class="policy-summary">
            <div class="summary-item">
                <span class="label">시행일자</span>
                <span class="value">2024. 05. 20</span>
            </div>
            <div class="summary-item">
                <span class="label">문의처</span>
                <span class="value">help@maknaez.com</span>
            </div>
        </div>

        <hr class="divider">

        <section class="policy-section">
            <h3 class="section-title">01. 개인정보 수집 항목</h3>
            <p class="section-desc">회사는 회원가입, 상담, 서비스 신청 등을 위해 아래와 같은 개인정보를 수집하고 있습니다.</p>
            
            <div class="data-grid">
                <div class="data-row">
                    <div class="data-th">회원가입</div>
                    <div class="data-td">아이디, 비밀번호, 이름, 휴대전화번호, 이메일</div>
                </div>
                <div class="data-row">
                    <div class="data-th">주문/결제</div>
                    <div class="data-td">배송지 정보(수령인, 주소, 연락처), 결제 기록</div>
                </div>
                <div class="data-row">
                    <div class="data-th">서비스 이용</div>
                    <div class="data-td">접속 로그, 쿠키, 접속 IP 정보</div>
                </div>
            </div>
        </section>

        <section class="policy-section">
            <h3 class="section-title">02. 개인정보의 보유 및 이용기간</h3>
            <p class="section-desc">원칙적으로, 개인정보 수집 및 이용목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다. 단, 관계법령의 규정에 의하여 보존할 필요가 있는 경우 회사는 일정 기간 동안 회원정보를 보관합니다.</p>
            
            <div class="data-grid">
                <div class="data-row">
                    <div class="data-th">계약/청약철회</div>
                    <div class="data-td">5년 (전자상거래법)</div>
                </div>
                <div class="data-row">
                    <div class="data-th">대금결제/재화공급</div>
                    <div class="data-td">5년 (전자상거래법)</div>
                </div>
                <div class="data-row">
                    <div class="data-th">소비자 불만처리</div>
                    <div class="data-td">3년 (전자상거래법)</div>
                </div>
            </div>
        </section>

        <section class="policy-section">
            <h3 class="section-title">03. 개인정보의 파기절차</h3>
            <p class="section-desc">
                정보주체의 개인정보는 원칙적으로 개인정보의 수집 및 이용목적이 달성되면 지체 없이 파기합니다.<br>
                전자적 파일 형태인 경우 복구 및 재생되지 않도록 기술적인 방법을 이용하여 완전하게 삭제합니다.
            </p>
        </section>
    </div>
</div>

<style>
:root {
    --text-primary: #111;
    --text-secondary: #555;
    --border-color: #ddd;
    --line-bold: #000;
}

body {
    font-family: 'Pretendard', sans-serif !important;
    color: var(--text-primary);
    line-height: 1.6;
}

.privacy-container {
    max-width: 900px;
    margin: 160px auto 150px auto;
    padding: 0 40px;
}

.privacy-header {
    margin-bottom: 50px;
}

/* --- [1] 세로 선 애니메이션 (lineExtend) --- */
.vertical-point {
    width: 2px;
    height: 0; /* 처음엔 높이 0 */
    background-color: #000;
    margin-bottom: 30px;
    display: block;
    /* 0.8초 동안 부드럽게 늘어남 */
    animation: lineExtend 0.8s cubic-bezier(0.19, 1, 0.22, 1) forwards;
}

@keyframes lineExtend {
    to { height: 40px; } /* 최종 높이 40px */
}

/* --- [2] 텍스트 등장 애니메이션 (fadeInUp) --- */
.animate-up {
    opacity: 0;
    transform: translateY(20px); /* 살짝 아래에서 시작 */
    animation: fadeInUp 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94) forwards;
}

@keyframes fadeInUp {
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* --- [3] 순차적 딜레이 설정 (싸라락 효과 핵심) --- */
.delay-1 { animation-delay: 0.3s; } /* 제목: 선이 어느 정도 그려질 때쯤 등장 */
.delay-2 { animation-delay: 0.5s; } /* 설명: 제목 직후 */
.delay-3 { animation-delay: 0.7s; } /* 본문: 가장 마지막에 */


/* --- 기존 스타일 유지 --- */
.page-title {
    font-size: 48px;
    font-weight: 800;
    color: #000;
    margin: 0 0 20px 0;
    letter-spacing: -0.5px;
    line-height: 1;
    text-transform: uppercase;
}

.page-desc {
    font-size: 16px;
    color: #666;
    font-weight: 400;
    margin: 0;
}

.policy-summary {
    display: flex;
    gap: 60px;
    padding: 10px 0;
}

.summary-item .label {
    display: block;
    font-size: 12px;
    color: #999;
    margin-bottom: 4px;
    font-weight: 600;
    text-transform: uppercase;
}

.summary-item .value {
    font-size: 15px;
    color: #333;
    font-weight: 500;
}

.divider {
    border: 0;
    border-top: 2px solid var(--line-bold);
    margin: 20px 0;
    opacity: 1;
}

.policy-section {
    margin-top: 80px;
    margin-bottom: 80px;
}

.section-title {
    font-size: 20px;
    font-weight: 700;
    color: #000;
    margin-bottom: 15px;
}

.section-desc {
    font-size: 15px;
    color: #555;
    margin-bottom: 25px;
    line-height: 1.7;
}

.data-grid {
    border-top: 1px solid #000;
}

.data-row {
    display: flex;
    border-bottom: 1px solid var(--border-color);
}

.data-th {
    width: 180px;
    background-color: transparent;
    padding: 20px 0;
    font-weight: 600;
    color: #000;
    font-size: 14px;
    flex-shrink: 0;
}

.data-td {
    padding: 20px 0 20px 20px;
    font-size: 14px;
    color: #444;
    line-height: 1.6;
}

@media (max-width: 768px) {
    .privacy-container { padding: 0 20px; margin-top: 100px; }
    .page-title { font-size: 32px; }
    .data-row { flex-direction: column; }
    .data-th { width: 100%; padding-bottom: 5px; color: #888; }
    .data-td { padding: 0 0 20px 0; }
}
</style>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>