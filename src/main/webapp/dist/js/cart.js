document.addEventListener("DOMContentLoaded", () => {
    
    // 천단위 콤마 함수
    const formatNumber = (num) => {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    };

    // 콤마 제거 후 숫자로 변환
    const parseNumber = (str) => {
        return parseInt(str.replace(/,/g, ''), 10) || 0;
    };

    // 전체 합계 계산 함수
    const updateCartTotal = () => {
        let totalProductPrice = 0;
        let totalDeliveryPrice = 0;

        const rows = document.querySelectorAll('.cart-item');
        
        rows.forEach(row => {
            const checkbox = row.querySelector('.check-item');
            if (checkbox.checked) {
                // 데이터 속성에서 단가, 배송비 가져오기
                const unitPrice = parseInt(row.dataset.price); 
                const deliveryPrice = parseInt(row.dataset.delivery);
                const quantity = parseInt(row.querySelector('.quantity-input').value);

                // 현재 행의 합계 업데이트 (화면 표시용)
                const rowTotal = unitPrice * quantity;
                row.querySelector('.item-total-price').textContent = formatNumber(rowTotal);

                // 전체 합계 누적
                totalProductPrice += rowTotal;
                totalDeliveryPrice += deliveryPrice; // 배송비 정책에 따라 로직 수정 가능 (ex: 5만원 이상 무료)
            }
        });

        // 최종 금액 표시
        document.getElementById('total-product-price').textContent = formatNumber(totalProductPrice);
        document.getElementById('total-delivery-price').textContent = formatNumber(totalDeliveryPrice);
        document.getElementById('final-total-price').textContent = formatNumber(totalProductPrice + totalDeliveryPrice);
    };

    // 1. 수량 변경 (+, -) 버튼 이벤트
    document.querySelectorAll('.btn-plus, .btn-minus').forEach(btn => {
        btn.addEventListener('click', (e) => {
            const row = e.target.closest('.cart-item');
            const input = row.querySelector('.quantity-input');
            let currentVal = parseInt(input.value);

            if (e.target.classList.contains('btn-plus')) {
                input.value = currentVal + 1;
            } else {
                if (currentVal > 1) {
                    input.value = currentVal - 1;
                } else {
                    alert("최소 수량은 1개입니다.");
                    return;
                }
            }
            
            // 수량 변경 시 합계 재계산
            updateCartTotal();
        });
    });

    // 2. 전체 선택 체크박스
    const checkAll = document.getElementById('check-all');
    checkAll.addEventListener('change', (e) => {
        const isChecked = e.target.checked;
        document.querySelectorAll('.check-item').forEach(box => {
            box.checked = isChecked;
        });
        updateCartTotal();
    });

    // 3. 개별 체크박스 변경 시
    document.querySelectorAll('.check-item').forEach(box => {
        box.addEventListener('change', () => {
            updateCartTotal();
            
            // 개별 체크박스가 하나라도 해제되면 전체 선택 해제
            const total = document.querySelectorAll('.check-item').length;
            const checked = document.querySelectorAll('.check-item:checked').length;
            checkAll.checked = (total === checked);
        });
    });

    // 4. 개별 삭제 버튼 (프론트엔드 처리만)
    document.querySelectorAll('.btn-delete').forEach(btn => {
        btn.addEventListener('click', (e) => {
            if (confirm("해당 상품을 장바구니에서 삭제하시겠습니까?")) {
                e.target.closest('.cart-item').remove();
                updateCartTotal();
                
                // TODO: 여기에 Ajax를 사용하여 서버 DB에서도 삭제하는 로직 추가 필요
            }
        });
    });

    // 5. 선택 삭제 버튼
    document.getElementById('btn-delete-selected').addEventListener('click', () => {
        const checkedItems = document.querySelectorAll('.check-item:checked');
        if (checkedItems.length === 0) {
            alert("삭제할 상품을 선택해주세요.");
            return;
        }

        if (confirm("선택한 상품을 삭제하시겠습니까?")) {
            checkedItems.forEach(item => {
                item.closest('.cart-item').remove();
            });
            updateCartTotal();
            // TODO: Ajax로 일괄 삭제 요청
        }
    });

    // 6. 구매하기 버튼
    document.getElementById('btn-order').addEventListener('click', () => {
        const checkedItems = document.querySelectorAll('.check-item:checked');
        if (checkedItems.length === 0) {
            alert("구매할 상품을 선택해주세요.");
            return;
        }
        
        alert("주문 페이지로 이동합니다.");
        // location.href = "/order/sheet"; // 주문서 작성 페이지로 이동
    });

    // 초기 로딩 시 합계 계산 실행
    updateCartTotal();
});