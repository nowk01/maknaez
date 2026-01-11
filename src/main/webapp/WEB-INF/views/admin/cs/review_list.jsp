<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰 관리 | MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_review.css">
</head>
<body>
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                <div class="page-header">
                    <h3 class="page-title">리뷰 관리</h3>
                    <p class="page-desc">Customer Product Reviews & Ratings</p>
                </div>

                <div class="chat-main-grid">
                    <div class="chat-sidebar">
                        <div class="inquiry-list-header">
                            <form name="searchForm" action="${pageContext.request.contextPath}/admin/cs/review_list" method="get">
                                <select name="score" onchange="searchList()" class="status-select">
                                    <option value="0" ${score == '0' ? 'selected' : ''}>전체 별점</option>
                                    <option value="5" ${score == '5' ? 'selected' : ''}>★★★★★</option>
                                    <option value="4" ${score == '4' ? 'selected' : ''}>★★★★☆</option>
                                    <option value="3" ${score == '3' ? 'selected' : ''}>★★★☆☆</option>
                                </select>
                                <div class="search-bar-wrap">
                                    <input type="text" name="keyword" value="${keyword}" placeholder="상품명 검색...">
                                    <button type="button" onclick="searchList()"><i class="fa fa-search"></i></button>
                                </div>
                            </form>
                        </div>
                        <div class="inquiry-list-wrapper">
                            <c:forEach var="dto" items="${list}">
                                <div class="inquiry-item" onclick="openReview('${dto.num}')">
                                    <div class="inquiry-info">
                                        <span>${dto.userName}</span>
                                        <span>${dto.reg_date}</span>
                                    </div>
                                    <div class="inquiry-subject">[${dto.productName}]</div>
                                    <div class="star-row" style="color: #ff4e00; font-size: 11px; margin-top: 5px;">
                                        <c:forEach begin="1" end="${dto.score}">★</c:forEach>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="chat-window">
                        <div class="empty-state" id="emptyState">
                            <i class="far fa-star" style="font-size: 50px; margin-bottom: 20px;"></i>
                            <p>상세 확인 할 리뷰를 선택해 주세요.</p>
                        </div>
                        <div class="d-none flex-column h-100" id="reviewView">
                            <div class="chat-header">
                                <h5 id="reviewTitle">상품명</h5>
                                <small id="reviewUser" class="text-muted">작성자 정보</small>
                            </div>
                            <div class="chat-body" id="reviewBody"></div>
                            <div class="chat-footer">
                                <div class="reply-input-wrap">
                                    <textarea id="replyContent" placeholder="이 리뷰에 답글을 남겨보세요..."></textarea>
                                    <button type="button" class="btn-send" onclick="sendReply()">답글등록</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <script src="${pageContext.request.contextPath}/dist/js/admin_review.js"></script>
</body>
</html>