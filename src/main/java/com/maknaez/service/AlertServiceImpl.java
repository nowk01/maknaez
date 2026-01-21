package com.maknaez.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.maknaez.mapper.AlertMapper;
import com.maknaez.model.AlertDTO;
import com.maknaez.mybatis.support.MapperContainer;

public class AlertServiceImpl implements AlertService {
	private AlertMapper mapper = MapperContainer.get(AlertMapper.class);

	@Override
	public List<AlertDTO> listAlert(Map<String, Object> map) {
		try {
			return mapper.listAlert(map);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public int dataCount(Map<String, Object> map) {
		try {
			return mapper.dataCount(map);
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}


	@Override
	public void updateReadAll(long memberIdx) throws Exception {
	    mapper.updateReadAll(memberIdx);
	}
	
	@Override
	public void updateRead(int alertIdx) throws Exception {
	    try {
	        int result = mapper.updateRead(alertIdx);
	        
	        if (result == 0) {
	            Map<String, Object> map = new HashMap<>();
	            map.put("memberIdx", 1); // 관리자
	            map.put("content", "읽음 처리된 알림");
	            map.put("dataIdx", alertIdx); 
	            
	            mapper.insertAlertRead(map); 
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
	
	@Override
	public void updateReadAll1(long memberIdx) throws Exception {
		try {
			mapper.updateReadAll(memberIdx);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}
}