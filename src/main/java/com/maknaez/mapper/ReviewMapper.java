package com.maknaez.mapper;

import java.util.List;

import com.maknaez.model.ReviewDTO;

public interface ReviewMapper {
	List<ReviewDTO> selectReviewsByProdId(long prodId);
}
