<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>로그인</title>
    
    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/header.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/footer.css" type="text/css">
    
    <style type="text/css">
        :root {
            --primary-color: #222; /* 짙은 차콜/블랙 */
            --border-color: #e0e0e0;
            --focus-color: #000;
        }

        body {
            background-color: #f8f9fa; /* 아주 연한 회색 배경 */
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            /* 헤더가 fixed(고정)되어 있으므로, 본문이 헤더 뒤로 숨지 않게 여백 추가 */
            padding-top: 80px; 
        }

        .login-wrapper {
            /* 화면 높이(100vh)에서 헤더(80px)와 푸터(대략 200~300px) 공간을 뺀 만큼 최소 높이를 잡아줌 
               이렇게 해야 내용이 적어도 푸터가 바닥에 붙어 있음
            */
            min-height: calc(100vh - 80px - 250px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 60px 20px;
        }

        .login-container {
            width: 100%;
            max-width: 420px;
            background: #fff;
            padding: 60px 40px;
            border-radius: 12px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.05); /* 고급스러운 그림자 */
            text-align: center;
        }

        .login-title {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 50px;
            letter-spacing: -0.5px;
        }

        /* --- 세련된 밑줄형 Input 스타일 --- */
        .input-group-minimal {
            position: relative;
            margin-bottom: 30px;
            text-align: left;
        }

        .input-minimal {
            width: 100%;
            padding: 10px 0;
            font-size: 1rem;
            color: #333;
            border: none;
            border-bottom: 1px solid var(--border-color);
            outline: none;
            background: transparent;
            transition: border-color 0.3s ease;
            border-radius: 0;
        }

        .input-minimal::placeholder {
            color: #aaa;
            font-size: 0.95rem;
            transition: color 0.3s ease;
        }

        .input-minimal:focus {
            border-bottom: 1px solid var(--focus-color);
        }
        
        .input-minimal:focus::placeholder {
            color: #777;
        }

        /* --- 체크박스 & 링크 영역 --- */
        .login-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
            font-size: 0.85rem;
            color: #666;
        }

        .form-check-input {
            cursor: pointer;
            margin-top: 0.2em;
        }
        
        .form-check-label {
            cursor: pointer;
            margin-left: 5px;
        }

        .link-text {
            color: #888;
            text-decoration: none;
            transition: color 0.2s;
        }
        .link-text:hover {
            color: #111;
            text-decoration: underline;
        }

        /* --- 로그인 버튼 --- */
        .btn-black {
            width: 100%;
            padding: 15px;
            background-color: var(--primary-color);
            color: #fff;
            font-size: 1rem;
            font-weight: 600;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-black:hover {
            background-color: #000;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        /* --- 하단 링크 --- */
        .bottom-links {
            margin-top: 30px;
            font-size: 0.9rem;
            color: #888;
        }
        
        .bottom-links a {
            color: #111;
            font-weight: 600;
            text-decoration: none;
            margin-left: 5px;
        }
        
        .bottom-links a:hover {
            text-decoration: underline;
        }
        
        /* 에러 메시지 */
        .error-msg {
            margin-top: 15px;
            color: #e74c3c;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <main class="login-wrapper">
        <div class="login-container">
            <h2 class="login-title">LOGIN</h2>
            
            <form name="loginForm" action="" method="post">
                
                <div class="input-group-minimal">
                    <input type="text" name="userId" class="input-minimal" placeholder="아이디" autocomplete="off">
                </div>
                
                <div class="input-group-minimal">
                    <input type="password" name="userPwd" class="input-minimal" placeholder="비밀번호" autocomplete="off">
                </div>

                <div class="login-actions">
                    <div class="d-flex align-items-center">
                        <input class="form-check-input" type="checkbox" id="saveId" name="saveId">
                        <label class="form-check-label" for="saveId">아이디 저장</label>
                    </div>
                    <a href="#" class="link-text">비밀번호를 잊으셨나요?</a>
                </div>

                <button type="button" class="btn-black" onclick="sendLogin();">로그인</button>

                <div class="bottom-links">
                    아직 회원이 아니신가요? <a href="join.jsp">회원가입</a>
                </div>
                
                <div class="error-msg">
                    ${message}
                </div>
            </form>
        </div>
    </main>
    
<script type="text/javascript">
function sendLogin() {
    const f = document.loginForm;
    
    if( ! f.userId.value.trim() ) {
        alert("아이디를 입력해주세요."); 
        f.userId.focus();
        return;
    }

    if( ! f.userPwd.value.trim() ) {
        alert("비밀번호를 입력해주세요.");
        f.userPwd.focus();
        return;
    }

    f.action = '${pageContext.request.contextPath}/member/login';
    f.submit();
}

// 엔터키 입력 시 로그인 처리
document.addEventListener("keydown", function(event) {
    if (event.key === "Enter") {
        sendLogin();
    }
});
</script>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
    <jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />
</body>
</html>