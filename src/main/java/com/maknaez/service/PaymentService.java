package com.maknaez.service;

import java.util.List;
import java.util.Map;

import com.maknaez.model.OrderDTO;
import com.maknaez.model.OrderItemDTO;
import com.maknaez.model.ProductDTO;

public interface PaymentService {
    
    // 기존 메서드 (사용하지 않게 되면 삭제해도 무방하지만, 호환성을 위해 유지하거나 deprecated 처리)
    public ProductDTO getProduct(long prodId) throws Exception; 
    public long getOrderSeq() throws Exception;
    public void processPayment(OrderDTO order, List<OrderItemDTO> items) throws Exception; 
    public List<Map<String, Object>> getOrderListByCart(String[] cartIds) throws Exception; // 장바구니 ID 목록으로 주문할 상품 리스트 조회
    public Map<String, Object> getProductDetailForOrder(long prodId, int quantity, long optId) throws Exception; // 단일 상품 바로 구매를 위한 상품 정보 조회 (옵션 포함)
}