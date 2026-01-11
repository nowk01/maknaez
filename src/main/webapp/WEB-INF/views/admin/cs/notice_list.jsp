<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항 관리 | MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_notice_list.css">
</head>
<body>
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                <div class="page-header">
                    <h3 class="page-title">공지사항 관리</h3>
                    <p class="page-desc">Announcement & News Management Protocol</p>
                </div>

                <div class="card-box">
                    <form name="searchForm" action="${pageContext.request.contextPath}/admin/cs/notice_list" method="get" class="search-grid">
                        <div class="filter-group">
                            <label>검색 설정</label>
                            <select name="schType" class="form-select">
                                <option value="all" ${schType=='all'?'selected':''}>전체</option>
                                <option value="subject" ${schType=='subject'?'selected':''}>제목</option>
                                <option value="content" ${schType=='content'?'selected':''}>내용</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label>키워드 입력</label>
                            <input type="text" name="kwd" class="form-control" value="${kwd}" placeholder="검색어를 입력하세요">
                        </div>
                        <button type="submit" class="btn-search">SEARCH</button>
                    </form>
                </div>

                <div class="card-box">
                    <div class="list-header">
                        <div class="list-count">검색 결과 <b>${dataCount}</b>건</div>
                        <div class="action-btns">
                            <button type="button" class="btn-write" onclick="location.href='${pageContext.request.contextPath}/admin/cs/notice_write'">공지 등록</button>
                            <button type="button" class="btn-ctrl" id="btnDeleteSelected">선택 삭제</button>
                        </div>
                    </div>

                    <table class="table">
                        <thead>
                            <tr>
                                <th style="width: 40px;"><input type="checkbox" id="checkAll"></th>
                                <th style="width: 80px;">번호</th>
                                <th>제목</th>
                                <th style="width: 120px;">작성자</th>
                                <th style="width: 150px;">작성일</th>
                                <th style="width: 100px;">조회수</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="dto" items="${list}">
                                <tr class="${dto.notice == 1 ? 'row-notice' : ''}">
                                    <td><input type="checkbox" name="nums" value="${dto.num}" class="chk"></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${dto.notice == 1}"><span class="badge-pin">NOTICE</span></c:when>
                                            <c:otherwise>${dto.listNum}</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-start">
                                        <a href="${articleUrl}&num=${dto.num}" class="subject-link">${dto.subject}</a>
                                    </td>
                                    <td>${dto.userName}</td>
                                    <td>${dto.reg_date}</td>
                                    <td>${dto.hitCount}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${list.size() == 0}">
                                <tr><td colspan="6" style="padding:50px;">등록된 공지사항이 없습니다.</td></tr>
                            </c:if>
                        </tbody>
                    </table>

                    <div class="pagination">
                        ${paging}
                    </div>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <script src="${pageContext.request.contextPath}/dist/js/admin_notice_list.js"></script>
</body>
</html>