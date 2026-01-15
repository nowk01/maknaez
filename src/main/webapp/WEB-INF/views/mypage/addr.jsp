<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>배송지 관리 | SALOMON</title>

<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/my_address.css">
<script src="${pageContext.request.contextPath}/dist/js/my_address.js?v=2"></script></head>

<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="mypage-container">
    <aside class="sidebar">
        <h2>마이페이지</h2>
        <div class="menu-group">
            <span class="menu-title">구매내역</span>
            <ul>
                <li><a href="${pageContext.request.contextPath}/member/mypage/orderList">주문/배송조회</a></li>
                <li><a href="${pageContext.request.contextPath}/member/mypage/cancelList">취소상품조회</a></li>
            </ul>
        </div>
        <div class="menu-group">
            <span class="menu-title">혜택내역</span>
            <ul>
                <li><a href="${pageContext.request.contextPath}/member/mypage/review">상품 리뷰</a></li>
                <li><a href="${pageContext.request.contextPath}/member/mypage/membership">포인트/쿠폰</a></li>
            </ul>
        </div>
        <div class="menu-group">
            <span class="menu-title">상품내역</span>
            <ul>
                <li><a href="${pageContext.request.contextPath}/member/mypage/wishList">관심 상품</a></li>
            </ul>
        </div>
        <div class="menu-group">
            <span class="menu-title">회원정보</span>
            <ul>
                <li><a href="${pageContext.request.contextPath}/member/mypage/myInfo">내 정보 관리</a></li>
                <li><a href="${pageContext.request.contextPath}/member/mypage/addr" class="active">배송지 관리</a></li>
                <li><a href="${pageContext.request.contextPath}/member/mypage/level_benefit">회원등급</a></li>
            </ul>
        </div>
        <div class="menu-group">
             <ul>
                <li><a href="${pageContext.request.contextPath}/member/logout" style="color:#999;">로그아웃</a></li>
             </ul>
        </div>
    </aside>

    <main class="main-content">
        <div class="customer-address-wrap">

            <div class="group">
                <h2 class="h2 feature-header">배송지 관리</h2>
                <p class="feature-subtext">자주 사용하시는 배송지 주소를 저장하세요</p>
                <div class="line"></div>
            </div>

            <div id="address-list">

                <c:forEach var="dto" items="${list}">
                    <div class="addr-item">
                        <div class="addr-info">
                            <strong>
                                ${dto.addrName} (${dto.receiverName})
                                <c:if test="${dto.isBasic == 1}">
                                    <span class="badge-default">기본</span>
                                </c:if>
                            </strong>
                            <div class="addr-text">[${dto.zipCode}] ${dto.addr1} ${dto.addr2}</div>
                            <div class="addr-text">${dto.receiverTel}</div>
                        </div>
                        
                        <div class="addr-actions">
                            <button type="button" class="btn-text btn-edit" 
                                onclick="editAddr(this)"
                                data-id="${dto.addrId}"
                                data-addrname="${dto.addrName}"
                                data-receiver="${dto.receiverName}"
                                data-tel="${dto.receiverTel}"
                                data-zip="${dto.zipCode}"
                                data-addr1="${dto.addr1}"
                                data-addr2="${dto.addr2}"
                                data-basic="${dto.isBasic}">
                                수정
                            </button>
                            <span class="bar">|</span>
                            <button type="button" class="btn-text btn-delete" onclick="deleteAddr(${dto.addrId})">삭제</button>
                        </div>
                    </div>
                </c:forEach>

                <div class="addr-create-area">
                    
                    <div id="addr_btn_area">
                        <button class="btn" onclick="openAddForm()">
                            배송지 추가
                        </button>
                    </div>

                    <div id="addr_form_area" style="display: none;">
                        <form name="addrForm" method="post" class="customer_address" 
                              data-write-url="${pageContext.request.contextPath}/member/mypage/addr/write"
                              data-update-url="${pageContext.request.contextPath}/member/mypage/addr/update">
                            
                            <input type="hidden" name="addrId" value="">

                            <div class="customer_address_table">
                                <label class="label">이름 / 배송지명 *</label>
                                <div class="divided">
                                    <input type="text" name="receiverName" class="address_form" placeholder="받는 분 성함">
                                    <input type="text" name="addrName" class="address_form" placeholder="배송지 별칭 (예: 집)">
                                </div>

                                <label class="label">전화번호 *</label>
                                <input type="tel" name="receiverTel" class="address_form" maxlength="11" placeholder="- 없이 입력">

                                <label class="label">배송지 주소 *</label>
                                <div class="divided">
                                    <input type="text" name="zipCode" id="zipCode" class="address_form" readonly>
                                    <button type="button" class="btn searchAddressButton" onclick="daumPostcode()">우편번호 검색</button>
                                </div>

                                <input type="text" name="addr1" id="addr1" class="address_form" readonly>
                                <input type="text" name="addr2" id="addr2" class="address_form" placeholder="상세 주소">

                                <label class="as-salomon__addressInputLabel">
                                    <input type="checkbox" name="isBasic" value="1"> 
                                    <span>기본 배송지로 저장</span>
                                </label>
                            </div>

                            <div class="action_bottom">
                                <input type="button" id="btnSubmit" class="btn" value="배송지 저장" onclick="sendOk()">
                                <a href="javascript:void(0)" class="note__text" onclick="toggleAddrForm(false)">
                                    목록으로 돌아가기
                                </a>
                            </div>

                        </form>
                    </div>

                </div>
            </div>

        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
<jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    document.body.dataset.contextPath = "${pageContext.request.contextPath}";
</script>

<script src="${pageContext.request.contextPath}/dist/js/address.js?v=2"></script>

</body>
</html>