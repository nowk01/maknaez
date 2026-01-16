package com.maknaez.service;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import com.maknaez.mapper.CartMapper;
import com.maknaez.model.CartDTO;
import com.maknaez.mybatis.support.SqlSessionManager;

public class CartServiceImpl implements CartService {

    @Override
    public void insertCart(CartDTO dto) throws Exception {
        // 필터가 세션을 관리하므로 getSession()만 호출
        SqlSession sqlSession = SqlSessionManager.getSession();
        CartMapper mapper = sqlSession.getMapper(CartMapper.class);
        
        // 1. 이미 담긴 상품인지 확인
        int count = mapper.checkExistingCart(dto);
        
        if (count > 0) {
            // 2-1. 이미 있으면 수량 증가
            mapper.updateCartQuantity(dto);
        } else {
            // 2-2. 없으면 새로 추가
            mapper.insertCart(dto);
        }
    }

    @Override
    public List<CartDTO> listCart(long memberIdx) {
        SqlSession sqlSession = SqlSessionManager.getSession();
        CartMapper mapper = sqlSession.getMapper(CartMapper.class);
        return mapper.listCart(memberIdx);
    }

    @Override
    public void updateQuantity(long cartId, int quantity) throws Exception {
        SqlSession sqlSession = SqlSessionManager.getSession();
        CartMapper mapper = sqlSession.getMapper(CartMapper.class);
        
        CartDTO dto = new CartDTO();
        dto.setCartId(cartId);
        dto.setQuantity(quantity);
        
        mapper.editCartQuantity(dto);
    }

    @Override
    public void deleteCart(List<Long> cartIds) throws Exception {
        SqlSession sqlSession = SqlSessionManager.getSession();
        CartMapper mapper = sqlSession.getMapper(CartMapper.class);
        
        mapper.deleteCart(cartIds);
    }
}