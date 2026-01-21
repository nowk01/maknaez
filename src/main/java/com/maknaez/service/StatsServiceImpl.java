package com.maknaez.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.maknaez.mapper.StatsMapper;
import com.maknaez.mybatis.support.SqlSessionManager;

public class StatsServiceImpl implements StatsService{
	StatsMapper mapper = SqlSessionManager.getSession().getMapper(StatsMapper.class);
	
	@Override
    public Map<String, Object> getSalesStats(String mode) throws Exception {
        StatsMapper mapper = SqlSessionManager.getSession().getMapper(StatsMapper.class);
        Map<String, Object> resultMap = new HashMap<>();
        
        long todaySales = mapper.getTodaySales();
        long yesterdaySales = mapper.getYesterdaySales();
        resultMap.put("todaySales", todaySales);
        resultMap.put("todaySalesDiff", calculateGrowth(todaySales, yesterdaySales)); // 증감률 문자열 (+ 5.0%)
        resultMap.put("todaySalesColor", getGrowthColor(todaySales, yesterdaySales)); // 색상 클래스

        long monthSales = mapper.getMonthSales();
        long lastMonthSales = mapper.getLastMonthSales();
        resultMap.put("monthSales", monthSales);
        resultMap.put("monthSalesDiff", calculateGrowth(monthSales, lastMonthSales));
        resultMap.put("monthSalesColor", getGrowthColor(monthSales, lastMonthSales));

        int todayOrders = mapper.getTodayOrderCount();
        int yesterdayOrders = mapper.getYesterdayOrderCount();
        int diffOrders = todayOrders - yesterdayOrders;
        String diffOrderStr = (diffOrders >= 0 ? "+ " : "") + diffOrders; // "+ 5" or "- 3"
        
        resultMap.put("todayOrderCount", todayOrders);
        resultMap.put("orderDiffStr", diffOrderStr + " 건");
        resultMap.put("orderDiffColor", (diffOrders >= 0) ? "text-success" : "text-danger"); // Green : Red

        List<Map<String, Object>> salesTrend;
        if ("monthly".equals(mode)) {
            salesTrend = mapper.getMonthlySalesTrend(); // 최근 1년
        } else {
            salesTrend = mapper.getRecentSales();       // 최근 7일 (기본)
        }
        resultMap.put("salesTrend", salesTrend);
        
        resultMap.put("topProducts", mapper.getTopSellingProducts());

        return resultMap;
    }

    private String calculateGrowth(long current, long past) {
        if (past == 0) {
            return current > 0 ? "+ 100%" : "0%";
        }
        double diff = (double) (current - past);
        double percent = (diff / past) * 100.0;
        return (percent >= 0 ? "+ " : "") + String.format("%.1f", percent) + "%";
    }

    private String getGrowthColor(long current, long past) {
        return (current >= past) ? "text-success" : "text-danger";
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
        map.put("dormantCount", mapper.getDormantMemberCount());     
        map.put("withdrawnCount", mapper.getWithdrawnMemberCount()); 
        
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
