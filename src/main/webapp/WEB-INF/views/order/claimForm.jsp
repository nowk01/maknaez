<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>신청 | MAKNAEZ</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage.css">

<style>
    body { background-color: #f9f9f9; } 
    
    .claim-container {
        display: flex;
        justify-content: center;
        align-items: flex-start; 
        padding: 80px 20px;
        min-height: 80vh;
        padding-left: 60px;
    }

    .claim-wrapper { 
        width: 100%; 
        max-width: 650px;
        background: #fff;
        padding: 50px;
        border: 1px solid #eee;
        color: #1a1c1e; 
        font-family: 'Pretendard', sans-serif; 
        box-sizing: border-box;
    }
    /* 상품 카드 (심플 & 모던) */
    .product-card { display: flex; align-items: center; padding: 15px; background: #fcfcfc; border: 1px solid #eee; margin-bottom: 30px; border-radius: 2px; }
    .product-card img { width: 64px; height: 64px; object-fit: cover; border: 1px solid #eee; background: #fff; flex-shrink: 0; }
    .product-info { margin-left: 15px; flex: 1; overflow: hidden; }
    .product-info .order-num { font-size: 11px; color: #999; margin-bottom: 3px; font-family: 'Inter'; font-weight: 500; }
    .product-info .product-name { font-size: 14px; font-weight: 700; color: #333; margin-bottom: 3px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .product-info .product-opt { font-size: 12px; color: #666; }

    /* 폼 요소 공통 */
    .form-section { margin-bottom: 25px; }
    .form-label { display: block; font-size: 13px; font-weight: 700; color: #111; margin-bottom: 8px; }
    .form-control, .form-select { width: 100%; height: 46px; border: 1px solid #ddd; padding: 0 12px; font-size: 13px; border-radius: 0; transition: all 0.2s; box-sizing: border-box; }
    .form-control:focus, .form-select:focus { border-color: #ff4e00; outline: none; background-color: #fff; }
    .form-control[readonly] { background-color: #f8f9fa; color: #555; border-color: #eee; cursor: default; font-weight: 500; }
    
    /* 반품 방법 라디오 버튼 (칼각 정렬) */
    .radio-box { display: flex; gap: 8px; width: 100%; }
    .radio-item { flex: 1; position: relative; } /* 1:1 비율 */
    .radio-item input[type="radio"] { position: absolute; opacity: 0; width: 0; }
    .radio-item label { 
        display: flex; align-items: center; justify-content: center;
        width: 100%; height: 46px; border: 1px solid #ddd; 
        font-size: 13px; font-weight: 600; cursor: pointer; color: #666; transition: 0.2s; background: #fff; margin: 0;
    }
    .radio-item input[type="radio"]:checked + label {
        border-color: #1a1c1e; background: #1a1c1e; color: #fff;
    }

    /* 안내 박스 */
    .info-box { background: #f7f7f7; padding: 15px; font-size: 12px; color: #666; line-height: 1.5; margin-top: 10px; border-radius: 2px; border: 1px dashed #ddd; }
    .info-box strong { color: #222; display: block; margin-bottom: 4px; font-weight: 700; }

    /* 텍스트 박스 */
    .form-textarea { height: 120px !important; padding: 12px; line-height: 1.5; resize: none; }

    /* [중요] 버튼 그룹: Grid 사용으로 5:5 완벽 분할 */
    .btn-group-custom { 
        display: grid; 
        grid-template-columns: 1fr 1fr; /* 정확히 반반 */
        gap: 10px; 
        margin-top: 40px; 
    }
    .btn-action { 
        width: 100%; 
        height: 52px; 
        font-size: 14px; 
        font-weight: 700; 
        cursor: pointer; 
        transition: 0.2s; 
        border-radius: 0; /* 각지게 */
        display: flex; 
        align-items: center; 
        justify-content: center;
    }
    
    /* 취소/돌아가기 버튼 (흰색) */
    .btn-back { background: #fff; color: #1a1c1e; border: 1px solid #ccc; }
    .btn-back:hover { border-color: #1a1c1e; background: #f9f9f9; }

    /* 신청하기 버튼 (검정색) */
    .btn-submit { background: #1a1c1e; color: #fff; border: 1px solid #1a1c1e; }
    .btn-submit:hover { background: #333; border-color: #333; }
    
    .required-star { color: #ff4e00; margin-left: 2px; vertical-align: top; }
</style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <div class="claim-container">
        <div class="claim-wrapper">

            <div class="product-card">
                <img src="${pageContext.request.contextPath}/uploads/product/${dto.thumbNail}" 
                     onerror="this.src='${pageContext.request.contextPath}/dist/images/no-image.png'">
                <div class="product-info">
                    <p class="order-num">No. ${dto.orderNum}</p>
                    <p class="product-name">${dto.productName}</p>
                    <p class="product-opt">옵션: ${dto.pdSize} / 수량: ${dto.qty}개</p>
                </div>
            </div>

            <form id="claimForm" action="${pageContext.request.contextPath}/order/claimRequest" method="post">
                <input type="hidden" name="orderNum" value="${dto.orderNum}">
                <input type="hidden" name="productNum" value="${dto.productNum}">
                <input type="hidden" name="pdSize" value="${dto.pdSize}">
                <input type="hidden" name="qty" value="${dto.qty}">
                <input type="hidden" name="type" value="${param.type}"> 
                
                <div class="form-section">
                    <label class="form-label">신청 유형</label>
                    <input type="text" class="form-control" readonly 
                           value="<c:if test="${param.type == 'CANCEL'}">결제 취소</c:if><c:if test="${param.type == 'RETURN'}">반품 (환불 요청)</c:if>">
                </div>

                <c:if test="${param.type == 'RETURN'}">
                    <div class="form-section">
                        <label class="form-label">회수 방법 <span class="required-star">●</span></label>
                        <div class="radio-box">
                            <div class="radio-item">
                                <input type="radio" id="return_agency" name="returnMethod" value="AGENCY" checked>
                                <label for="return_agency">지정 택배사 회수</label>
                            </div>
                            <div class="radio-item">
                                <input type="radio" id="return_self" name="returnMethod" value="SELF">
                                <label for="return_self">직접 발송</label>
                            </div>
                        </div>
                        
                        <div id="agencyInfo" class="info-box">
                            <strong>[자동 수거 안내]</strong>
                            1~3일 내 기사님이 방문하여 수거합니다.<br>
                            회수지: <b>${dto.addr1} ${dto.addr2}</b>
                        </div>

                        <div id="selfInfo" class="info-box" style="display: none;">
                            <strong>[직접 발송 안내]</strong>
                            선불 택배를 이용하여 아래 주소로 보내주세요.<br>
                            주소: 서울특별시 강남구 테헤란로 123, 물류센터
                        </div>
                    </div>
                </c:if>

                <div class="form-section">
                    <label class="form-label">신청 사유 <span class="required-star">●</span></label>
                    <select name="reasonCategory" class="form-select" id="reasonCategory" required>
                        <option value="">사유를 선택해 주세요</option>
                        <option value="단순 변심">단순 변심 (마음이 바뀌었어요)</option>
                        <option value="사이즈/색상 불만">사이즈/색상이 생각과 달라요</option>
                        <option value="상품 불량">상품이 파손되어 왔어요</option>
                        <option value="배송 지연">배송이 너무 늦어요</option>
                        <option value="오배송">다른 상품이 왔어요</option>
                        <option value="기타">기타 사유 (직접 입력)</option>
                    </select>
                </div>

                <div class="form-section" style="margin-bottom: 0;">
                    <label class="form-label">상세 내용</label>
                    <textarea name="reasonDetail" class="form-control form-textarea" id="reasonDetail"
                        placeholder="상세 사유를 입력해 주세요."></textarea>
                    <p style="font-size: 11px; color: #999; margin-top: 8px;">
                        * 사진 확인이 필요한 경우 1:1 문의를 이용해 주세요.
                    </p>
                </div>

                <div class="btn-group-custom">
                    <button type="button" class="btn-action btn-back" onclick="history.back()">뒤로가기</button>
                    <button type="submit" class="btn-action btn-submit">
                        <c:if test="${param.type == 'CANCEL'}">취소 신청하기</c:if>
                        <c:if test="${param.type == 'RETURN'}">반품 신청하기</c:if>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
    <jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // 반품 방법 토글 로직
            const radios = document.getElementsByName("returnMethod");
            const agencyInfo = document.getElementById("agencyInfo");
            const selfInfo = document.getElementById("selfInfo");

            if(radios.length > 0) { 
                radios.forEach(radio => {
                    radio.addEventListener("change", function() {
                        if (this.value === "AGENCY") {
                            agencyInfo.style.display = "block";
                            selfInfo.style.display = "none";
                        } else {
                            agencyInfo.style.display = "none";
                            selfInfo.style.display = "block";
                        }
                    });
                });
            }

            // 폼 검증
            const claimForm = document.getElementById("claimForm");
            claimForm.addEventListener("submit", function(e) {
                const category = document.getElementById("reasonCategory").value;
                const detail = document.getElementById("reasonDetail").value.trim();
                const type = "${param.type}";

                if (!category) {
                    alert("신청 사유를 선택해 주세요.");
                    e.preventDefault();
                    return;
                }

                if (category === "기타" && detail.length < 2) {
                    alert("기타 사유 선택 시 상세 내용을 입력해 주세요.");
                    e.preventDefault();
                    return;
                }

                let confirmMsg = (type === 'CANCEL') 
                    ? "주문을 취소하시겠습니까?" 
                    : "반품을 신청하시겠습니까?";

                if (!confirm(confirmMsg)) {
                    e.preventDefault();
                }
            });
        });
    </script>

</body>
</html>