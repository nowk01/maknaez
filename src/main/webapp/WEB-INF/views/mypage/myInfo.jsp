<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>내 정보 관리 | 쇼핑몰</title>
    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/my_info.css">

    <script type="text/javascript">
        // 폼 전송 전 데이터 가공 및 유효성 검사
        function updateMember() {
            const f = document.memberForm;

            // 1. 이름 병합 (성 + 이름 -> userName)
            const lastName = document.getElementById("last_name_customer").value.trim();
            const firstName = document.getElementById("first_name_customer").value.trim();
            if(!lastName || !firstName) {
                alert("이름을 모두 입력해주세요.");
                return;
            }
            f.userName.value = lastName + firstName;

            // 2. 이메일 분리 (aaa@bbb.com -> email1, email2)
            const fullEmail = document.getElementById("email_customer").value.trim();
            if(!fullEmail || !fullEmail.includes("@")) {
                alert("올바른 이메일 형식이 아닙니다.");
                return;
            }
            const emailParts = fullEmail.split("@");
            f.email1.value = emailParts[0];
            f.email2.value = emailParts[1];

            // 3. 비밀번호 확인 (필수)
            if(!f.userPwd.value) {
                alert("정보 수정을 위해 비밀번호를 입력해주세요.");
                f.userPwd.focus();
                return;
            }

            // 4. 전송
            f.action = "${pageContext.request.contextPath}/member/update";
            f.submit();
        }
    </script>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="mypage-container">

    <aside class="sidebar">
        <h2>마이페이지</h2>
        <div class="menu-group">
            <span class="menu-title">구매내역</span>
            <ul>
                <li><a href="${pageContext.request.contextPath}/member/mypage/orderList">주문/배송조회</a></li>
                <li><a href="${pageContext.request.contextPath}/member/mypage/cancelList">취소/반품조회</a></li>
            </ul>
        </div>
        <div class="menu-group">
            <span class="menu-title">혜택내역</span>
            <ul>
                <li><a href="${pageContext.request.contextPath}/member/mypage/review">상품 리뷰</a></li>
                <li><a href="#">포인트/쿠폰</a></li>
            </ul>
        </div>
        <div class="menu-group">
            <span class="menu-title">상품내역</span>
            <ul>
                <li><a href="#">최근 본 상품</a></li>
                <li><a href="${pageContext.request.contextPath}/member/mypage/wishList">관심 상품</a></li>
            </ul>
        </div>
        <div class="menu-group">
            <span class="menu-title">회원정보</span>
            <ul>
                <li><a href="${pageContext.request.contextPath}/member/pwd?mode=update" class="active">내 정보 관리</a></li>
                <li><a href="#">배송지 관리</a></li>
                <li><a href="#">회원등급</a></li>
                <li><a href="#">문의하기</a></li>
            </ul>
        </div>
        <div class="menu-group">
             <ul>
                <li><a href="${pageContext.request.contextPath}/member/logout" style="color:#999;">로그아웃</a></li>
             </ul>
        </div>
    </aside>

    <main class="main-content">
        <div id="customer_detail" class="group sm-salomon__details">
            <h2 class="h2 feature-header">내 정보 관리</h2>
            
            <div class="customer__detailsForm">
                <form name="memberForm" method="post" enctype="multipart/form-data">
                    
                    <input type="hidden" name="userName">
                    <input type="hidden" name="email1">
                    <input type="hidden" name="email2">
                    
                    <input type="hidden" name="zip" value="${dto.zip}">
                    <input type="hidden" name="addr1" value="${dto.addr1}">
                    <input type="hidden" name="addr2" value="${dto.addr2}">
                    <input type="hidden" name="profile_photo" value="${dto.profile_photo}">
                    
                    <div class="input-row">
                        <label class="info-label">아이디</label>
                        <input type="text" value="${dto.userId}" disabled style="background:#f9f9f9;">
                    </div>

                    <div id="customer_form">
                        <label class="info-label" for="last_name_customer">이름</label>
                        <div class="divided">
                            <c:set var="lastName" value="${fn:substring(dto.userName, 0, 1)}" />
                            <c:set var="firstName" value="${fn:substring(dto.userName, 1, fn:length(dto.userName))}" />
                            
                            <input class="divided__input" type="text" aria-label="성" placeholder="성" id="last_name_customer" value="${lastName}">
                            <input class="divided__input" type="text" aria-label="이름" placeholder="이름" id="first_name_customer" value="${firstName}" required>
                        </div>

                        <div class="input-row">
                            <label class="info-label" for="birth_date_customer">생년월일</label>
                            <input type="text" placeholder="YYYY-MM-DD" id="birth_date_customer" name="birth" value="${dto.birth}">
                        </div>

                        <div class="input-row">
                            <label class="info-label" for="email_customer">이메일주소</label>
                            <input aria-label="이메일" placeholder="이메일" type="email" id="email_customer" value="${dto.email1}@${dto.email2}">
                        </div>

                        <div class="input-row">
                            <label class="info-label" for="phone_customer">휴대폰번호</label>
                            <div class="phone-field">
                                <input type="tel" class="phone_customer" name="tel" id="phone_customer" value="${dto.tel}" placeholder="01012345678" maxlength="13">
                                <button class="btn phone-field__send-code" type="button">번호변경</button>
                            </div>
                            <label class="info-label otp-text hidden">인증번호가 전송되었습니다.</label>
                        </div>

                        <div class="input-row password-wrap">
                            <label class="info-label">비밀번호</label>
                            <div style="display:flex; gap:10px;">
                                <input type="password" name="userPwd" placeholder="정보 수정을 위해 비밀번호 입력" style="flex:1;">
                                <button type="button" class="btn" onclick="location.href='#'">재설정</button>
                            </div>
                        </div>

                        <div class="input-row">
                            <div class="pretty-select id-gender_customer">
                                <select name="gender" id="gender_customer">
                                    <option value="1" ${dto.gender == 1 ? "selected" : ""}>남성</option>
                                    <option value="2" ${dto.gender == 2 ? "selected" : ""}>여성</option>
                                </select>
                                <svg fill="#000000" viewBox="0 0 24 24"><path d="M7.41 7.84L12 12.42l4.59-4.58L18 9.25l-6 6-6-6z"></path></svg>
                            </div>
                        </div>

                        <div class="checkbox-row">
                            <input type="checkbox" id="email_consent_customer" ${dto.receiveEmail == 1 ? "checked" : ""}>
                            <label for="email_consent_customer">이메일 수신에 동의합니다</label>
                        </div>
                        <div class="checkbox-row">
                            <input type="checkbox" id="sms_consent_customer" checked>
                            <label for="sms_consent_customer">SMS 수신에 동의합니다.</label>
                        </div>

                        <div class="wide-action">
                            <button type="button" class="as-salomon__submit" onclick="updateMember();">
                                저장
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
<jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />

</body>
</html>