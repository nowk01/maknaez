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

<!-- 다음 주소 API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<style>
    @import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&family=Noto+Sans+KR:wght@300;400;500;700&display=swap');

    body {
        font-family: 'Noto Sans KR', sans-serif;
        color: #000;
        background-color: #fff;
    }

    .payment-wrap {
        max-width: 1200px;
        margin: 0 auto;
        padding: 60px 20px 120px;
    }

    /* 타이틀 */
    .page-title {
        text-align: center;
        font-size: 32px;
        font-weight: 700;
        margin-bottom: 50px;
        letter-spacing: -1px;
    }

    /* 섹션 공통 */
    .section-title {
        font-size: 20px;
        font-weight: 700;
        border-bottom: 2px solid #000;
        padding-bottom: 15px;
        margin-bottom: 20px;
        margin-top: 40px;
    }
    .section-title:first-child { margin-top: 0; }

    /* 상품 정보 테이블 */
    .tbl-order {
        width: 100%;
        border-collapse: collapse;
        border-bottom: 1px solid #ddd;
    }
    .tbl-order th {
        padding: 15px;
        border-bottom: 1px solid #000;
        text-align: center;
        font-weight: 600;
        background: #f9f9f9;
    }
    .tbl-order td {
        padding: 20px 10px;
        text-align: center;
        border-top: 1px solid #eee;
        vertical-align: middle;
    }
    .td-info { text-align: left !important; display: flex; align-items: center; }
    .td-info img { width: 80px; height: 80px; object-fit: cover; border: 1px solid #eee; margin-right: 15px; }
    .td-info .p-name { font-weight: 500; font-size: 15px; margin-bottom: 5px; }
    .td-info .p-opt { font-size: 13px; color: #888; }

    /* 폼 스타일 */
    .form-label { font-weight: 500; font-size: 14px; margin-top: 10px; }
    .form-control, .form-select {
        border-radius: 0;
        border: 1px solid #ddd;
        padding: 10px 15px;
        font-size: 14px;
    }
    .form-control:focus, .form-select:focus {
        border-color: #000;
        box-shadow: none;
    }
    .btn-addr {
        border-radius: 0;
        background: #333;
        color: #fff;
        border: 1px solid #333;
        font-size: 13px;
    }
    .btn-addr:hover { background: #000; color: #fff; }

    /* 결제 정보 (Sticky) */
    .sticky-summary {
        position: sticky;
        top: 80px; /* [수정] 30px -> 80px (헤더 높이 고려 등 더 보기 좋게 변경) */
        background: #fdfdfd;
        border: 1px solid #000;
        padding: 30px;
    }
    .sum-row { display: flex; justify-content: space-between; margin-bottom: 15px; font-size: 15px; }
    .sum-row.total { 
        margin-top: 20px; 
        padding-top: 20px; 
        border-top: 1px solid #ddd; 
        font-weight: 700; 
        font-size: 18px; 
        color: #dc3545; /* 강조색 */
    }
    .sum-row.total .price { font-family: 'Montserrat', sans-serif; font-size: 24px; }

    .btn-pay {
        width: 100%;
        height: 60px;
        background: #000;
        color: #fff;
        font-size: 18px;
        font-weight: 700;
        border: none;
        border-radius: 0;
        margin-top: 30px;
        transition: background 0.2s;
    }
    .btn-pay:hover { background: #333; }

    /* 라디오 버튼 커스텀 */
    .pay-method-wrap { display: flex; gap: 10px; margin-top: 15px; flex-wrap: wrap; }
    .pay-radio { display: none; }
    .pay-label {
        flex: 1 1 30%; /* 3개 나란히 배치 */
        text-align: center;
        padding: 15px 0;
        border: 1px solid #ddd;
        cursor: pointer;
        font-weight: 500;
        transition: all 0.2s;
        font-size: 13px;
        white-space: nowrap;
    }
    .pay-radio:checked + .pay-label {
        border-color: #000;
        background: #000;
        color: #fff;
    }

</style>
</head>
<body>

<header>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<div class="payment-wrap">
    <div class="page-title">주문 / 결제 </div>

    <form name="paymentForm" id="paymentForm">
        <!-- 서버 전송용 Hidden Data -->
        <input type="hidden" name="prod_id" value="${product.prodId}">
        <input type="hidden" name="quantity" value="${quantity}">
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
                        <tr>
                            <td class="td-info">
                                <!-- 이미지 경로: uploads/product/파일명 (예시) -->
                                <img src="${pageContext.request.contextPath}/uploads/product/${product.imageFile}" 
                                     onerror="this.src='https://placehold.co/80x80?text=No+Img'">
                                <div>
                                    <div class="p-name">${product.productName}</div>
                                    <div class="p-opt">기본 옵션</div>
                                </div>
                            </td>
                            <td>${quantity}개</td>
                            <td class="fw-bold">
                                <fmt:formatNumber value="${totalPrice}" pattern="#,###"/>원
                            </td>
                        </tr>
                    </tbody>
                </table>

                <!-- 2. 주문자 정보 -->
                <div class="section-title">주문자 정보</div>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">보내는 분</label>
                        <!-- MemberDTO의 userName -->
                        <input type="text" class="form-control" value="${member.userName}" readonly>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">연락처</label>
                        <!-- MemberDTO의 tel -->
                        <input type="text" class="form-control" value="${member.tel}" readonly>
                    </div>
                    <div class="col-12 mt-2">
                        <label class="form-label">이메일</label>
                        <!-- MemberDTO의 email -->
                        <input type="text" class="form-control" value="${member.email}" readonly>
                    </div>
                </div>

                <!-- 3. 배송지 정보 -->
                <div class="d-flex justify-content-between align-items-end mt-5 mb-3 border-bottom border-dark pb-3">
                    <div class="h5 fw-bold m-0">배송지 정보</div>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="sameAddress">
                        <label class="form-check-label" for="sameAddress">주문자 정보와 동일</label>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">받는 분 <span class="text-danger">*</span></label>
                        <input type="text" name="receiver_name" id="receiver_name" class="form-control" placeholder="이름">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">연락처 <span class="text-danger">*</span></label>
                        <input type="text" name="receiver_tel" id="receiver_tel" class="form-control" placeholder="- 없이 입력">
                    </div>
                </div>

                <div class="row mb-3">
                    <label class="form-label">주소 <span class="text-danger">*</span></label>
                    <div class="col-12 d-flex gap-2 mb-2">
                        <input type="text" name="zip_code" id="zip_code" class="form-control" style="width: 120px;" placeholder="우편번호" readonly>
                        <button type="button" class="btn btn-addr" onclick="searchAddress()">주소찾기</button>
                    </div>
                    <div class="col-12 mb-2">
                        <input type="text" name="addr1" id="addr1" class="form-control" placeholder="기본 주소" readonly>
                    </div>
                    <div class="col-12">
                        <input type="text" name="addr2" id="addr2" class="form-control" placeholder="상세 주소를 입력해주세요">
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
                        <span>상품금액</span>
                        <span><fmt:formatNumber value="${totalPrice}" pattern="#,###"/>원</span>
                    </div>
                    <div class="sum-row">
                        <span>배송비</span>
                        <span>0원</span> <!-- 조건부 무료배송 로직 필요시 추가 -->
                    </div>
                    <div class="sum-row">
                        <span>할인금액</span>
                        <span>0원</span>
                    </div>

                    <div class="sum-row total">
                        <span>총 결제금액</span>
                        <span class="price"><fmt:formatNumber value="${totalPrice}" pattern="#,###"/>원</span>
                    </div>

                    <div class="mt-4">
                        <label class="form-label fw-bold">결제 수단</label>
                        <!-- [수정] 결제 수단 추가 및 변경 -->
                        <div class="pay-method-wrap">
                            <!-- 1. 카카오페이 -->
                            <input type="radio" name="pay_method" id="kakaopay" value="kakaopay" class="pay-radio" checked>
                            <label for="kakaopay" class="pay-label">카카오페이</label>

                            <!-- 2. 신용카드 -->
                            <input type="radio" name="pay_method" id="card" value="card" class="pay-radio">
                            <label for="card" class="pay-label">신용카드</label>

                            <!-- 3. 무통장입금 -->
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

<footer>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>
<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>

<script>
// [주문자 정보 동일] 체크박스 이벤트
$(function() {
    $("#sameAddress").change(function() {
        if($(this).is(":checked")) {
            $("#receiver_name").val("${member.userName}");
            $("#receiver_tel").val("${member.tel}");
            // 회원의 저장된 주소 정보가 있다면 가져옴 (MemberDTO 필드 기준)
            $("#zip_code").val("${member.zip}");
            $("#addr1").val("${member.addr1}");
            $("#addr2").val("${member.addr2}");
        } else {
            $("#receiver_name").val("");
            $("#receiver_tel").val("");
            $("#zip_code").val("");
            $("#addr1").val("");
            $("#addr2").val("");
        }
    });
});

// [배송 메모] 직접 입력 토글
function changeMemo(select) {
    const $direct = $("#memoDirect");
    if(select.value === "direct") {
        $direct.show().focus();
        $direct.prop("name", "memo"); // input이 name을 가짐
        $(select).removeAttr("name");
    } else {
        $direct.hide().val("");
        $(select).prop("name", "memo"); // select가 name을 가짐
        $direct.removeAttr("name");
    }
}

// [주소 찾기] 다음 우편번호 API
function searchAddress() {
    new daum.Postcode({
        oncomplete: function(data) {
            let addr = '';
            if (data.userSelectedType === 'R') { 
                addr = data.roadAddress;
            } else { 
                addr = data.jibunAddress;
            }
            $("#zip_code").val(data.zonecode);
            $("#addr1").val(addr);
            $("#addr2").focus();
        }
    }).open();
}

// [결제 요청]
function processPayment() {
    const f = document.paymentForm;

    // 유효성 검사
    if(!f.receiver_name.value) { alert("받는 분 이름을 입력해주세요."); f.receiver_name.focus(); return; }
    if(!f.receiver_tel.value) { alert("연락처를 입력해주세요."); f.receiver_tel.focus(); return; }
    if(!f.zip_code.value || !f.addr1.value) { alert("주소를 입력해주세요."); return; }
    if(!f.addr2.value) { 
        if(!confirm("상세주소가 입력되지 않았습니다. 그대로 진행하시겠습니까?")) {
            f.addr2.focus(); return; 
        }
    }

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