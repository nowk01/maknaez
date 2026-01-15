package com.maknaez.controller;

import java.io.PrintWriter;
import java.util.List;

import com.maknaez.model.ReviewDTO;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.annotation.RequestMethod;
import com.maknaez.service.ReviewService;
import com.maknaez.service.ReviewServiceImpl;
import com.maknaez.util.MyUtil;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

@Controller
public class ReviewController {

    private ReviewService reviewService = new ReviewServiceImpl();
    private MyUtil myUtil = new MyUtil();

    @RequestMapping(value = "/review/list", method = RequestMethod.GET)
    public void list(HttpServletRequest req, HttpServletResponse resp) {
        resp.setContentType("application/json; charset=UTF-8");
        
        JSONObject result = new JSONObject();
        PrintWriter out = null;
        
        try {
            out = resp.getWriter();
            
            String prodIdStr = req.getParameter("prodId");
            String pageNoStr = req.getParameter("pageNo");
            
            if (prodIdStr == null || prodIdStr.trim().isEmpty()) {
                result.put("status", "error");
                result.put("message", "상품 ID가 없습니다.");
            } else {
                long prodId = Long.parseLong(prodIdStr);
                int current_page = 1;
                if(pageNoStr != null && !pageNoStr.isEmpty()) {
                    current_page = Integer.parseInt(pageNoStr);
                }
                
                int rows = 5; // ★ 5개씩 출력 설정
                int dataCount = reviewService.dataCount(prodId);
                
                // MyUtil을 사용하여 전체 페이지 수 계산
                int total_page = myUtil.pageCount(dataCount, rows);
                
                if(current_page > total_page) current_page = total_page;
                if(current_page < 1) current_page = 1;
                
                int start = (current_page - 1) * rows + 1;
                int end = current_page * rows;

                List<ReviewDTO> list = null;
                if(dataCount > 0) {
                    // 페이징된 메서드 호출
                    list = reviewService.listReviews(prodId, start, end);
                }
                
                JSONArray jsonList = new JSONArray();
                if (list != null) {
                    for (ReviewDTO dto : list) {
                        JSONObject item = new JSONObject();
                        item.put("reviewId", dto.getReviewId());
                        item.put("prodId", dto.getProdId());
                        item.put("memberIdx", dto.getMemberIdx());
                        item.put("content", dto.getContent());
                        item.put("starRating", dto.getStarRating());
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
                result.put("count", dataCount);
                result.put("totalPage", total_page);
                result.put("pageNo", current_page);
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("status", "error");
            result.put("message", "Server Error: " + e.getMessage());
        }

        if (out != null) {
            out.print(result.toString());
            out.flush();
        }
    }
}