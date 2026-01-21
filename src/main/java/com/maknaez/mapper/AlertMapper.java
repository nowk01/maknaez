package com.maknaez.mapper;

import java.util.List;
import java.util.Map;

public interface AlertMapper {
    // 결제완료된 주문 내역 조회
    public List<Map<String, Object>> listNewOrders();
    
    // 답변 대기 중인 문의 내역 조회
    public List<Map<String, Object>> listNewInquiries();
}