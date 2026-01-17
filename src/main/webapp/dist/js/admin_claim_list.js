
document.addEventListener("DOMContentLoaded", function() {
    const checkAll = document.getElementById('checkAll');
    if (checkAll) {
        checkAll.addEventListener('change', function() {
            document.querySelectorAll('tbody input[type="checkbox"]').forEach(box => {
                box.checked = checkAll.checked;
            });
        });
    }
});

// 2. 선택 일괄 승인
function approveClaim() {
    const selected = document.querySelectorAll('tbody input[type="checkbox"]:checked');
    if (selected.length === 0) return alert("처리할 항목을 선택해주세요.");
    
    if (confirm(`${selected.length}건의 요청을 일괄 승인하시겠습니까?\n(주의: 일괄 승인 시 개별 검수 확인이 생략됩니다.)`)) {
        alert("일괄 처리가 완료되었습니다.");
      
    }
}

// 3. 엑셀 다운로드 
function excelDownload() {
    alert("Excel 다운로드를 시작합니다.");
    // location.href = '/admin/order/excel/download'; // 실제 링크 연결 시 사용
}

function openApproveModal(orderNum, type, productName, qty, link) {
    console.log("모달 열기 클릭됨:", orderNum, type);

    // 1. 기본 데이터 바인딩 (텍스트 채우기)
    document.getElementById('m_orderNum').innerText = orderNum;
    document.getElementById('m_type').innerText = type;
    document.getElementById('m_product').innerText = productName;
    document.getElementById('m_qty').innerText = qty;

    // 2. [승인하기] 버튼에 실제 이동할 링크 연결
    const btn = document.getElementById('realApproveBtn');
    btn.onclick = function() {
        location.href = link;
    };

    const infoBox = document.querySelector('.modal-info p');
    const typeSpan = document.getElementById('m_type');  

    if (type === '반품') {
        // [CASE 1] 반품일 때 -> 회수 확인 경고창 띄우기
        typeSpan.style.color = '#dc3545'; 
        
        infoBox.innerHTML = `
            <div style="background:#fff5f5; padding:12px; border:1px solid #ffcccc; margin-bottom:10px; border-radius:4px; text-align:left;">
                <strong style="color:#d9534f; display:block; margin-bottom:5px;">⚠️ 반품 승인 전 필수 확인</strong>
                <span style="font-size:13px; color:#555; line-height:1.5; display:block;">
                1. 고객 상품이 <b>물류센터에 회수(입고)</b>되었나요?<br>
                2. 상품 <b>검수(파손/오염 확인)</b>가 끝났나요?
                </span>
            </div>
            <span style="font-size:12px; color:#888;">승인 시 환불 처리 및 재고가 <b>${qty}개</b> 복구됩니다.</span>
        `;
        
        btn.innerText = "반품 입고 확인 및 승인"; 
        
    } else {
        typeSpan.style.color = '#0d6efd';
        
        infoBox.innerHTML = `
            <div style="padding:5px 0 10px 0;">
                <span style="color:#333; font-weight:700; font-size:14px;">
                    요청하신 주문 건을 취소하시겠습니까?
                </span>
            </div>
            <span style="font-size:12px; color:#888; line-height:1.4; display:block;">
                승인 즉시 PG사 <b>결제 취소</b>가 진행되며,<br>
                상품 재고가 <b>${qty}개</b> 자동 복구됩니다.
            </span>
        `;
        
        btn.innerText = "취소 승인하기";
    }

    // 4. 모달창 보여주기
    document.getElementById('approveModal').style.display = 'flex';
}

// 5. 모달창 닫기
function closeModal() {
    document.getElementById('approveModal').style.display = 'none';
}