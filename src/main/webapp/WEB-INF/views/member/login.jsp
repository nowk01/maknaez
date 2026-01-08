<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>로그인</title>
    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
    
    <style type="text/css">
    	/* 화면 중앙 정렬을 위한 Wrapper */
		.login-wrapper {
		    min-height: 70vh; /* 헤더/푸터 제외하고 충분한 높이 확보 */
		    display: flex;
		    align-items: center;
		    justify-content: center;
		    background-color: #fff; /* 필요시 #f8f9fa(연한 회색) 변경 */
		}
		
		/* 로그인 박스 스타일 */
		.login-box {
		    width: 100%;
		    max-width: 400px; /* 너무 넓어지지 않게 제한 */
		    padding: 40px 20px;
		    background-color: #fff;
		    /* 박스 테두리가 필요하면 아래 주석 해제 (이미지는 테두리가 연하게 있음) */
		    border: 1px solid #eee; 
		}
		
		/* 타이틀 */
		.login-title {
		    font-weight: 700;
		    text-align: center;
		    margin-bottom: 40px;
		    font-size: 1.8rem;
		    color: #111;
		}
		
		/* 입력창 커스텀 (각지게, 넉넉하게) */
		.form-control-lg {
		    border-radius: 0;
		    font-size: 0.95rem;
		    padding: 12px 15px;
		    border: 1px solid #ddd;
		}
		.form-control-lg:focus {
		    box-shadow: none;
		    border-color: #333;
		}
		
		/* 체크박스 및 링크 폰트 사이즈 */
		.login-options {
		    font-size: 0.9rem;
		    color: #666;
		}
		.find-pw-link {
		    text-decoration: none;
		    color: #666;
		}
		
		/* 로그인 버튼 */
		.btn-login {
		    border-radius: 0;
		    font-weight: 600;
		    padding: 12px;
		    background-color: #333;
		    border: none;
		}
		.btn-login:hover {
		    background-color: #000;
		}
		
		/* 하단 링크 (회원가입 | 아이디 찾기) */
		.sub-links {
		    text-align: center;
		    font-size: 0.9rem;
		}
		.sub-links a {
		    text-decoration: none;
		    color: #555;
		}
		
		/* SNS 버튼 공통 */
		.sns-btn {
		    width: 48px;
		    height: 48px;
		    border-radius: 50%;
		    display: flex;
		    align-items: center;
		    justify-content: center;
		    text-decoration: none;
		    font-size: 1.2rem;
		    transition: opacity 0.2s;
		}
		.sns-btn:hover {
		    opacity: 0.8;
		}
		
		/* SNS 색상별 설정 */
		.sns-naver {
		    background-color: #03c75a;
		    color: #fff !important;
		    font-weight: 900;
		    font-family: sans-serif; /* N 글자를 위해 */
		}
		.sns-kakao {
		    background-color: #fee500;
		    color: #3c1e1e !important;
		    font-size: 1.1rem;
		}
		.sns-google {
		    background-color: #ea4335;
		    color: #fff !important;
		}
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <main class="login-wrapper">
        <div class="login-box">
            <h2 class="login-title">로그인</h2>
            
            <form action="" method="post">
                <div class="mb-3">
                    <input type="text" name="userId" class="form-control form-control-lg" placeholder="아이디 또는 이메일" required>
                </div>
                
                <div class="mb-3">
                    <input type="password" name="userPwd" class="form-control form-control-lg" placeholder="비밀번호" required>
                </div>

                <div class="d-flex justify-content-between align-items-center mb-4 login-options">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="saveId" name="saveId">
                        <label class="form-check-label" for="saveId">아이디 저장</label>
                    </div>
                    <a href="#" class="find-pw-link">비밀번호 찾기</a>
                </div>

                <div class="d-grid">
                    <button type="submit" class="btn btn-dark btn-lg btn-login" onclick="sendLogin();">로그인</button>
                </div>
            </form>

            <div class="sub-links mt-3">
                <a href="join.jsp">회원가입</a>
                <span class="mx-2 text-secondary">|</span>
                <a href="#">아이디 찾기</a>
            </div>

            <div class="sns-login-area mt-5 text-center">
                <p class="text-secondary small mb-3">SNS 계정으로 간편 로그인</p>
                <div class="d-flex justify-content-center gap-3">
                    <a href="#" class="sns-btn sns-naver">N</a>
                    <a href="#" class="sns-btn sns-kakao"><i class="fas fa-comment"></i></a>
                    <a href="#" class="sns-btn sns-google"><i class="fab fa-google"></i></a>
                </div>
            </div>
            
            <div class="d-grid">
				<p class="form-control-plaintext text-center text-primary">${message}</p>
			</div>
        </div>
    </main>
    
<script type="text/javascript">
function sendLogin() {
    const f = document.loginForm;
	
    if( ! f.userId.value.trim() ) {
        f.userId.focus();
        return;
    }

    if( ! f.userPwd.value.trim() ) {
        f.userPwd.focus();
        return;
    }

    f.action = '${pageContext.request.contextPath}/member/login';
    f.submit();
}
</script>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
    
    <jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />
</body>
</html>