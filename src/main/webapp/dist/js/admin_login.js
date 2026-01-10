function sendAdminLogin() {
    const f = document.adminForm;
    
    // 아이디 공백 체크
    if(!f.userId.value.trim()) { 
        alert("아이디를 입력하세요."); 
        f.userId.focus(); 
        return; 
    }
    
    // 비밀번호 공백 체크
    if(!f.userPwd.value.trim()) { 
        alert("비밀번호를 입력하세요."); 
        f.userPwd.focus(); 
        return; 
    }
    
    f.submit();
}

// DOM 로드 후 이벤트 바인딩
document.addEventListener("DOMContentLoaded", () => {
    // 인풋창에서 엔터키 누르면 로그인 함수 실행
    const inputs = document.querySelectorAll('.form-input');
    inputs.forEach(input => {
        input.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                sendAdminLogin();
            }
        });
    });
});