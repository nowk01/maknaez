package com.maknaez.service;

import java.util.List;
import java.util.Map;
import com.maknaez.model.MemberDTO;
import com.maknaez.model.PointDTO;

public interface PointService {
    public int dataCountMemberPoint(Map<String, Object> map);
    public List<MemberDTO> listMemberPoint(Map<String, Object> map);
    
    public int dataCountPointHistory(Map<String, Object> map);
    public List<PointDTO> listPointHistory(Map<String, Object> map);
    
    public void insertPoint(PointDTO dto) throws Exception;
    public void insertPointList(List<Long> memberIdxs, int amount, String reason) throws Exception;
    
    public int findCurrentPoint(long memberIdx);
    
}