package com.maknaez.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import com.maknaez.mapper.OrderMapper;
import com.maknaez.model.AddressDTO;
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

    /**
     * [결제 프로세스 구현]
     * 1. 주문 마스터(Order) 생성
     * 2. 주문 상세(Item) 리스트 반복 저장 및 재고 차감
     * 3. 결제 내역 저장
     */
    @Override
    public void processPayment(OrderDTO order, List<OrderItemDTO> items) throws Exception {
        SqlSession session = SqlSessionManager.getSession();
        OrderMapper orderMapper = session.getMapper(OrderMapper.class);

        try {
            orderMapper.insertOrder(order); 
            
            String orderNum = order.getOrderNum(); 

            for (OrderItemDTO item : items) {
                try {
                     item.setOrder_id(Long.parseLong(orderNum));
                     
                } catch (NumberFormatException e) {
                    // 주문번호에 문자가 섞여있다면 이 부분 수정 필요
                    e.printStackTrace();
                    throw new Exception("주문 번호 형식이 올바르지 않습니다.");
                }
                
                orderMapper.insertOrderItem(item); // 상세 저장
                orderMapper.updateStock(item);     // 재고 감소
            }

            // 3. 결제 테이블 저장
            orderMapper.insertPayment(order); 
            
            // 트랜잭션 커밋 (환경에 따라 자동 커밋될 수 있음)
            // session.commit(); 

        } catch (Exception e) {
            // session.rollback();
            e.printStackTrace();
            throw e; // 컨트롤러에 에러 전파
        }
    }

    /**
     * [추가] 장바구니 ID 배열로 상품 정보 리스트 조회
     */
    @Override
    public List<Map<String, Object>> getOrderListByCart(String[] cartIds) throws Exception {
        SqlSession session = SqlSessionManager.getSession();
        OrderMapper orderMapper = session.getMapper(OrderMapper.class);
        
        return orderMapper.selectOrderListByCart(cartIds);
    }
    
    /**
     * [추가] 단일 상품 바로 구매 정보 조회
     */
    @Override
    public Map<String, Object> getProductDetailForOrder(long prodId, int quantity, long optId) throws Exception {
        SqlSession session = SqlSessionManager.getSession();
        OrderMapper orderMapper = session.getMapper(OrderMapper.class);
        
        Map<String, Object> param = new HashMap<>();
        param.put("prodId", prodId);
        param.put("quantity", quantity);
        param.put("optId", optId);
        
        return orderMapper.selectProductForOrder(param);
    }
    
    @Override
    public List<AddressDTO> getAddressList(long memberIdx) throws Exception {
        SqlSession session = SqlSessionManager.getSession();
        OrderMapper orderMapper = session.getMapper(OrderMapper.class);
        return orderMapper.listAddress(memberIdx);
    }
    
}