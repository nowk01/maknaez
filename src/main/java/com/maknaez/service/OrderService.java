package com.maknaez.service;

import java.util.List;
import java.util.Map;
import com.maknaez.model.OrderDTO;

public interface OrderService {
    public int dataCount(Map<String, Object> map) throws Exception;
    public List<OrderDTO> listOrder(Map<String, Object> map) throws Exception;
    public void updateOrderState(Map<String, Object> map) throws Exception;
    public void insertClaim(Map<String, Object> map) throws Exception;
    public Map<String, Object> findByIdClaim(String orderId) throws Exception;
    public void updateClaimApprove(Map<String, Object> map) throws Exception;
    public void updateStockIncrease(Map<String, Object> map) throws Exception;
}