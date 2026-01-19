package com.maknaez.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.maknaez.mapper.ReviewMapper;
import com.maknaez.model.ReviewDTO;
import com.maknaez.model.PointDTO;
import com.maknaez.mybatis.support.SqlSessionManager;

public class ReviewServiceImpl implements ReviewService {

    ReviewMapper mapper = SqlSessionManager.getSession().getMapper(ReviewMapper.class);
    private PointService pointService = new PointServiceImpl();

    @Override
    public int dataCount(long prodId) {
        return mapper.dataCount(prodId);
    }

    @Override
    public List<ReviewDTO> listReviews(long prodId, int start, int end) {
        Map<String, Object> map = new HashMap<>();
        map.put("prodId", prodId);
        map.put("start", start);
        map.put("end", end);
        return mapper.selectReviewsByProdId(map);
    }

    @Override
    public void insertReview(ReviewDTO dto, String pathname) throws Exception {
        try {
            int count = mapper.findByOrderNum(dto.getOrderNum());
            if (count > 0) {
                throw new Exception("이미 리뷰를 작성한 주문입니다.");
            }
            mapper.insertReview(dto);

            int point = (dto.getReviewImg() != null && !dto.getReviewImg().isEmpty()) ? 3000 : 1000;
            PointDTO pointDTO = new PointDTO();
            pointDTO.setMemberIdx(dto.getMemberIdx());
            pointDTO.setOrder_id(dto.getOrderNum());
            pointDTO.setReason("구매후기 작성 (" + (point == 3000 ? "포토" : "텍스트") + ")");
            pointDTO.setPoint_amount(point);
            pointService.insertPoint(pointDTO);

        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }
    
    @Override
    public int dataCountMyReviews(long memberIdx) {
        return mapper.countMyReviews(memberIdx);
    }
    
    @Override
    public List<ReviewDTO> listMyReviews(Map<String, Object> map) {
        return mapper.selectMyReviews(map);
    }

    @Override
    public int dataCountAdmin(Map<String, Object> map) {
        return mapper.dataCountAdmin(map);
    }

    @Override
    public List<ReviewDTO> listReviewAdmin(Map<String, Object> map) {
        return mapper.listReviewAdmin(map);
    }

    @Override
    public ReviewDTO findById(long reviewId) {
        return mapper.findById(reviewId);
    }

    @Override
    public void deleteReview(long reviewId) throws Exception {
        try {
            mapper.deleteReview(reviewId);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }
    
    @Override
    public Map<String, Object> readReviewStats(long prodId) {
        return mapper.selectProductReviewStats(prodId);
    }
    
    @Override
    public void updateReviewStatus(long reviewId, String status) throws Exception {
        try {
            Map<String, Object> map = new HashMap<>();
            map.put("reviewId", reviewId);
            map.put("status", status);
            mapper.updateReviewStatus(map);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }
}