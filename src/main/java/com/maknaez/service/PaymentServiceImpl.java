package com.maknaez.service;

import org.apache.ibatis.session.SqlSession;

import com.maknaez.mapper.OrderMapper;
import com.maknaez.model.OrderDTO;
import com.maknaez.model.OrderItemDTO;
import com.maknaez.model.ProductDTO;
import com.maknaez.mybatis.support.SqlSessionManager;

public class PaymentServiceImpl implements PaymentService {

    @Override
    public ProductDTO getProduct(long prodId) throws Exception {
        SqlSession session = SqlSessionManager.getSession();
        OrderMapper orderMapper = session.getMapper(OrderMapper.class);

        ProductDTO dto = orderMapper.getProduct(prodId);
        if (dto == null) {
            throw new Exception("상품 정보를 찾을 수 없습니다.");
        }
        return dto;
    }

    @Override
    public long getOrderSeq() throws Exception {
        SqlSession session = SqlSessionManager.getSession();
        OrderMapper orderMapper = session.getMapper(OrderMapper.class);

        return orderMapper.getOrderSeq();
    }

    @Override
    public void processPayment(OrderDTO order, OrderItemDTO item) throws Exception {
        SqlSession session = SqlSessionManager.getSession();
        OrderMapper orderMapper = session.getMapper(OrderMapper.class);

        try {
            
            orderMapper.insertOrder(order); // 1. 주문 테이블 저장 (Master)
            orderMapper.insertOrderItem(item); // 2. 주문 상세 테이블 저장 (Detail)
            orderMapper.insertPayment(order); // 3. 결제 테이블 저장
            orderMapper.updateStock(item); // 4. 상품 재고 감소

        } catch (Exception e) {
            e.printStackTrace();
            throw e; // 예외를 던져야 트랜잭션 롤백 가능
        }
    }
}