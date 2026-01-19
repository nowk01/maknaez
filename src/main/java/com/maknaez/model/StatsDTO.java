package com.maknaez.model;

public class StatsDTO {
    private long todaySales;
    private long monthSales;
    private int todayOrderCount;

    // 그래프 및 리스트용
    private String statsDate;   // 날짜 (MM-DD)
    private long totalRevenue;  // 해당 날짜 매출액
    
    // 상품 랭킹용
    private String productName;
    private int salesCount;

    public long getTodaySales() { return todaySales; }
    public void setTodaySales(long todaySales) { this.todaySales = todaySales; }
    public long getMonthSales() { return monthSales; }
    public void setMonthSales(long monthSales) { this.monthSales = monthSales; }
    public int getTodayOrderCount() { return todayOrderCount; }
    public void setTodayOrderCount(int todayOrderCount) { this.todayOrderCount = todayOrderCount; }
    public String getStatsDate() { return statsDate; }
    public void setStatsDate(String statsDate) { this.statsDate = statsDate; }
    public long getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(long totalRevenue) { this.totalRevenue = totalRevenue; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public int getSalesCount() { return salesCount; }
    public void setSalesCount(int salesCount) { this.salesCount = salesCount; }
}