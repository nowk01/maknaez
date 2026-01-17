package com.maknaez.service;

import java.util.List;
import java.util.Map;

import com.maknaez.mapper.OrderMapper;
import com.maknaez.model.OrderDTO;
import com.maknaez.mybatis.support.MapperContainer;

public class OrderServiceImpl implements OrderService {
    
    @Override
    public int dataCount(Map<String, Object> map) throws Exception {
        OrderMapper mapper = MapperContainer.get(OrderMapper.class);
        return mapper.dataCount(map);
    }

    @Override
    public List<OrderDTO> listOrder(Map<String, Object> map) throws Exception {
        OrderMapper mapper = MapperContainer.get(OrderMapper.class);
        return mapper.listOrder(map);
    }

    @Override
    public void updateOrderState(Map<String, Object> map) throws Exception {
        OrderMapper mapper = MapperContainer.get(OrderMapper.class);
        try {
            mapper.updateOrderState(map);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    public void insertClaim(Map<String, Object> map) throws Exception {
        OrderMapper mapper = MapperContainer.get(OrderMapper.class);
        try {
            mapper.insertClaim(map);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    public Map<String, Object> findByIdClaim(String orderId) throws Exception {
        OrderMapper mapper = MapperContainer.get(OrderMapper.class);
        return mapper.findByIdClaim(orderId);
    }

    // 승인 시 상태 변경
    @Override
    public void updateClaimApprove(Map<String, Object> map) throws Exception {
        OrderMapper mapper = MapperContainer.get(OrderMapper.class);
        try {
            mapper.updateClaimApprove(map);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    // 승인 시 재고 복구
    @Override
    public void updateStockIncrease(Map<String, Object> map) throws Exception {
        OrderMapper mapper = MapperContainer.get(OrderMapper.class);
        try {
            mapper.updateStockIncrease(map);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }
}