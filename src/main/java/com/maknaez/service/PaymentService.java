package com.maknaez.service;

import com.maknaez.model.OrderDTO;
import com.maknaez.model.OrderItemDTO;
import com.maknaez.model.ProductDTO;

public interface PaymentService {
    
    public ProductDTO getProduct(long prodId) throws Exception; // 상품 정보 조회
    public long getOrderSeq() throws Exception; // 주문 번호 시퀀스 조회
    public void processPayment(OrderDTO order, OrderItemDTO item) throws Exception; // 결제 처리 (주문 생성 + 상세 저장 + 결제 내역 + 재고 감소)
}