package com.maknaez.mapper;

import java.util.List;
import java.util.Map;

public interface StatsMapper {
    long getTodaySales() throws Exception;
    long getMonthSales() throws Exception;
    int getTodayOrderCount() throws Exception;
    List<Map<String, Object>> getRecentSales();
    List<Map<String, Object>> getTopSellingProducts();
}