document.addEventListener('DOMContentLoaded', function() {
    updateTotal();

    // 1. 전체 선택 체크박스
    const checkAll = document.getElementById('check-all');
    checkAll.addEventListener('change', function() {
        const checkboxes = document.querySelectorAll('.check-item');
        checkboxes.forEach(cb => cb.checked = checkAll.checked);
        updateTotal();
    });

    // 2. 개별 체크박스 변경 시
    const checkboxes = document.querySelectorAll('.check-item');
    checkboxes.forEach(cb => {
        cb.addEventListener('change', updateTotal);
    });

    // 3. 수량 변경 (+/-)
    document.querySelectorAll('.btn-plus').forEach(btn => {
        btn.addEventListener('click', function() {
            changeQuantity(this, 1);
        });
    });

    document.querySelectorAll('.btn-minus').forEach(btn => {
        btn.addEventListener('click', function() {
            changeQuantity(this, -1);
        });
    });

    // 4. 상품 삭제 (개별)
    document.querySelectorAll('.btn-delete').forEach(btn => {
        btn.addEventListener('click', function() {
            if(!confirm('정말 삭제하시겠습니까?')) return;
            const row = this.closest('tr');
            row.remove();
            updateTotal();
            // TODO: Ajax로 DB 삭제 요청
        });
    });

    // 5. 선택 상품 삭제
    document.querySelector('#btn-delete-selected').addEventListener('click', function() {
        const checkedItems = document.querySelectorAll('.check-item:checked');
        if (checkedItems.length === 0) {
            alert('삭제할 상품을 선택해주세요.');
            return;
        }

        if(!confirm('선택한 상품을 삭제하시겠습니까?')) return;

        checkedItems.forEach(cb => {
            cb.closest('tr').remove();
        });
        updateTotal();
        // TODO: Ajax로 DB 일괄 삭제 요청
    });
    
    // 6. 구매하기 버튼
    document.querySelector('#btn-order').addEventListener('click', function() {
        const checkedItems = document.querySelectorAll('.check-item:checked');
        if (checkedItems.length === 0) {
            alert('구매할 상품을 선택해주세요.');
            return;
        }
        alert('주문서 작성 페이지로 이동합니다.');
        // location.href = '/order/sheet'; // 실제 이동 경로
    });
});

// 수량 변경 함수
function changeQuantity(btn, change) {
    const row = btn.closest('tr');
    const input = row.querySelector('.quantity-input');
    let qty = parseInt(input.value);
    
    qty += change;
    if (qty < 1) return; // 최소 1개

    input.value = qty;

    // 상품 금액 업데이트 (단가 * 수량)
    const unitPrice = parseInt(row.dataset.price);
    const totalPriceSpan = row.querySelector('.item-total-price');
    const newPrice = unitPrice * qty;
    
    totalPriceSpan.textContent = newPrice.toLocaleString();
    
    updateTotal();
    
    // TODO: Ajax로 DB 수량 업데이트 요청
}

// 총 금액 계산 함수
function updateTotal() {
    let totalProduct = 0;
    let totalDelivery = 0;

    const rows = document.querySelectorAll('.cart-item');
    rows.forEach(row => {
        const checkbox = row.querySelector('.check-item');
        if (checkbox.checked) {
            const qty = parseInt(row.querySelector('.quantity-input').value);
            const price = parseInt(row.dataset.price);
            const delivery = parseInt(row.dataset.delivery);

            totalProduct += (price * qty);
            
            // 배송비 로직 (상품별 배송비인 경우)
            // 묶음 배송인 경우 로직 수정 필요
            totalDelivery += delivery; 
        }
    });

    const finalTotal = totalProduct + totalDelivery;

    document.getElementById('total-product-price').textContent = totalProduct.toLocaleString();
    document.getElementById('total-delivery-price').textContent = totalDelivery.toLocaleString();
    document.getElementById('final-total-price').textContent = finalTotal.toLocaleString();
}