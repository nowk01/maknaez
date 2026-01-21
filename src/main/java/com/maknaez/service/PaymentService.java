package com.maknaez.service;

import java.util.List;
import java.util.Map;

import com.maknaez.model.AddressDTO;
import com.maknaez.model.OrderDTO;
import com.maknaez.model.OrderItemDTO;
import com.maknaez.model.PaymentDTO;
import com.maknaez.model.ProductDTO;

public interface PaymentService {
    public ProductDTO getProduct(long prodId) throws Exception; 
    public long getOrderSeq() throws Exception;
    public String processPayment(OrderDTO order, List<OrderItemDTO> items, String[] cartIds, PaymentDTO payment) throws Exception; 
    public List<Map<String, Object>> getOrderListByCart(String[] cartIds) throws Exception; 
    public Map<String, Object> getProductDetailForOrder(long prodId, int quantity, long optId) throws Exception;
    public List<AddressDTO> getAddressList(long memberIdx) throws Exception;
    
    public OrderDTO getOrderCompleteInfo(String orderId) throws Exception;
    public PaymentDTO getPaymentInfo(String orderId) throws Exception;
    
}