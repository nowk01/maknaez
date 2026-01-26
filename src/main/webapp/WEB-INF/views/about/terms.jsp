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

        <h1 class="page-title animate-up delay-1">TERMS OF USE</h1>
        <p class="page-desc animate-up delay-2">
            MAKNAEZ 서비스 이용을 위한<br>
            서비스 이용약관입니다.
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
                <span class="label">게시일자</span>
                <span class="value">2024. 05. 13</span>
            </div>
        </div>

        <hr class="divider">

        <section class="policy-section">
            <h3 class="section-title">제 1 조 (목적)</h3>
            <p class="section-desc">
                이 약관은 MAKNAEZ(이하 "회사"라 함)가 운영하는 사이버 몰(이하 "몰"이라 함)에서 제공하는 인터넷 관련 서비스(이하 "서비스"라 함)를 이용함에 있어 사이버 몰과 이용자의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.
            </p>
        </section>

        <section class="policy-section">
            <h3 class="section-title">제 2 조 (정의)</h3>
            <p class="section-desc">
                1. "몰"이란 회사가 재화 또는 용역(이하 "재화 등"이라 함)을 이용자에게 제공하기 위하여 컴퓨터 등 정보통신설비를 이용하여 재화 등을 거래할 수 있도록 설정한 가상의 영업장을 말합니다.<br>
                2. "이용자"란 "몰"에 접속하여 이 약관에 따라 "몰"이 제공하는 서비스를 받는 회원 및 비회원을 말합니다.
            </p>
        </section>

        <section class="policy-section">
            <h3 class="section-title">제 3 조 (회원가입 및 이용계약)</h3>
            <div class="data-grid">
                <div class="data-row">
                    <div class="data-th">가입 자격</div>
                    <div class="data-td">"몰"이 정한 가입 양식에 따라 회원정보를 기입한 후 이 약관에 동의한다는 의사표시를 함으로써 회원가입을 신청합니다.</div>
                </div>
                <div class="data-row">
                    <div class="data-th">승낙 유보</div>
                    <div class="data-td">가입신청자가 이 약관 제7조 제3항에 의하여 이전에 회원자격을 상실한 적이 있는 경우 승낙을 유보할 수 있습니다.</div>
                </div>
            </div>
        </section>
        
        <section class="policy-section">
            <h3 class="section-title">제 4 조 (지급방법)</h3>
            <p class="section-desc">
                "몰"에서 구매한 재화 또는 용역에 대한 대금지급방법은 다음 각 호의 방법중 가용한 방법으로 할 수 있습니다.
            </p>
            <div class="data-grid">
                <div class="data-row">
                    <div class="data-th">결제 수단</div>
                    <div class="data-td">폰뱅킹, 인터넷뱅킹, 메일 뱅킹 등의 각종 계좌이체 및 선불카드, 직불카드, 신용카드 등의 각종 카드 결제</div>
                </div>
            </div>
        </section>

        <section class="policy-section">
            <h3 class="section-title">부칙</h3>
            <p class="section-desc">
                1. 이 약관은 2024년 05월 20일부터 시행합니다.<br>
                2. 이 약관 시행 전에 이미 가입된 회원은 변경된 약관의 적용을 받습니다.
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

.vertical-point {
    width: 2px;
    height: 0;
    background-color: #000;
    margin-bottom: 30px;
    display: block;
    animation: lineExtend 0.8s cubic-bezier(0.19, 1, 0.22, 1) forwards;
}

@keyframes lineExtend {
    to { height: 40px; }
}

.animate-up {
    opacity: 0;
    transform: translateY(20px);
    animation: fadeInUp 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94) forwards;
}

@keyframes fadeInUp {
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* 딜레이 설정 */
.delay-1 { animation-delay: 0.3s; }
.delay-2 { animation-delay: 0.5s; }
.delay-3 { animation-delay: 0.7s; }

/* 타이포그래피 */
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

/* 메타데이터  */
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

/* 구분선 */
.divider {
    border: 0;
    border-top: 2px solid var(--line-bold);
    margin: 20px 0;
    opacity: 1;
}

/* 섹션 스타일 */
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
    word-break: keep-all; 
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

</style>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>