package com.maknaez.service;

import java.util.List;
import com.maknaez.model.ReviewDTO;

public interface ReviewService {
    int dataCount(long prodId); // 제품 리뷰 검색

    /**
     * 특정 상품의 리뷰 목록을 조회 (페이징)
     * @param prodId 상품 번호
     * @param start 시작 행
     * @param end 끝 행
     * @return 리뷰 DTO 리스트
     */
    List<ReviewDTO> listReviews(long prodId, int start, int end);
}