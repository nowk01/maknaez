<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>로그인 | MAKNAEZ</title>

    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/footer.css">

    <style>
        body {
            background: #fff;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            padding-top: 0;
            color: #111;
        }

        /* ===== LOGIN WRAPPER ===== */
        .login-wrapper {
            max-width: 420px;
            margin: 0 auto;
            padding: 100px 20px 80px; 
            text-align: center;
        }

        /* ===== SLIDE ANIMATION ===== */
        .slide-item {
            opacity: 0;
            transform: translateY(30px);
            transition: all 0.8s cubic-bezier(0.22, 1, 0.36, 1);
        }

        .slide-item.show {
            opacity: 1;
            transform: translateY(0);
        }

        /* ===== LOGIN FORM STYLES ===== */
        .login-title { font-size: 28px; font-weight: 700; margin-bottom: 20px; }
        .login-desc { font-size: 14px; color: #555; line-height: 1.6; margin-bottom: 40px; }
        
        .btn-kakao {
            width: 100%; height: 52px; background: #FEE500;
            border: none; border-radius: 26px;
            font-size: 15px; font-weight: 600; cursor: pointer; margin-bottom: 40px;
        }

        .form-input {
            width: 100%; height: 48px; border: 1px solid #ddd;
            padding: 0 14px; font-size: 14px; margin-bottom: 12px;
        }
        .form-input:focus { outline: none; border-color: #000; }

        .login-options {
            display: flex; justify-content: space-between; align-items: center;
            font-size: 13px; color: #777; margin: 15px 0 30px;
        }
        .login-options a { color: #777; text-decoration: none; }
        
        .btn-login {
            width: 100%; height: 52px; background: #000; color: #fff;
            border: none; border-radius: 26px; font-size: 15px; font-weight: 600; cursor: pointer;
        }

        .error-msg { margin-top: 15px; color: #e74c3c; font-size: 13px; }

        /* ===== REGISTER SECTION (여백 및 줄 스타일 수정) ===== */
        .register-wrapper {
            /* [수정 1] 양옆 여백 주기 */
            width: 80%;          /* 화면의 94%만 사용 (양옆 공간 남김) */
            max-width: 1600px;   /* 너무 넓어지지 않게 최대폭 제한 */
            margin: 0 auto 100px; /* 가운데 정렬 및 아래 여백 */
            
            /* [수정 2] 줄과 글자 사이 간격 (높이감) */
            padding: 70px 0;    
            
            border-top: 3px solid #000;    
            border-bottom: 3px solid #000; 

            text-align: center;
            background-color: #fff;

            opacity: 0;
            transform: translateY(40px);
            transition: all 1s cubic-bezier(0.22, 1, 0.36, 1);
        }

        .register-wrapper.active {
            opacity: 1;
            transform: translateY(0);
        }

        .register-content {
            max-width: 420px; 
            margin: 0 auto;
            padding: 0 20px;
        }

        .register-title {
            font-size: 24px;
            font-weight: 800;
            margin-bottom: 10px;
            color: #000;
        }

        .register-desc {
            font-size: 14px;
            color: #666;
            margin-bottom: 30px;
        }

        .btn-outline {
            display: block;
            width: 100%;
            height: 52px;
            line-height: 52px;
            background: #fff;
            color: #000;
            border: 1px solid #000;
            border-radius: 26px;
            font-size: 15px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s;
        }

        .btn-outline:hover {
            background: #000;
            color: #fff;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<main class="login-wrapper">
    <h2 class="login-title slide-item">로그인</h2>

    <p class="login-desc slide-item">
        카카오로 간편하게 회원가입/로그인 하세요.<br>
        카카오로 가입 시 광고 및 마케팅 수신에 동의하시면<br>
        <strong>5,000포인트</strong>가 지급됩니다.
    </p>

    <button type="button" class="btn-kakao slide-item">
        카카오 회원가입 및 로그인
    </button>

    <form name="loginForm" method="post">
    <%
        String returnUrl = request.getParameter("returnUrl");
        if (returnUrl == null || returnUrl.trim().isEmpty()) {
            String referer = request.getHeader("Referer");
            if (referer != null && !referer.contains("/member/login")) {
                try {
                    java.net.URL url = new java.net.URL(referer);
                    String path = url.getPath(); // 예: /maknaez/collections/list
                    String query = url.getQuery();
                    
                    // [중요] 컨텍스트 패스(/maknaez)를 찾아 제거하여 중복 방지
                    String cp = request.getContextPath();
                    if (cp != null && !cp.isEmpty() && path.startsWith(cp)) {
                        path = path.substring(cp.length()); // /collections/list 만 남김
                    }
                    
                    returnUrl = path + (query != null ? "?" + query : "");
                } catch (Exception e) {
                    returnUrl = "";
                }
            }
        }
        if (returnUrl == null) returnUrl = "";
    %>
    	<input type="hidden" name="returnUrl" value="<%= returnUrl %>">
   		<input type="text" name="userId" class="form-input slide-item" placeholder="아이디">
        <input type="password" name="userPwd" class="form-input slide-item" placeholder="비밀번호">

        <div class="login-options slide-item">
            <label><input type="checkbox" name="saveId"> 이메일 저장</label>
            <a href="#">비밀번호를 잊으셨나요?</a>
        </div>

        <button type="button" class="btn-login slide-item" onclick="sendLogin();">
            로그인
        </button>

        <div class="error-msg slide-item">${message}</div>
    </form>
</main>

<section class="register-wrapper">
    <div class="register-content">
        <h2 class="register-title">계정이 없으신가요?</h2>
        <p class="register-desc">
            MAKNAEZ 회원에겐 특별한 멤버십 혜택이 제공됩니다.
        </p>
        <a href="${pageContext.request.contextPath}/member/consent" class="btn-outline">
    		회원가입 하기
		</a>
    </div>
</section>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
<jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />

<script>
/* ===== LOGIN SLIDE ===== */
document.addEventListener("DOMContentLoaded", () => {
    const items = document.querySelectorAll(".slide-item");
    items.forEach((el, idx) => {
        setTimeout(() => {
            el.classList.add("show");
        }, idx * 120);
    });
});

/* ===== REGISTER SCROLL ANIMATION ===== */
const registerWrapper = document.querySelector('.register-wrapper');
const observer = new IntersectionObserver(entries => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('active');
            observer.unobserve(entry.target);
        }
    });
}, { threshold: 0.2 });
observer.observe(registerWrapper);

/* ===== LOGIN LOGIC ===== */
function sendLogin() {
    const f = document.loginForm;
    if (!f.userId.value.trim()) { alert("이메일을 입력해주세요."); f.userId.focus(); return; }
    if (!f.userPwd.value.trim()) { alert("비밀번호를 입력해주세요."); f.userPwd.focus(); return; }
    f.action = '${pageContext.request.contextPath}/member/login';
    f.submit();
}
document.loginForm.addEventListener("keydown", function(e) {
    if (e.key === "Enter") { e.preventDefault(); sendLogin(); }
});
</script>

</body>
</html>