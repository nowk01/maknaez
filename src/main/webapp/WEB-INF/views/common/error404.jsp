<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;800&display=swap" rel="stylesheet">
<style>
    /* 전체 섹션 설정 */
    .slm-error-section {
        background-color: #fff;
        color: #000;
        font-family: 'Inter', -apple-system, sans-serif;
        height: 75vh;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        text-align: center;
        padding: 0 20px;
    }

    /* 1. 수직선 확장 애니메이션 */
    .slm-divider {
        width: 1px;
        height: 0;
        background-color: #000;
        margin-bottom: 30px;
        animation: lineExtend 1.2s cubic-bezier(0.19, 1, 0.22, 1) forwards;
    }

    @keyframes lineExtend {
        to { height: 60px; }
    }

    /* 2. 요소들 페이드인 + 슬라이드 업 애니메이션 */
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

    /* 상단 라벨 */
    .error-label {
        font-size: 11px;
        font-weight: 700;
        letter-spacing: 0.3em;
        text-transform: uppercase;
        margin-bottom: 20px;
        animation-delay: 0.4s;
    }

    /* 404 메인 타이틀 */
    .error-main-title {
        font-size: 130px;
        font-weight: 800;
        letter-spacing: -0.05em;
        margin: 0;
        line-height: 1;
        animation-delay: 0.6s;
    }

    /* 서브 타이틀 */
    .error-sub-title {
        font-size: 20px;
        font-weight: 700;
        letter-spacing: 0.05em;
        margin: 15px 0 25px;
        text-transform: uppercase;
        animation-delay: 0.8s;
    }

    /* 설명글 */
    .error-description {
        font-size: 14px;
        color: #666;
        line-height: 1.8;
        max-width: 450px;
        margin: 0 auto 50px;
        word-break: keep-all;
        animation-delay: 1.0s;
    }

    /* 버튼 그룹 */
    .slm-btn-wrap {
        display: flex;
        gap: 12px;
        animation-delay: 1.2s;
    }

    /* 버튼 공통 스타일 */
    .slm-action-btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 180px;
        height: 54px;
        font-size: 12px;
        font-weight: 700;
        letter-spacing: 0.15em;
        text-decoration: none;
        text-transform: uppercase;
        border: 1px solid #000;
        transition: all 0.4s cubic-bezier(0.19, 1, 0.22, 1);
    }

    /* BACK 버튼 (라인) */
    .btn-lined {
        background-color: #fff;
        color: #000;
    }
    .btn-lined:hover {
        background-color: #000;
        color: #fff;
    }

    /* HOME 버튼 (블랙) */
    .btn-filled {
        background-color: #000;
        color: #fff;
    }
    .btn-filled:hover {
        background-color: #333;
        border-color: #333;
    }
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <main class="slm-error-section">
        <div class="slm-divider"></div>
        
        <span class="error-label animate-up">Status Report</span>
        <h1 class="error-main-title animate-up">404</h1>
        <h2 class="error-sub-title animate-up">Page not found</h2>
        
        <p class="error-description animate-up">
            죄송합니다. 요청하신 페이지가 존재하지 않거나,<br>
            기술적인 문제로 인해 일시적으로 접속이 불가능합니다.
        </p>
        
        <div class="slm-btn-wrap animate-up">
            <a href="javascript:history.back();" class="slm-action-btn btn-lined">BACK</a>
            <a href="${pageContext.request.contextPath}/main" class="slm-action-btn btn-filled">HOME</a>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body>
</html>