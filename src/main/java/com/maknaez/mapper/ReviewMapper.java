package com.maknaez.mapper;

import java.util.List;
import java.util.Map;

import com.maknaez.model.ReviewDTO;

public interface ReviewMapper {
	
	int dataCount(long prodId); // 상품별 리뷰 수
	List<ReviewDTO> selectReviewsByProdId(Map<String, Object> map); // 상품별 리뷰 목록
	
	void insertReview(ReviewDTO dto) throws Exception;
	int findByOrderNum(String orderNum);
	
	int countMyReviews(long memberIdx);
	List<ReviewDTO> selectMyReviews(Map<String, Object> map);
}