<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<style>
.cs-wrap {
	max-width: 1100px;
	margin: 50px auto;
	padding: 0 20px;
	display: flex;
	gap: 50px;
	font-family: 'Noto Sans KR', sans-serif;
}

.cs-sidebar {
	width: 180px;
	flex-shrink: 0;
}

.cs-sidebar-title {
	font-size: 20px;
	font-weight: 800;
	color: #000;
	margin-bottom: 20px;
	padding-bottom: 0;
	height: 30px;
	display: flex;
	align-items: center;
}

.cs-menu {
	list-style: none;
	padding: 0;
	margin: 0;
	border-top: 1px solid #eee;
}

.cs-menu li a {
	display: block;
	padding: 14px 5px;
	font-size: 14px;
	color: #666;
	text-decoration: none;
	border-bottom: 1px solid #eee;
	transition: all 0.2s;
}

.cs-menu li a:hover {
	color: #000;
	font-weight: 500;
	background: #f9f9f9;
}

.cs-menu li a.active {
	color: #000;
	font-weight: 700;
	background: #fff;
}

.cs-content {
	flex: 1;
}

.content-header {
	margin-bottom: 30px;
	height: 30px;
	display: flex;
	align-items: flex-end;
	justify-content: space-between;
}

.content-title {
	font-size: 22px;
	font-weight: 700;
	color: #000;
	margin: 0;
}

.faq-tabs {
	display: flex;
	gap: 8px;
	margin-bottom: 20px;
	padding-bottom: 20px;
}

.tab-btn {
	padding: 8px 18px;
	border: 1px solid #eee;
	background: #fff;
	font-size: 13px;
	cursor: pointer;
	border-radius: 20px;
	color: #666;
	transition: 0.2s;
}

.tab-btn:hover {
	border-color: #ccc;
	color: #000;
}

.tab-btn.active {
	background: #000;
	color: #fff;
	border-color: #000;
	font-weight: 500;
}

.faq-list {
	border-top: 1px solid #eee;
}

.faq-item {
	border-bottom: 1px solid #eee;
}

.faq-question {
	padding: 20px 10px;
	cursor: pointer;
	display: flex;
	justify-content: space-between;
	align-items: center;
	font-size: 14px;
	font-weight: 500;
	color: #333;
	transition: background 0.2s;
}

.faq-question:hover {
	background: #f9f9f9;
}

.faq-question .category {
	color: #888;
	font-size: 12px;
	margin-right: 15px;
	width: 60px;
	font-weight: 400;
}

.faq-question .subject {
	flex: 1;
}

.faq-question .icon {
	font-size: 18px;
	color: #ccc;
	transition: transform 0.3s;
}

.faq-answer {
	max-height: 0;
	overflow: hidden;
	background: #fcfcfc; /* 아주 연한 회색 배경 */
	color: #555;
	font-size: 13px;
	line-height: 1.6;
	padding: 0 20px;
	transition: all 0.3s ease-in-out;
	opacity: 0;
}

.faq-item.active .faq-answer {
	padding: 20px 20px 30px 20px;
	max-height: 300px;
	opacity: 1;
	border-top: 1px solid #f0f0f0;
}

.faq-item.active .faq-question .icon {
	transform: rotate(45deg);
	color: #000;
}

.faq-item.active .faq-question {
	font-weight: 700;
	color: #000;
}

.no-data {
	padding: 50px 0;
	color: #999;
	font-size: 13px;
	text-align: center;
}
</style>

<script>
    function toggleFaq(element) {
        const item = element.parentElement;
        if(item.classList.contains('active')) {
            item.classList.remove('active');
        } else {
            document.querySelectorAll('.faq-item').forEach(i => i.classList.remove('active'));
            item.classList.add('active');
        }
    }
    
    function filterFaq(category) {
        location.href = '${pageContext.request.contextPath}/cs/faq?category=' + category;
    }
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/layout/header.jsp" />

	<div class="cs-wrap">

		<div class="cs-sidebar">
			<div class="cs-sidebar-title">고객센터</div>
			<ul class="cs-menu">
				<li><a href="${pageContext.request.contextPath}/cs/notice">공지사항</a></li>
				<li><a href="${pageContext.request.contextPath}/cs/faq"
					class="active">자주 묻는 질문</a></li>
				<li><a href="${pageContext.request.contextPath}/cs/list">1:1
						문의</a></li>
				<li><a href="#">이용안내</a></li>
			</ul>
		</div>

		<div class="cs-content">
			<div class="content-header">
				<h2 class="content-title">자주 묻는 질문</h2>
			</div>

			<div class="faq-tabs">
				<button class="tab-btn ${category=='all'?'active':''}"
					onclick="filterFaq('all')">전체</button>
				<button class="tab-btn ${category=='배송'?'active':''}"
					onclick="filterFaq('배송')">배송</button>
				<button class="tab-btn ${category=='상품'?'active':''}"
					onclick="filterFaq('상품')">상품</button>
				<button class="tab-btn ${category=='교환/반품'?'active':''}"
					onclick="filterFaq('교환/반품')">반품/교환</button>
				<button class="tab-btn ${category=='회원'?'active':''}"
					onclick="filterFaq('회원')">회원</button>
			</div>

			<div class="faq-list">
				<c:choose>
					<c:when test="${empty list}">
						<div class="no-data">등록된 질문이 없습니다.</div>
					</c:when>
					<c:otherwise>
						<c:forEach var="dto" items="${list}">
							<div class="faq-item">
								<div class="faq-question" onclick="toggleFaq(this)">
									<span class="category">[${dto.category}]</span> <span
										class="subject">${dto.subject}</span> <span class="icon">+</span>
								</div>
								<div class="faq-answer">${dto.content}</div>
							</div>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body>
</html>