package com.maknaez.service;

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
	public void updateRead(int alertIdx) throws Exception {
	    mapper.updateRead(alertIdx);
	}

	@Override
	public void updateReadAll(long memberIdx) throws Exception {
	    mapper.updateReadAll(memberIdx);
	}
//	@Override
//	public void updateRead(int alertIdx) throws Exception {
//		try {
//			mapper.updateRead(alertIdx);
//		} catch (Exception e) {
//			System.out.println("ERROR: updateRead 실행 중 DB 에러 발생!");
//			e.printStackTrace();
//			throw e;
//		}
//	}
//
//	@Override
//	public void updateReadAll(long memberIdx) throws Exception {
//		try {
//			mapper.updateReadAll(memberIdx);
//		} catch (Exception e) {
//			e.printStackTrace();
//			throw e;
//		}
//	}
}