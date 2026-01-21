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

    .btn-change-addr {
        border: 1px solid #ddd;
        background: #fff;
        font-size: 12px;
        padding: 5px 10px;
        vertical-align: middle;
        font-weight: 500;
    }
    .btn-change-addr:hover { border-color: #000; background: #f9f9f9; }

    /* 포인트 입력 영역 스타일 */
    .point-box { background: #fff; border: 1px solid #ddd; padding: 15px; margin: 15px 0; border-radius: 4px; }
    .point-input-group { display: flex; gap: 5px; margin-bottom: 5px; }
    .point-input-group input { text-align: right; font-weight: 600; }
    .btn-use-point { background: #555; color: #fff; border: 1px solid #555; font-size: 12px; padding: 0 10px; white-space: nowrap; cursor: pointer; }
    .point-desc { font-size: 12px; color: #888; text-align: right; line-height: 1.4; }
    .point-avail { color: #000; font-weight: 600; }

    /* [수정] 오버레이 스타일 (강력한 z-index 및 flex 중앙 정렬) */
    #payment-loading-overlay {
        display: none; /* JS로 flex 변경 */
        position: fixed;
        top: 0;
        left: 0;
        width: 100vw;
        height: 100vh;
        background-color: rgba(0, 0, 0, 0.85); /* 더 어둡게 */
        z-index: 10000; /* 최상단 보장 */
        flex-direction: column;
        justify-content: center;
        align-items: center;
        color: #fff;
    }

    /* 로딩 스피너 (Bootstrap spinner-border 활용 또는 커스텀) */
    .custom-spinner {
        width: 60px;
        height: 60px;
        border: 6px solid rgba(255, 255, 255, 0.3);
        border-radius: 50%;
        border-top-color: #fff;
        animation: spin 1s ease-in-out infinite;
        margin-bottom: 25px;
    }

    @keyframes spin {
        to { transform: rotate(360deg); }
    }

    .loading-text {
        font-size: 1.4rem;
        font-weight: 700;
        letter-spacing: 1px;
        margin-bottom: 10px;
    }
    .loading-sub-text {
        font-size: 1rem;
        color: #ccc;
        font-weight: 300;
    }
</style>
</head>
<body>

<header>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<div class="payment-wrap">
    <div class="page-title">주문 / 결제</div>

    <form name="paymentForm" id="paymentForm" method="post">
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

                <!-- 3. 배송지 정보 -->
                <div class="d-flex align-items-center mt-5 mb-3 border-bottom border-dark pb-3">
                    <div class="h5 fw-bold m-0">배송지 정보</div>
                    <button type="button" class="btn-change-addr ms-auto" onclick="openAddressPopup()">[배송지 변경]</button>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">받는 분 <span class="text-danger">*</span></label>
                        <input type="text" name="receiver_name" id="receiver_name" class="form-control" value="${member.userName}" readonly placeholder="배송지 변경을 클릭하세요">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">연락처 <span class="text-danger">*</span></label>
                        <input type="text" name="receiver_tel" id="receiver_tel" class="form-control" value="${member.tel}" readonly placeholder="배송지 변경을 클릭하세요">
                    </div>
                </div>

                <div class="row mb-3">
                    <label class="form-label">주소 <span class="text-danger">*</span></label>
                    <div class="col-12 d-flex gap-2 mb-2">
                        <input type="text" name="zip_code" id="zip_code" class="form-control" style="width: 120px;" placeholder="우편번호" value="${member.zip}" readonly>
                    </div>
                    <div class="col-12 mb-2">
                        <input type="text" name="addr1" id="addr1" class="form-control" placeholder="기본 주소" value="${member.addr1}" readonly>
                    </div>
                    <div class="col-12">
                        <input type="text" name="addr2" id="addr2" class="form-control" placeholder="상세 주소" value="${member.addr2}">
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

                    <!-- 포인트 입력 영역 -->
                    <div class="point-box">
                        <div class="d-flex justify-content-between mb-2">
                            <span style="font-size:14px; font-weight:600;">포인트 사용</span>
                        </div>
                        <div class="point-input-group">
                            <input type="text" name="point" id="pointInput" class="form-control form-control-sm" value="0" oninput="validatePoint(this)">
                            <button type="button" class="btn-use-point" onclick="useAllPoints()">전액사용</button>
                        </div>
                        <div class="point-desc">
                            보유: <span class="point-avail" id="availPoint"><fmt:formatNumber value="${currentPoint}" pattern="#,###"/></span> P<br>
                            - 1,000 포인트 이상부터 사용 가능합니다.<br>
                            - 총 결제금액의 30% 이내에서 사용 가능합니다.
                        </div>
                    </div>

                    <div class="sum-row total">
                        <span>총 결제금액</span>
                        <span class="price" id="finalPriceDisplay"><fmt:formatNumber value="${totalPrice}" pattern="#,###"/>원</span>
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
                        결제하기
                    </button>
                </div>
            </div>
        </div>
    </form>
</div>

<!-- [수정] 결제 로딩 오버레이 (구조 변경 및 스타일 강화) -->
<div id="payment-loading-overlay">
    <div class="custom-spinner"></div>
    <div class="loading-text">결제가 진행중입니다...</div>
    <div class="loading-sub-text">잠시만 기다려주세요.</div>
</div>

<footer>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>
<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>

<script>
// 전역 변수
const totalPrice = ${totalPrice};
const availPoint = ${currentPoint};

// 배송메모 직접입력 토글
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

// 다음 주소 API
function daumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            var fullAddr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
            var extraAddr = '';
            if(data.userSelectedType === 'R'){
                if(data.bname !== '') extraAddr += data.bname;
                if(data.buildingName !== '') extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
            }
            document.getElementById('zip_code').value = data.zonecode;
            document.getElementById('addr1').value = fullAddr;
            document.getElementById('addr2').focus();
        }
    }).open();
}

// 배송지 목록 팝업
function openAddressPopup() {
    const url = "${pageContext.request.contextPath}/order/address/list";
    const option = "width=500,height=600,top=100,left=200";
    window.open(url, "addressPopup", option);
}

// 전화번호 포맷팅
function formatPhoneNumber(tel) {
    if(!tel) return "";
    let str = tel.replace(/[^0-9]/g, '');
    let result = "";
    if(str.length < 4) return str;
    if(str.length < 7) result = str.substr(0, 3) + "-" + str.substr(3);
    else if(str.length < 11) result = str.substr(0, 3) + "-" + str.substr(3, 3) + "-" + str.substr(6);
    else result = str.substr(0, 3) + "-" + str.substr(3, 4) + "-" + str.substr(7);
    return result;
}

// 팝업에서 호출하는 데이터 세팅 함수
window.setShippingAddress = function(data) {
    $("#receiver_name").val(data.name);
    $("#receiver_tel").val(formatPhoneNumber(data.tel));
    $("#zip_code").val(data.zip);
    $("#addr1").val(data.addr1);
    $("#addr2").val(data.addr2);
};

// [포인트 유효성 검사 및 계산]
function validatePoint(input) {
    let val = input.value.replace(/[^0-9]/g, ""); // 숫자만
    if(val === "") val = 0;
    val = parseInt(val);

    const maxLimit = Math.floor(totalPrice * 0.3); // 30% 제한

    if (val > availPoint) {
        alert("보유 포인트를 초과하여 사용할 수 없습니다.");
        val = availPoint;
    }
    
    if (val > maxLimit) {
        alert("포인트는 결제 금액의 30% (" + maxLimit.toLocaleString() + " P) 까지만 사용 가능합니다.");
        val = maxLimit;
    }

    input.value = val;
    updateFinalPrice(val);
}

// [포인트 전액 사용]
function useAllPoints() {
    if (availPoint < 1000) {
        alert("포인트는 1,000 P 이상부터 사용 가능합니다.");
        return;
    }

    const maxLimit = Math.floor(totalPrice * 0.3);
    let useAmount = availPoint;

    if (useAmount > maxLimit) {
        useAmount = maxLimit;
    }

    $("#pointInput").val(useAmount);
    updateFinalPrice(useAmount);
}

// [최종 금액 업데이트]
function updateFinalPrice(usePoint) {
    const finalPrice = totalPrice - usePoint;
    $("#finalPriceDisplay").text(finalPrice.toLocaleString() + "원");
}

// [결제 요청]
function processPayment() {
    const f = document.paymentForm;

    if(!f.receiver_name.value || !f.zip_code.value || !f.addr1.value) { 
        alert("배송지 정보를 입력하거나 목록에서 선택해주세요.");
        openAddressPopup(); 
        return; 
    }
    
    if(!f.addr2.value) {
        alert("상세주소를 입력해주세요.");
        f.addr2.focus();
        return;
    }

    let usePoint = parseInt(f.point.value) || 0;
    if (usePoint > 0 && usePoint < 1000) {
        alert("포인트는 1,000 P 이상부터 사용 가능합니다.");
        f.point.focus();
        return;
    }

    if(!confirm("결제를 진행하시겠습니까?")) return;

    // [수정] 오버레이 노출 및 flex 설정
    $("#payment-loading-overlay").css("display", "flex");

    setTimeout(function() {
        const url = "${pageContext.request.contextPath}/order/pay";
        const formData = $(f).serialize();

        $.ajax({
            type: "POST",
            url: url,
            data: formData,
            dataType: "json",
            success: function(data) {
                if (data.status === "success") {
                    location.href = "${pageContext.request.contextPath}" + data.redirect;
                } else {
                    $("#payment-loading-overlay").hide();
                    alert(data.message);
                }
            },
            error: function(jqXHR) {
                $("#payment-loading-overlay").hide();
                console.log(jqXHR.responseText);
                alert("통신 중 오류가 발생했습니다.");
            }
        });
    }, 3000); 
}
</script>

</body>
</html>