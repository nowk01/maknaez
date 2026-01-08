<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>약관동의 | MAKNAEZ</title>

    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/footer.css">

    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            padding-top: 80px;
            color: #111;
        }

        .consent-container {
            max-width: 600px;
            margin: 80px auto 120px;
            padding: 0 20px;
        }

        .page-title {
            font-size: 28px;
            font-weight: 700;
            text-align: center;
            margin-bottom: 50px;
        }

        /* 전체 동의 */
        .all-check-box {
            padding-bottom: 20px;
            border-bottom: 2px solid #000;
            margin-bottom: 30px;
        }

        .check-label {
            display: flex;
            align-items: center;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
        }

        .check-label input {
            width: 20px;
            height: 20px;
            margin-right: 12px;
            accent-color: #000;
        }

        /* 약관 리스트 */
        .terms-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .terms-item {
            margin-bottom: 25px;
            border-radius: 6px;
            transition: background 0.3s, border 0.3s;
        }

        .terms-item.active {
            background: #fafafa;
            border: 1px solid #ddd;
            padding: 15px;
        }

        .terms-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .terms-label {
            font-size: 14px;
            color: #333;
            display: flex;
            align-items: center;
            cursor: pointer;
        }

        .terms-label input {
            width: 18px;
            height: 18px;
            margin-right: 10px;
            accent-color: #000;
        }

        .btn-view {
            font-size: 12px;
            color: #888;
            text-decoration: underline;
            background: none;
            border: none;
            cursor: pointer;
            padding: 0;
        }

        /* 슬라이드 약관 */
        .terms-content {
            max-height: 0;
            overflow: hidden;
            background: #f9f9f9;
            padding: 0 15px;
            margin-top: 12px;
            font-size: 12px;
            color: #666;
            border: 1px solid #eee;
            line-height: 1.6;
            transition: max-height 0.35s ease, padding 0.25s ease;
        }

        .terms-content.show {
            max-height: 240px;
            padding: 15px;
        }

        /* 버튼 */
        .btn-group {
            margin-top: 60px;
            display: flex;
            gap: 10px;
        }

        .btn-next {
            flex: 1;
            height: 52px;
            background: #000;
            color: #fff;
            border: none;
            border-radius: 26px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: opacity 0.3s;
        }

        .btn-next:hover:not(:disabled) {
            opacity: 0.85;
        }

        .btn-next:disabled {
            background: #ccc;
            cursor: not-allowed;
        }

        .btn-cancel {
            flex: 1;
            height: 52px;
            background: #fff;
            color: #000;
            border: 1px solid #ddd;
            border-radius: 26px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
        }

        .req { color: #e74c3c; font-weight: bold; margin-right: 4px; }
        .opt { color: #888; margin-right: 4px; }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="consent-container">
    <h2 class="page-title">약관동의</h2>

    <form name="consentForm" action="${pageContext.request.contextPath}/member/account" method="get">

        <div class="all-check-box">
            <label class="check-label">
                <input type="checkbox" id="checkAll">
                MAKNAEZ 이용약관, 개인정보 수집 및 이용, 프로모션 안내(선택)에 모두 동의합니다.
            </label>
        </div>

        <ul class="terms-list">
            <li class="terms-item">
                <div class="terms-header">
                    <label class="terms-label">
                        <input type="checkbox" class="required-check">
                        <span class="req">[필수]</span> 이용약관 동의
                    </label>
                    <button type="button" class="btn-view" onclick="toggleTerms(1)">내용보기</button>
                </div>
                <div class="terms-content" id="terms1">
                    제1조(목적)<br>
                    본 약관은 MAKNAEZ가 제공하는 서비스 이용과 관련한 권리·의무 및 책임사항을 규정함을 목적으로 합니다.
                </div>
            </li>

            <li class="terms-item">
                <div class="terms-header">
                    <label class="terms-label">
                        <input type="checkbox" class="required-check">
                        <span class="req">[필수]</span> 개인정보 수집 및 이용 동의
                    </label>
                    <button type="button" class="btn-view" onclick="toggleTerms(2)">내용보기</button>
                </div>
                <div class="terms-content" id="terms2">
                    수집 항목: 성명, 아이디, 비밀번호, 이메일, 연락처<br>
                    이용 목적: 회원가입 및 고객관리
                </div>
            </li>

            <li class="terms-item">
                <div class="terms-header">
                    <label class="terms-label">
                        <input type="checkbox" class="optional-check">
                        <span class="opt">[선택]</span> 쇼핑정보 수신 동의
                    </label>
                    <button type="button" class="btn-view" onclick="toggleTerms(3)">내용보기</button>
                </div>
                <div class="terms-content" id="terms3">
                    이벤트, 할인 혜택, 신상품 정보를 이메일/SMS로 제공합니다.
                </div>
            </li>
        </ul>

        <div class="btn-group">
            <button type="button" class="btn-cancel"
                onclick="location.href='${pageContext.request.contextPath}/member/login';">
                취소
            </button>
            <button type="button" class="btn-next" id="btnNext" disabled onclick="submitConsent();">
                다음
            </button>
        </div>
    </form>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
<jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />

<script>
    const checkAll = document.getElementById("checkAll");
    const requiredChecks = document.querySelectorAll(".required-check");
    const allChecks = document.querySelectorAll("input[type='checkbox']:not(#checkAll)");
    const btnNext = document.getElementById("btnNext");

    // 살로몬 스타일 아코디언
    function toggleTerms(id) {
        const current = document.getElementById("terms" + id);
        const item = current.closest(".terms-item");
        const btn = item.querySelector(".btn-view");

        document.querySelectorAll(".terms-content").forEach(tc => {
            if (tc !== current) {
                tc.classList.remove("show");
                tc.closest(".terms-item").classList.remove("active");
                tc.closest(".terms-item").querySelector(".btn-view").innerText = "내용보기";
            }
        });

        const isOpen = current.classList.contains("show");
        if (isOpen) {
            current.classList.remove("show");
            item.classList.remove("active");
            btn.innerText = "내용보기";
        } else {
            current.classList.add("show");
            item.classList.add("active");
            btn.innerText = "닫기";
        }
    }

    checkAll.addEventListener("change", () => {
        allChecks.forEach(cb => cb.checked = checkAll.checked);
        updateNextButton();
    });

    allChecks.forEach(cb => {
        cb.addEventListener("change", () => {
            checkAll.checked = allChecks.length ===
                document.querySelectorAll("input[type='checkbox']:not(#checkAll):checked").length;
            updateNextButton();
        });
    });

    function updateNextButton() {
        btnNext.disabled = ![...requiredChecks].every(cb => cb.checked);
    }

    function submitConsent() {
        document.consentForm.submit();
    }
</script>

</body>
</html>
