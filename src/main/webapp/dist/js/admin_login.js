function sendAdminLogin() {
    const f = document.adminForm;
    
    if(!f.userId.value.trim()) { 
        alert("아이디를 입력하세요."); 
        f.userId.focus(); 
        return; 
    }
    
    if(!f.userPwd.value.trim()) { 
        alert("비밀번호를 입력하세요."); 
        f.userPwd.focus(); 
        return; 
    }
    
    f.submit();
}

document.addEventListener("DOMContentLoaded", () => {
    const inputs = document.querySelectorAll('.form-input');
    inputs.forEach(input => {
        input.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                sendAdminLogin();
            }
        });
    });
});