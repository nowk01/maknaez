<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>장바구니 - Maknaez</title>

<!-- 공통 리소스 -->
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>

<style>
    /* * [STYLE] BLACK & WHITE THEME 
     * 파란색 요소 배제, 각진 버튼, 굵은 선 사용
     */
    @import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800&family=Noto+Sans+KR:wght@300;400;500;700&display=swap');

    body {
        background-color: #fff;
        font-family: 'Noto Sans KR', sans-serif;
        color: #000;
        margin: 0;
    }
    
    a { text-decoration: none; color: inherit; }
    ul, li { list-style: none; padding: 0; margin: 0; }
    p { margin: 0; }

    .cart-wrap {
        width: 100%;
        max-width: 1400px; /* 넓은 화면 대응 */
        margin: 0 auto;
        padding: 80px 20px 150px;
    }

    /* --- 타이틀 영역 (가운데 정렬) --- */
    .page-head {
        text-align: center; /* 가운데 정렬 */
        margin-bottom: 50px;
    }

    .page-title {
        font-family: 'Noto Sans KR', sans-serif;
        font-size: 40px;
        font-weight: 700;
        color: #000;
        margin: 0;
        letter-spacing: -1px;
    }

    /* --- 장바구니 테이블 --- */
    .tbl-cart {
        width: 100%;
        border-collapse: collapse;
        table-layout: fixed;
        border-top: 3px solid #000; /* 상단 굵은 검정 구분선 */
    }

    .tbl-cart th {
        height: 60px;
        border-bottom: 1px solid #000; /* 헤더 아래 검정 구분선 */
        font-size: 15px;
        color: #000;
        background: #fff;
        font-weight: 700;
        text-align: center;
    }

    .tbl-cart td {
        padding: 25px 10px;
        text-align: center;
        border-bottom: 1px solid #ddd;
        color: #333;
        vertical-align: middle;
    }
    
    /* 마지막 행 하단에 검정 구분선 추가 (옵션) */
    .tbl-cart tbody tr:last-child td {
        border-bottom: 1px solid #000;
    }

    /* 상품 정보 열 (좌측 정렬) */
    .td-product {
        text-align: left !important;
        padding-left: 20px !important;
    }

    /* 상품 레이아웃 */
    .prd-info {
        display: flex;
        align-items: center;
    }
    .prd-img {
        width: 110px;
        height: 110px;
        background: #f4f4f4;
        margin-right: 25px;
        flex-shrink: 0;
        border: 1px solid #eee;
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
    }
    .prd-img img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    
    .prd-txt .brand {
        display: block;
        font-size: 13px;
        font-weight: 700;
        text-decoration: underline;
        margin-bottom: 6px;
    }
    .prd-txt .name {
        font-size: 16px;
        font-weight: 500;
        color: #000;
        margin-bottom: 8px;
        line-height: 1.4;
    }
    .prd-txt .option {
        font-size: 13px;
        color: #888;
    }

    /* 수량 조절 버튼 (각진 형태) */
    .qty-box {
        display: inline-flex;
        border: 1px solid #ddd;
        height: 34px;
    }
    .qty-btn {
        width: 34px;
        height: 32px;
        background: #fff;
        border: none;
        cursor: pointer;
        font-size: 16px;
        color: #000;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .qty-btn:hover { background: #f0f0f0; }
    .qty-input {
        width: 44px;
        height: 32px;
        border: none;
        border-left: 1px solid #ddd;
        border-right: 1px solid #ddd;
        text-align: center;
        font-size: 14px;
        font-weight: 600;
        color: #000;
        outline: none;
    }

    /* 가격 폰트 */
    .price-txt {
        font-family: 'Montserrat', sans-serif;
        font-weight: 700;
        font-size: 16px;
        color: #000;
    }
    .deli-txt {
        font-size: 14px;
        color: #666;
    }

    /* 버튼 스타일 (각진 블랙) */
    .btn {
        display: inline-block;
        text-align: center;
        border-radius: 0 !important; /* 각지게 */
        cursor: pointer;
        transition: all 0.2s;
        font-size: 13px;
    }
    .btn-black {
        background: #000;
        color: #fff;
        border: 1px solid #000;
        padding: 8px 15px;
        width: 100px;
        margin-bottom: 5px;
    }
    .btn-black:hover { background: #333; border-color: #333; color:#fff; }
    
    .btn-line {
        background: #fff;
        color: #000;
        border: 1px solid #ccc;
        padding: 8px 15px;
        width: 100px;
    }
    .btn-line:hover { border-color: #000; background: #000; color: #fff; }

    /* 체크박스 커스텀 */
    input[type="checkbox"] {
        accent-color: #000;
        width: 20px;
        height: 20px;
        cursor: pointer;
    }

    /* 하단 선택 삭제 바 */
    .btm-action {
        margin-top: 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .btn-sel-del {
        border: 1px solid #ccc;
        background: #fff;
        color: #333;
        padding: 8px 16px;
        font-size: 13px;
        border-radius: 0;
    }
    .btn-sel-del:hover { border-color: #000; color: #000; }
    
    .info-txt { font-size: 13px; color: #999; }


    /* --- 하단 결제 요약 (수직형) --- */
    .summary-area {
        margin-top: 50px;
        border-top: 2px solid #000;    /* 구분선 */
        border-bottom: 2px solid #000; 
    }
    
    .sum-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 15px 30px;
    }
    
    .sum-row.delivery {
        border-bottom: 1px solid #eee; 
    }
    
    .sum-row .lbl {
        font-size: 18px; 
        font-weight: 700;
        color: #000;
    }
    
    .sum-row .val {
        font-family: 'Montserrat', sans-serif;
        font-size: 20px; 
        font-weight: 600;
        color: #000;
    }

    .sum-row.total {
        background-color: #f9f9f9; /* 연한 배경 */
    }

    .sum-row.total .lbl {
        font-size: 18px; 
        font-weight: 700;
        color: #000;
        display: flex;
        align-items: center;
    }
    
    .sum-row.total .count {
        font-size: 15px;
        color: #777;
        font-weight: 400;
        margin-left: 10px;
        font-family: 'Noto Sans KR', sans-serif;
    }

    .sum-row.total .val {
        font-size: 34px; 
        font-weight: 800;
        color: #000;
    }

    /* 하단 대형 버튼 */
    .btn-big-area {
        margin-top: 50px;
        text-align: center;
        display: flex;
        justify-content: center;
        gap: 15px;
    }
    .btn-xl {
        width: 260px;
        height: 60px;
        line-height: 60px;
        font-size: 16px;
        font-weight: 700;
        border-radius: 0;
        padding: 0;
    }
    .btn-keep {
        border: 1px solid #ccc;
        background: #fff;
        color: #000;
    }
    .btn-keep:hover { border-color: #000; }
    
    .btn-order-all {
        background: #000;
        border: 1px solid #000;
        color: #fff;
    }
    .btn-order-all:hover { background: #333; border-color: #333; color:#fff;}

    /* 비었을 때 */
    .empty-cart {
        padding: 120px 0;
        text-align: center;
        color: #aaa;
    }
    .empty-cart i { font-size: 60px; margin-bottom: 20px; display: block; }

</style>
</head>
<body>

<header>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<div class="cart-wrap">
    
    <!-- 타이틀 영역 (가운데 정렬) -->
    <div class="page-head">
        <h2 class="page-title">장바구니</h2>
    </div>

    <form name="cartForm">
        <!-- 테이블 -->
        <table class="tbl-cart">
            <colgroup>
                <col width="60">  <!-- 체크 -->
                <col width="*">   <!-- 상품정보 -->
                <col width="140"> <!-- 수량 -->
                <col width="160"> <!-- 주문금액 -->
                <col width="120"> <!-- 배송비 -->
                <col width="140"> <!-- 선택 -->
            </colgroup>
            <thead>
                <tr>
                    <th><input type="checkbox" id="chkAll" checked></th>
                    <th>상품정보</th>
                    <th>수량</th>
                    <th>주문금액</th>
                    <th>배송비</th>
                    <th>선택</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty list}">
                        <tr>
                            <td colspan="6" class="empty-cart">
                                <i class="bi bi-cart4"></i>
                                <p>장바구니에 담긴 상품이 없습니다.</p>
                                <a href="${pageContext.request.contextPath}/" class="btn btn-black mt-3" style="width:180px;">쇼핑하러 가기</a>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="dto" items="${list}">
                            <!-- data-price, data-deli: 스크립트 계산용 -->
                            <tr class="cart-row" data-price="${dto.prodPrice}" data-deli="0" data-cart-id="${dto.cartId}">
                                <td>
                                    <input type="checkbox" name="cart_ids" value="${dto.cartId}" class="chk-item" checked>
                                </td>
                                <td class="td-product">
                                    <div class="prd-info">
                                        <div class="prd-img">
                                            <!-- 이미지 경로: uploads/파일명 (없으면 대체 이미지) -->
                                            <img src="${pageContext.request.contextPath}/uploads/product/${dto.prodImg}" 
                                                 alt="${dto.prodName}"
                                                 onerror="this.src='https://placehold.co/110x110/f4f4f4/aaa?text=No+Image'">
                                        </div>
                                        <div class="prd-txt">
                                            <!-- 브랜드명 (DB에 없다면 하드코딩하거나 제거) -->
                                            <span class="brand">MAKNAEZ</span>
                                            <div class="name">${dto.prodName}</div>
                                            <!-- 옵션 정보 -->
                                            <div class="option">옵션 : ${dto.sizeValue}</div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="qty-box">
                                        <button type="button" class="qty-btn minus">-</button>
                                        <input type="text" class="qty-input" value="${dto.quantity}" readonly>
                                        <button type="button" class="qty-btn plus">+</button>
                                    </div>
                                </td>
                                <td>
                                    <div class="price-txt">
                                        <fmt:formatNumber value="${dto.prodPrice * dto.quantity}" pattern="#,###"/>원
                                    </div>
                                </td>
                                <td><div class="deli-txt">무료배송</div></td>
                                <td>
                                    <button type="button" class="btn btn-black" onclick="location.href='${pageContext.request.contextPath}/order/payment?cartIds=${dto.cartId}'">주문하기</button>
                                    <button type="button" class="btn btn-line" onclick="deleteItem(${dto.cartId})">삭제</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <!-- 하단 선택 삭제 -->
        <div class="btm-action">
            <button type="button" class="btn btn-sel-del" onclick="deleteSelected()">선택상품 삭제</button>
            <span class="info-txt">장바구니 상품은 최대 30일간 보관됩니다.</span>
        </div>

        <!-- 결제 정보 요약 (수직형 - 슬림) -->
        <div class="summary-area">
            <div class="sum-row delivery">
                <span class="lbl">배송비</span>
                <span class="val"><span id="res-deli">0</span>원</span>
            </div>
            <div class="sum-row total">
                <span class="lbl">결제 예정 금액 <span class="count">[총 <span id="res-count">${count}</span>건]</span></span>
                <span class="val"><span id="res-total"><fmt:formatNumber value="${totalProdPrice}" pattern="#,###"/></span>원</span>
            </div>
        </div>

        <!-- 대형 버튼 영역 -->
        <div class="btn-big-area">
            <a href="${pageContext.request.contextPath}/" class="btn btn-xl btn-keep">쇼핑 계속하기</a>
            <button type="button" class="btn btn-xl btn-order-all" onclick="orderAll()">전체상품 주문</button>
        </div>

    </form>
</div>

<footer>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>
<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>

<!-- jQuery 필수 -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>

<script>
$(function(){
    // 초기 계산 (JSTL로 뿌려진 데이터 기반으로 한번 더 체크)
    updateTotal();

    // 전체 선택
    $("#chkAll").click(function(){
        $(".chk-item").prop("checked", $(this).is(":checked"));
        updateTotal();
    });

    // 개별 선택
    $(document).on("click", ".chk-item", function(){
        let all = $(".chk-item").length;
        let checked = $(".chk-item:checked").length;
        $("#chkAll").prop("checked", all === checked);
        updateTotal();
    });

    // 수량 변경 (Ajax 연동)
    $(".plus, .minus").click(function(){
        let $row = $(this).closest("tr");
        let $inp = $row.find(".qty-input");
        let qty = parseInt($inp.val());
        let cartId = $row.data("cart-id");
        
        if($(this).hasClass("plus")) qty++;
        else if(qty > 1) qty--;
        else return; // 1 미만 방지
        
        // 서버 업데이트
        $.ajax({
            type: "POST",
            url: "${pageContext.request.contextPath}/cart/updateQty",
            data: { cartId: cartId, quantity: qty },
            dataType: "json",
            success: function(data) {
                if(data.status === "success") {
                    // 성공 시 UI 업데이트
                    $inp.val(qty);
                    let unitPrice = parseInt($row.data("price"));
                    $row.find(".price-txt").text((unitPrice * qty).toLocaleString() + "원");
                    updateTotal();
                } else {
                    alert("수량 변경 실패");
                }
            },
            error: function() {
                alert("서버 통신 오류");
            }
        });
    });
});

function updateTotal() {
    let sumProd = 0;
    let sumDeli = 0;
    let count = 0;

    $(".chk-item:checked").each(function(){
        let $row = $(this).closest("tr");
        let qty = parseInt($row.find(".qty-input").val());
        let price = parseInt($row.data("price"));
        let deli = parseInt($row.data("deli"));

        sumProd += price * qty;
        sumDeli += deli; 
        count++;
    });

    $("#res-deli").text(sumDeli.toLocaleString());
    $("#res-total").text((sumProd + sumDeli).toLocaleString());
    $("#res-count").text(count);
}

// 개별 삭제
function deleteItem(cartId) {
    if(!confirm("삭제하시겠습니까?")) return;
    
    $.ajax({
        type: "POST",
        url: "${pageContext.request.contextPath}/cart/delete",
        data: { cartId: cartId },
        dataType: "json",
        success: function(data) {
            if(data.status === "success") {
                location.reload(); // 새로고침하여 목록 갱신
            } else {
                alert("삭제 실패");
            }
        },
        error: function() {
            alert("서버 오류");
        }
    });
}

// 선택 삭제
function deleteSelected() {
    let $checked = $(".chk-item:checked");
    if($checked.length == 0) return alert("선택된 상품이 없습니다.");
    
    if(!confirm("선택한 상품을 삭제하시겠습니까?")) return;

    let ids = [];
    $checked.each(function() {
        ids.push($(this).val());
    });

    $.ajax({
        type: "POST",
        url: "${pageContext.request.contextPath}/cart/delete",
        traditional: true, // 배열 전송 시 필요
        data: { cartIds: ids },
        dataType: "json",
        success: function(data) {
            if(data.status === "success") {
                location.reload();
            } else {
                alert("삭제 실패");
            }
        },
        error: function() {
            alert("서버 오류");
        }
    });
}

// 전체 주문 (선택된 것만)
function orderAll() {
    if($(".chk-item:checked").length == 0) return alert("주문할 상품을 선택해주세요.");
    
    // 폼 전송 방식 예시 (실제 구현 시 OrderController로 전송)
    // 여기서는 단순히 선택된 ID들을 쿼리스트링으로 넘기는 방식 예시
    let ids = [];
    $(".chk-item:checked").each(function() {
        ids.push("cartIds=" + $(this).val());
    });
    
    location.href = "${pageContext.request.contextPath}/order/payment?" + ids.join("&");
}
</script>

</body>
</html>