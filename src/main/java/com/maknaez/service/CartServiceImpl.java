package com.maknaez.service;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import com.maknaez.mapper.CartMapper;
import com.maknaez.model.CartDTO;
import com.maknaez.mybatis.support.SqlSessionManager;

public class CartServiceImpl implements CartService {

    @Override
    public void insertCart(CartDTO dto) throws Exception {
        SqlSession sqlSession = SqlSessionManager.getSession();
        CartMapper mapper = sqlSession.getMapper(CartMapper.class);
        
        int count = mapper.checkExistingCart(dto);
        
        if (count > 0) {
            mapper.updateCartQuantity(dto);
        } else {
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