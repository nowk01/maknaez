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
        resultMap.put("todaySalesDiff", calculateGrowth(todaySales, yesterdaySales)); 
        resultMap.put("todaySalesColor", getGrowthColor(todaySales, yesterdaySales)); 

        long monthSales = mapper.getMonthSales();
        long lastMonthSales = mapper.getLastMonthSales();
        resultMap.put("monthSales", monthSales);
        resultMap.put("monthSalesDiff", calculateGrowth(monthSales, lastMonthSales));
        resultMap.put("monthSalesColor", getGrowthColor(monthSales, lastMonthSales));

        int todayOrders = mapper.getTodayOrderCount();
        int yesterdayOrders = mapper.getYesterdayOrderCount();
        int diffOrders = todayOrders - yesterdayOrders;
        String diffOrderStr = (diffOrders >= 0 ? "+ " : "") + diffOrders; 
        
        resultMap.put("todayOrderCount", todayOrders);
        resultMap.put("orderDiffStr", diffOrderStr + " 건");
        resultMap.put("orderDiffColor", (diffOrders >= 0) ? "text-success" : "text-danger");

        List<Map<String, Object>> salesTrend;
        if ("monthly".equals(mode)) {
            salesTrend = mapper.getMonthlySalesTrend(); 
        } else {
            salesTrend = mapper.getRecentSales();   
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

        map.put("orderStatus", mapper.getOrderStatusDistribution());
        map.put("categoryShare", mapper.getCategoryShare());         
        map.put("bestSellers", mapper.getBestSellers());             
        map.put("topWishlist", mapper.getTopWishlist());             
        map.put("topCart", mapper.getTopCart());                  

        return map;
    }
	
	@Override
    public Map<String, Object> getCustomerStats() throws Exception {
        StatsMapper mapper = SqlSessionManager.getSession().getMapper(StatsMapper.class);
        Map<String, Object> map = new HashMap<>();

        map.put("totalMemberCount", mapper.getTotalMemberCount());
        map.put("vipRatio", mapper.getVipRatio());
        map.put("newMemberTrend", mapper.getNewMemberTrend());
        map.put("gradeDist", mapper.getGradeDistribution());
        map.put("genderDist", mapper.getGenderDistribution());
        map.put("ageDist", mapper.getAgeDistribution());
        map.put("dormantCount", mapper.getDormantMemberCount());     
        map.put("withdrawnCount", mapper.getWithdrawnMemberCount()); 
        
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
