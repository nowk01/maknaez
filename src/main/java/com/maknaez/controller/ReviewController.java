package com.maknaez.controller;

import java.io.PrintWriter;
import java.util.List;

import com.maknaez.model.ReviewDTO;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.annotation.RequestMethod;
import com.maknaez.service.ReviewService;
import com.maknaez.service.ReviewServiceImpl;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

@Controller
public class ReviewController {

    private ReviewService reviewService = new ReviewServiceImpl();

    @RequestMapping(value = "/review/list", method = RequestMethod.GET)
    public void list(HttpServletRequest req, HttpServletResponse resp) {
        // 1. 가장 먼저 응답 타입을 JSON으로 설정 (에러가 나도 JSON으로 나가도록)
        resp.setContentType("application/json; charset=UTF-8");
        
        JSONObject result = new JSONObject();
        PrintWriter out = null;
        
        try {
            out = resp.getWriter();
            
            // 파라미터 확인 로그
            String prodIdStr = req.getParameter("prodId");
            System.out.println("[ReviewController] 요청 받음. prodId: " + prodIdStr);

            if (prodIdStr == null || prodIdStr.trim().isEmpty()) {
                result.put("status", "error");
                result.put("message", "상품 ID(prodId) 파라미터가 없습니다.");
            } else {
                long prodId = Long.parseLong(prodIdStr);
                
                // 서비스 호출 (DB 조회)
                // 여기서 에러가 나면 catch 블록으로 이동합니다.
                List<ReviewDTO> list = reviewService.listReviews(prodId);
                
                // DTO -> JSON 변환
                JSONArray jsonList = new JSONArray();
                if (list != null) {
                    for (ReviewDTO dto : list) {
                        JSONObject item = new JSONObject();
                        item.put("reviewId", dto.getReviewId());
                        item.put("prodId", dto.getProdId());
                        item.put("memberIdx", dto.getMemberIdx());
                        item.put("content", dto.getContent());
                        item.put("starRating", dto.getStarRating());
                        // null 체크 후 빈 문자열 처리
                        item.put("reviewImg", dto.getReviewImg() == null ? "" : dto.getReviewImg());
                        item.put("optionValue", dto.getOptionValue() == null ? "" : dto.getOptionValue());
                        item.put("regDate", dto.getRegDate());
                        item.put("writerName", dto.getWriterName());
                        item.put("writerId", dto.getWriterId());
                        jsonList.put(item);
                    }
                }

                result.put("status", "success");
                result.put("data", jsonList);
                result.put("count", jsonList.length());
            }

        } catch (Throwable e) {
            // 2. 모든 에러를 잡아서 콘솔에 찍고 JSON 메시지로 변환
            e.printStackTrace(); // 서버 로그 필수 확인
            System.out.println("[ReviewController] 치명적 에러: " + e.getMessage());
            
            result.put("status", "error");
            // 에러 클래스 이름과 메시지를 함께 보냄
            result.put("message", "Server Error: " + e.getClass().getName() + " - " + e.getMessage());
        }

        // 3. JSON 문자열 출력
        if (out != null) {
            out.print(result.toString());
            out.flush();
            out.close();
        }
    }
}