package com.maknaez.service;

import java.util.Map;

public interface StatsService {
	
	public Map<String, Object> getSalesStats(String mode) throws Exception;
	
	public Map<String, Object> getProductStats() throws Exception;
	
	public Map<String, Object> getCustomerStats() throws Exception;
	
	public Map<String, Object> getVisitorStats(String mode) throws Exception;
}
