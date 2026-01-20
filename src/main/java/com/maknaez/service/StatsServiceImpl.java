package com.maknaez.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.maknaez.mapper.StatsMapper;
import com.maknaez.mybatis.support.SqlSessionManager;

public class StatsServiceImpl implements StatsService{
	StatsMapper mapper = SqlSessionManager.getSession().getMapper(StatsMapper.class);
	
	@Override
    public Map<String, Object> getSalesStats() throws Exception {
        // 매퍼 가져오기
        StatsMapper mapper = SqlSessionManager.getSession().getMapper(StatsMapper.class);
        
        // try-catch 제거! 예외 발생 시 컨트롤러로 전파되도록 함.
        Map<String, Object> resultMap = new HashMap<>();
        
        // 1. 요약 카드 데이터
        resultMap.put("todaySales", mapper.getTodaySales());
        resultMap.put("monthSales", mapper.getMonthSales());
        resultMap.put("todayOrderCount", mapper.getTodayOrderCount());
        
        // 2. 그래프 데이터 (최근 7일)
        List<Map<String, Object>> recentSales = mapper.getRecentSales();
        resultMap.put("recentSales", recentSales);
        
        // 3. 상품 랭킹 (TOP 5)
        List<Map<String, Object>> topProducts = mapper.getTopSellingProducts();
        resultMap.put("topProducts", topProducts);

        return resultMap;
    }
	
	@Override
    public Map<String, Object> getProductStats() throws Exception {
        StatsMapper mapper = SqlSessionManager.getSession().getMapper(StatsMapper.class);
        Map<String, Object> map = new HashMap<>();

        map.put("pendingInquiryCount", mapper.getPendingInquiryCount());
        map.put("soldOutCount", mapper.getSoldOutCount());
        map.put("lowStockCount", mapper.getLowStockCount());

        // 2. 차트 데이터
        map.put("orderStatus", mapper.getOrderStatusDistribution()); // 주문 상태
        map.put("categoryShare", mapper.getCategoryShare());         // 카테고리 비중
        map.put("bestSellers", mapper.getBestSellers());             // 베스트 셀러
        map.put("topWishlist", mapper.getTopWishlist());             // 찜 순위
        map.put("topCart", mapper.getTopCart());                     // 장바구니 순위

        return map;
    }
	
	@Override
    public Map<String, Object> getCustomerStats() throws Exception {
        StatsMapper mapper = SqlSessionManager.getSession().getMapper(StatsMapper.class);
        Map<String, Object> map = new HashMap<>();

        // 1. 요약 및 차트 데이터
        map.put("totalMemberCount", mapper.getTotalMemberCount());
        map.put("vipRatio", mapper.getVipRatio());
        map.put("newMemberTrend", mapper.getNewMemberTrend());
        map.put("gradeDist", mapper.getGradeDistribution());
        map.put("genderDist", mapper.getGenderDistribution());
        map.put("ageDist", mapper.getAgeDistribution());
        
        // 2. VIP 리스트 (전체 데이터를 가져와서 JS에서 정렬)
        map.put("vipList", mapper.getVipRanking());

        return map;
    }
	
	@Override
    public Map<String, Object> getVisitorStats(String mode) throws Exception {
        StatsMapper mapper = SqlSessionManager.getSession().getMapper(StatsMapper.class);
        Map<String, Object> map = new HashMap<>();

        if ("monthly".equals(mode)) {
            map.put("dauStats", mapper.getMonthlyDau());
        } else {
            map.put("dauStats", mapper.getDailyDau());
        }

        map.put("hourlyStats", mapper.getHourlyTraffic());

        map.put("todayTotalLogin", mapper.getTodayTotalLogin());

        return map;
    }
}
