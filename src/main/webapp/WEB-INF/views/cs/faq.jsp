<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/cs.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/layout/header.jsp" />

	<div class="cs-wrap">
		<div class="cs-sidebar">
			<div class="cs-sidebar-title">SUPPORT</div>
			<ul class="cs-menu">
				<li><a href="${pageContext.request.contextPath}/cs/notice">Notice</a></li>
				<li><a href="${pageContext.request.contextPath}/cs/faq"
					class="active">FAQ</a></li>
				<li><a href="${pageContext.request.contextPath}/cs/list">1:1
						Inquiry</a></li>
			</ul>
		</div>

		<div class="cs-content">
			<div class="content-header">
				<h2 class="content-title">FAQ</h2>
			</div>

			<div class="faq-tabs">
				<button class="tab-btn ${category=='all'?'active':''}"
					onclick="filterFaq('all')">ALL</button>
				<button class="tab-btn ${category=='배송'?'active':''}"
					onclick="filterFaq('배송')">DELIVERY</button>
				<button class="tab-btn ${category=='상품'?'active':''}"
					onclick="filterFaq('상품')">PRODUCT</button>
				<button class="tab-btn ${category=='교환/반품'?'active':''}"
					onclick="filterFaq('교환/반품')">RETURN</button>
				<button class="tab-btn ${category=='회원'?'active':''}"
					onclick="filterFaq('회원')">MEMBER</button>
			</div>

			<div class="faq-list">
				<div class="faq-item" data-cate="배송">
					<div class="faq-question" onclick="toggleFaq(this)">
						<span class="category">배송</span> <span class="subject">주문한
							상품은 언제 배송되나요?</span> <span class="icon">+</span>
					</div>
					<div class="faq-answer">평일 오후 2시 이전 결제 완료 건은 당일 출고됩니다. 출고 후
						일반적인 배송 기간은 1~3일이며, 택배사 사정에 따라 달라질 수 있습니다.</div>
				</div>

				<div class="faq-item" data-cate="배송">
					<div class="faq-question" onclick="toggleFaq(this)">
						<span class="category">배송</span> <span class="subject">배송지
							정보를 변경하고 싶습니다.</span> <span class="icon">+</span>
					</div>
					<div class="faq-answer">'상품 준비 중' 이전 단계인 '결제 완료' 상태에서만 변경이
						가능합니다. 고객센터 혹은 1:1 문의를 통해 즉시 요청해 주세요.</div>
				</div>

				<div class="faq-item" data-cate="상품">
					<div class="faq-question" onclick="toggleFaq(this)">
						<span class="category">상품</span> <span class="subject">XT-6
							모델 사이즈는 어떻게 선택해야 하나요?</span> <span class="icon">+</span>
					</div>
					<div class="faq-answer">XT-6는 다소 타이트하게 설계된 모델입니다. 발볼이 보통이라면
						정사이즈를 추천하지만, 여유 있는 착용감을 원하시거나 발볼이 넓으신 분들은 5mm 업을 권장합니다.</div>
				</div>

				<div class="faq-item" data-cate="상품">
					<div class="faq-question" onclick="toggleFaq(this)">
						<span class="category">상품</span> <span class="subject">품절된
							상품의 재입고 알림을 받고 싶어요.</span> <span class="icon">+</span>
					</div>
					<div class="faq-answer">상품 상세 페이지에서 '재입고 알림 신청' 버튼을 클릭하시면, 해당
						사이즈 입고 시 문자로 알림을 보내드립니다.</div>
				</div>

				<div class="faq-item" data-cate="교환/반품">
					<div class="faq-question" onclick="toggleFaq(this)">
						<span class="category">교환/반품</span> <span class="subject">교환
							및 반품 신청 기간이 어떻게 되나요?</span> <span class="icon">+</span>
					</div>
					<div class="faq-answer">상품 수령 후 7일 이내에 신청해 주셔야 합니다. 제품의 택 제거,
						착용 흔적, 신발 박스 훼손 시에는 처리가 불가합니다.</div>
				</div>

				<div class="faq-item" data-cate="교환/반품">
					<div class="faq-question" onclick="toggleFaq(this)">
						<span class="category">교환/반품</span> <span class="subject">반품
							시 배송비는 얼마인가요?</span> <span class="icon">+</span>
					</div>
					<div class="faq-answer">단순 변심에 의한 반품 시 왕복 배송비 6,000원이 환불 금액에서
						차감됩니다. 제품 불량의 경우 배송비는 전액 본사에서 부담합니다.</div>
				</div>

				<div class="faq-item" data-cate="회원">
					<div class="faq-question" onclick="toggleFaq(this)">
						<span class="category">회원</span> <span class="subject">비회원
							주문 내역은 어떻게 확인하나요?</span> <span class="icon">+</span>
					</div>
					<div class="faq-answer">로그인 페이지 하단의 '비회원 주문확인' 메뉴에서 주문번호와 주문
						시 설정한 비밀번호를 입력하여 조회가 가능합니다.</div>
				</div>

				<div class="faq-item" data-cate="회원">
					<div class="faq-question" onclick="toggleFaq(this)">
						<span class="category">회원</span> <span class="subject">아이디와
							비밀번호를 잊어버렸습니다.</span> <span class="icon">+</span>
					</div>
					<div class="faq-answer">로그인 화면의 'ID/PW 찾기'를 이용해 주세요. 등록하신 이메일
						또는 휴대폰 번호 인증을 통해 확인하실 수 있습니다.</div>
				</div>
			</div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
	<script>
        const contextPath = "${pageContext.request.contextPath}";
    </script>
	<script src="${pageContext.request.contextPath}/dist/js/cs.js"></script>
</body>
</html>