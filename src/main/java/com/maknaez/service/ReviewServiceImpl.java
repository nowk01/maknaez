package com.maknaez.service;

import java.util.List;
import com.maknaez.mapper.ReviewMapper;
import com.maknaez.model.ReviewDTO;
import com.maknaez.mybatis.support.SqlSessionManager;

public class ReviewServiceImpl implements ReviewService {

    @Override
    public List<ReviewDTO> listReviews(long prodId) {
        ReviewMapper mapper = SqlSessionManager.getSession().getMapper(ReviewMapper.class);
        return mapper.selectReviewsByProdId(prodId);
    }
}