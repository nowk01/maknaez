package com.maknaez.mapper;

import java.util.List;
import java.util.Map;
import com.maknaez.model.WishlistDTO;

public interface WishlistMapper {
    public void insertWish(WishlistDTO dto) throws Exception;
    public void deleteWish(Map<String, Object> map) throws Exception;
    public List<WishlistDTO> listWish(Map<String, Object> map) throws Exception;
    public int dataCountWish(Map<String, Object> map) throws Exception;
    public int checkWish(Map<String, Object> map) throws Exception;
    public List<Long> listLikedProductIds(long memberIdx) throws Exception;
}