<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>거래명세서 발행 - MAKNAEZ ADMIN</title>
<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/admin_estimate_list.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/admin_estimate_write.css">
</head>
<body>
	<div id="wrapper">
		<jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
		<div id="page-content-wrapper">
			<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

			<div class="content-container">
				<div class="page-header">
					<h3 class="page-title">거래명세서 발행</h3>
					<p class="page-desc">Official Transaction Statement for
						Customer</p>
				</div>

				<div class="estimate-paper">
					<div class="estimate-header">
						<div class="estimate-title">거래명세서</div>
						<div style="text-align: right;">
							<p style="font-weight: 700; font-size: 14px;">주문번호:
								${orderInfo.orderNum}</p>
							<p style="color: #888; font-size: 12px;">발행일자:
								${orderInfo.orderDate}</p>
						</div>
					</div>

					<div class="info-grid">
						<div class="info-box">
							<h4>수신 (고객 정보)</h4>
							<table class="info-table">
								<tr>
									<th>성함</th>
									<td>${orderInfo.userName}</td>
								</tr>
								<tr>
									<th>아이디</th>
									<td>${orderInfo.userId}</td>
								</tr>
								<tr>
									<th>연락처</th>
									<td>${orderInfo.tel}</td>
								</tr>
								<tr>
									<th>이메일</th>
									<td>${orderInfo.email}</td>
								</tr>
							</table>
						</div>
						<div class="info-box">
							<h4>발신 (공급자 정보)</h4>
							<table class="info-table">
								<tr>
									<th>상호명</th>
									<td>MAKNAEZ</td>
								</tr>
								<tr>
									<th>대표자</th>
									<td>MAKNAEZ</td>
								</tr>
								<tr>
									<th>사업자번호</th>
									<td>123-45-67890</td>
								</tr>
								<tr>
									<th>주소</th>
									<td>서울특별시 강남구 테헤란로 123</td>
								</tr>
							</table>
						</div>
					</div>

					<table class="product-table">
						<thead>
							<tr>
								<th>이미지</th>
								<th>상품명/옵션</th>
								<th style="width: 100px;">단가</th>
								<th style="width: 60px;">수량</th>
								<th style="width: 120px;">금액</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="item" items="${list}">
								<tr>
									<td style="text-align: center;"><img
										src="${pageContext.request.contextPath}/uploads/product/${item.thumbNail}"
										style="width: 50px; height: 50px; object-fit: cover; border: 1px solid #eee;"
										onerror="this.src='${pageContext.request.contextPath}/dist/images/no-image.png';">
									</td>
									<td>
										<div style="font-weight: 700;">${item.productName}</div>
										<div style="font-size: 12px; color: #888;">옵션:
											${item.pdSize}</div>
									</td>
									<td style="text-align: right;"><fmt:formatNumber
											value="${item.price}" pattern="#,###" />원</td>
									<td style="text-align: center;">${item.qty}</td>
									<td style="text-align: right; font-weight: 700;"><fmt:formatNumber
											value="${item.price * item.qty}" pattern="#,###" />원</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>

					<div class="total-section">
						<span class="total-label">합계 금액 (VAT 포함)</span> <span
							class="total-amount"><fmt:formatNumber
								value="${orderInfo.totalAmount}" pattern="#,###" /> 원</span>
					</div>

					<div class="btn-area">
						<button type="button" class="btn-print"
							onclick="downloadEstimate()">명세서 출력 / PDF 저장</button>
						<button type="button" class="btn-cancel" onclick="goBackList()">목록으로</button>
					</div>
				</div>
			</div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
	<script type="text/javascript">
    // JSP 문법은 오직 이 'JSP 파일 안'에서만 작동합니다.
    // 여기서 자바스크립트 변수로 옮겨 담아야 외부 JS 파일이 가져다 쓸 수 있어요.
    var currentOrderNum = "${orderInfo.orderNum}"; 
    var contextPath = "${pageContext.request.contextPath}";
</script>

<script src="${pageContext.request.contextPath}/dist/js/admin_estimate_write.js"></script>
</body>
</html>