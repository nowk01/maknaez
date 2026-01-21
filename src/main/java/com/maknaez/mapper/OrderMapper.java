package com.maknaez.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.maknaez.model.AddressDTO;
import com.maknaez.model.OrderDTO;
import com.maknaez.model.OrderItemDTO;
import com.maknaez.model.PaymentDTO;
import com.maknaez.model.ProductDTO;

public interface OrderMapper {
    public int dataCount(Map<String, Object> map) throws SQLException;
    public List<OrderDTO> listOrder(Map<String, Object> map) throws SQLException;
    
    public ProductDTO getProduct(long prod_id) throws SQLException;
    public long getOrderSeq() throws SQLException; // 주문 번호(Sequence) 미리 가져오기
    public void insertOrder(OrderDTO dto) throws SQLException; // 1. 주문 테이블 저장
    public void insertOrderItem(OrderItemDTO dto) throws SQLException; // 2. 주문 상세 테이블 저장 (상품별)
    public void insertPayment(OrderDTO dto) throws SQLException; // 3. 결제 테이블 저장
    public void updateStock(OrderItemDTO dto) throws SQLException; // 재고 감소
    public void updateOrderState(Map<String, Object> map) throws SQLException;
    public void insertClaim(Map<String, Object> map) throws SQLException;
    public Map<String, Object> findByIdClaim(String orderId) throws SQLException;
    public void updateStockIncrease(Map<String, Object> map) throws SQLException;
    public void updateClaimApprove(Map<String, Object> map) throws SQLException;
    public int estimateCount(Map<String, Object> map);
    public List<Map<String, Object>> listEstimate(Map<String, Object> map);
    public int waitingEstimateCount();
	public List<Map<String, Object>> getOrderDetailsForEstimate(String orderNum);

    public List<Map<String, Object>> selectOrderListByCart(String[] cartIds) throws SQLException;
    public Map<String, Object> selectProductForOrder(Map<String, Object> map) throws SQLException;
    public List<AddressDTO> listAddress(long memberIdx) throws SQLException; // 배송지 목록 조회
 
    public void insertShipment(Map<String, Object> map) throws SQLException; //  배송 정보 저장 (SHIPMENTS 테이블)

    public List<Map<String, Object>> getOrderListByCart(Map<String, Object> map) throws SQLException; // 장바구니 주문 목록 조회 (XML ID: getOrderListByCart) 
    public Map<String, Object> getProductDetailForOrder(Map<String, Object> map) throws SQLException; // 단일 상품 구매 정보 조회 (XML ID: getProductDetailForOrder)
 
    public void insertPayment(PaymentDTO dto) throws SQLException; // PaymentDTO를 이용한 결제 정보 저장    
    public OrderDTO selectOrderCompleteInfo(String orderId) throws SQLException; // 완료 페이지용 조회
    public PaymentDTO selectPaymentByOrder(String orderId) throws SQLException;

}