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
			// 1. 이미 작성된 리뷰인지 확인
			int count = mapper.findByOrderNum(dto.getOrderNum());
			if (count > 0) {
				throw new Exception("이미 리뷰를 작성한 주문입니다.");
			}

			// 2. 리뷰 이미지 처리 (이미지 있으면 저장 경로 설정)
			// 컨트롤러에서 파일 업로드 후 파일명을 dto에 담아 보냄

			// 3. 리뷰 DB 저장
			mapper.insertReview(dto);

			// 4. 포인트 적립 (텍스트: 1000, 포토: 3000)
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
	
	
	
}