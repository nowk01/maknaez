package com.maknaez.mapper;

import java.util.List;
import java.util.Map;

import com.maknaez.model.AlertDTO;

public interface AlertMapper {
    public List<Map<String, Object>> listNewOrders();
    public List<Map<String, Object>> listNewInquiries();
    public List<AlertDTO> listAlert(Map<String, Object> map);
    public int dataCount(Map<String, Object> map);
    public void updateRead(int alertIdx);
    public void updateReadAll(long memberIdx);
}