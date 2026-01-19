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
}