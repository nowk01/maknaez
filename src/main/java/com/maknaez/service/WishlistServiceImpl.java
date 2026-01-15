package com.maknaez.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.maknaez.mapper.WishlistMapper;
import com.maknaez.model.WishlistDTO;
import com.maknaez.mybatis.support.MapperContainer;

public class WishlistServiceImpl implements WishlistService {
    
    // [중요] MapperContainer를 통해 가져옵니다.
    private WishlistMapper mapper = MapperContainer.get(WishlistMapper.class);

    @Override
    public void insertWish(WishlistDTO dto) throws Exception {
        try {
            mapper.insertWish(dto);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    public void deleteWish(Map<String, Object> map) throws Exception {
        try {
            mapper.deleteWish(map);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    public List<WishlistDTO> listWish(Map<String, Object> map) {
        List<WishlistDTO> list = null;
        try {
            list = mapper.listWish(map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int dataCountWish(Map<String, Object> map) {
        int result = 0;
        try {
            result = mapper.dataCountWish(map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    @Override
    public boolean isLiked(long memberIdx, long prodId) {
        boolean result = false;
        try {
            Map<String, Object> map = new HashMap<>();
            map.put("memberIdx", memberIdx);
            map.put("prodId", prodId);
            
            // 찜 개수가 1개 이상이면 true
            result = mapper.checkWish(map) > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}