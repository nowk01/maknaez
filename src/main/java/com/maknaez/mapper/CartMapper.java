package com.maknaez.mapper;

import java.util.List;
import com.maknaez.model.CartDTO;

public interface CartMapper {
   
    public int insertCart(CartDTO dto);  // 장바구니 담기
    public int checkExistingCart(CartDTO dto); // 장바구니 중복 확인
    public void updateCartQuantity(CartDTO dto); // 장바구니 수량 추가 (기존 수량 + 새 수량)
    public void editCartQuantity(CartDTO dto); // 장바구니 수량 변경 (새 수량으로 덮어쓰기)
    public List<CartDTO> listCart(long memberIdx);  // 장바구니 목록 조회
    public void deleteCart(List<Long> cartIds); // 장바구니 삭제
}