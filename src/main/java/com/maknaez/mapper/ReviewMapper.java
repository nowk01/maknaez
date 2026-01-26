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

	public Map<String, Object> selectProductReviewStats(long prodId); // 상품별 평균 별점 및 리뷰 통계 조회
	
	// 관리자 기능
    int dataCountAdmin(Map<String, Object> map); // 관리자용 검색 포함 개수
    List<ReviewDTO> listReviewAdmin(Map<String, Object> map); // 관리자용 리스트
    ReviewDTO findById(long reviewId); // 상세 조회
    void deleteReview(long reviewId); // 삭제
    void updateReviewStatus(Map<String, Object> map); // 상태 변경
    
	void updateReply(Map<String, Object> map);

}