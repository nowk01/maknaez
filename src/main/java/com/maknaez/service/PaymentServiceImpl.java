package com.maknaez.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import com.maknaez.mapper.CartMapper;
import com.maknaez.mapper.OrderMapper;
import com.maknaez.mapper.ProductMapper;
import com.maknaez.model.AddressDTO;
import com.maknaez.model.OrderDTO;
import com.maknaez.model.OrderItemDTO;
import com.maknaez.model.PaymentDTO;
import com.maknaez.model.ProductDTO;
import com.maknaez.mybatis.support.MapperContainer;

public class PaymentServiceImpl implements PaymentService {

    private OrderMapper orderMapper = MapperContainer.get(OrderMapper.class);
    private ProductMapper productMapper = MapperContainer.get(ProductMapper.class);
    private CartMapper cartMapper = MapperContainer.get(CartMapper.class);

    @Override
    public ProductDTO getProduct(long prodId) throws Exception {
        try {
            return orderMapper.getProduct(prodId);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    public long getOrderSeq() throws Exception {
        try {
            return orderMapper.getOrderSeq();
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    public List<Map<String, Object>> getOrderListByCart(String[] cartIds) throws Exception {
        Map<String, Object> map = new HashMap<>();
        map.put("cartIds", cartIds);
        try {
            return orderMapper.getOrderListByCart(map);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    public Map<String, Object> getProductDetailForOrder(long prodId, int quantity, long optId) throws Exception {
        Map<String, Object> map = new HashMap<>();
        map.put("prodId", prodId);
        map.put("quantity", quantity);
        map.put("optId", optId);
        try {
            return orderMapper.getProductDetailForOrder(map);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    public String processPayment(OrderDTO order, List<OrderItemDTO> items, String[] cartIds, PaymentDTO payment) throws Exception {
        
        String orderId = generateOrderId();
        order.setOrderNum(orderId); 

        if (!items.isEmpty()) {
            OrderItemDTO info = items.get(0);
            
            long deliveryNumber = System.currentTimeMillis() + new Random().nextInt(100);
            
            Map<String, Object> shipmentMap = new HashMap<>();
            shipmentMap.put("deliveryNumber", deliveryNumber);
            shipmentMap.put("addrId", null);
            shipmentMap.put("receiverName", info.getReceiver_name());
            shipmentMap.put("receiverTel", info.getReceiver_tel());
            shipmentMap.put("zipCode", info.getZip_code());
            shipmentMap.put("addr1", info.getAddr1());
            shipmentMap.put("addr2", info.getAddr2());
            shipmentMap.put("memo", info.getMemo());
            shipmentMap.put("status", "결제완료");
            shipmentMap.put("company", "막내즈운송");
            
            orderMapper.insertShipment(shipmentMap);
            order.setDeliveryNumber(deliveryNumber);
        }

        orderMapper.insertOrder(order);
        
        payment.setOrderId(orderId); // 생성된 주문번호 연결
        
        // 결제 상태가 없으면 기본값 설정
        if (payment.getPayStatus() == null || payment.getPayStatus().isEmpty()) {
            payment.setPayStatus("결제완료");
        }        
        // PG 거래번호가 없으면 임시값 생성 (실결제 연동 시에는 PG사 값을 사용)
        if (payment.getPgTid() == null || payment.getPgTid().isEmpty()) {
            payment.setPgTid("IMP_" + System.currentTimeMillis()); 
        }
        
        // 결제 금액이 0이면 주문 금액으로 설정
        if (payment.getPayAmount() == 0) {
            payment.setPayAmount(order.getTotalAmount());
        }
        
        orderMapper.insertPayment(payment);

        for (OrderItemDTO item : items) {
            item.setOrder_id(orderId);
            orderMapper.insertOrderItem(item);

            long optId = item.getOpt_id();
            int buyQty = item.getCount();

            Integer currentStock = productMapper.getLastStock(optId);
            if (currentStock == null) currentStock = 0;

            if (currentStock < buyQty) {
                throw new Exception("상품(옵션ID: " + optId + ")의 재고가 부족합니다. (남은수량: " + currentStock + ")");
            }

            Map<String, Object> logMap = new HashMap<>();
            logMap.put("prodId", item.getProd_id());
            logMap.put("optId", optId);
            logMap.put("qty", buyQty); 
            logMap.put("finalStock", currentStock - buyQty); 
            logMap.put("reason", "정상판매"); 

            productMapper.insertStockUpdateLog(logMap);
        }

        // 5. 장바구니 비우기 (List<Long>으로 변환하여 전달)
        if (cartIds != null && cartIds.length > 0) {
            try {
                List<Long> cartIdList = new ArrayList<>();
                for (String cid : cartIds) {
                    try {
                        cartIdList.add(Long.parseLong(cid));
                    } catch (NumberFormatException e) {
                        // 숫자가 아닌 값이 섞여있을 경우 무시
                    }
                }
                
                if (!cartIdList.isEmpty()) {
                    cartMapper.deleteCart(cartIdList);
                }
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println(">>> 장바구니 삭제 중 오류 발생 (결제는 성공함)");
            }
        }

        return orderId;
    }

    @Override
    public List<AddressDTO> getAddressList(long memberIdx) throws Exception {
        try {
            return orderMapper.listAddress(memberIdx);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    private String generateOrderId() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String dateStr = sdf.format(new Date());
        int randomNum = new Random().nextInt(9000) + 1000;
        return "ORD_" + dateStr + "_" + randomNum;
    }
    
 // 주문 완료 정보 조회
    @Override
    public OrderDTO getOrderCompleteInfo(String orderId) throws Exception {
        try {
            return orderMapper.selectOrderCompleteInfo(orderId);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    // 결제 정보 조회
    @Override
    public PaymentDTO getPaymentInfo(String orderId) throws Exception {
        try {
            return orderMapper.selectPaymentByOrder(orderId);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }
}