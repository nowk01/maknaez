<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>신청 | MAKNAEZ</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage.css">

<style>
    /* 기존 스타일 유지하면서 깔끔하게 정리 */
    .claim-wrapper { max-width: 700px; margin: 60px auto; color: #000; font-family: 'Noto Sans KR', sans-serif; }
    .claim-header { border-bottom: 2px solid #000; padding-bottom: 15px; margin-bottom: 40px; }
    .claim-header h2 { font-size: 28px; font-weight: 800; letter-spacing: -1px; text-transform: uppercase; }

    /* 상품 정보 카드 */
    .product-card { display: flex; align-items: center; padding: 20px; background: #f9f9f9; margin-bottom: 40px; border: 1px solid #eee; }
    .product-card img { width: 100px; height: 100px; object-fit: cover; background: #fff; border: 1px solid #e5e5e5; }
    .product-info { margin-left: 20px; }
    .product-info .order-num { font-size: 12px; color: #888; text-transform: uppercase; margin-bottom: 5px; }
    .product-info .product-name { font-size: 16px; font-weight: 700; }

    /* 폼 스타일 */
    .form-section { margin-bottom: 30px; }
    .form-label { display: block; font-size: 13px; font-weight: 700; text-transform: uppercase; margin-bottom: 10px; }
    .form-control { width: 100%; border: 1px solid #e5e5e5; padding: 15px; font-size: 14px; border-radius: 0; }
    .form-control:focus { border-color: #000; outline: none; }
    .form-control[readonly] { background-color: #f5f5f5; color: #666; cursor: not-allowed; }
    .form-textarea { resize: none; height: 150px; line-height: 1.6; }

    /* 버튼 그룹 */
    .btn-group { display: flex; gap: 10px; margin-top: 50px; }
    .btn-salomon { flex: 1; padding: 20px; font-size: 15px; font-weight: 700; text-transform: uppercase; border: 1px solid #000; cursor: pointer; transition: 0.3s; }
    .btn-black { background: #000; color: #fff; }
    .btn-white { background: #fff; color: #000; }
    .btn-black:hover { background: #333; }
    .btn-white:hover { background: #f0f0f0; }
    .required-star { color: #ff4d4d; margin-left: 3px; }
</style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <div class="mypage-container">
        <aside class="sidebar">
            <h2>마이페이지</h2>
            <div class="menu-group">
                <span class="menu-title">구매내역</span>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/member/mypage/orderList" class="active">주문/배송조회</a></li>
                    <li><a href="${pageContext.request.contextPath}/member/mypage/cancelList">취소상품조회</a></li>
                </ul>
            </div>
            <div class="menu-group">
                <span class="menu-title">혜택내역</span>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/member/mypage/review">상품 리뷰</a></li>
                    <li><a href="#">포인트/쿠폰</a></li>
                </ul>
            </div>
            <div class="menu-group">
                <span class="menu-title">상품내역</span>
                <ul>
                    <li><a href="#">최근 본 상품</a></li>
                    <li><a href="${pageContext.request.contextPath}/member/mypage/wishList">관심 상품</a></li>
                </ul>
            </div>
            <div class="menu-group">
                <span class="menu-title">회원정보</span>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/member/mypage/myImfo">내 정보 관리</a></li>
                    <li><a href="${pageContext.request.contextPath}/member/mypage/addr">배송지 관리</a></li>
                    <li><a href="${pageContext.request.contextPath}/member/mypage/level_benefit">회원등급</a></li>
                </ul>
            </div>
        </aside>

        <main class="main-content">
            <div class="claim-wrapper">
                <header class="claim-header">
                    <h2>
                        <c:choose>
                            <c:when test="${param.type == 'CANCEL'}">주문 취소 신청</c:when>
                            <c:when test="${param.type == 'RETURN'}">반품 신청</c:when>
                            <c:otherwise>취소/반품 신청</c:otherwise>
                        </c:choose>
                    </h2>
                </header>

                <div class="product-card">
                    <img src="${pageContext.request.contextPath}/uploads/product/${dto.thumbNail}" 
                         onerror="this.src='${pageContext.request.contextPath}/dist/images/no-image.png'">
                    <div class="product-info">
                        <p class="order-num">No. ${dto.orderNum}</p>
                        <p class="product-name">${dto.productName}</p>
                        <p style="font-size: 13px; color: #666;">[옵션] ${dto.pdSize} / ${dto.qty}개</p>
                    </div>
                </div>

                <form id="claimForm" action="${pageContext.request.contextPath}/order/claimRequest" method="post">
                    <input type="hidden" name="order_id" value="${param.order_id}">
                    
                    <div class="form-section">
                        <label class="form-label">신청 유형</label>
                        <input type="hidden" name="type" value="${param.type}">
                        <input type="text" class="form-control" readonly 
                               value="<c:if test="${param.type == 'CANCEL'}">주문 취소 (결제 취소)</c:if><c:if test="${param.type == 'RETURN'}">반품 신청 (환불 요청)</c:if>">
                    </div>

                    <div class="form-section">
                        <label class="form-label">신청 사유 <span class="required-star">*</span></label>
                        <div class="select-wrapper">
                            <select name="reason_category" class="form-control" id="reasonCategory" required>
                                <option value="">사유를 선택해 주세요</option>
                                <option value="단순 변심">단순 변심 (마음이 바뀌었어요)</option>
                                <option value="사이즈/색상 불만">사이즈/색상이 생각과 달라요</option>
                                <option value="상품 불량">상품이 파손되어 왔어요</option>
                                <option value="배송 지연">배송이 너무 늦어요</option>
                                <option value="오배송">다른 상품이 왔어요</option>
                                <option value="기타">기타 사유 (직접 입력)</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-section">
                        <label class="form-label">상세 내용</label>
                        <textarea name="reason" class="form-control form-textarea" id="reasonDetail"
                            placeholder="구체적인 사유를 입력해 주시면 빠른 처리에 도움이 됩니다."></textarea>
                    </div>

                    <div class="btn-group">
                        <button type="button" class="btn-salomon btn-white" onclick="history.back()">뒤로가기</button>
                        <button type="submit" class="btn-salomon btn-black">신청하기</button>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const claimForm = document.getElementById("claimForm");

            claimForm.addEventListener("submit", function(e) {
                const category = document.getElementById("reasonCategory").value;
                const detail = document.getElementById("reasonDetail").value.trim();
                const type = "${param.type}"; // JSP 파라미터값 가져오기

                // 1. 필수 선택 값 확인
                if (!category) {
                    alert("신청 사유를 반드시 선택해 주세요.");
                    e.preventDefault();
                    return;
                }

                // 2. 기타 선택 시 상세 사유 필수 입력
                if (category === "기타" && detail.length < 5) {
                    alert("기타 사유 선택 시, 상세 내용을 입력해 주세요.");
                    e.preventDefault();
                    return;
                }

                // 3. 최종 확인 메시지 (교환 멘트 제거됨)
                let confirmMsg = "";
                if(type === 'CANCEL') {
                    confirmMsg = "정말 주문을 취소하시겠습니까?\n취소 시 사용한 포인트와 쿠폰은 복구됩니다.";
                } else {
                    confirmMsg = "반품을 신청하시겠습니까?\n상품 수거 후 검수를 거쳐 환불이 진행됩니다.";
                }

                if (!confirm(confirmMsg)) {
                    e.preventDefault();
                }
            });
        });
    </script>

</body>
</html>