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
}
