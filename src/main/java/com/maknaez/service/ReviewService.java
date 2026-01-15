package com.maknaez.service;

import java.util.List;
import com.maknaez.model.ReviewDTO;

public interface ReviewService {
    /**
     * 특정 상품의 리뷰 목록을 조회
     * @param prodId 상품 번호
     * @return 리뷰 DTO 리스트
     */
    List<ReviewDTO> listReviews(long prodId);
}