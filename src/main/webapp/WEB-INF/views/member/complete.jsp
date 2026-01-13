<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>${title} | MAKNAEZ</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<style>
    /* 회원가입/정보수정 완료 컨테이너 */
    .complete-container {
        max-width: 500px;
        margin: 150px auto 120px;
        padding: 0 25px;
        text-align: center;
        font-family: 'Inter', 'Pretendard', sans-serif;
    }

    .complete-icon {
        width: 80px;
        height: 80px;
        background: #000;
        color: #fff;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 40px;
        font-size: 40px;
    }

    .complete-header {
        margin-bottom: 30px;
    }

    .complete-header h2 {
        font-size: 32px;
        font-weight: 900;
        letter-spacing: -1px;
        margin-bottom: 15px;
        text-transform: uppercase;
    }

    .complete-msg {
        font-size: 16px;
        line-height: 1.6;
        color: #333;
        margin-bottom: 50px;
    }

    .complete-msg b {
        color: #000;
        font-weight: 800;
    }

    /* 하단 버튼 영역 */
    .btn-area {
        display: flex;
        gap: 15px;
    }

    .btn-complete {
        flex: 1;
        height: 60px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 14px;
        font-weight: 800;
        text-decoration: none;
        letter-spacing: 1px;
        transition: 0.3s;
        text-transform: uppercase;
    }

    .btn-home {
        background: #fff;
        color: #000;
        border: 1px solid #000;
    }

    .btn-home:hover {
        background: #f8f8f8;
    }

    .btn-login {
        background: #000;
        color: #fff;
        border: 1px solid #000;
    }

    .btn-login:hover {
        background: #1a1a1a;
    }
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="complete-container">
    <div class="complete-icon">
        <i class="fa-solid fa-check"></i>
    </div>

    <div class="complete-header">
        <h2>${title} 완료</h2>
    </div>

    <div class="complete-msg">
        ${message}
    </div>

    <div class="btn-area">
        <a href="${pageContext.request.contextPath}/" class="btn-complete btn-home">홈으로 이동 HOME</a>
        
        <c:if test="${title == '회원가입'}">
            <a href="${pageContext.request.contextPath}/member/login" class="btn-complete btn-login">로그인 LOGIN</a>
        </c:if>
        
        <c:if test="${title == '정보수정'}">
            <a href="${pageContext.request.contextPath}/member/mypage/main.do" class="btn-complete btn-login">마이페이지 MY PAGE</a>
        </c:if>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

</body>
</html>