package com.maknaez.service;

import java.util.List;
import com.maknaez.model.CartDTO;

public interface CartService {
    // 장바구니 추가 (중복 체크 포함)
    public void insertCart(CartDTO dto) throws Exception;
    // 목록 조회
    public List<CartDTO> listCart(long memberIdx);    
    // 수량 변경
    public void updateQuantity(long cartId, int quantity) throws Exception;    
    // 삭제
    public void deleteCart(List<Long> cartIds) throws Exception;
}