package com.maknaez.mapper;

import com.maknaez.model.CartDTO;

public interface CartMapper {
    public int insertCart(CartDTO dto);	// 장바구니에 상품 추가
    public int checkExistingCart(CartDTO dto); // 장바구니 제품 체크
    public void updateCartQuantity(CartDTO dto); // 장바구니 수량 업데이트
}