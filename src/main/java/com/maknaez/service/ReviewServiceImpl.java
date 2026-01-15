package com.maknaez.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.maknaez.mapper.ReviewMapper;
import com.maknaez.model.ReviewDTO;
import com.maknaez.mybatis.support.SqlSessionManager;

public class ReviewServiceImpl implements ReviewService {

	ReviewMapper mapper = SqlSessionManager.getSession().getMapper(ReviewMapper.class);
	
    @Override
    public int dataCount(long prodId) {
        return mapper.dataCount(prodId);
    }

    @Override
    public List<ReviewDTO> listReviews(long prodId, int start, int end) {
        
        Map<String, Object> map = new HashMap<>();
        map.put("prodId", prodId);
        map.put("start", start);
        map.put("end", end);
        
        return mapper.selectReviewsByProdId(map);
    }
}