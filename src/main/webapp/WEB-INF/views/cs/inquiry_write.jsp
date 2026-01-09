<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/cs.css">
<style>
    /* 작성 폼 스타일 */
    .write-table { width: 100%; border-collapse: collapse; border-top: 1px solid #eee; border-bottom: 1px solid #ddd; }
    .write-table th { width: 100px; background: #f8f8f8; padding: 15px; text-align: left; font-weight: 600; color: #333; border-bottom: 1px solid #eee; font-size: 13px; vertical-align: middle; }
    .write-table td { padding: 10px 15px; border-bottom: 1px solid #eee; }
    .input-field { width: 100%; padding: 10px; border: 1px solid #ddd; font-size: 13px; outline: none; box-sizing: border-box; transition: border-color 0.2s; }
    .input-field:focus { border-color: #333; }
    .input-readonly { background: #fff; color: #888; border: none; padding-left: 0; font-weight: 500; }
    textarea.input-field { height: 300px; resize: none; line-height: 1.6; }
    .file-input { padding: 5px 0; font-size: 13px; }
    
    .btn-area { margin-top: 30px; text-align: center; display: flex; justify-content: center; gap: 8px; }
    .btn { min-width: 100px; padding: 12px 0; font-size: 13px; font-weight: 500; cursor: pointer; border: 1px solid #ddd; transition: all 0.2s; }
    .btn-cancel { background: #fff; color: #555; }
    .btn-cancel:hover { background: #f5f5f5; border-color: #ccc; }
    .btn-submit { background: #333; color: #fff; border-color: #333; }
    .btn-submit:hover { background: #000; border-color: #000; }
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<div class="cs-wrap">
    <div class="cs-sidebar">
        <div class="cs-sidebar-title">고객센터</div>
        <ul class="cs-menu">
            <li><a href="${pageContext.request.contextPath}/cs/notice">공지사항</a></li>
            <li><a href="${pageContext.request.contextPath}/cs/faq">자주 묻는 질문</a></li>
            <li><a href="${pageContext.request.contextPath}/cs/list" class="active">1:1 문의</a></li>
            <li><a href="#">이용안내</a></li>
        </ul>
    </div>

    <div class="cs-content">
        <div class="content-header">
            <h2 class="content-title">문의 작성</h2>
        </div>
        
        <form name="qnaForm" method="post" enctype="multipart/form-data">
            <table class="write-table">
                <tr>
                    <th>작성자</th>
                    <td>
                        <input type="text" class="input-field input-readonly" value="${sessionScope.member.userName}" readonly>
                    </td>
                </tr>
                <tr>
                    <th>제목</th>
                    <td>
                        <input type="text" name="subject" class="input-field" placeholder="제목을 입력하세요">
                    </td>
                </tr>
                <tr>
                    <th>내용</th>
                    <td>
                        <textarea name="content" class="input-field" placeholder="문의하실 내용을 자세히 적어주세요."></textarea>
                    </td>
                </tr>
                <tr>
                    <th>첨부파일</th>
                    <td>
                        <input type="file" name="selectFile" class="file-input">
                    </td>
                </tr>
            </table>
            
            <div class="btn-area">
                <button type="button" class="btn btn-cancel" onclick="location.href='${pageContext.request.contextPath}/cs/list'">취소</button>
                <button type="submit" class="btn btn-submit">등록하기</button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</body>
</html>