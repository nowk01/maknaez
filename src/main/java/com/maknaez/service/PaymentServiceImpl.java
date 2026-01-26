package com.maknaez.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import com.maknaez.mapper.CartMapper;
import com.maknaez.mapper.MemberMapper;
import com.maknaez.mapper.OrderMapper;
import com.maknaez.mapper.ProductMapper;
import com.maknaez.model.AddressDTO;
import com.maknaez.model.MemberDTO;
import com.maknaez.model.OrderDTO;
import com.maknaez.model.OrderItemDTO;
import com.maknaez.model.PaymentDTO;
import com.maknaez.model.PointDTO;
import com.maknaez.model.ProductDTO;
import com.maknaez.mybatis.support.MapperContainer;

public class PaymentServiceImpl implements PaymentService {

    private OrderMapper orderMapper = MapperContainer.get(OrderMapper.class);
    private ProductMapper productMapper = MapperContainer.get(ProductMapper.class);
    private CartMapper cartMapper = MapperContainer.get(CartMapper.class);
    private MemberMapper memberMapper = MapperContainer.get(MemberMapper.class);
    private PointService pointService = new PointServiceImpl(); 

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
        
        long memberIdx = order.getMemberIdx();
        int usedPoint = (order.getPoint() != null) ? order.getPoint() : 0; 
        long totalAmount = order.getTotalAmount(); 

        if (usedPoint > 0) {
            int currentPoint = pointService.findCurrentPoint(memberIdx);
            if (usedPoint > currentPoint) {
                throw new Exception("보유 포인트가 부족합니다. (보유: " + currentPoint + "P)");
            }
            if (usedPoint < 1000) {
                throw new Exception("포인트는 1,000P 이상부터 사용 가능합니다.");
            }
            long maxPointLimit = (long) (totalAmount * 0.3);
            if (usedPoint > maxPointLimit) {
                throw new Exception("포인트는 결제 금액의 30%(" + maxPointLimit + "P)까지만 사용 가능합니다.");
            }
        }

        long realPayAmount = totalAmount - usedPoint;
        order.setRealTotalAmount((int)realPayAmount);

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

        payment.setOrderId(orderId);
        if (payment.getPayStatus() == null || payment.getPayStatus().isEmpty()) {
            payment.setPayStatus("결제완료");
        }
        if (payment.getPgTid() == null || payment.getPgTid().isEmpty()) {
            payment.setPgTid("IMP_" + System.currentTimeMillis()); 
        }
        payment.setPayAmount(realPayAmount); 
        orderMapper.insertPayment(payment);

        for (OrderItemDTO item : items) {
            item.setOrder_id(orderId);
            orderMapper.insertOrderItem(item);

            long optId = item.getOpt_id();
            int buyQty = item.getCount();

            Integer currentStock = productMapper.getLastStock(optId);
            if (currentStock == null) currentStock = 0;

            if (currentStock < buyQty) {
                throw new Exception("상품(옵션ID: " + optId + ")의 재고가 부족합니다.");
            }

            Map<String, Object> logMap = new HashMap<>();
            logMap.put("prodId", item.getProd_id());
            logMap.put("optId", optId);
            logMap.put("qty", buyQty); 
            logMap.put("finalStock", currentStock - buyQty);
            logMap.put("reason", "OUT");

            productMapper.insertStockUpdateLog(logMap);
        }

        if (cartIds != null && cartIds.length > 0) {
            try {
                List<Long> cartIdList = new ArrayList<>();
                for (String cid : cartIds) {
                    try {
                        cartIdList.add(Long.parseLong(cid));
                    } catch (NumberFormatException e) {
                    }
                }
                if (!cartIdList.isEmpty()) {
                    cartMapper.deleteCart(cartIdList);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        if (usedPoint > 0) {
            PointDTO useDto = new PointDTO();
            useDto.setMemberIdx(memberIdx);
            useDto.setOrder_id(orderId);
            useDto.setReason("상품 구매 사용");
            useDto.setPoint_amount(-usedPoint);
            pointService.insertPoint(useDto);
        }

        MemberDTO member = memberMapper.findById(order.getUserId()); 
        if (member != null) {
            int userLevel = member.getUserLevel();
            double saveRate = 0.01;

            if (userLevel >= 1 && userLevel <= 10) saveRate = 0.01;
            else if (userLevel >= 11 && userLevel <= 20) saveRate = 0.015;
            else if (userLevel >= 21 && userLevel <= 30) saveRate = 0.02;
            else if (userLevel >= 31 && userLevel <= 40) saveRate = 0.03;
            else if (userLevel >= 41 && userLevel <= 50) saveRate = 0.05;

            int savePoint = (int) (realPayAmount * saveRate);

            if (savePoint > 0) {
                PointDTO saveDto = new PointDTO();
                saveDto.setMemberIdx(memberIdx);
                saveDto.setOrder_id(orderId);
                saveDto.setReason("상품 구매 적립");
                saveDto.setPoint_amount(savePoint);
                pointService.insertPoint(saveDto);
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
    
    @Override
    public OrderDTO getOrderCompleteInfo(String orderId) throws Exception {
        try {
            return orderMapper.selectOrderCompleteInfo(orderId);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    public PaymentDTO getPaymentInfo(String orderId) throws Exception {
        try {
            return orderMapper.selectPaymentByOrder(orderId);
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
}