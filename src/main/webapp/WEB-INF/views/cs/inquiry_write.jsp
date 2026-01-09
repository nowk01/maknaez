<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/cs.css">
<script>
    function triggerFile() {
        document.getElementById('hiddenFile').click();
    }

    function checkFile(input) {
        const preview = document.getElementById('fileNamePreview');
        if (input.files && input.files[0]) {
            preview.innerText = "📎 " + input.files[0].name;
            preview.style.display = "block";
        } else {
            preview.style.display = "none";
        }
    }

    function sendInquiry() {
        const f = document.qnaForm;
        if(!f.subject.value.trim()) {
            alert("제목(주제)을 입력해주세요.");
            f.subject.focus();
            return;
        }
        if(!f.content.value.trim()) {
            alert("문의 내용을 입력해주세요.");
            f.content.focus();
            return;
        }
        f.submit();
    }
</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<div class="cs-wrap">
    <div class="cs-sidebar">
        <div class="cs-sidebar-title">SUPPORT</div>
        <ul class="cs-menu">
            <li><a href="${pageContext.request.contextPath}/cs/notice">Notice</a></li>
            <li><a href="${pageContext.request.contextPath}/cs/faq">FAQ</a></li>
            <li><a href="${pageContext.request.contextPath}/cs/list" class="active">1:1 Inquiry</a></li>
            <li><a href="#">Guide</a></li>
        </ul>
    </div>

    <div class="cs-content">
        <div class="chat-write-container">
            <div class="chat-write-header">
                <div class="chat-write-title">1:1 문의하기</div>
                <div class="chat-write-desc">운영시간 내에 답변해 드립니다.</div>
                <button type="button" class="btn-close-chat" onclick="location.href='${pageContext.request.contextPath}/cs/list'"><i class="bi bi-x-lg"></i></button>
            </div>

            <div class="chat-simulation-area">
                <div class="sys-msg">
                    <div class="sys-profile">
                        <div class="sys-icon">S</div>
                        <span class="sys-name">MAKNAEZ SUPPORT</span>
                    </div>
                    <div class="sys-bubble">
                        안녕하세요, <b>${sessionScope.member.userName}</b>님.<br>
                        무엇을 도와드릴까요?<br><br>
                        아래 입력창에 문의 내용을 남겨주시면<br>
                        담당자가 확인 후 답변 드리겠습니다.
                    </div>
                </div>
            </div>

            <div class="chat-input-zone">
                <form name="qnaForm" method="post" enctype="multipart/form-data">
                    <input type="text" name="subject" class="subject-input" placeholder="문의 주제를 간략히 입력해주세요 (예: 배송 언제 되나요?)">

                    <div class="message-box">
                        <div class="file-wrapper">
                            <i class="bi bi-paperclip file-btn" onclick="triggerFile()"></i>
                            <input type="file" id="hiddenFile" name="selectFile" style="display:none;" onchange="checkFile(this)">
                        </div>
                        
                        <textarea name="content" class="msg-textarea" placeholder="메시지를 입력하세요..."></textarea>
                        
                        <button type="button" class="send-btn" onclick="sendInquiry()">
                            <i class="bi bi-arrow-up-short"></i>
                        </button>
                    </div>
                    <div id="fileNamePreview" class="file-preview"></div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</body>
</html>