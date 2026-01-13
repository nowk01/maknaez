<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>배송지 관리 | 쇼핑몰</title>

<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/addr.css">

<script type="text/javascript">
    // 폼 토글 (목록 <-> 추가화면 전환)
    function toggleView() {
        const listView = document.getElementById("list_view");
        const formView = document.getElementById("form_view");
        const pageTitle = document.getElementById("page_title");

        if (formView.style.display === "none" || formView.style.display === "") {
            // 폼 보여주기
            listView.style.display = "none";
            formView.style.display = "block";
            pageTitle.innerText = "새 배송지 추가";
            
            // 폼 초기화
            document.addrForm.reset();
        } else {
            // 목록 보여주기
            formView.style.display = "none";
            listView.style.display = "block";
            pageTitle.innerText = "배송지 관리";
        }
    }

    // 주소 저장 전송
    function sendOk() {
        const f = document.addrForm;
        
        if(!f.name.value.trim()) {
            alert("받는 분 성함을 입력하세요.");
            f.name.focus();
            return;
        }
        if(!f.tel.value.trim()) {
            alert("전화번호를 입력하세요.");
            f.tel.focus();
            return;
        }
        if(!f.zip.value.trim()) {
            alert("우편번호를 검색해주세요.");
            return;
        }
        if(!f.addr2.value.trim()) {
            alert("상세 주소를 입력해주세요.");
            f.addr2.focus();
            return;
        }

        f.action = "${pageContext.request.contextPath}/member/mypage/addr/write";
        f.submit();
    }
    
    // 배송지 삭제
    function deleteAddr(addrIdx) {
    	if(confirm("정말 이 배송지를 삭제하시겠습니까?")) {
    		location.href = "${pageContext.request.contextPath}/member/mypage/addr/delete?addrIdx=" + addrIdx;
    	}
    }
</script>
</head>
<body>

    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <div class="mypage-container">

        <aside class="sidebar">
            <h2>마이페이지</h2>
            <div class="menu-group">
                <span class="menu-title">구매내역</span>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/member/mypage/orderList">주문/배송조회</a></li>
                    <li><a href="${pageContext.request.contextPath}/member/mypage/cancelList">취소/반품조회</a></li>
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
                    <li><a href="${pageContext.request.contextPath}/member/mypage/myInfo">내 정보 관리</a></li>
                    <li><a href="${pageContext.request.contextPath}/member/mypage/addr" class="active">배송지 관리</a></li>
                    <li><a href="#">회원등급</a></li>
                    <li><a href="#">문의하기</a></li>
                </ul>
            </div>
            <div class="menu-group">
                <ul>
                    <li><a href="${pageContext.request.contextPath}/member/logout" style="color: #999;">로그아웃</a></li>
                </ul>
            </div>
        </aside>

        <main class="main-content">
            <h2 class="feature-header" id="page_title">배송지 관리</h2>

            <div id="address_container">
                
                <div id="list_view">
                    <div class="addr-list-header">
                        <button type="button" class="btn-black" onclick="toggleView();">+ 배송지 추가</button>
                    </div>

                    <c:if test="${empty list}">
                        <div class="empty-msg">등록된 배송지가 없습니다.</div>
                    </c:if>

                    <c:if test="${not empty list}">
                        <c:forEach var="dto" items="${list}">
                            <div class="addr-item">
                                <div class="addr-info-box">
                                    <div class="addr-name">
                                        ${dto.name}
                                        <c:if test="${dto.isDefault == 1}">
                                            <span class="badge-default">기본</span>
                                        </c:if>
                                    </div>
                                    <div class="addr-detail">
                                        [${dto.zip}] ${dto.addr1} ${dto.addr2}
                                    </div>
                                    <div class="addr-tel">${dto.tel}</div>
                                </div>
                                <div class="addr-actions">
                                    <button type="button" class="btn-small" onclick="deleteAddr(${dto.addrIdx});">삭제</button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:if>
                </div>

                <div id="form_view">
                    <form name="addrForm" method="post">
                        
                        <div class="input-row">
                            <label class="info-label">이름</label>
                            <input type="text" name="name" placeholder="받는 분 성함">
                        </div>

                        <div class="input-row">
                            <label class="info-label">휴대폰번호</label>
                            <input type="text" name="tel" placeholder="010-0000-0000">
                        </div>

                        <div class="input-row">
                            <label class="info-label">주소</label>
                            <div class="zip-field">
                                <input type="text" name="zip" id="zip" placeholder="우편번호" readonly>
                                <button type="button" class="btn-black" onclick="daumPostcode();">검색</button>
                            </div>
                            <input type="text" name="addr1" id="addr1" placeholder="기본 주소" readonly style="margin-bottom: 10px;">
                            <input type="text" name="addr2" id="addr2" placeholder="상세 주소를 입력하세요">
                        </div>

                        <div class="checkbox-row">
                            <input type="checkbox" id="default_check" name="isDefault" value="1">
                            <label for="default_check">기본 배송지로 저장</label>
                        </div>

                        <div class="wide-action">
                            <button type="button" class="btn-cancel" onclick="toggleView();">취소</button>
                            <button type="button" class="btn-submit" onclick="sendOk();">저장</button>
                        </div>
                    </form>
                </div>

            </div>
        </main>
    </div>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
    <jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />
    
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script>
        function daumPostcode() {
            new daum.Postcode({
                oncomplete: function(data) {
                    var addr = ''; 
                    if (data.userSelectedType === 'R') { 
                        addr = data.roadAddress;
                    } else { 
                        addr = data.jibunAddress;
                    }

                    document.getElementById('zip').value = data.zonecode;
                    document.getElementById("addr1").value = addr;
                    document.getElementById("addr2").focus();
                }
            }).open();
        }
    </script>

</body>
</html>