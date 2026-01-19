package com.maknaez.service;

import java.util.List;
import com.maknaez.model.ReviewDTO;

public interface ReviewService {
    int dataCount(long prodId); // 제품 리뷰 검색

    List<ReviewDTO> listReviews(long prodId, int start, int end);
    
    void insertReview(ReviewDTO dto, String pathname) throws Exception;
    
   
}