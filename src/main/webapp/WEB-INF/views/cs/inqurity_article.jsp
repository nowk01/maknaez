<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<style>
    .cs-wrap { max-width: 1200px; margin: 60px auto; padding: 0 20px; display: flex; gap: 50px; font-family: 'Noto Sans KR', sans-serif; }
    .cs-sidebar { width: 200px; flex-shrink: 0; }
    .cs-sidebar-title { font-size: 24px; font-weight: 700; margin-bottom: 30px; padding-bottom: 15px; border-bottom: 2px solid #333; }
    .cs-menu { list-style: none; padding: 0; margin: 0; }
    .cs-menu li a { display: block; padding: 15px 0; font-size: 15px; color: #888; text-decoration: none; border-bottom: 1px solid #eee; transition: all 0.2s; }
    .cs-menu li a:hover { color: #333; font-weight: 500; }
    .cs-menu li a.active { color: #000; font-weight: 700; border-bottom: 2px solid #000; }
    .cs-content { flex: 1; }
    .content-header { border-bottom: 2px solid #333; margin-bottom: 0; }
    .view-table { width: 100%; border-collapse: collapse; }
    .view-table th { background: #f9f9f9; width: 120px; padding: 15px; text-align: left; font-weight: 500; color: #333; border-bottom: 1px solid #eee; }
    .view-table td { padding: 15px; border-bottom: 1px solid #eee; color: #444; }
    .view-content { min-height: 200px; padding: 30px 15px; line-height: 1.6; border-bottom: 1px solid #ddd; }
    .btn-area { margin-top: 30px; text-align: center; }
    .btn { display: inline-block; padding: 10px 30px; background: #333; color: #fff; text-decoration: none; font-size: 14px; border-radius: 4px; }
    .btn:hover { background: #555; }
    .btn-list { background: #fff; color: #333; border: 1px solid #ccc; }
    .btn-list:hover { background: #f5f5f5; }
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
<div class="cs-wrap">
    <div class="cs-sidebar">
        <div class="cs-sidebar-title">고객센터</div>
        <ul class="cs-menu">
            <li><a href="#">공지사항</a></li>
            <li><a href="#">자주 묻는 질문</a></li>
            <li><a href="${pageContext.request.contextPath}/cs/list" class="active">1:1 문의</a></li>
            <li><a href="#">이용안내</a></li>
        </ul>
    </div>
    <div class="cs-content">
        <div class="content-header"></div>
        <table class="view-table">
            <tr><th colspan="2" style="font-size: 18px; background: #fff; border-bottom: 2px solid #333;">${dto.subject}</th></tr>
            <tr>
                <td width="50%">작성자 : ${dto.userName}</td>
                <td width="50%" align="right">등록일 : ${dto.reg_date} | 조회 : ${dto.hitCount}</td>
            </tr>
            <c:if test="${not empty dto.saveFilename}">
            <tr>
                <td colspan="2">
                    첨부파일 : <a href="${pageContext.request.contextPath}/cs/download?num=${dto.num}">${dto.originalFilename}</a>
                </td>
            </tr>
            </c:if>
        </table>
        <div class="view-content">${dto.content}</div>
        <div class="btn-area">
            <a href="${pageContext.request.contextPath}/cs/list?${query}" class="btn btn-list">목록</a>
            <c:if test="${sessionScope.member.userId == dto.userId}">
                <a href="${pageContext.request.contextPath}/cs/delete?num=${dto.num}&${query}" class="btn" onclick="return confirm('삭제하시겠습니까?');">삭제</a>
            </c:if>
        </div>
    </div>
</div>
<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</body>
</html>