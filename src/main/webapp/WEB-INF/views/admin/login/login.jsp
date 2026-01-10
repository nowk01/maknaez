<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MAKNAEZ Administrator</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_login.css">
</head>
<body>

    <div class="admin-login-box">
        <div class="logo-area">
            <h1>MAKNAEZ</h1>
            <span>Administrator Login</span>
        </div>

        <form name="adminForm" action="${pageContext.request.contextPath}/admin/login" method="post">
            <c:if test="${not empty message}">
                <div class="error-msg">⚠️ ${message}</div>
            </c:if>

            <div class="form-group">
                <label class="form-label">Admin ID</label>
                <input type="text" name="userId" class="form-input" placeholder="관리자 아이디" autocomplete="off">
            </div>

            <div class="form-group">
                <label class="form-label">Password</label>
                <input type="password" name="userPwd" class="form-input" placeholder="비밀번호">
            </div>

            <button type="button" class="btn-submit" onclick="sendAdminLogin();">LOGIN</button>
        </form>
        
        <div class="footer">&copy; MAKNAEZ Corp. All rights reserved.</div>
    </div>

    <script src="${pageContext.request.contextPath}/dist/js/admin_login.js"></script>

</body>
</html>