package com.maknaez.service;

import java.util.List;
import java.util.Map;
import com.maknaez.model.WishlistDTO;

public interface WishlistService {
    public void insertWish(WishlistDTO dto) throws Exception;
    public void deleteWish(Map<String, Object> map) throws Exception;
    public List<WishlistDTO> listWish(Map<String, Object> map);
    public int dataCountWish(Map<String, Object> map);
    public boolean isLiked(long memberIdx, long prodId);
}