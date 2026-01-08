package com.maknaez.service;

import java.util.List;
import java.util.Map;

import com.maknaez.mapper.MemberMapper;
import com.maknaez.model.MemberDTO;
import com.maknaez.mybatis.support.MapperContainer;
import com.maknaez.mybatis.support.SqlSessionManager;

public class MemberServiceImpl implements MemberService {
	private MemberMapper mapper = MapperContainer.get(MemberMapper.class);

	@Override
	public MemberDTO loginMember(Map<String, Object> map) {
		MemberDTO dto = null;
		
		try {
			dto = mapper.loginMember(map);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return dto;
	}

	@Override
	public void insertMember(MemberDTO dto) throws Exception {
		try {
			/*
			mapper.insertMember1(dto);
			mapper.insertMember2(dto);
			*/
			
			mapper.insertMember12(dto);
		} catch (Exception e) {
			// 트랜잭션 처리
			SqlSessionManager.setRollbackOnly();
			
			e.printStackTrace();
			
			throw e;
		}
		
	}

	@Override
	public void updateMember(MemberDTO dto) throws Exception {
		try {
			mapper.updateMember1(dto);
			mapper.updateMember2(dto);
		} catch (Exception e) {
			SqlSessionManager.setRollbackOnly();
			
			e.printStackTrace();
			
			throw e;
		}
	}

	@Override
	public void updateMemberLevel(Map<String, Object> map) throws Exception {
		try {
			mapper.updateMemberLevel(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public void deleteProfilePhoto(Map<String, Object> map) throws Exception {
		try {
			mapper.deleteProfilePhoto(map);
		} catch (Exception e) {
			e.printStackTrace();
			
			throw e;
		}
	}

	@Override
	public void deleteMember(Map<String, Object> map) throws Exception {
		try {
			mapper.deleteMember1(map);
			mapper.deleteMember2(map);
		} catch (Exception e) {
			SqlSessionManager.setRollbackOnly();
			
			e.printStackTrace();
			
			throw e;
		}
	}

	@Override
	public MemberDTO findById(String userId) {
		MemberDTO dto = null;
		try {
			dto = mapper.findById(userId);
			
			if(dto != null && dto.getEmail() != null) {
				String[] ss = dto.getEmail().split("@");
				if(ss.length == 2) {
					dto.setEmail1(ss[0]);
					dto.setEmail2(ss[1]);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			
			throw e;
		}
		return dto;
	}

	@Override
	public List<Map<String, Object>> listAgeSection() {
		// TODO Auto-generated method stub
		return null;
	}

}
