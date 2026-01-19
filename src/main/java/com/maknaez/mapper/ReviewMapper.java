package com.maknaez.mapper;

import java.util.List;
import java.util.Map;

import com.maknaez.model.ReviewDTO;

public interface ReviewMapper {
	
	int dataCount(long prodId);// 전체 리뷰 수
	List<ReviewDTO> selectReviewsByProdId(Map<String, Object> map); // 페이징용
	
	void insertReview(ReviewDTO dto) throws Exception;
    int findByOrderNum(String orderNum);
}
