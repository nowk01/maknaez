package com.maknaez.mapper;

import java.util.List;
import java.util.Map;

public interface StatsMapper {
	// 매출 통계 관련 
    long getTodaySales() throws Exception;
    long getMonthSales() throws Exception;
    int getTodayOrderCount() throws Exception;
    List<Map<String, Object>> getRecentSales();
    List<Map<String, Object>> getTopSellingProducts();
    
    // 상품 통계 관련 
    List<Map<String, Object>> getOrderStatusDistribution() throws Exception;
    int getPendingInquiryCount() throws Exception;
    int getSoldOutCount() throws Exception;
    int getLowStockCount() throws Exception;
    List<Map<String, Object>> getCategoryShare() throws Exception;
    List<Map<String, Object>> getBestSellers() throws Exception;
    List<Map<String, Object>> getTopWishlist() throws Exception;
    List<Map<String, Object>> getTopCart() throws Exception;
    
    // 회원 통계 관련
    int getTotalMemberCount() throws Exception;
    List<Map<String, Object>> getNewMemberTrend() throws Exception;
    List<Map<String, Object>> getGradeDistribution() throws Exception;
    List<Map<String, Object>> getGenderDistribution() throws Exception;
    List<Map<String, Object>> getAgeDistribution() throws Exception;
    List<Map<String, Object>> getVipRanking() throws Exception;
    double getVipRatio() throws Exception;
    
    // 방문자 통계 관련
    List<Map<String, Object>> getDailyDau() throws Exception;
    List<Map<String, Object>> getMonthlyDau() throws Exception;
    List<Map<String, Object>> getHourlyTraffic() throws Exception;
    int getTodayTotalLogin() throws Exception;
}