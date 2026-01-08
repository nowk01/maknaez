<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<style>
    .cs-wrap {
        max-width: 1100px;
        margin: 50px auto;
        padding: 0 20px;
        display: flex;
        gap: 50px;
        font-family: 'Noto Sans KR', sans-serif;
    }

    .cs-sidebar { width: 180px; flex-shrink: 0; }
    
    .cs-sidebar-title { 
        font-size: 20px; 
        font-weight: 800; 
        color: #000;
        margin-bottom: 20px; 
        height: 30px;
        display: flex;
        align-items: center;
        padding-bottom: 0;
    }

    .cs-menu { list-style: none; padding: 0; margin: 0; border-top: 1px solid #eee; }
    
    .cs-menu li a { 
        display: block; 
        padding: 14px 5px; 
        font-size: 14px; 
        color: #666; 
        text-decoration: none; 
        border-bottom: 1px solid #eee; 
        transition: all 0.2s; 
    }
    
    .cs-menu li a:hover { color: #000; font-weight: 500; background: #f9f9f9; }
    .cs-menu li a.active { color: #000; font-weight: 700; background: #fff; }

    .cs-content { flex: 1; }

    .content-header { 
        margin-bottom: 20px; 
        height: 30px; 
        display: flex; 
        align-items: flex-end;
        justify-content: space-between;
      
    }
    .content-title { font-size: 22px; font-weight: 700; color: #000; margin: 0; }
    .content-desc { font-size: 13px; color: #888; margin: 0; padding-bottom: 3px; }

    .board-table { 
        width: 100%; 
        border-collapse: collapse; 
        border-top: 1px solid #eee;
    }
    .board-table th { 
        padding: 15px 0; 
        border-bottom: 1px solid #eee; 
        font-size: 13px; 
        font-weight: 600; 
        background: #f8f8f8; 
        color: #333; 
        text-align: center; 
    }
    .board-table td { 
        padding: 15px 0; 
        border-bottom: 1px solid #eee; 
        font-size: 13px; 
        color: #444; 
        text-align: center; 
    }
    .board-table td.subject { text-align: left; padding-left: 15px; cursor: pointer; }
    .board-table td.subject:hover { text-decoration: underline; color: #000; }

    .status-badge { display: inline-block; padding: 3px 8px; border-radius: 4px; font-size: 11px; font-weight: 500; }
    .status-wait { background: #eee; color: #888; }
    .status-done { background: #333; color: #fff; }

    .bottom-area { display: flex; justify-content: space-between; align-items: center; margin-top: 30px; }
    .search-form { display: flex; gap: 4px; }
    .search-select, .search-input { height: 34px; padding: 0 10px; border: 1px solid #ddd; outline: none; font-size: 13px; box-sizing: border-box; }
    .btn-search { height: 34px; padding: 0 15px; border: 1px solid #ddd; background: #fff; font-size: 13px; cursor: pointer; }
    .btn-search:hover { background: #f5f5f5; border-color: #ccc; }
    
    .btn-write { 
        height: 34px; line-height: 32px; padding: 0 20px; 
        background: #000; color: #fff; font-size: 13px; font-weight: 500; 
        text-decoration: none; transition: 0.2s; border: 1px solid #000; 
    }
    .btn-write:hover { background: #fff; color: #000; }
    .no-data { padding: 50px 0; color: #999; font-size: 13px; }
</style>

<script type="text/javascript">
    function searchList() {
        const f = document.searchForm;
        f.submit();
    }
</script>
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
        <div class="content-header">
            <h3 class="content-title">1:1 문의</h3>
            <p class="content-desc">궁금한 점을 남겨주시면 순차적으로 답변해 드립니다.</p>
        </div>

        <table class="board-table">
            <colgroup>
                <col width="60"> 
                <col width="90"> 
                <col width="*">
                <col width="100">
                <col width="110">
            </colgroup>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>상태</th>
                    <th>제목</th>
                    <th>작성자</th>
                    <th>작성일</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty list}">
                        <tr>
                            <td colspan="5" class="no-data">등록된 문의 내역이 없습니다.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="dto" items="${list}">
                            <tr>
                                <td>${dto.num}</td>
                                <td>
                                    <span class="status-badge ${dto.hitCount > 0 ? 'status-done' : 'status-wait'}">
                                        ${dto.hitCount > 0 ? '답변완료' : '대기중'}
                                    </span>
                                </td>
                                <td class="subject" onclick="location.href='${pageContext.request.contextPath}/cs/article?num=${dto.num}&page=${page}&condition=${condition}&keyword=${keyword}'">
                                    ${dto.subject}
                                </td>
                                <td>${dto.userName}</td>
                                <td>${dto.reg_date}</td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <div class="bottom-area">
            <form name="searchForm" action="${pageContext.request.contextPath}/cs/list" method="get" class="search-form">
                <select name="condition" class="search-select">
                    <option value="all" ${condition=="all"?"selected='selected'":""}>전체</option>
                    <option value="subject" ${condition=="subject"?"selected='selected'":""}>제목</option>
                    <option value="content" ${condition=="content"?"selected='selected'":""}>내용</option>
                    <option value="userName" ${condition=="userName"?"selected='selected'":""}>작성자</option>
                    <option value="reg_date" ${condition=="reg_date"?"selected='selected'":""}>작성일</option>
                </select>
                <input type="text" name="keyword" value="${keyword}" class="search-input" placeholder="검색어 입력">
                <button type="button" class="btn-search" onclick="searchList()">검색</button>
            </form>

            <a href="${pageContext.request.contextPath}/cs/write" class="btn-write">문의하기</a>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</body>
</html>