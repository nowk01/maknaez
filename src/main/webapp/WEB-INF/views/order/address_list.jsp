<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>배송지 변경</title>
<!-- Bootstrap 5 CDN -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    body { background: #fff; padding: 20px; font-family: 'Noto Sans KR', sans-serif; }
    
    /* 헤더 스타일 */
    .header { 
        border-bottom: 2px solid #000; 
        padding-bottom: 15px; 
        margin-bottom: 20px; 
        display: flex; 
        justify-content: space-between; /* 양 끝 정렬 */
        align-items: center; 
    }
    .header h2 { font-size: 20px; font-weight: 700; margin: 0; }

    /* [추가] 배송지 추가/관리 버튼 스타일 */
    .btn-add {
        font-size: 13px;
        padding: 6px 12px;
        border: 1px solid #ddd;
        background: #fff;
        color: #333;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.2s;
    }
    .btn-add:hover { border-color: #000; background: #f9f9f9; color: #000; }
    
    /* 리스트 아이템 스타일 */
    .addr-item {
        display: block;
        position: relative;
        border: 1px solid #ddd;
        padding: 20px 20px 20px 50px; /* 라디오 버튼 공간 확보 */
        margin-bottom: 10px;
        cursor: pointer;
    }
    .addr-item:hover { border-color: #888; }
    .addr-item.selected { border: 2px solid #000; padding: 19px 19px 19px 49px; /* 보더 두께만큼 보정 */ }

    /* 라디오 버튼 커스텀 */
    .addr-radio {
        position: absolute;
        left: 20px;
        top: 24px;
        width: 18px;
        height: 18px;
        accent-color: #000;
        cursor: pointer;
    }

    /* 배송지 정보 텍스트 */
    .info-row { margin-bottom: 6px; }
    .name { font-weight: 700; font-size: 16px; margin-right: 8px; }
    .badge-basic {
        background: #f4f4f4; border: 1px solid #ddd; font-size: 11px;
        color: #666; padding: 2px 6px; vertical-align: middle; margin-left: 5px;
    }
    .badge-basic.active { background: #e5f4ff; border-color: #cceeff; color: #0077d9; }
    
    .phone { font-size: 14px; color: #555; }
    .addr-text { font-size: 14px; color: #333; margin-top: 8px; line-height: 1.5; }

    /* 하단 버튼 */
    .btn-wrap {
        margin-top: 30px;
        display: flex;
        gap: 10px;
    }
    .btn-black {
        flex: 1;
        background: #000;
        color: #fff;
        border: none;
        height: 50px;
        font-weight: 700;
        font-size: 16px;
    }
    .btn-black:hover { background: #333; }
    
    .empty-msg { text-align: center; padding: 60px 0; color: #999; }
</style>
</head>
<body>

<div class="header">
    <h2>배송지 목록</h2>
    <!-- [수정] 클릭 시 goAddrManage 호출 -->
    <button type="button" class="btn-add" onclick="goAddrManage()">배송지 관리</button>
</div>

<form name="addrForm">
    <div class="addr-list">
        <c:forEach var="dto" items="${list}">
            <label class="addr-item" onclick="selectItem(this)">
                <input type="radio" name="addrId" class="addr-radio"
                       value="${dto.addrId}"
                       data-name="${dto.receiverName}"
                       data-tel="${dto.receiverTel}"
                       data-zip="${dto.zipCode}"
                       data-addr1="${dto.addr1}"
                       data-addr2="${dto.addr2}">
                
                <div class="info-row">
                    <span class="name">${dto.receiverName}</span>
                    <c:if test="${not empty dto.addrName}">
                        <span style="font-size:13px; color:#888;">(${dto.addrName})</span>
                    </c:if>
                    <!-- 기본배송지 뱃지 -->
                    <c:if test="${dto.isBasic == 1}">
                        <span class="badge-basic active">기본배송지</span>
                    </c:if>
                </div>
                
                <div class="info-row phone phone-format" data-original="${dto.receiverTel}">${dto.receiverTel}</div>
                
                <div class="addr-text">
                    [${dto.zipCode}] ${dto.addr1} ${dto.addr2}
                </div>
            </label>
        </c:forEach>

        <c:if test="${empty list}">
            <div class="empty-msg">등록된 배송지가 없습니다.</div>
        </c:if>
    </div>

    <div class="btn-wrap">
        <button type="button" class="btn-black" onclick="applyAddress()">배송지 변경</button>
    </div>
</form>

<script>
function goAddrManage() {
    location.href = "${pageContext.request.contextPath}/member/mypage/addr?popup=true"; 
}

document.addEventListener("DOMContentLoaded", function() {
    const phones = document.querySelectorAll('.phone-format');
    phones.forEach(function(el) {
        el.innerText = formatTelList(el.getAttribute('data-original'));
    });
});

function formatTelList(tel) {
    if(!tel) return "";
    let str = tel.replace(/[^0-9]/g, '');
    let result = "";
    
    if(str.length < 4) {
        return str;
    } else if(str.length < 7) {
        result = str.substr(0, 3) + "-" + str.substr(3);
    } else if(str.length < 11) {
        if(str.startsWith('02')) {
            result = str.substr(0, 2) + "-" + str.substr(2, 3) + "-" + str.substr(5);
        } else {
            result = str.substr(0, 3) + "-" + str.substr(3, 3) + "-" + str.substr(6);
        }
    } else {
        result = str.substr(0, 3) + "-" + str.substr(3, 4) + "-" + str.substr(7);
    }
    return result;
}

// 클릭 시 스타일 변경
function selectItem(element) {
    document.querySelectorAll('.addr-item').forEach(el => el.classList.remove('selected'));
    element.classList.add('selected');
    const radio = element.querySelector('input[type="radio"]');
    if(radio) radio.checked = true;
}

// [배송지 변경] 버튼 클릭 시
function applyAddress() {
    const checked = document.querySelector('input[name="addrId"]:checked');
    if(!checked) {
        alert("배송지를 선택해주세요.");
        return;
    }

    if(opener && !opener.closed) {
        opener.setShippingAddress({
            id: checked.value,
            name: checked.dataset.name,
            tel: checked.dataset.tel,
            zip: checked.dataset.zip,
            addr1: checked.dataset.addr1,
            addr2: checked.dataset.addr2
        });
        window.close();
    } else {
        alert("결제 페이지가 닫혀있어 적용할 수 없습니다.");
    }
}
</script>

</body>
</html>