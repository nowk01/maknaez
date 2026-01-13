package com.maknaez.service;

import java.util.List;
import java.util.Map;
import com.maknaez.mapper.PointMapper;
import com.maknaez.model.MemberDTO;
import com.maknaez.model.PointDTO;
import com.maknaez.mybatis.support.MapperContainer;

public class PointServiceImpl implements PointService {
    
    private PointMapper mapper = MapperContainer.get(PointMapper.class);

    @Override
    public int dataCountMemberPoint(Map<String, Object> map) {
        int result = 0;
        try {
            result = mapper.dataCountMemberPoint(map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    @Override
    public List<MemberDTO> listMemberPoint(Map<String, Object> map) {
        List<MemberDTO> list = null;
        try {
            list = mapper.listMemberPoint(map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int dataCountPointHistory(Map<String, Object> map) {
        int result = 0;
        try {
            result = mapper.dataCountPointHistory(map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    @Override
    public List<PointDTO> listPointHistory(Map<String, Object> map) {
        List<PointDTO> list = null;
        try {
            list = mapper.listPointHistory(map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public void insertPoint(PointDTO dto) throws Exception {
        try {
            int currentPoint = 0;
            try {
                currentPoint = mapper.findCurrentPoint(dto.getMemberIdx());
            } catch (Exception e) { 
                currentPoint = 0; 
            }
            
            int remPoint = currentPoint + dto.getPoint_amount();
            dto.setRem_point(remPoint);
            
            mapper.insertPoint(dto);
            
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    public void insertPointList(List<Long> memberIdxs, int amount, String reason) throws Exception {
        try {
            for (Long memberIdx : memberIdxs) {
                PointDTO dto = new PointDTO();
                dto.setMemberIdx(memberIdx);
                dto.setPoint_amount(amount); 
                dto.setReason(reason);
                dto.setOrder_id(null); 

                
                insertPoint(dto); 
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw e; 
        }
    }
}