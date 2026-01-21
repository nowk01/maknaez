<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>주문/결제 - Maknaez</title>

<!-- 공통 리소스 & Bootstrap 5 -->
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<style>
    /* ... (기존 스타일 유지) ... */
    @import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&family=Noto+Sans+KR:wght@300;400;500;700&display=swap');

    body { font-family: 'Noto Sans KR', sans-serif; color: #000; background-color: #fff; }
    .payment-wrap { max-width: 1200px; margin: 0 auto; padding: 60px 20px 120px; }
    .page-title { text-align: center; font-size: 32px; font-weight: 700; margin-bottom: 50px; letter-spacing: -1px; }
    
    .section-title { font-size: 20px; font-weight: 700; border-bottom: 2px solid #000; padding-bottom: 15px; margin-bottom: 20px; margin-top: 40px; }
    .section-title:first-child { margin-top: 0; }
    
    .tbl-order { width: 100%; border-collapse: collapse; border-bottom: 1px solid #ddd; }
    .tbl-order th { padding: 15px; border-bottom: 1px solid #000; text-align: center; font-weight: 600; background: #f9f9f9; }
    .tbl-order td { padding: 20px 10px; text-align: center; border-top: 1px solid #eee; vertical-align: middle; }
    .td-info { text-align: left !important; display: flex; align-items: center; }
    .td-info img { width: 80px; height: 80px; object-fit: cover; border: 1px solid #eee; margin-right: 15px; }
    .td-info .p-name { font-weight: 500; font-size: 15px; margin-bottom: 5px; }
    .td-info .p-opt { font-size: 13px; color: #888; }
    
    .form-label { font-weight: 500; font-size: 14px; margin-top: 10px; }
    .form-control, .form-select { border-radius: 0; border: 1px solid #ddd; padding: 10px 15px; font-size: 14px; }
    .form-control:focus, .form-select:focus { border-color: #000; box-shadow: none; }
    
    /* 읽기 전용 필드 스타일 (회색 배경) */
    .form-control[readonly] { background-color: #f8f9fa; cursor: default; }

    .sticky-summary { position: sticky; top: 80px; background: #fdfdfd; border: 1px solid #000; padding: 30px; }
    .sum-row { display: flex; justify-content: space-between; margin-bottom: 15px; font-size: 15px; }
    .sum-row.total { margin-top: 20px; padding-top: 20px; border-top: 1px solid #ddd; font-weight: 700; font-size: 18px; color: #dc3545; }
    .sum-row.total .price { font-family: 'Montserrat', sans-serif; font-size: 24px; }
    .btn-pay { width: 100%; height: 60px; background: #000; color: #fff; font-size: 18px; font-weight: 700; border: none; border-radius: 0; margin-top: 30px; transition: background 0.2s; }
    .btn-pay:hover { background: #333; }
    .pay-method-wrap { display: flex; gap: 10px; margin-top: 15px; flex-wrap: wrap; }
    .pay-radio { display: none; }
    .pay-label { flex: 1 1 30%; text-align: center; padding: 15px 0; border: 1px solid #ddd; cursor: pointer; font-weight: 500; transition: all 0.2s; font-size: 13px; white-space: nowrap; }
    .pay-radio:checked + .pay-label { border-color: #000; background: #000; color: #fff; }

    /* [수정] 배송지 변경 버튼 스타일 (오른쪽 정렬을 위해 margin-left 제거 후 아래 html에서 클래스 처리) */
    .btn-change-addr {
        border: 1px solid #ddd;
        background: #fff;
        font-size: 12px;
        padding: 5px 10px;
        vertical-align: middle;
        font-weight: 500;
    }
    .btn-change-addr:hover { border-color: #000; background: #f9f9f9; }
</style>
</head>
<body>

<header>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<div class="payment-wrap">
    <div class="page-title">주문 / 결제</div>

    <form name="paymentForm" id="paymentForm">
        <input type="hidden" name="total_amount" value="${totalPrice}">

        <div class="row">
            <!-- 왼쪽: 정보 입력 영역 -->
            <div class="col-lg-8">
                
                <!-- 1. 주문 상품 -->
                <div class="section-title">주문 상품 정보</div>
                <table class="tbl-order">
                    <colgroup>
                        <col width="*">
                        <col width="100">
                        <col width="150">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>상품정보</th>
                            <th>수량</th>
                            <th>주문금액</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${orderList}">
                            <tr>
                                <td class="td-info">
                                    <input type="hidden" name="prod_id" value="${item.PROD_ID}">
                                    <input type="hidden" name="quantity" value="${item.QUANTITY}">
                                    <input type="hidden" name="opt_id" value="${item.OPT_ID}">
                                    <c:if test="${not empty item.CART_ID}">
                                        <input type="hidden" name="cart_id" value="${item.CART_ID}">
                                    </c:if>
                                    <img src="${pageContext.request.contextPath}/uploads/product/${item.THUMBNAIL}" 
                                         onerror="this.src='https://placehold.co/80x80?text=No+Img'">
                                    <div>
                                        <div class="p-name">${item.PROD_NAME}</div>
                                        <div class="p-opt">옵션: ${item.OPTION_VALUE}</div>
                                    </div>
                                </td>
                                <td>${item.QUANTITY}개</td>
                                <td class="fw-bold">
                                    <fmt:formatNumber value="${item.TOTAL_PRICE}" pattern="#,###"/>원
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <!-- 2. 주문자 정보 -->
                <div class="section-title">주문자 정보</div>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">보내는 분</label>
                        <input type="text" class="form-control" value="${member.userName}" readonly>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">연락처</label>
                        <input type="text" class="form-control" value="${member.tel}" readonly>
                    </div>
                    <div class="col-12 mt-2">
                        <label class="form-label">이메일</label>
                        <input type="text" class="form-control" value="${member.email}" readonly>
                    </div>
                </div>

                <!-- 3. 배송지 정보 (수정됨) -->
                <div class="d-flex align-items-center mt-5 mb-3 border-bottom border-dark pb-3">
                    <div class="h5 fw-bold m-0">배송지 정보</div>
                    <!-- [수정] ms-auto 클래스 추가하여 오른쪽 끝으로 이동 -->
                    <button type="button" class="btn-change-addr ms-auto" onclick="openAddressPopup()">[배송지 변경]</button>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">받는 분 <span class="text-danger">*</span></label>
                        <!-- [수정] readonly 추가 (키인 금지) -->
                        <input type="text" name="receiver_name" id="receiver_name" class="form-control" readonly placeholder="배송지 변경을 클릭하세요">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">연락처 <span class="text-danger">*</span></label>
                        <input type="text" name="receiver_tel" id="receiver_tel" class="form-control" readonly placeholder="배송지 변경을 클릭하세요">
                    </div>
                </div>

                <div class="row mb-3">
                    <label class="form-label">주소 <span class="text-danger">*</span></label>
                    <div class="col-12 d-flex gap-2 mb-2">
                        <!-- [수정] 주소찾기 버튼 제거, readonly 유지 -->
                        <input type="text" name="zip_code" id="zip_code" class="form-control" style="width: 120px;" placeholder="우편번호" readonly>
                    </div>
                    <div class="col-12 mb-2">
                        <input type="text" name="addr1" id="addr1" class="form-control" placeholder="기본 주소" readonly>
                    </div>
                    <div class="col-12">
                        <!-- [수정] 상세주소도 readonly -->
                        <input type="text" name="addr2" id="addr2" class="form-control" placeholder="상세 주소" readonly>
                    </div>
                </div>

                <div class="row mb-5">
                    <div class="col-12">
                        <label class="form-label">배송 메모</label>
                        <select class="form-select" id="memoSelect" onchange="changeMemo(this)">
                            <option value="">배송 시 요청사항을 선택해주세요</option>
                            <option value="부재 시 경비실에 맡겨주세요">부재 시 경비실에 맡겨주세요</option>
                            <option value="부재 시 문 앞에 놓아주세요">부재 시 문 앞에 놓아주세요</option>
                            <option value="배송 전 연락바랍니다">배송 전 연락바랍니다</option>
                            <option value="direct">직접 입력</option>
                        </select>
                        <input type="text" name="memo" id="memoDirect" class="form-control mt-2" placeholder="요청사항 입력" style="display:none;">
                    </div>
                </div>
            </div>

            <!-- 오른쪽: 결제 요약 (Sticky) -->
            <div class="col-lg-4">
                <div class="sticky-summary">
                    <div class="h5 fw-bold mb-4">결제 상세</div>
                    
                    <div class="sum-row">
                        <span>총 수량</span>
                        <span>${totalQuantity}개</span>
                    </div>
                    <div class="sum-row">
                        <span>상품금액</span>
                        <span><fmt:formatNumber value="${totalPrice}" pattern="#,###"/>원</span>
                    </div>
                    <div class="sum-row">
                        <span>배송비</span>
                        <span>0원</span> 
                    </div>

                    <div class="sum-row total">
                        <span>총 결제금액</span>
                        <span class="price"><fmt:formatNumber value="${totalPrice}" pattern="#,###"/>원</span>
                    </div>

                    <div class="mt-4">
                        <label class="form-label fw-bold">결제 수단</label>
                        <div class="pay-method-wrap">
                            <input type="radio" name="pay_method" id="kakaopay" value="kakaopay" class="pay-radio" checked>
                            <label for="kakaopay" class="pay-label">카카오페이</label>

                            <input type="radio" name="pay_method" id="card" value="card" class="pay-radio">
                            <label for="card" class="pay-label">신용카드</label>

                            <input type="radio" name="pay_method" id="bank" value="bank" class="pay-radio">
                            <label for="bank" class="pay-label">무통장입금</label>
                        </div>
                    </div>
                    
                    

                    <button type="button" class="btn-pay" onclick="processPayment()">
                        <fmt:formatNumber value="${totalPrice}" pattern="#,###"/>원 결제하기
                    </button>
                </div>
            </div>
        </div>
    </form>
</div>

<footer>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>
<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>

<script>
// [배송 메모] 직접 입력 토글
function changeMemo(select) {
    const $direct = $("#memoDirect");
    if(select.value === "direct") {
        $direct.show().focus();
        $direct.prop("name", "memo"); 
        $(select).removeAttr("name");
    } else {
        $direct.hide().val("");
        $(select).prop("name", "memo"); 
        $direct.removeAttr("name");
    }
}

// [추가] 배송지 변경 팝업 열기
function openAddressPopup() {
    // 404 에러 발생 시 여기 URL이 맞는지 확인 필요 (/maknaez/order/address/list 가 되어야 함)
    // contextPath가 /maknaez 라고 가정
    const url = "${pageContext.request.contextPath}/order/address/list";
    const option = "width=500,height=600,top=100,left=200";
    window.open(url, "addressPopup", option);
}

// [추가] 전화번호 포맷팅 함수 (데이터 수신 시 사용)
function formatPhoneNumber(tel) {
    if(!tel) return "";
    let str = tel.replace(/[^0-9]/g, ''); // 숫자만 추출
    let result = "";
    
    if(str.length < 4) {
        return str;
    } else if(str.length < 7) {
        result = str.substr(0, 3) + " - " + str.substr(3);
    } else if(str.length < 11) { // 02-123-4567 등
        if(str.startsWith('02')) {
            result = str.substr(0, 2) + " - " + str.substr(2, 3) + " - " + str.substr(5);
        } else {
            result = str.substr(0, 3) + " - " + str.substr(3, 3) + " - " + str.substr(6);
        }
    } else { // 010-1234-5678
        result = str.substr(0, 3) + " - " + str.substr(3, 4) + " - " + str.substr(7);
    }
    return result;
}

// [추가] 팝업에서 호출하는 함수 (데이터 세팅)
window.setShippingAddress = function(data) {
    $("#receiver_name").val(data.name);
    // [수정] 포맷팅 함수 적용하여 값 입력
    $("#receiver_tel").val(formatPhoneNumber(data.tel));
    $("#zip_code").val(data.zip);
    $("#addr1").val(data.addr1);
    $("#addr2").val(data.addr2);
};

// [결제 요청]
function processPayment() {
    const f = document.paymentForm;

    // 유효성 검사
    if(!f.receiver_name.value) { alert("배송지를 선택해주세요."); openAddressPopup(); return; }

    if(!confirm("결제를 진행하시겠습니까?")) return;

    // Ajax 전송
    const url = "${pageContext.request.contextPath}/order/pay";
    const formData = $(f).serialize();

    $.ajax({
        type: "POST",
        url: url,
        data: formData,
        dataType: "json",
        success: function(data) {
            if (data.status === "success") {
                alert("결제가 완료되었습니다.");
                location.href = "${pageContext.request.contextPath}" + data.redirect;
            } else {
                alert(data.message);
            }
        },
        error: function(e) {
            console.log(e);
            alert("서버 통신 중 오류가 발생했습니다.");
        }
    });
}
</script>

</body>
</html>