package com.maknaez.service;

import java.util.List;
import java.util.Map;
import com.maknaez.model.AlertDTO;

public interface AlertService {
    public List<AlertDTO> listAlert(Map<String, Object> map);
    public int dataCount(Map<String, Object> map);
    public void updateRead(int alertIdx) throws Exception;
    public void updateReadAll(long memberIdx) throws Exception;
	void updateReadAll1(long memberIdx) throws Exception;
}