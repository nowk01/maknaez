package com.maknaez.service;

import java.util.List;
import java.util.Map;
import com.maknaez.model.ReviewDTO;

public interface ReviewService {
    public int dataCount(long prodId);
    public List<ReviewDTO> listReviews(long prodId, int start, int end);
    public void insertReview(ReviewDTO dto, String pathname) throws Exception;
    
    public int dataCountMyReviews(long memberIdx);
    public List<ReviewDTO> listMyReviews(Map<String, Object> map);
    
    public Map<String, Object> readReviewStats(long prodId); 
    
    public int dataCountAdmin(Map<String, Object> map);
    public List<ReviewDTO> listReviewAdmin(Map<String, Object> map);
    public ReviewDTO findById(long reviewId);
    public void deleteReview(long reviewId) throws Exception;
    public void updateReviewStatus(long reviewId, int enabled) throws Exception;
}