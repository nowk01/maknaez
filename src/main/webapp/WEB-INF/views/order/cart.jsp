<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>장바구니 - Maknaez</title>
    
    <!-- Header Resources (CSS, Fonts) -->
    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
    
    <!-- 장바구니 전용 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/cart.css">
</head>
<body>

    <!-- Header -->
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <div class="container my-5">
        <h2 class="text-center mb-5 fw-bold">SHOPPING CART</h2>

        <!-- 장바구니 단계 표시 (선택사항) -->
        <div class="row mb-4">
            <div class="col-12 text-end text-muted small">
                <span class="fw-bold text-dark">01 장바구니</span> &gt; 02 주문서작성 &gt; 03 결제완료
            </div>
        </div>

        <!-- 장바구니 테이블 -->
        <div class="cart-table-container">
            <table class="table align-middle text-center cart-table">
                <thead class="table-light">
                    <tr>
                        <th scope="col" style="width: 5%;"><input type="checkbox" id="check-all" checked></th>
                        <th scope="col" style="width: 10%;">이미지</th>
                        <th scope="col" style="width: 35%;">상품정보</th>
                        <th scope="col" style="width: 15%;">수량</th>
                        <th scope="col" style="width: 15%;">상품금액</th>
                        <th scope="col" style="width: 10%;">배송비</th>
                        <th scope="col" style="width: 10%;">선택</th>
                    </tr>
                </thead>
                <tbody id="cart-list-body">
                    <!-- [퍼블리싱용 가짜 데이터 1] -->
                    <tr class="cart-item" data-price="25000" data-delivery="3000">
                        <td><input type="checkbox" class="check-item" name="cartIdx" value="1" checked></td>
                        <td>
                            <a href="#">
                                <img src="https://via.placeholder.com/80" alt="상품이미지" class="img-fluid rounded">
                            </a>
                        </td>
                        <td class="text-start">
                            <a href="#" class="text-decoration-none text-dark fw-bold">프리미엄 무선 이어폰</a>
                            <div class="text-muted small mt-1">옵션: 화이트 / 1개</div>
                        </td>
                        <td>
                            <div class="input-group input-group-sm justify-content-center" style="width: 100px; margin: 0 auto;">
                                <button class="btn btn-outline-secondary btn-minus" type="button">-</button>
                                <input type="text" class="form-control text-center quantity-input" value="1" readonly>
                                <button class="btn btn-outline-secondary btn-plus" type="button">+</button>
                            </div>
                        </td>
                        <td class="fw-bold"><span class="item-total-price">25,000</span>원</td>
                        <td class="text-muted small">3,000원<br>(선불)</td>
                        <td>
                            <button type="button" class="btn btn-sm btn-outline-danger btn-delete">
                                <i class="bi bi-x-lg"></i> 삭제
                            </button>
                        </td>
                    </tr>
                    
                    <!-- [퍼블리싱용 가짜 데이터 2] -->
                    <tr class="cart-item" data-price="12000" data-delivery="0">
                        <td><input type="checkbox" class="check-item" name="cartIdx" value="2" checked></td>
                        <td>
                            <a href="#">
                                <img src="https://via.placeholder.com/80" alt="상품이미지" class="img-fluid rounded">
                            </a>
                        </td>
                        <td class="text-start">
                            <a href="#" class="text-decoration-none text-dark fw-bold">아이폰 15 케이스</a>
                            <div class="text-muted small mt-1">옵션: 투명 / 1개</div>
                        </td>
                        <td>
                            <div class="input-group input-group-sm justify-content-center" style="width: 100px; margin: 0 auto;">
                                <button class="btn btn-outline-secondary btn-minus" type="button">-</button>
                                <input type="text" class="form-control text-center quantity-input" value="2" readonly>
                                <button class="btn btn-outline-secondary btn-plus" type="button">+</button>
                            </div>
                        </td>
                        <td class="fw-bold"><span class="item-total-price">24,000</span>원</td>
                        <td class="text-muted small">무료배송</td>
                        <td>
                            <button type="button" class="btn btn-sm btn-outline-danger btn-delete">
                                <i class="bi bi-x-lg"></i> 삭제
                            </button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="d-flex justify-content-start mb-5">
            <button type="button" class="btn btn-outline-secondary btn-sm" id="btn-delete-selected">선택상품 삭제</button>
        </div>

        <!-- 결제 금액 요약 영역 -->
        <div class="card bg-light border-0 mb-5">
            <div class="card-body py-4">
                <div class="row text-center align-items-center">
                    <div class="col-md-3">
                        <div class="text-muted mb-2">총 상품금액</div>
                        <h4 class="fw-bold mb-0"><span id="total-product-price">49,000</span>원</h4>
                    </div>
                    <div class="col-md-1">
                        <i class="bi bi-plus-circle fs-4 text-muted"></i>
                    </div>
                    <div class="col-md-3">
                        <div class="text-muted mb-2">총 배송비</div>
                        <h4 class="fw-bold mb-0"><span id="total-delivery-price">3,000</span>원</h4>
                    </div>
                    <div class="col-md-1">
                        <i class="bi bi-pause-circle fs-4 text-muted" style="transform: rotate(90deg);"></i>
                    </div>
                    <div class="col-md-4">
                        <div class="text-primary fw-bold mb-2">결제 예정 금액</div>
                        <h3 class="fw-bold text-primary mb-0"><span id="final-total-price">52,000</span>원</h3>
                    </div>
                </div>
            </div>
        </div>

        <!-- 하단 버튼 -->
        <div class="row justify-content-center gap-2">
            <div class="col-md-3 d-grid">
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline-dark btn-lg">계속 쇼핑하기</a>
            </div>
            <div class="col-md-3 d-grid">
                <button type="button" class="btn btn-primary btn-lg" id="btn-order">구매하기</button>
            </div>
        </div>

    </div>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
    
    <!-- Footer Resources (JS) -->
    <jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />
    
    <!-- 장바구니 로직 JS -->
    <script src="${pageContext.request.contextPath}/dist/js/cart.js"></script>
</body>
</html>